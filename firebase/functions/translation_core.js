// Server-side machine translation shared by the importer: creates review
// drafts in machineTranslations for English texts that changed, so revised
// records get updated translations in every additional language before
// Kingdom Heirs reviews and publishes them. Same cache layout as the
// translateTexts callable (translation.js). Never used for Scripture.

const crypto = require("crypto");
const { GoogleAuth } = require("google-auth-library");

const kCollection = "machineTranslations";
const auth = new GoogleAuth({
  scopes: ["https://www.googleapis.com/auth/cloud-translation"],
});

function docIdFor(lang, text) {
  const hash = crypto.createHash("sha256").update(text, "utf8").digest("hex");
  return `${lang}_${hash}`;
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
      body: JSON.stringify({ q: texts, source: "en", target, format: "text" }),
    },
  );
  if (!response.ok) {
    throw new Error(`Translation service returned ${response.status}.`);
  }
  const body = await response.json();
  return ((body.data && body.data.translations) || []).map(
    (t) => t.translatedText || "",
  );
}

/**
 * Ensures a machine draft exists for each English text in `lang`.
 * Existing (machine or approved) entries for the same text are kept.
 * Returns the number of new drafts created.
 */
async function ensureMachineDrafts(db, admin, texts, lang) {
  const unique = [...new Set(texts.filter((t) => t && t.trim().length > 0))];
  let created = 0;
  for (let start = 0; start < unique.length; start += 100) {
    const chunk = unique.slice(start, start + 100);
    const refs = chunk.map((t) => db.collection(kCollection).doc(docIdFor(lang, t)));
    const snaps = await db.getAll(...refs);
    const missing = chunk.filter((_, i) => !snaps[i].exists);
    if (missing.length === 0) continue;
    const translated = await googleTranslate(missing, lang);
    const batch = db.batch();
    missing.forEach((text, j) => {
      if (!translated[j]) return;
      batch.set(db.collection(kCollection).doc(docIdFor(lang, text)), {
        sourceText: text,
        targetLanguage: lang,
        translatedText: translated[j],
        status: "machine",
        provider: "google-v2",
        reason: "english_source_revised",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      }, { merge: true });
      created++;
    });
    await batch.commit();
  }
  return created;
}

module.exports = { ensureMachineDrafts };
