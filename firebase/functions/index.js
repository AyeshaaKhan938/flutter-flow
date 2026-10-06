const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {GoogleAuth} = require("google-auth-library");
admin.initializeApp();

const kFcmTokensCollection = "fcm_tokens";
const kPushNotificationsCollection = "ff_push_notifications";
const kSchedulerIntervalMinutes = 60;
const firestore = admin.firestore();

const kPushNotificationRuntimeOpts = {
  timeoutSeconds: 540,
  memory: "2GB",
};

exports.addFcmToken = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    return "Failed: Unauthenticated calls are not allowed.";
  }
  const userDocPath = data.userDocPath;
  const fcmToken = data.fcmToken;
  const deviceType = data.deviceType;
  if (
    typeof userDocPath === "undefined" ||
    typeof fcmToken === "undefined" ||
    typeof deviceType === "undefined" ||
    userDocPath.split("/").length <= 1 ||
    fcmToken.length === 0 ||
    deviceType.length === 0
  ) {
    return "Invalid arguments encoutered when adding FCM token.";
  }
  if (context.auth.uid != userDocPath.split("/")[1]) {
    return "Failed: Authenticated user doesn't match user provided.";
  }
  const existingTokens = await firestore
    .collectionGroup(kFcmTokensCollection)
    .where("fcm_token", "==", fcmToken)
    .get();
  var userAlreadyHasToken = false;
  for (var doc of existingTokens.docs) {
    const user = doc.ref.parent.parent;
    if (user.path != userDocPath) {
      // Should never have the same FCM token associated with multiple users.
      await doc.ref.delete();
    } else {
      userAlreadyHasToken = true;
    }
  }
  if (userAlreadyHasToken) {
    return "FCM token already exists for this user. Ignoring...";
  }
  await getUserFcmTokensCollection(userDocPath).doc().set({
    fcm_token: fcmToken,
    device_type: deviceType,
    created_at: admin.firestore.FieldValue.serverTimestamp(),
  });
  return "Successfully added FCM token!";
});

// ---------------------------------------------------------------------------
// Audience targeting for push notifications.
//
// Every field below is optional on an `ff_push_notifications` document. When a
// field is absent the notification behaves exactly like FlutterFlow's stock
// implementation (target_audience / user_refs only).
//
//   target_language          'en' | 'es' | 'ur' | 'lg', or a list / comma
//                            separated string of them. Matched against the
//                            user's `preferredLanguage` (missing => 'en').
//   target_pathway           Pathway id (or list). Matched against the user's
//                            `recommendedPathwayId`, `companionPathwayId`,
//                            `currentPathwayId` and `additionalPathwayIds`.
//   target_timezone          IANA timezone (or list), e.g. 'Africa/Kampala'.
//                            Matched against the user's `timezone`.
//   notification_title_i18n  { en, es, ur, lg } localized titles.
//   notification_text_i18n   { en, es, ur, lg } localized bodies. Each user
//                            receives their preferredLanguage, falling back
//                            to English, then to notification_title/_text.
//   local_send_hour          0-23. Deliver to each user when it is this hour
//                            in the user's own timezone (users without a
//                            valid timezone are treated as UTC). Delivery
//                            runs for 24 hours starting at scheduled_time (or
//                            at creation when there is no scheduled_time).
//                            Timezones already delivered to are recorded in
//                            the `sent_timezones` array so nobody is notified
//                            twice.
//
// PRIVACY: push payloads must never carry reflection content. Only an explicit
// whitelist of data keys is sent, parameter_data is scrubbed of any key that
// looks like reflection*, and user documents are read with a field mask so
// reflection / survey data is never even loaded here.
// ---------------------------------------------------------------------------
const kSupportedLanguages = ["en", "es", "ur", "lg"];
const kDefaultLanguage = "en";
const kDefaultTimezone = "UTC";
const kLocalSendWindowHours = 24;
const kLocalSendInProgressStatus = "in_progress";
const kReflectionKeyPattern = /reflection/i;
// Only these user fields are read for targeting.
const kUserTargetingFields = [
  "preferredLanguage",
  "timezone",
  "recommendedPathwayId",
  "companionPathwayId",
  "currentPathwayId",
  "additionalPathwayIds",
];

exports.sendPushNotificationsTrigger = functions
  .runWith(kPushNotificationRuntimeOpts)
  .firestore.document(`${kPushNotificationsCollection}/{id}`)
  .onCreate(async (snapshot, _) => {
    try {
      // Ignore scheduled push notifications on create
      const scheduledTime = snapshot.data().scheduled_time || "";
      if (scheduledTime) {
        return;
      }

      await sendPushNotifications(snapshot);
    } catch (e) {
      console.log(`Error: ${e}`);
      await snapshot.ref.update({ status: "failed", error: `${e}` });
    }
  });

exports.sendScheduledPushNotifications = functions
  .runWith(kPushNotificationRuntimeOpts)
  .pubsub.schedule(`every ${kSchedulerIntervalMinutes} minutes synchronized`)
  .onRun(async (_) => {
    const minutesToMilliseconds = (minutes) => minutes * 60 * 1000;
    function currentTimeDownToNearestMinute() {
      // Add a second to the current time to avoid minute boundary issues.
      const currentTime = new Date(new Date().getTime() + 1000);
      // Remove seconds and milliseconds to get the time down to the minute.
      currentTime.setSeconds(0, 0);
      return currentTime;
    }

    // Determine the cutoff times for this round of push notifications.
    const intervalMs = minutesToMilliseconds(kSchedulerIntervalMinutes);
    const upperCutoffTime = currentTimeDownToNearestMinute();
    const lowerCutoffTime = new Date(upperCutoffTime.getTime() - intervalMs);
    // Send push notifications that we've scheduled.
    const scheduledNotifications = await firestore
      .collection(kPushNotificationsCollection)
      .where("scheduled_time", ">", lowerCutoffTime)
      .where("scheduled_time", "<=", upperCutoffTime)
      .get();
    // Local-time notifications that are still working through timezones.
    const localTimeNotifications = await firestore
      .collection(kPushNotificationsCollection)
      .where("status", "==", kLocalSendInProgressStatus)
      .get();

    const seen = new Set();
    const snapshots = [
      ...scheduledNotifications.docs,
      ...localTimeNotifications.docs,
    ].filter((doc) => {
      if (seen.has(doc.ref.path)) {
        return false;
      }
      seen.add(doc.ref.path);
      return true;
    });

    for (var snapshot of snapshots) {
      try {
        await sendPushNotifications(snapshot);
      } catch (e) {
        console.log(`Error: ${e}`);
        await snapshot.ref.update({ status: "failed", error: `${e}` });
      }
    }
  });

async function sendPushNotifications(snapshot) {
  const notificationData = snapshot.data();
  const titleI18n = getI18nMap(notificationData.notification_title_i18n);
  const bodyI18n = getI18nMap(notificationData.notification_text_i18n);
  const hasI18n =
    Object.keys(titleI18n).length > 0 || Object.keys(bodyI18n).length > 0;
  const title =
    notificationData.notification_title ||
    titleI18n[kDefaultLanguage] ||
    firstValue(titleI18n);
  const body =
    notificationData.notification_text ||
    bodyI18n[kDefaultLanguage] ||
    firstValue(bodyI18n);
  const imageUrl = notificationData.notification_image_url || "";
  const sound = notificationData.notification_sound || "";
  const parameterData = sanitizeParameterData(
    notificationData.parameter_data || "",
  );
  const targetAudience = notificationData.target_audience || "";
  const initialPageName = notificationData.initial_page_name || "";
  const userRefsStr = notificationData.user_refs || "";
  const batchIndex = notificationData.batch_index || 0;
  const numBatches = notificationData.num_batches || 0;
  const status = notificationData.status || "";

  const targetLanguages = toStringList(notificationData.target_language).map(
    normalizeLanguageCode,
  );
  const targetPathways = toStringList(notificationData.target_pathway);
  const targetTimezones = toStringList(notificationData.target_timezone).map(
    (tz) => tz.toLowerCase(),
  );
  const localSendHour = parseLocalSendHour(notificationData.local_send_hour);
  const isLocalTime = localSendHour !== null;
  const hasTargets =
    targetLanguages.length > 0 ||
    targetPathways.length > 0 ||
    targetTimezones.length > 0;

  const isResumableLocalTime =
    isLocalTime && status === kLocalSendInProgressStatus;
  if (status !== "" && status !== "started" && !isResumableLocalTime) {
    console.log(`Already processed ${snapshot.ref.path}. Skipping...`);
    return;
  }

  if (!title || !body) {
    await snapshot.ref.update({ status: "failed" });
    return;
  }

  // Map each FCM token to the user document that owns it.
  const tokenToUser = new Map();
  const userRefs = userRefsStr === "" ? [] : userRefsStr.trim().split(",");
  if (userRefsStr) {
    for (var userRef of userRefs) {
      const trimmedRef = userRef.trim();
      if (!trimmedRef) {
        continue;
      }
      const userDoc = firestore.doc(trimmedRef);
      const userTokens = await userDoc.collection(kFcmTokensCollection).get();
      userTokens.docs.forEach((token) => {
        const fcmToken = token.data().fcm_token;
        if (fcmToken) {
          tokenToUser.set(fcmToken, userDoc.path);
        }
      });
    }
  } else {
    var userTokensQuery = firestore.collectionGroup(kFcmTokensCollection);
    // Handle batched push notifications by splitting tokens up by document
    // id.
    if (numBatches > 0) {
      userTokensQuery = userTokensQuery
        .orderBy(admin.firestore.FieldPath.documentId())
        .startAt(getDocIdBound(batchIndex, numBatches))
        .endBefore(getDocIdBound(batchIndex + 1, numBatches));
    }
    const userTokens = await userTokensQuery.get();
    userTokens.docs.forEach((token) => {
      const data = token.data();
      const audienceMatches =
        targetAudience === "All" || data.device_type === targetAudience;
      const userDoc = token.ref.parent.parent;
      if (audienceMatches && data.fcm_token && userDoc) {
        tokenToUser.set(data.fcm_token, userDoc.path);
      }
    });
  }

  // Load the (minimal) user profiles only when targeting needs them.
  const userPaths = Array.from(new Set(tokenToUser.values()));
  const needsUserProfiles = hasTargets || hasI18n || isLocalTime;
  const userProfiles = needsUserProfiles
    ? await getUserNotificationProfiles(userPaths)
    : new Map();

  // Decide which users receive the notification in this run.
  const now = new Date();
  const recipients = new Map();
  for (var userPath of userPaths) {
    const profile = userProfiles.get(userPath) || {};
    if (
      !userMatchesTargets(
        profile,
        targetLanguages,
        targetPathways,
        targetTimezones,
      )
    ) {
      continue;
    }
    const timezone = resolveTimezone(profile.timezone);
    if (isLocalTime && getLocalHour(timezone, now) !== localSendHour) {
      continue;
    }
    recipients.set(userPath, {
      language: resolveLanguage(profile.preferredLanguage),
      timezone,
    });
  }

  // For local-time sends, atomically claim the timezones handled in this run
  // so overlapping invocations never notify the same timezone twice.
  if (isLocalTime) {
    const candidateTimezones = Array.from(
      new Set(Array.from(recipients.values()).map((r) => r.timezone)),
    );
    const claimedTimezones = await claimTimezones(
      snapshot.ref,
      candidateTimezones,
    );
    for (var [path, recipient] of Array.from(recipients.entries())) {
      if (!claimedTimezones.has(recipient.timezone)) {
        recipients.delete(path);
      }
    }
  }

  // Group tokens per language so each batch carries a single localized text.
  const tokensByLanguage = new Map();
  tokenToUser.forEach((userPath, fcmToken) => {
    const recipient = recipients.get(userPath);
    if (!recipient) {
      return;
    }
    const language = hasI18n ? recipient.language : kDefaultLanguage;
    if (!tokensByLanguage.has(language)) {
      tokensByLanguage.set(language, []);
    }
    tokensByLanguage.get(language).push(fcmToken);
  });

  var messageBatches = [];
  tokensByLanguage.forEach((tokensArr, language) => {
    const localizedTitle =
      titleI18n[language] || titleI18n[kDefaultLanguage] || title;
    const localizedBody =
      bodyI18n[language] || bodyI18n[kDefaultLanguage] || body;
    for (let i = 0; i < tokensArr.length; i += 500) {
      const tokensBatch = tokensArr.slice(
        i,
        Math.min(i + 500, tokensArr.length),
      );
      const messages = {
        notification: {
          title: localizedTitle,
          body: localizedBody,
          ...(imageUrl && { imageUrl: imageUrl }),
        },
        // Whitelisted data keys only. Never add reflection content here.
        data: stripReflectionKeys({
          initialPageName,
          parameterData,
        }),
        android: {
          notification: {
            ...(sound && { sound: sound }),
          },
        },
        apns: {
          payload: {
            aps: {
              ...(sound && { sound: sound }),
            },
          },
        },
        tokens: tokensBatch,
      };
      messageBatches.push(messages);
    }
  });

  var numSent = 0;
  await Promise.all(
    messageBatches.map(async (messages) => {
      const response = await admin.messaging().sendEachForMulticast(messages);
      numSent += response.successCount;
    }),
  );

  if (!isLocalTime) {
    await snapshot.ref.update({ status: "succeeded", num_sent: numSent });
    return;
  }

  // Local-time sends stay "in_progress" until every hour of the delivery
  // window has had a chance to run.
  const windowEnd = notificationData.local_send_window_end
    ? toDate(notificationData.local_send_window_end)
    : new Date(now.getTime() + kLocalSendWindowHours * 60 * 60 * 1000);
  const nextRun = new Date(
    now.getTime() + kSchedulerIntervalMinutes * 60 * 1000,
  );
  const isFinished = nextRun.getTime() > windowEnd.getTime();
  await snapshot.ref.update({
    status: isFinished ? "succeeded" : kLocalSendInProgressStatus,
    num_sent: admin.firestore.FieldValue.increment(numSent),
    local_send_window_end: windowEnd,
  });
}

async function getUserNotificationProfiles(userPaths) {
  const profiles = new Map();
  for (let i = 0; i < userPaths.length; i += 100) {
    const refs = userPaths
      .slice(i, Math.min(i + 100, userPaths.length))
      .map((path) => firestore.doc(path));
    if (refs.length === 0) {
      continue;
    }
    // Field mask keeps private data (reflections, survey responses) out.
    const docs = await firestore.getAll(...refs, {
      fieldMask: kUserTargetingFields,
    });
    docs.forEach((doc) => {
      if (doc.exists) {
        profiles.set(doc.ref.path, doc.data());
      }
    });
  }
  return profiles;
}

function userMatchesTargets(
  profile,
  targetLanguages,
  targetPathways,
  targetTimezones,
) {
  if (
    targetLanguages.length > 0 &&
    !targetLanguages.includes(resolveLanguage(profile.preferredLanguage))
  ) {
    return false;
  }
  if (targetPathways.length > 0) {
    const userPathways = getUserPathwayIds(profile);
    if (!targetPathways.some((id) => userPathways.has(id))) {
      return false;
    }
  }
  if (targetTimezones.length > 0) {
    const timezone = (profile.timezone || "").toString().trim().toLowerCase();
    if (!timezone || !targetTimezones.includes(timezone)) {
      return false;
    }
  }
  return true;
}

function getUserPathwayIds(profile) {
  const ids = new Set();
  [
    profile.recommendedPathwayId,
    profile.companionPathwayId,
    profile.currentPathwayId,
  ]
    .concat(toStringList(profile.additionalPathwayIds))
    .forEach((id) => {
      if (typeof id === "string" && id.trim()) {
        ids.add(id.trim());
      }
    });
  return ids;
}

async function claimTimezones(notificationRef, timezones) {
  if (timezones.length === 0) {
    return new Set();
  }
  return firestore.runTransaction(async (transaction) => {
    const doc = await transaction.get(notificationRef);
    const alreadySent = new Set(doc.get("sent_timezones") || []);
    const claimed = timezones.filter((tz) => !alreadySent.has(tz));
    if (claimed.length > 0) {
      transaction.update(notificationRef, {
        sent_timezones: admin.firestore.FieldValue.arrayUnion(...claimed),
      });
    }
    return new Set(claimed);
  });
}

function toStringList(value) {
  if (value === undefined || value === null || value === "") {
    return [];
  }
  const values = Array.isArray(value) ? value : `${value}`.split(",");
  return values
    .filter((v) => v !== undefined && v !== null)
    .map((v) => `${v}`.trim())
    .filter((v) => v !== "");
}

function normalizeLanguageCode(code) {
  return `${code || ""}`.trim().toLowerCase().split(/[-_]/)[0];
}

function resolveLanguage(code) {
  const normalized = normalizeLanguageCode(code);
  return kSupportedLanguages.includes(normalized)
    ? normalized
    : kDefaultLanguage;
}

function getI18nMap(value) {
  const result = {};
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    return result;
  }
  Object.keys(value).forEach((key) => {
    const text = value[key];
    if (typeof text === "string" && text.trim() !== "") {
      result[normalizeLanguageCode(key)] = text;
    }
  });
  return result;
}

function firstValue(map) {
  const keys = Object.keys(map);
  return keys.length > 0 ? map[keys[0]] : "";
}

function parseLocalSendHour(value) {
  if (value === undefined || value === null || value === "") {
    return null;
  }
  const hour = Number(value);
  if (!Number.isInteger(hour) || hour < 0 || hour > 23) {
    return null;
  }
  return hour;
}

function getLocalHour(timeZone, date) {
  try {
    const hour = new Intl.DateTimeFormat("en-US", {
      timeZone,
      hour: "numeric",
      hourCycle: "h23",
    }).format(date);
    return parseInt(hour, 10) % 24;
  } catch (e) {
    return null;
  }
}

function resolveTimezone(timezone) {
  const trimmed = `${timezone || ""}`.trim();
  if (trimmed && getLocalHour(trimmed, new Date()) !== null) {
    return trimmed;
  }
  return kDefaultTimezone;
}

function toDate(value) {
  if (value && typeof value.toDate === "function") {
    return value.toDate();
  }
  return new Date(value);
}

// Removes any key named like reflection* (at any depth) so private reflection
// content can never leak into a push payload.
function stripReflectionKeys(value) {
  if (Array.isArray(value)) {
    return value.map(stripReflectionKeys);
  }
  if (value && typeof value === "object") {
    const result = {};
    Object.keys(value).forEach((key) => {
      if (!kReflectionKeyPattern.test(key)) {
        result[key] = stripReflectionKeys(value[key]);
      }
    });
    return result;
  }
  return value;
}

function sanitizeParameterData(parameterData) {
  if (!parameterData) {
    return "";
  }
  if (typeof parameterData !== "string") {
    return JSON.stringify(stripReflectionKeys(parameterData));
  }
  try {
    return JSON.stringify(stripReflectionKeys(JSON.parse(parameterData)));
  } catch (e) {
    // Unparseable payloads that mention reflections are dropped entirely.
    return kReflectionKeyPattern.test(parameterData) ? "" : parameterData;
  }
}

function getUserFcmTokensCollection(userDocPath) {
  return firestore.doc(userDocPath).collection(kFcmTokensCollection);
}

function getDocIdBound(index, numBatches) {
  if (index <= 0) {
    return "users/(";
  }
  if (index >= numBatches) {
    return "users/}";
  }
  const numUidChars = 62;
  const twoCharOptions = Math.pow(numUidChars, 2);

  var twoCharIdx = (index * twoCharOptions) / numBatches;
  var firstCharIdx = Math.floor(twoCharIdx / numUidChars);
  var secondCharIdx = Math.floor(twoCharIdx % numUidChars);
  const firstChar = getCharForIndex(firstCharIdx);
  const secondChar = getCharForIndex(secondCharIdx);
  return "users/" + firstChar + secondChar;
}

function getCharForIndex(charIdx) {
  if (charIdx < 10) {
    return String.fromCharCode(charIdx + "0".charCodeAt(0));
  } else if (charIdx < 36) {
    return String.fromCharCode("A".charCodeAt(0) + charIdx - 10);
  } else {
    return String.fromCharCode("a".charCodeAt(0) + charIdx - 36);
  }
}
// Scripture passages from API.Bible. The API key lives only in Secret
// Manager (API_BIBLE_KEY), never in the mobile app. The runtime service
// account reads the secret at call time (James grants Secret Accessor on
// the secret); deploy does not need secretmanager.secrets.setIamPolicy.
// Only signed-in members can call it, and only for the approved Bibles.
const kApprovedBibleIds = new Set([
  "78a9f6124f344018-01", // English: New International Version 2011
  "592420522e16049f-01", // Spanish: Reina Valera 1909
  "eecbca904435fce9-01", // Urdu: Biblica Open Urdu Contemporary Version
  "f276be3571f516cb-01", // Luganda: Biblica Open Luganda Contemporary Bible
]);

// Plus any Bible named by an active language in the CMS `languages`
// collection (admins add a language's API.Bible id there), cached 5 min.
let cmsBibleIds = new Set();
let cmsBibleIdsAt = 0;
async function isApprovedBibleId(bibleId) {
  if (kApprovedBibleIds.has(bibleId)) {
    return true;
  }
  if (Date.now() - cmsBibleIdsAt > 5 * 60 * 1000) {
    try {
      const snap = await admin.firestore().collection("languages")
        .where("active", "==", true).get();
      const ids = new Set();
      snap.forEach((doc) => {
        const id = String((doc.data() || {}).bibleId || "").trim();
        if (id) {
          ids.add(id);
        }
      });
      cmsBibleIds = ids;
      cmsBibleIdsAt = Date.now();
    } catch (err) {
      console.error("Could not load languages", err);
    }
  }
  return cmsBibleIds.has(bibleId);
}
const kPassageIdPattern = /^[1-3]?[A-Z]{2,3}\.\d{1,3}(\.\d{1,3})?(-[1-3]?[A-Z]{2,3}\.\d{1,3}(\.\d{1,3})?)?$/;

let apiBibleKeyCache = null;
async function getApiBibleKey() {
  if (process.env.API_BIBLE_KEY) {
    return process.env.API_BIBLE_KEY;
  }
  if (apiBibleKeyCache) {
    return apiBibleKeyCache;
  }
  const auth = new GoogleAuth({
    scopes: ["https://www.googleapis.com/auth/cloud-platform"],
  });
  const client = await auth.getClient();
  const projectId =
    process.env.GCLOUD_PROJECT || process.env.GCP_PROJECT || admin.app().options.projectId;
  const url =
    "https://secretmanager.googleapis.com/v1/projects/" +
    `${projectId}/secrets/API_BIBLE_KEY/versions/latest:access`;
  const res = await client.request({url, method: "GET"});
  apiBibleKeyCache = Buffer.from(res.data.payload.data, "base64").toString("utf8");
  return apiBibleKeyCache;
}

exports.getBiblePassage = functions
  // Runs as the App Engine default service account, which Kingdom Heirs
  // granted Secret Manager Secret Accessor on API_BIBLE_KEY.
  .runWith({
    timeoutSeconds: 30,
    serviceAccount: "kingdom-heirs-discipleshipapp@appspot.gserviceaccount.com",
  })
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Sign in to read Scripture passages.",
      );
    }
    const bibleId = String((data && data.bibleId) || "");
    const passageId = String((data && data.passageId) || "");
    if (!/^[A-Za-z0-9-]{1,64}$/.test(bibleId) ||
        !kPassageIdPattern.test(passageId) ||
        !(await isApprovedBibleId(bibleId))) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Unknown Bible or passage.",
      );
    }
    const url =
      `https://api.scripture.api.bible/v1/bibles/${bibleId}/passages/` +
      `${encodeURIComponent(passageId)}?content-type=text&include-notes=false` +
      "&include-titles=false&include-chapter-numbers=false" +
      "&include-verse-numbers=true";
    let apiKey;
    try {
      apiKey = await getApiBibleKey();
    } catch (err) {
      // Most likely the runtime service account cannot read the secret.
      const status = err && err.response ? err.response.status : "";
      console.error("API_BIBLE_KEY access failed", status, err && err.message);
      throw new functions.https.HttpsError(
        "failed-precondition",
        `Bible key unavailable (Secret Manager ${status || "error"}).`,
      );
    }
    if (!apiKey) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Bible service is not configured.",
      );
    }
    const response = await fetch(url, {
      headers: {"api-key": apiKey.trim()},
    });
    if (!response.ok) {
      throw new functions.https.HttpsError(
        response.status === 404 ? "not-found" : "unavailable",
        `Bible service returned ${response.status}.`,
      );
    }
    const body = await response.json();
    const passage = body.data || {};
    return {
      reference: passage.reference || "",
      content: passage.content || "",
      copyright: passage.copyright || "",
      // Token only; the app reports each displayed passage to FUMS.
      fumsToken: (body.meta && body.meta.fumsToken) || "",
    };
  });

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  let firestore = admin.firestore();
  let userRef = firestore.doc("users/" + user.uid);
  await firestore.collection("users").doc(user.uid).delete();
});

// CMS CSV importer (Admin > Import page). Source: content_import.js
exports.importContentCsv = require("./content_import").importContentCsv;

// Machine translation for CMS-managed languages (see translation.js).
Object.assign(exports, require("./translation"));
