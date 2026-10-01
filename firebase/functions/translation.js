// Machine translation of Kingdom Heirs-authored English text (lesson titles,
// reflection prompts, applications, prayers, quiz/assessment questions,
// Daily Truth commentary, encouragements, announcements, UI labels) into
// the languages administrators activate in the `languages` collection.
//
// NEVER send Scripture here: Bible passages come from API.Bible
// (getBiblePassage) in each language's approved Bible, or in English.
//
// Every translation is cached in `machineTranslations/{lang}_{sha256(text)}`
// and shared by all members, so Google Cloud Translation is billed once per
// distinct text and language. Administrators review, correct and approve
// entries in the app (Admin > Languages > Translation review); approved
// text replaces the machine text everywhere.
//
// Requires the Cloud Translation API to be enabled in the Firebase project's
// Google Cloud console; the function's service account needs the
// "Cloud Translation API User" role (the default compute service account
// has Editor, which includes it).
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const crypto = require("crypto");
const { GoogleAuth } = require("google-auth-library");

if (!admin.apps.length) {
  admin.initializeApp();
}

const kMaxTexts = 100;
const kMaxTextLength = 5000;
const kCollection = "machineTranslations";

// Built-in languages: allowed when no `languages` doc exists for them yet,
// matching the app's fallback when the collection has not been seeded.
const kBuiltInLanguages = new Set(["es", "ur", "lg"]);

const auth = new GoogleAuth({
  scopes: ["https://www.googleapis.com/auth/cloud-translation"],
});

function docIdFor(lang, text) {
  const hash = crypto.createHash("sha256").update(text, "utf8").digest("hex");
  return `${lang}_${hash}`;
}

// Active languages, cached in memory for 5 minutes.
let languagesCache = null;
let languagesCachedAt = 0;
async function loadLanguages() {
  if (languagesCache && Date.now() - languagesCachedAt < 5 * 60 * 1000) {
    return languagesCache;
  }
  const snap = await admin.firestore().collection("languages").get();
  const map = new Map();
  snap.forEach((doc) => {
    const data = doc.data() || {};
    const code = String(data.code || doc.id).trim().toLowerCase();
    map.set(code, data);
  });
  languagesCache = map;
  languagesCachedAt = Date.now();
  return map;
}

async function googleTranslate(texts, target) {
  const client = await auth.getClient();
  const { token } = await client.getAccessToken();
  const projectId = await auth.getProjectId();
  const response = await fetch(
    "https://translation.googleapis.com/language/translate/v2",
    {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json; charset=utf-8",
        "x-goog-user-project": projectId,
      },
      body: JSON.stringify({
        q: texts,
        source: "en",
        target,
        format: "text",
      }),
    },
  );
  if (!response.ok) {
    const detail = await response.text();
    console.error("Cloud Translation error", response.status, detail);
    throw new functions.https.HttpsError(
      response.status === 403 ? "failed-precondition" : "unavailable",
      `Translation service returned ${response.status}.`,
    );
  }
  const body = await response.json();
  return ((body.data && body.data.translations) || []).map(
    (t) => t.translatedText || "",
  );
}

exports.translateTexts = functions
  .runWith({ timeoutSeconds: 60, memory: "256MB" })
  .https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Sign in to load translations.",
      );
    }
    const lang = String((data && data.targetLanguage) || "")
      .trim()
      .toLowerCase();
    const texts = Array.isArray(data && data.texts) ? data.texts : null;
    if (!/^[a-z]{2,3}([_-][a-z0-9]{2,4})?$/.test(lang) || lang === "en") {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Unknown target language.",
      );
    }
    if (!texts || texts.length > kMaxTexts ||
        texts.some((t) => typeof t !== "string" || t.length > kMaxTextLength)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        `Send 1-${kMaxTexts} texts of at most ${kMaxTextLength} characters.`,
      );
    }

    const languages = await loadLanguages();
    const config = languages.get(lang);
    const allowed = config ?
      config.active !== false &&
        (config.tier === "machine" || config.tier === "approved") :
      kBuiltInLanguages.has(lang);
    if (!allowed) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "This language is not active.",
      );
    }
    const googleTarget =
      String((config && config.googleCode) || "").trim() || lang;

    const db = admin.firestore();
    const unique = [...new Set(texts.filter((t) => t.trim().length > 0))];
    const refs = unique.map((t) =>
      db.collection(kCollection).doc(docIdFor(lang, t)));
    const snaps = refs.length ? await db.getAll(...refs) : [];

    const results = new Map();
    const misses = [];
    snaps.forEach((snap, i) => {
      const d = snap.exists ? snap.data() : null;
      if (d && d.status === "approved" && d.approvedText) {
        results.set(unique[i], { text: d.approvedText, status: "approved" });
      } else if (d && d.translatedText) {
        results.set(unique[i], { text: d.translatedText, status: "machine" });
      } else {
        misses.push(i);
      }
    });

    // Only texts never translated before reach Google (billed per character).
    for (let start = 0; start < misses.length; start += 100) {
      const chunk = misses.slice(start, start + 100);
      const translated =
        await googleTranslate(chunk.map((i) => unique[i]), googleTarget);
      const batch = db.batch();
      chunk.forEach((i, j) => {
        const text = translated[j] || "";
        if (!text) {
          return;
        }
        results.set(unique[i], { text, status: "machine" });
        batch.set(refs[i], {
          sourceText: unique[i],
          targetLanguage: lang,
          translatedText: text,
          status: "machine",
          provider: "google-v2",
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        }, { merge: true });
      });
      await batch.commit();
    }

    return {
      targetLanguage: lang,
      translations: texts.map((t) => {
        const r = results.get(t);
        return r ?
          { sourceText: t, text: r.text, status: r.status } :
          { sourceText: t, text: "", status: "none" };
      }),
    };
  });
