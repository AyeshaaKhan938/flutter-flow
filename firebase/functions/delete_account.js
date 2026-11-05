// "Delete my account": removes a member's account and personal data.
//
// Called by the signed-in member from Profile. Deletes, in order:
//   1. users/{uid} and every subcollection under it (certificates,
//      fcm_tokens, askUsage, and anything the older backend keeps there);
//   2. documents in any top-level collection whose userId, uid or user
//      field points at the member (reflections, askReports, and progress,
//      quiz and assessment records written by the older backend);
//   3. the Firebase Authentication account (onUserDeleted then runs too).
// Shared content (pathways, lessons, quizzes, daily content) is never
// touched. Ask logs hold no member id. Nothing about the member is kept.

const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Content and configuration collections: never searched for member data.
const kSharedCollections = new Set([
  "pathways",
  "lessons",
  "quizzes",
  "dailyScripture",
  "encouragements",
  "announcements",
  "onboardingQuestions",
  "assessmentQuestions",
  "assessmentItems",
  "languages",
  "machineTranslations",
  "importJobs",
  "researchSources",
  "researchSections",
  "askLogs",
  "config",
  "users",
  "ff_push_notifications",
]);

async function deleteMemberDocuments(firestore, uid) {
  const userRef = firestore.doc(`users/${uid}`);
  const writer = firestore.bulkWriter();
  let removed = 0;
  const collections = await firestore.listCollections();
  for (const collection of collections) {
    if (kSharedCollections.has(collection.id)) {
      continue;
    }
    const queries = [
      collection.where("userId", "==", uid),
      collection.where("uid", "==", uid),
      collection.where("user", "==", userRef),
      collection.where("userRef", "==", userRef),
    ];
    for (const query of queries) {
      const snap = await query.get();
      for (const doc of snap.docs) {
        // Subcollections of a member's record go with it.
        await firestore.recursiveDelete(doc.ref, writer);
        removed++;
      }
    }
  }
  await writer.close();
  return removed;
}

exports.deleteMyAccount = functions
  .runWith({timeoutSeconds: 300, memory: "512MB"})
  .https.onCall(async (data, context) => {
    const uid = context.auth && context.auth.uid;
    if (!uid) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Sign in to delete your account.",
      );
    }
    // Deleting requires a recent sign-in, so a borrowed unlocked phone
    // cannot delete the account long after the member signed in.
    const authTime = (context.auth.token && context.auth.token.auth_time) || 0;
    if (Date.now() / 1000 - authTime > 10 * 60) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "requires-recent-login",
      );
    }

    const firestore = admin.firestore();
    const removed = await deleteMemberDocuments(firestore, uid);
    await firestore.recursiveDelete(firestore.doc(`users/${uid}`));
    await admin.auth().deleteUser(uid);
    console.log(`Account deleted (${removed} related documents).`);
    return {deleted: true};
  });

exports.deleteMemberDocuments = deleteMemberDocuments;
