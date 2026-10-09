// Kingdom Heirs Research Library and "Ask Kingdom Heirs".
//
// Manuscripts are split into chapter/heading sections (tools/
// manuscript_sections.py) and stored server-only in Firestore:
//   researchSources/{sourceId}    title, author, rights holder, edition,
//                                 pathway, language, status
//   researchSections/{sectionId}  text + embedding (never readable by clients)
//   config/askKingdomHeirs        { enabled, paused, dailyLimitPerMember }
//
// askKingdomHeirs answers only from approved sections (and never the raw
// files), cites each source it used, links to the matching pathway (the app
// keeps locked pathways locked), refuses to invent teaching, never quotes
// long passages, and answers crisis messages with emergency guidance.
// Until Kingdom Heirs approves going live (config.enabled), only content
// admins can use it.
//
// The library is small (about a thousand sections), so search is a cosine
// similarity over embeddings cached in memory; no vector index is needed.

const { GoogleAuth } = require("google-auth-library");

const kLocation = "us-central1";
const kEmbeddingModel = "text-embedding-005";
const kAnswerModel = "gemini-2.5-flash";
const kTopSections = 8;
const kMinScore = 0.45;
const kMaxQuestionLength = 1000;
const kDefaultDailyLimit = 100;
const kAdminRoles = ["admin", "ministry_reviewer"];
const kMaxExcerptWords = 40;

const kCrisisPattern = new RegExp(
  [
    "kill (myself|me)", "suicid", "end (my|it all)", "want to die",
    "don'?t want to (live|be alive)", "hurt (myself|me)", "self[- ]?harm",
    "cut(ting)? myself", "overdos", "being abused", "abusing me",
    "not safe at home", "going to hurt (someone|him|her|them)",
  ].join("|"),
  "i",
);

const kCrisisAnswer =
  "I'm really sorry you're facing this, and I'm glad you reached out. " +
  "If you are in immediate danger or thinking about harming yourself or " +
  "someone else, please contact your local emergency number now, or go to " +
  "the nearest emergency room. In the United States you can call or text " +
  "988 (Suicide & Crisis Lifeline) at any time. Please also reach out to a " +
  "trusted pastor, ministry leader, Recovery Mentor, or a qualified " +
  "counselor near you. You do not have to carry this alone.\n\n" +
  "\"The Lord is close to the brokenhearted and saves those who are " +
  "crushed in spirit.\" (Psalm 34:18)";

const kNotFoundAnswer =
  "I couldn't find an answer to that in the approved Kingdom Heirs " +
  "resources. You may want to try different words, explore a related " +
  "pathway, or talk with a trusted pastor or ministry leader.";

const kSystemInstruction = `You are "Ask Kingdom Heirs", a helpful, warm assistant inside the Kingdom Heirs discipleship app.

Rules you must always follow:
1. Answer ONLY from the SOURCES provided in the user message. Do not use outside knowledge, other books, or your own opinions, and never present an opinion as Kingdom Heirs teaching.
2. If the SOURCES do not answer the question, set "found" to false and say so briefly. Do not guess.
3. Cite every source you used by its id in "citations". Never cite an id that is not in SOURCES.
4. Summarize in your own words. You may quote at most two short excerpts, each under ${kMaxExcerptWords} words. Never reproduce whole sections, chapters, or long passages.
5. When you mention Scripture, give the reference exactly as it appears in the SOURCES (for example "John 8:36") and do not quote more than one verse.
6. Be gentle, pastoral, and Scripture-centered. Do not give medical, mental-health, legal, diagnostic, or emergency advice. Never pressure anyone to disclose trauma or to forgive on a timetable. For those needs, encourage a qualified professional or a trusted pastor.
7. Keep answers under 200 words, conversational, in the same language as the question (sources are in English; do not translate source quotations).`;

let auth = null;
function authClient() {
  if (!auth) {
    auth = new GoogleAuth({ scopes: ["https://www.googleapis.com/auth/cloud-platform"] });
  }
  return auth.getClient();
}

function projectId(admin) {
  return process.env.GCLOUD_PROJECT || process.env.GCP_PROJECT ||
    admin.app().options.projectId;
}

function modelUrl(admin, model, method) {
  return `https://${kLocation}-aiplatform.googleapis.com/v1/projects/` +
    `${projectId(admin)}/locations/${kLocation}/publishers/google/models/` +
    `${model}:${method}`;
}

/** Embeddings for [texts] (RETRIEVAL_DOCUMENT or RETRIEVAL_QUERY). */
async function embed(admin, texts, taskType, titles) {
  const client = await authClient();
  const res = await client.request({
    url: modelUrl(admin, kEmbeddingModel, "predict"),
    method: "POST",
    data: {
      instances: texts.map((content, i) => ({
        content,
        task_type: taskType,
        ...(titles && titles[i] ? { title: titles[i] } : {}),
      })),
      parameters: { autoTruncate: true },
    },
  });
  return res.data.predictions.map((p) => p.embeddings.values);
}

function norm(v) {
  let s = 0;
  for (const x of v) s += x * x;
  return Math.sqrt(s) || 1;
}

// Approved sections cached per instance; refreshed every 10 minutes so a
// newly approved source is searchable without a redeploy.
let cache = null;
let cacheAt = 0;
async function loadSections(db) {
  if (cache && Date.now() - cacheAt < 10 * 60 * 1000) return cache;
  const [sources, sections] = await Promise.all([
    db.collection("researchSources").where("status", "==", "approved").get(),
    db.collection("researchSections").where("status", "==", "approved").get(),
  ]);
  const approved = new Map(sources.docs.map((d) => [d.id, d.data()]));
  cache = [];
  sections.forEach((doc) => {
    const s = doc.data();
    if (!approved.has(s.sourceId) || !Array.isArray(s.embedding)) return;
    cache.push({ id: doc.id, ...s, norm: norm(s.embedding) });
  });
  cacheAt = Date.now();
  return cache;
}

function search(sections, queryVector, limit) {
  const qn = norm(queryVector);
  return sections
    .map((s) => {
      let dot = 0;
      for (let i = 0; i < queryVector.length; i++) dot += queryVector[i] * s.embedding[i];
      return { s, score: dot / (qn * s.norm) };
    })
    .filter((r) => r.score >= kMinScore)
    .sort((a, b) => b.score - a.score)
    .slice(0, limit);
}

/** "Source: Title, Chapter 4 — Chapter title" (day/week labels kept). */
function citationLabel(s) {
  const kind = s.chapterKind === "day" ? "Day" : s.chapterKind === "week" ? "Week" : "Chapter";
  const parts = [`Source: ${s.title}`];
  if (s.chapterNumber) {
    parts.push(`${kind} ${s.chapterNumber}${s.chapterTitle ? ` — ${s.chapterTitle}` : ""}`);
  } else if (s.chapterTitle) {
    parts.push(s.chapterTitle);
  }
  if (s.sectionTitle && s.sectionTitle !== s.chapterTitle) parts.push(s.sectionTitle);
  return parts.join(", ");
}

/** Cuts any run of 25+ consecutive words copied from a source. */
function limitVerbatim(answer, sources) {
  const words = answer.split(/\s+/);
  const sourceText = " " + sources.map((s) => s.text.toLowerCase().replace(/\s+/g, " ")).join(" ") + " ";
  const kRun = 25;
  let out = [];
  for (let i = 0; i < words.length;) {
    let len = 0;
    while (i + len + kRun <= words.length &&
      sourceText.includes(" " + words.slice(i, i + len + kRun).join(" ").toLowerCase() + " ")) {
      len++;
    }
    if (len > 0) {
      out = out.concat(words.slice(i, i + kRun - 5), ["…"]);
      i += len + kRun - 1;
    } else {
      out.push(words[i]);
      i++;
    }
  }
  return out.join(" ");
}

async function generate(admin, question, hits) {
  const sourcesBlock = hits.map(({ s }) =>
    `[${s.id}] ${citationLabel(s).replace(/^Source: /, "")}\n${s.text}`).join("\n\n---\n\n");
  const client = await authClient();
  const res = await client.request({
    url: modelUrl(admin, kAnswerModel, "generateContent"),
    method: "POST",
    data: {
      systemInstruction: { parts: [{ text: kSystemInstruction }] },
      contents: [{
        role: "user",
        parts: [{ text: `SOURCES:\n\n${sourcesBlock}\n\nQUESTION: ${question}` }],
      }],
      generationConfig: {
        temperature: 0.2,
        maxOutputTokens: 900,
        responseMimeType: "application/json",
        responseSchema: {
          type: "OBJECT",
          properties: {
            found: { type: "BOOLEAN" },
            answer: { type: "STRING" },
            citations: { type: "ARRAY", items: { type: "STRING" } },
          },
          required: ["found", "answer", "citations"],
        },
        thinkingConfig: { thinkingBudget: 0 },
      },
    },
  });
  const cand = res.data.candidates && res.data.candidates[0];
  const text = cand && cand.content && cand.content.parts &&
    cand.content.parts.map((p) => p.text || "").join("");
  const usage = res.data.usageMetadata || {};
  return { parsed: JSON.parse(text || "{}"), usage };
}

async function isAdmin(db, uid) {
  const user = await db.collection("users").doc(uid).get();
  return kAdminRoles.includes((user.data() || {}).role || "");
}

/** Core of askKingdomHeirs, separated from the Firebase wiring for tests. */
async function answerQuestion({ db, admin, uid, question }) {
  const q = String(question || "").trim().slice(0, kMaxQuestionLength);
  if (!q) return { status: "empty", answer: "", citations: [] };

  const config = (await db.collection("config").doc("askKingdomHeirs").get()).data() || {};
  const adminUser = await isAdmin(db, uid);
  if (!config.enabled && !adminUser) {
    return {
      status: "not_live",
      answer: "Ask Kingdom Heirs is coming soon. Thank you for your patience.",
      citations: [],
    };
  }
  if (config.paused) {
    return {
      status: "paused",
      answer: "Ask Kingdom Heirs is resting for a little while. Please try again later. " +
        "Your pathways and lessons are still available.",
      citations: [],
    };
  }

  if (kCrisisPattern.test(q)) {
    return { status: "crisis", answer: kCrisisAnswer, citations: [] };
  }

  // Per-member daily safety limit (blocks automated abuse only).
  const day = new Date().toISOString().slice(0, 10);
  const usageRef = db.collection("users").doc(uid).collection("askUsage").doc(day);
  const limit = Number(config.dailyLimitPerMember) || kDefaultDailyLimit;
  const allowed = await db.runTransaction(async (tx) => {
    const snap = await tx.get(usageRef);
    const count = (snap.data() || {}).count || 0;
    if (count >= limit && !adminUser) return false;
    tx.set(usageRef, { count: count + 1 }, { merge: true });
    return true;
  });
  if (!allowed) {
    return {
      status: "limit",
      answer: "You've asked a lot of questions today. Please come back tomorrow.",
      citations: [],
    };
  }

  const sections = await loadSections(db);
  const [qv] = await embed(admin, [q], "RETRIEVAL_QUERY");
  const hits = search(sections, qv, kTopSections);
  if (hits.length === 0) {
    return { status: "not_found", answer: kNotFoundAnswer, citations: [] };
  }

  const { parsed, usage } = await generate(admin, q, hits);
  const byId = new Map(hits.map(({ s }) => [s.id, s]));
  const cited = [...new Set((parsed.citations || []).filter((id) => byId.has(id)))];
  if (!parsed.found || cited.length === 0) {
    return { status: "not_found", answer: kNotFoundAnswer, citations: [] };
  }
  const used = cited.map((id) => byId.get(id));
  const answer = limitVerbatim(String(parsed.answer || "").trim(), used);

  // Minimal, non-identifying usage record (no question text is stored).
  await db.collection("askLogs").add({
    at: admin.firestore.FieldValue.serverTimestamp(),
    day,
    sources: used.map((s) => s.sourceId),
    inputTokens: usage.promptTokenCount || 0,
    outputTokens: usage.candidatesTokenCount || 0,
  });

  return {
    status: "ok",
    answer,
    citations: used.map((s) => ({
      sectionId: s.id,
      label: citationLabel(s),
      sourceTitle: s.title,
      chapterNumber: s.chapterNumber || null,
      chapterTitle: s.chapterTitle || "",
      pathwayId: s.pathwayId || "",
    })),
  };
}

/**
 * Stores one source and a batch of its sections with embeddings.
 * data: { source: {sourceId, title, author, rightsHolder, edition, pathwayId,
 *         track, language, status, sourceFile, notes}, sections: [ ... ] }
 */
async function ingest({ db, admin, data }) {
  const source = data && data.source;
  const sections = (data && data.sections) || [];
  if (!source || !/^[a-z0-9-]{3,80}$/.test(source.sourceId || "")) {
    throw new Error("source.sourceId is required");
  }
  const status = source.status === "approved" ? "approved" : "draft";
  await db.collection("researchSources").doc(source.sourceId).set({
    sourceId: source.sourceId,
    title: String(source.title || ""),
    author: String(source.author || ""),
    rightsHolder: String(source.rightsHolder || "Kingdom Heirs Foundation"),
    edition: String(source.edition || ""),
    pathwayId: String(source.pathwayId || ""),
    track: String(source.track || ""),
    language: String(source.language || "en"),
    sourceFile: String(source.sourceFile || ""),
    notes: String(source.notes || ""),
    status,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, { merge: true });

  let written = 0;
  for (let i = 0; i < sections.length; i += 5) {
    const chunk = sections.slice(i, i + 5);
    const vectors = await embed(admin, chunk.map((s) => s.text),
      "RETRIEVAL_DOCUMENT", chunk.map((s) => [s.chapterTitle, s.sectionTitle].filter(Boolean).join(" — ")));
    const batch = db.batch();
    chunk.forEach((s, j) => {
      const id = `${source.sourceId}--${String(s.sectionIndex).padStart(4, "0")}`;
      batch.set(db.collection("researchSections").doc(id), {
        sourceId: source.sourceId,
        title: String(source.title || ""),
        pathwayId: String(source.pathwayId || ""),
        language: String(source.language || "en"),
        chapterNumber: s.chapterNumber || null,
        chapterKind: s.chapterKind || "",
        chapterTitle: String(s.chapterTitle || ""),
        sectionTitle: String(s.sectionTitle || ""),
        headingPath: Array.isArray(s.headingPath) ? s.headingPath.map(String) : [],
        sectionIndex: s.sectionIndex,
        text: String(s.text || ""),
        wordCount: s.wordCount || 0,
        embedding: vectors[j],
        status,
      });
    });
    await batch.commit();
    written += chunk.length;
  }
  cache = null;
  return { sourceId: source.sourceId, status, sections: written };
}

/** Sets status on a source and all of its sections (draft / approved). */
async function setSourceStatus({ db, sourceId, status }) {
  const value = status === "approved" ? "approved" : "draft";
  await db.collection("researchSources").doc(sourceId).set({ status: value }, { merge: true });
  const snap = await db.collection("researchSections").where("sourceId", "==", sourceId).get();
  for (let i = 0; i < snap.docs.length; i += 400) {
    const batch = db.batch();
    snap.docs.slice(i, i + 400).forEach((d) => batch.update(d.ref, { status: value }));
    await batch.commit();
  }
  cache = null;
  return { sourceId, status: value, sections: snap.size };
}

module.exports = {
  answerQuestion, ingest, setSourceStatus, citationLabel, limitVerbatim, search, kCrisisPattern,
};

// Firebase wiring (skipped when loaded by local tests).
let functionsLib = null;
try {
  functionsLib = require("firebase-functions");
} catch (_) {
  functionsLib = null;
}
if (functionsLib) {
  const admin = require("firebase-admin");
  const db = () => {
    if (!admin.apps.length) admin.initializeApp();
    return admin.firestore();
  };
  const requireAdmin = async (context) => {
    if (!context.auth) {
      throw new functionsLib.https.HttpsError("unauthenticated", "Sign in first.");
    }
    if (!(await isAdmin(db(), context.auth.uid))) {
      throw new functionsLib.https.HttpsError("permission-denied", "Content administrators only.");
    }
  };

  module.exports.askKingdomHeirs = functionsLib
    .runWith({ timeoutSeconds: 60, memory: "1GB" })
    .https.onCall(async (data, context) => {
      if (!context.auth) {
        throw new functionsLib.https.HttpsError("unauthenticated", "Sign in to ask a question.");
      }
      try {
        return await answerQuestion({ db: db(), admin, uid: context.auth.uid, question: data && data.question });
      } catch (err) {
        console.error("askKingdomHeirs failed", err && err.response ? err.response.data : err);
        throw new functionsLib.https.HttpsError("internal", "Ask Kingdom Heirs could not answer right now.");
      }
    });

  module.exports.ingestResearchSections = functionsLib
    .runWith({ timeoutSeconds: 540, memory: "1GB" })
    .https.onCall(async (data, context) => {
      await requireAdmin(context);
      try {
        return await ingest({ db: db(), admin, data });
      } catch (err) {
        console.error("ingestResearchSections failed", err && err.response ? err.response.data : err);
        throw new functionsLib.https.HttpsError("internal", String(err.message || err));
      }
    });

  module.exports.setResearchSourceStatus = functionsLib
    .runWith({ timeoutSeconds: 120 })
    .https.onCall(async (data, context) => {
      await requireAdmin(context);
      return setSourceStatus({ db: db(), sourceId: String(data && data.sourceId || ""), status: data && data.status });
    });

  // Budget alerts (Pub/Sub topic "ask-kingdom-heirs-budget", linked to the
  // $50/month Cloud Billing budget) pause Ask Kingdom Heirs at 100%.
  module.exports.onAskBudgetAlert = functionsLib.pubsub
    .topic("ask-kingdom-heirs-budget")
    .onPublish(async (message) => {
      const n = message.json || {};
      if (Number(n.costAmount) >= Number(n.budgetAmount) && Number(n.budgetAmount) > 0) {
        await db().collection("config").doc("askKingdomHeirs").set({
          paused: true,
          pausedAt: admin.firestore.FieldValue.serverTimestamp(),
          pausedReason: `Budget reached: ${n.costAmount} of ${n.budgetAmount} ${n.currencyCode || ""}`,
        }, { merge: true });
      }
    });
}
