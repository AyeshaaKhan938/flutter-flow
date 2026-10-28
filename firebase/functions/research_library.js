// Kingdom Heirs Research Library and "Ask Kingdom Heirs".
//
// Manuscripts are split into chapter/heading sections (tools/
// manuscript_sections.py) and stored server-only in Firestore:
//   researchSources/{sourceId}    title, author, rights holder, edition,
//                                 pathway, language, status
//   researchSections/{sectionId}  text + embedding (never readable by clients)
//   config/askKingdomHeirs        { enabled, paused, dailyLimitPerMember,
//                                   testerEmails }
//
// askKingdomHeirs answers only from approved sections (and never the raw
// files), cites each source it used, links to the matching pathway (the app
// keeps locked pathways locked), refuses to invent teaching, never quotes
// long passages, and answers crisis messages with emergency guidance.
// Until Kingdom Heirs approves going live (config.enabled), only content
// admins and the internal testers in config.testerEmails can use it.
//
// The library is small (about a thousand sections), so search is a cosine
// similarity over embeddings cached in memory; no vector index is needed.

const { GoogleAuth } = require("google-auth-library");

const kLocation = "us-central1";
// Multilingual, so questions in Spanish, Urdu or Luganda find English sources.
const kEmbeddingModel = "text-multilingual-embedding-002";
const kAnswerModel = "gemini-2.5-flash";
// Faster fallback when the shared Gemini capacity is slow or busy.
const kFallbackModel = "gemini-2.5-flash-lite";
const kTopSections = 8;
const kMinScore = 0.45;
const kMaxQuestionLength = 1000;
const kDefaultDailyLimit = 100;
const kAdminRoles = ["admin", "ministry_reviewer"];
const kMaxExcerptWords = 40;
const kMaxCitations = 4;
// Shown to members: one primary source and up to two supporting sources,
// each book at most once.
const kMaxShownSources = 3;
// "App Help" answers questions about how the app works (pathway order,
// locked pathways, certificates); it outranks teaching sections for them.
const kAppHelpSourceId = "kh-app-help";
const kAppQuestionPattern = /\b(begin|start|first|order|sequence|pathways?|lock(ed)?|unlock|certificates?|commission(ing|ed)?|app)\b/i;
const kAppHelpBoost = 0.08;

// Safety boundaries (Kingdom Heirs, 28 October 2026). Each question is
// checked before any retrieval, in this order, and only the first matching
// category applies, so its template is never combined with another:
//   crisis    -> the emergency response only (no retrieval, no AI answer)
//   medical   -> medical template first, then what the resources teach
//   legal     -> legal template first (never mentions doctors or medication)
//   financial -> professional-advice template first
// Members are never asked for personal medical, legal or crisis details.
const kCrisisPattern = new RegExp(
  [
    "kill(ing)? (myself|me)\\b", "suicid", "end(ing)? my (own )?life", "end it all", "want to die",
    "don'?t want to (live|be alive)", "hurt(ing)? myself", "harm(ing)? myself", "self[- ]?harm",
    "danger of (hurting|harming|killing)", "in (immediate )?danger", "not safe", "unsafe at home",
    "cut(ting)? myself", "overdos",
    "(kill|hurt|harm|attack|shoot|stab)(ing)? (someone|somebody|him|her|them|my (wife|husband|child|children|kids?|parents?|mother|father|mom|dad|family))",
    "going to hurt", "want to hurt",
    "(being|been|am|was|is|are) (being )?abused", "abus(ing|es) me", "domestic (abuse|violence)",
    "sexual(ly)? abus", "molest", "raped?\\b", "beat(s|ing)? me", "hit(s|ting)? me", "threaten(s|ed|ing)? (me|to kill|to hurt)",
    "violen(t|ce) (at home|toward me|towards me|against me)",
  ].join("|"),
  "i",
);

const kCrisisTemplate =
  "If you are in immediate danger or may harm yourself or someone else, " +
  "call emergency services now. In the United States, call or text 988 for " +
  "the Suicide & Crisis Lifeline, or call 911. Outside the United States, " +
  "contact your local emergency number, nearest emergency room, or a crisis " +
  "service in your country. Please also contact a trusted person nearby who " +
  "can stay with you.";
const kCrisisAnswer = kCrisisTemplate + "\n\n" +
  "When you are safe, please also reach out to a trusted pastor, " +
  "safeguarding leader, counselor, or Recovery Mentor. You do not have to " +
  "carry this alone.";

const kMedicalPattern = /medic(ation|ine|al)|\bmeds\b|prescri|dosage|\bdose\b|\bpills?\b|diagnos|symptom|treatment|therap(y|ist)|psychiatr|psycholog|antidepress|mental[- ]health|mental illness|depress(ion|ed)|anxiety (disorder|attack)|panic attack|bipolar|schizo|\bptsd\b|eating disorder|counsel(l)?ing|counsel(l)?or|withdraw(al|ing)|detox|rehab|\bdoctor\b|hospital|surgery|chemo|cancer|insulin|vaccin/i;
const kMedicalTemplate =
  "Kingdom Heirs cannot provide medical or mental-health advice. Do not " +
  "start, stop, or change medication or treatment without speaking with a " +
  "licensed healthcare professional.";

const kLegalPattern = /\blegal(ly)?\b|lawyer|attorney|\blaw\b|\bsue\b|suing|lawsuit|court|judge|criminal|crime|arrest|police|press charges|charges against|custody|divorce|immigra|visa\b|deport|asylum|contract|\bsign (the|this|a)\b|my rights|legal rights|\brights\b|report (him|her|them|it|this|abuse|to the)|testify|subpoena|will and testament|inherit(ance)?|evict|landlord/i;
const kLegalTemplate =
  "Kingdom Heirs cannot provide legal advice. Please speak with a licensed " +
  "attorney in your state or country for advice about your situation.";

const kFinancialPattern = /financ|\bmoney\b.*\b(invest|loan|debt)|invest(ing|ment)?|\bstocks?\b|crypto|bitcoin|retirement|pension|401k|\btax(es)?\b|insurance|\bloan\b|\bdebt\b|mortgage|bankrupt|credit (card|score)|employ(er|ment)|\bmy job\b|fired|salary|wage|business (plan|decision)/i;
const kFinancialTemplate =
  "Kingdom Heirs cannot provide financial, tax, insurance, employment, or " +
  "other professional advice. Please speak with an appropriately licensed or " +
  "qualified professional about your situation.";

/** The single safety category for [q] (checked before retrieval). */
function safetyCategory(q) {
  if (kCrisisPattern.test(q)) return "crisis";
  if (kMedicalPattern.test(q)) return "medical";
  if (kLegalPattern.test(q)) return "legal";
  if (kFinancialPattern.test(q)) return "financial";
  return "";
}
const kSafetyTemplate = { medical: kMedicalTemplate, legal: kLegalTemplate, financial: kFinancialTemplate };
// What follows the template when the resources have nothing to add.
const kSafetyClosing = {
  medical: "A trusted pastor or ministry leader can also pray with you and walk with you as you seek wise care.",
  legal: "A trusted pastor or ministry leader can also pray with you and help you seek wisdom, truth, and safety.",
  financial: "A trusted pastor or ministry leader can also pray with you as you seek wise counsel.",
};
// Extra instructions to the model per category.
const kSafetyInstruction = {
  medical: "This question involves medical or mental-health matters. Do NOT diagnose, do not tell the person what to do, and never tell anyone to start, stop, change, or reject medication or treatment, or to rely on prayer instead of medical care. Share only what the sources teach about faith, prayer, and wise care, and encourage qualified professional support. Do not ask for personal medical details.",
  legal: "This question involves a legal matter. Do NOT give legal advice and do not say whether to sue, report, sign, testify, or take any legal action. Do NOT mention doctors, medication, or medical treatment. Share only what the sources teach about truth, forgiveness, boundaries, wisdom, safety, and seeking appropriate help. Do not ask for personal legal details.",
  financial: "This question involves financial or other professional matters. Do NOT give financial, tax, insurance, employment, or professional advice and do not tell the person what decision to make. Share only what the sources teach about wisdom, stewardship, and trust, and encourage a qualified professional. Do not ask for personal details.",
};
// Sentences removed from legal answers (the legal template must not mention
// medical care).
const kMedicalMention = /doctor|physician|medicat|medical|treatment|prescri|therap/i;
function dropSentences(text, pattern) {
  return text.split(/(?<=[.!?])\s+/).filter((s) => !pattern.test(s)).join(" ");
}

// The model must not repeat or mix in any safety template (each answer
// shows exactly one, added by the server), nor show internal source ids.
const kTemplateSentences = [kCrisisTemplate, kMedicalTemplate, kLegalTemplate, kFinancialTemplate]
  .flatMap((tpl) => tpl.split(/(?<=[.!?])\s+/))
  .map((s) => s.toLowerCase().replace(/[^a-z0-9]+/g, " ").trim());
function cleanAnswer(text) {
  const kept = text
    .replace(/\s*\((?:[a-z0-9]+(?:-[a-z0-9]+)*--\d{4}(?:,\s*)?)+\)/g, "")
    .replace(/\b[a-z0-9]+(?:-[a-z0-9]+)*--\d{4}\b/g, "")
    .split(/\n\n+/)
    .map((para) => para.split(/(?<=[.!?])\s+/).filter((s) => {
      const n = s.toLowerCase().replace(/[^a-z0-9]+/g, " ").trim();
      return n && !kTemplateSentences.some((tpl) => tpl.length > 20 && (n.includes(tpl) || tpl.includes(n) && n.length > 30));
    }).join(" "))
    .filter(Boolean);
  return kept.join("\n\n").trim();
}

/** Safety & Boundaries describes the rules; it is not teaching to cite. */
const isSafetyRules = (s) => s.sourceId === kAppHelpSourceId && s.chapterTitle === "Safety & Boundaries";

// Requests for whole chapters or books get a policy answer, not the text.
const kFullTextPattern = /(full|entire|whole|complete) (text|chapter|book)|word for word|verbatim|copy (the|this) (chapter|book)|download (the|this)? ?(book|manuscript)/i;
const kFullTextAnswer =
  "I can't share full chapters or the complete books, but I'm glad to " +
  "summarize a chapter, answer a question about it, or point you to the " +
  "pathway where it is taught. What would you like to know?";

// Questions in another language are answered in English until Kingdom
// Heirs approves reviewed translations.
const kEnglishOnlyNotice =
  "This answer is in English while reviewed translations are being prepared.";

const kNotFoundAnswer =
  "I couldn't find an answer to that in the approved Kingdom Heirs " +
  "resources. You may want to try different words, explore a related " +
  "pathway, or talk with a trusted pastor or ministry leader.";

const kSystemInstruction = `You are "Ask Kingdom Heirs", a helpful, warm assistant inside the Kingdom Heirs discipleship app.

Rules you must always follow:
1. Answer ONLY from the SOURCES provided in the user message. Do not use outside knowledge, other books, or your own opinions, and never present an opinion as Kingdom Heirs teaching.
2. If the SOURCES do not answer the question, set "found" to false and say so briefly. Do not guess.
3. Cite only the sources you actually drew from (at most ${kMaxCitations}), by id, in "citations". Never cite an id that is not in SOURCES.
4. Summarize in your own words. You may quote at most two short excerpts, each under ${kMaxExcerptWords} words. Never reproduce whole sections, chapters, or long passages.
5. When you mention Scripture, give the reference exactly as it appears in the SOURCES (for example "John 8:36") and do not quote more than one verse.
6. Be gentle, pastoral, and Scripture-centered. Do not give medical, mental-health, legal, diagnostic, or emergency advice. Never tell anyone to start, stop, or change a medication or treatment; say that such decisions belong with their doctor or a qualified professional. Never ask members to share personal medical, legal, or crisis details, and never pressure anyone to disclose trauma or to forgive on a timetable. For those needs, encourage a qualified professional or a trusted pastor.
7. Keep answers under 200 words and conversational.
8. A source titled "App Help" describes how the Kingdom Heirs app works (pathway order, locked pathways, certificates). For questions about the app, answer from App Help and cite it first.`;

// Kingdom Heirs has not approved machine-translated teaching, so answers are
// in English (questions may be in any language) unless
// config/askKingdomHeirs.answerInMemberLanguage is turned on.
const kLanguageRule = {
  english: "9. Always answer in English, even if the question is in another language.",
  member: "9. Answer in the same language as the question. Do not translate quotations from the sources.",
};

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

function modelUrl(admin, model, method, location = kLocation) {
  const host = location === "global" ? "aiplatform.googleapis.com" : `${location}-aiplatform.googleapis.com`;
  return `https://${host}/v1/projects/${projectId(admin)}/locations/${location}/` +
    `publishers/google/models/${model}:${method}`;
}

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

/** POST with retries on 429/503 (Vertex shared capacity), across locations. */
async function vertexPost(urls, data) {
  const client = await authClient();
  let lastErr = null;
  for (let attempt = 0; attempt < 3; attempt++) {
    const url = urls[attempt % urls.length];
    try {
      return await client.request({ url, method: "POST", data, timeout: 25000 });
    } catch (err) {
      const code = err && err.response && err.response.status;
      const timedOut = err && (err.type === "request-timeout" || /timeout/i.test(err.message || ""));
      lastErr = err;
      if (!timedOut && code !== 429 && code !== 503 && code !== 500) throw err;
      await sleep(500 * (attempt + 1));
    }
  }
  throw lastErr;
}

/** Embeddings for [texts] (RETRIEVAL_DOCUMENT or RETRIEVAL_QUERY). */
async function embed(admin, texts, taskType, titles) {
  const res = await vertexPost([modelUrl(admin, kEmbeddingModel, "predict")], {
      instances: texts.map((content, i) => ({
        content,
        task_type: taskType,
        ...(titles && titles[i] ? { title: titles[i] } : {}),
      })),
      parameters: { autoTruncate: true },
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

async function generate(admin, question, hits, memberLanguage, safety) {
  const sourcesBlock = hits.map(({ s }) =>
    `[${s.id}] ${citationLabel(s).replace(/^Source: /, "")}\n${s.text}`).join("\n\n---\n\n");
  const languageRule = kLanguageRule[memberLanguage ? "member" : "english"];
  const res = await vertexPost([
    modelUrl(admin, kAnswerModel, "generateContent", "global"),
    modelUrl(admin, kFallbackModel, "generateContent", "global"),
    modelUrl(admin, kAnswerModel, "generateContent"),
  ], {
      systemInstruction: {
        parts: [{ text: kSystemInstruction + "\n" + languageRule }],
      },
      contents: [{
        role: "user",
        parts: [{ text: `SOURCES:\n\n${sourcesBlock}\n\nQUESTION: ${question}\n\n(${languageRule.slice(3)})` +
          (safety ? `\n(${kSafetyInstruction[safety]} The required safety statement is already shown above your answer: do not repeat it or add any other disclaimer.)` : "") +
          "\n(Never write source ids in the answer text; list them only in \"citations\".)" }],
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
            questionLanguage: { type: "STRING", description: "ISO 639-1 code of the question's language" },
          },
          required: ["found", "answer", "citations", "questionLanguage"],
        },
        thinkingConfig: { thinkingBudget: 0 },
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

/** True for an internal tester listed in config.testerEmails. */
function isTester(config, email) {
  const e = String(email || "").trim().toLowerCase();
  return !!e && Array.isArray(config.testerEmails) &&
    config.testerEmails.some((t) => String(t).trim().toLowerCase() === e);
}

/** Questions about how the app works rank App Help above teaching. */
function boostAppHelp(hits, question) {
  if (!kAppQuestionPattern.test(question)) return hits;
  return hits
    .map((h) => (h.s.sourceId === kAppHelpSourceId ? { s: h.s, score: h.score + kAppHelpBoost } : h))
    .sort((a, b) => b.score - a.score);
}

/** One section per book, primary first, at most [kMaxShownSources]. */
function distinctSources(sections) {
  const seen = new Set();
  return sections.filter((s) => {
    if (seen.has(s.sourceId)) return false;
    seen.add(s.sourceId);
    return true;
  }).slice(0, kMaxShownSources);
}

/** Core of askKingdomHeirs, separated from the Firebase wiring for tests. */
async function answerQuestion({ db, admin, uid, email, question }) {
  const q = String(question || "").trim().slice(0, kMaxQuestionLength);
  if (!q) return { status: "empty", answer: "", citations: [] };

  const config = (await db.collection("config").doc("askKingdomHeirs").get()).data() || {};
  const adminUser = await isAdmin(db, uid);
  if (!config.enabled && !adminUser && !isTester(config, email)) {
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

  // Safety boundaries come before any retrieval or citations.
  const safety = safetyCategory(q);
  if (safety === "crisis") {
    return { status: "crisis", safety, answer: kCrisisAnswer, citations: [] };
  }
  const safetyTemplate = kSafetyTemplate[safety] || "";
  const safetyOnly = () => ({
    status: safety, safety,
    answer: `${safetyTemplate}\n\n${kSafetyClosing[safety]}`,
    citations: [],
  });
  if (kFullTextPattern.test(q)) {
    return { status: "policy", answer: kFullTextAnswer, citations: [] };
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
  const hits = boostAppHelp(search(sections, qv, kTopSections * 2), q)
    .filter((h) => !safety || !isSafetyRules(h.s))
    .slice(0, kTopSections);
  if (hits.length === 0) {
    return safety ? safetyOnly() : { status: "not_found", answer: kNotFoundAnswer, citations: [] };
  }

  const { parsed, usage } = await generate(admin, q, hits,
    config.answerInMemberLanguage === true, safety);
  const byId = new Map(hits.map(({ s }) => [s.id, s]));
  const cited = [...new Set((parsed.citations || []).filter((id) => byId.has(id)))]
    .slice(0, kMaxCitations);
  if (!parsed.found || cited.length === 0) {
    return safety ? safetyOnly() : { status: "not_found", answer: kNotFoundAnswer, citations: [] };
  }
  const used = cited.map((id) => byId.get(id));
  // App Help is app instructions, not a book, so it may be quoted in full.
  let answer = limitVerbatim(String(parsed.answer || "").trim(),
    used.filter((s) => s.sourceId !== kAppHelpSourceId));
  answer = cleanAnswer(answer);
  if (safety === "legal") answer = dropSentences(answer, kMedicalMention);
  if (!answer) return safetyOnly();
  const questionLanguage = String(parsed.questionLanguage || "en").toLowerCase().slice(0, 2);
  const languageNotice = config.answerInMemberLanguage !== true && questionLanguage !== "en"
    ? kEnglishOnlyNotice : "";
  if (languageNotice) answer = `${languageNotice}\n\n${answer}`;
  // The safety template always comes first.
  if (safetyTemplate) answer = `${safetyTemplate}\n\n${answer}`;
  const shown = distinctSources(used);

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
    safety,
    answer,
    languageNotice,
    citations: shown.map((s, i) => ({
      role: i === 0 ? "primary" : "supporting",
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
  // A new edition replaces every section of the old one.
  if (data.replace === true) {
    const old = await db.collection("researchSections").where("sourceId", "==", source.sourceId).get();
    for (let i = 0; i < old.docs.length; i += 50) {
      const batch = db.batch();
      old.docs.slice(i, i + 50).forEach((d) => batch.delete(d.ref));
      await batch.commit();
    }
  }
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
  safetyCategory,
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
    .runWith({ timeoutSeconds: 120, memory: "1GB" })
    .https.onCall(async (data, context) => {
      if (!context.auth) {
        throw new functionsLib.https.HttpsError("unauthenticated", "Sign in to ask a question.");
      }
      try {
        return await answerQuestion({
          db: db(), admin, uid: context.auth.uid,
          email: context.auth.token && context.auth.token.email,
          question: data && data.question,
        });
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

  // Member feedback on an answer ("Report an issue"). Stores only what the
  // member chose to send, for ministry review.
  module.exports.reportAskIssue = functionsLib.https.onCall(async (data, context) => {
    if (!context.auth) {
      throw new functionsLib.https.HttpsError("unauthenticated", "Sign in first.");
    }
    const text = (v, n) => String(v || "").slice(0, n);
    await db().collection("askReports").add({
      at: admin.firestore.FieldValue.serverTimestamp(),
      uid: context.auth.uid,
      reason: text(data && data.reason, 60),
      note: text(data && data.note, 1000),
      question: text(data && data.question, 1000),
      answer: text(data && data.answer, 4000),
      citations: Array.isArray(data && data.citations) ? data.citations.slice(0, 8).map((c) => text(c, 300)) : [],
      status: "open",
    });
    return { ok: true };
  });

  // Admin: read or change config/askKingdomHeirs (enabled, paused,
  // answerInMemberLanguage, dailyLimitPerMember, testerEmails).
  module.exports.askConfig = functionsLib.https.onCall(async (data, context) => {
    await requireAdmin(context);
    const ref = db().collection("config").doc("askKingdomHeirs");
    const allowed = ["enabled", "paused", "answerInMemberLanguage", "dailyLimitPerMember", "testerEmails"];
    const update = {};
    allowed.forEach((k) => {
      if (data && data.set && data.set[k] !== undefined) update[k] = data.set[k];
    });
    if (Object.keys(update).length) await ref.set(update, { merge: true });
    const snap = await ref.get();
    const out = snap.data() || {};
    if (out.pausedAt && out.pausedAt.toDate) out.pausedAt = out.pausedAt.toDate().toISOString();
    return out;
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
