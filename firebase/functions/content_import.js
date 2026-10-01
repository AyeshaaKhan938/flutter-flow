// CMS CSV importer for Kingdom Heirs content.
//
// Callable `importContentCsv` ({type, fileName, csvText, mode}) validates a
// CSV in the formats documented in docs/import/README.md and, in 'commit'
// mode, upserts it into Firestore by `stableId`. Every run writes a report to
// `importJobs/{jobId}`.
//
// The parsing / validation / planning steps are pure functions (exported for
// local testing without Firebase): parseCsv -> validateRows -> buildPlan.

const kStatuses = ["draft", "review", "published", "unpublished"];
const kKnownLangs = ["en", "es", "ur", "lg"];
const kOptionLetters = ["A", "B", "C", "D"];
const kBatchLimit = 400;
const kMaxCsvChars = 8 * 1024 * 1024;
const kMaxStoredIssues = 500;
const kMaxStoredRowResults = 1000;

// ---------------------------------------------------------------------------
// Type definitions
// ---------------------------------------------------------------------------

// columns: non-localized columns accepted for the type.
// localized: field prefixes accepted as `<field>_<lang>`.
// requiredHeaders: headers that must be present.
// requiredValues: columns that must be non-empty on every row.
const kTypes = {
  pathways: {
    label: "Pathways",
    collection: "pathways",
    idColumn: "stableId",
    columns: ["stableId", "order", "durationDays", "status"],
    localized: ["title", "description"],
    requiredHeaders: ["stableId", "order", "title_en"],
    requiredValues: ["stableId", "order", "title_en"],
    ints: ["order", "durationDays"],
  },
  lessons: {
    label: "Lessons",
    collection: "lessons",
    idColumn: "stableId",
    columns: ["stableId", "pathwayId", "dayNumber", "status", "scriptureRef"],
    localized: [
      "title",
      "scriptureText",
      "reflectionPrompt",
      "application",
      "prayer",
    ],
    requiredHeaders: ["stableId", "pathwayId", "dayNumber", "title_en"],
    requiredValues: ["stableId", "pathwayId", "dayNumber", "title_en"],
    ints: ["dayNumber"],
  },
  quiz_questions: {
    label: "Quiz questions",
    collection: "quizzes",
    idColumn: "quizStableId",
    columns: [
      "quizStableId",
      "pathwayId",
      "lessonId",
      "passingScore",
      "status",
      "questionNumber",
      "correctAnswer",
    ],
    localized: ["title", "question", "optionA", "optionB", "optionC", "optionD"],
    requiredHeaders: [
      "quizStableId",
      "pathwayId",
      "lessonId",
      "questionNumber",
      "question_en",
      "optionA_en",
      "optionB_en",
      "correctAnswer",
    ],
    requiredValues: [
      "quizStableId",
      "pathwayId",
      "lessonId",
      "questionNumber",
      "question_en",
      "optionA_en",
      "optionB_en",
      "correctAnswer",
    ],
    ints: ["passingScore", "questionNumber"],
  },
  daily_scripture: {
    label: "Daily Scripture",
    collection: "dailyScripture",
    idColumn: "stableId",
    columns: [
      "stableId",
      "date",
      "dayNumber",
      "verseRef",
      "status",
      "readInContext",
    ],
    localized: ["theme", "text"],
    requiredHeaders: ["stableId", "date", "verseRef", "text_en"],
    requiredValues: ["stableId", "date", "verseRef", "text_en"],
    ints: ["dayNumber"],
  },
  encouragements: {
    label: "Encouragements",
    collection: "encouragements",
    idColumn: "stableId",
    columns: [
      "stableId",
      "date",
      "dayNumber",
      "scriptureRef",
      "attribution",
      "rightsCleared",
      "status",
      "collectionTheme",
    ],
    localized: ["title", "quote"],
    requiredHeaders: ["stableId", "date", "quote_en"],
    requiredValues: ["stableId", "date", "quote_en"],
    ints: ["dayNumber"],
    bools: ["rightsCleared"],
  },
  assessment_questions: {
    label: "Assessment questions",
    collection: "assessmentItems",
    idColumn: "questionId",
    columns: [
      "questionId",
      "sequence",
      "optionId",
      "points",
      "triggerCode",
      "active",
      "status",
    ],
    localized: ["question", "answer"],
    requiredHeaders: [
      "questionId",
      "sequence",
      "optionId",
      "points",
      "question_en",
      "answer_en",
    ],
    // question_en is checked once per questionId (it may be given on the
    // first option row only).
    requiredValues: ["questionId", "sequence", "optionId", "points", "answer_en"],
    ints: ["sequence", "points"],
    bools: ["active"],
  },
};

// ---------------------------------------------------------------------------
// CSV parsing
// ---------------------------------------------------------------------------

/**
 * RFC 4180 CSV parser. Handles a UTF-8 BOM, CRLF / LF / CR line endings,
 * quoted fields containing commas, quotes ("") and newlines.
 *
 * Returns {headers, records: [{row, values: {header: value}, extra: []}],
 * errors: [{row, column, message}]}. `row` is the spreadsheet row number
 * (header = row 1). Fully blank lines are skipped but still counted.
 */
function parseCsv(text) {
  const errors = [];
  if (typeof text !== "string") {
    return {
      headers: [],
      records: [],
      errors: [{ row: 0, column: "", message: "No CSV text received." }],
    };
  }
  if (text.charCodeAt(0) === 0xfeff) {
    text = text.slice(1);
  }

  const rawRows = [];
  let row = [];
  let field = "";
  let inQuotes = false;
  let quotedField = false;
  let i = 0;
  const n = text.length;
  const endField = () => {
    row.push(field);
    field = "";
    quotedField = false;
  };
  const endRow = () => {
    endField();
    rawRows.push(row);
    row = [];
  };
  while (i < n) {
    const c = text[i];
    if (inQuotes) {
      if (c === '"') {
        if (text[i + 1] === '"') {
          field += '"';
          i += 2;
          continue;
        }
        inQuotes = false;
        i++;
        continue;
      }
      field += c;
      i++;
      continue;
    }
    if (c === '"') {
      if (field.length === 0 && !quotedField) {
        inQuotes = true;
        quotedField = true;
      } else {
        // Stray quote inside an unquoted field: keep it literally.
        field += c;
      }
      i++;
      continue;
    }
    if (c === ",") {
      endField();
      i++;
      continue;
    }
    if (c === "\r" || c === "\n") {
      endRow();
      if (c === "\r" && text[i + 1] === "\n") {
        i++;
      }
      i++;
      continue;
    }
    field += c;
    i++;
  }
  if (inQuotes) {
    errors.push({
      row: rawRows.length + 1,
      column: "",
      message: "Unterminated quoted field (a \" is not closed).",
    });
  }
  if (field.length > 0 || row.length > 0 || quotedField) {
    endRow();
  }

  if (rawRows.length === 0) {
    errors.push({ row: 1, column: "", message: "The file is empty." });
    return { headers: [], records: [], errors };
  }

  const headers = rawRows[0].map((h) => h.trim());
  const seen = new Set();
  headers.forEach((h, idx) => {
    if (h === "") {
      // An empty trailing header from a trailing comma is harmless.
      return;
    }
    if (seen.has(h)) {
      errors.push({
        row: 1,
        column: h,
        message: `Duplicate column header "${h}" (column ${idx + 1}).`,
      });
    }
    seen.add(h);
  });

  const records = [];
  for (let r = 1; r < rawRows.length; r++) {
    const cells = rawRows[r];
    if (cells.every((c) => c.trim() === "")) {
      continue;
    }
    const values = {};
    const extra = [];
    cells.forEach((cell, idx) => {
      const h = headers[idx];
      if (idx >= headers.length) {
        if (cell.trim() !== "") extra.push(cell);
        return;
      }
      if (!h) return;
      values[h] = cell;
    });
    records.push({ row: r + 1, values, extra });
  }
  return { headers, records, errors };
}

// ---------------------------------------------------------------------------
// Validation
// ---------------------------------------------------------------------------

function isValidMonthDay(s) {
  const m = /^(\d{2})-(\d{2})$/.exec(s);
  if (!m) return false;
  const month = Number(m[1]);
  const day = Number(m[2]);
  if (month < 1 || month > 12 || day < 1) return false;
  // Leap year so that 02-29 is accepted.
  const daysInMonth = new Date(Date.UTC(2024, month, 0)).getUTCDate();
  return day <= daysInMonth;
}

function parseIntStrict(s) {
  if (!/^-?\d+$/.test(s)) return null;
  const v = Number(s);
  return Number.isSafeInteger(v) ? v : null;
}

function parseBool(s) {
  const v = s.toLowerCase();
  if (["true", "yes", "y", "1"].includes(v)) return true;
  if (["false", "no", "n", "0"].includes(v)) return false;
  return null;
}

function isValidDocId(id) {
  return (
    id.length > 0 &&
    id.length <= 700 &&
    !id.includes("/") &&
    id !== "." &&
    id !== ".." &&
    !/^__.*__$/.test(id)
  );
}

/** Splits a header into {field, lang} if it is a `<field>_<lang>` column. */
function splitLocalizedHeader(header, def) {
  const m = /^(.+)_([A-Za-z]{2,3})$/.exec(header);
  if (!m) return null;
  if (!def.localized.includes(m[1])) return null;
  return { field: m[1], lang: m[2].toLowerCase() };
}

/**
 * Validates parsed CSV rows for `type`.
 *
 * `refs` (optional) carries Firestore lookups for link checks:
 *   {pathways: Set<pathwayStableId>, lessons: Map<pathwayStableId, Set<lessonStableId>>}
 * When omitted, link checks are skipped (used by local tests).
 *
 * Returns {records, errors, warnings, rowCount, failedRows: Set<row>,
 *   duplicatesInFile: [...], translationStatus: {lang: n}}.
 * Each record is grouped by its id ({id, rows, fields, localized, status,
 * pathwayId, questions?, options?}).
 */
function validateRows(type, parsed, refs) {
  const def = kTypes[type];
  const errors = [];
  const warnings = [];
  const failedRows = new Set();
  const duplicatesInFile = [];
  const translationStatus = {};
  kKnownLangs.forEach((l) => (translationStatus[l] = 0));

  // Rows of a grouped type (one quiz / one assessment question spread over
  // several rows) fail together: a half-imported quiz is never written.
  const grouped = type === "quiz_questions" || type === "assessment_questions";
  const failedIds = new Set();
  let currentId = "";
  const fail = (row, column, message) => {
    errors.push({ row, column, message });
    failedRows.add(row);
    if (grouped && currentId) failedIds.add(currentId);
  };

  if (!def) {
    return {
      records: [],
      errors: [{ row: 0, column: "", message: `Unknown content type "${type}".` }],
      warnings,
      rowCount: parsed.records.length,
      failedRows: new Set(parsed.records.map((r) => r.row)),
      duplicatesInFile,
      translationStatus,
    };
  }

  parsed.errors.forEach((e) => errors.push(e));

  // Header checks.
  const headerSet = new Set(parsed.headers.filter((h) => h));
  const missing = def.requiredHeaders.filter((h) => !headerSet.has(h));
  missing.forEach((h) =>
    errors.push({ row: 1, column: h, message: `Missing required column "${h}".` })
  );
  const localizedHeaders = [];
  parsed.headers.forEach((h) => {
    if (!h) return;
    if (def.columns.includes(h)) return;
    const loc = splitLocalizedHeader(h, def);
    if (loc) {
      localizedHeaders.push({ header: h, ...loc });
      if (!(loc.lang in translationStatus)) translationStatus[loc.lang] = 0;
      return;
    }
    warnings.push({
      row: 1,
      column: h,
      message: `Unknown column "${h}" is ignored.`,
    });
  });

  // A file-level problem (missing headers, broken quoting, duplicate
  // headers) fails every row: nothing in the file can be trusted.
  if (errors.length > 0) {
    parsed.records.forEach((r) => failedRows.add(r.row));
    return {
      records: [],
      errors,
      warnings,
      rowCount: parsed.records.length,
      failedRows,
      duplicatesInFile,
      translationStatus,
    };
  }

  const recordsById = new Map();
  const seenRowKeys = new Map(); // duplicate detection key -> first row
  const seenDates = new Map(); // date -> {row, id}
  const dayNumbers = new Map(); // pathway|day -> row (lessons)

  for (const rec of parsed.records) {
    const row = rec.row;
    const v = (col) => (rec.values[col] || "").trim();

    if (rec.extra.length > 0) {
      fail(row, "", `Row has ${rec.extra.length} more value(s) than there are columns. Check for an unquoted comma.`);
    }

    // Required values.
    def.requiredValues.forEach((col) => {
      if (v(col) === "") fail(row, col, `"${col}" is required.`);
    });

    const id = v(def.idColumn);
    currentId = id;
    if (id && !isValidDocId(id)) {
      fail(row, def.idColumn, `"${id}" is not a valid ID (it cannot contain "/").`);
    }

    // Integers.
    const ints = {};
    (def.ints || []).forEach((col) => {
      const raw = v(col);
      if (raw === "") return;
      const parsedInt = parseIntStrict(raw);
      if (parsedInt === null) {
        fail(row, col, `"${raw}" is not a whole number.`);
      } else if (col !== "points" && parsedInt < 0) {
        fail(row, col, `"${raw}" cannot be negative.`);
      } else {
        ints[col] = parsedInt;
      }
    });
    if (type === "quiz_questions" && ints.passingScore !== undefined &&
        ints.passingScore > 100) {
      fail(row, "passingScore", "passingScore is a percentage (0-100).");
    }
    if (ints.questionNumber !== undefined && ints.questionNumber < 1) {
      fail(row, "questionNumber", "questionNumber starts at 1.");
    }

    // Booleans.
    const bools = {};
    (def.bools || []).forEach((col) => {
      const raw = v(col);
      if (raw === "") return;
      const b = parseBool(raw);
      if (b === null) {
        fail(row, col, `"${raw}" must be true or false.`);
      } else {
        bools[col] = b;
      }
    });

    // Status.
    const status = v("status");
    if (status !== "" && !kStatuses.includes(status.toLowerCase())) {
      fail(row, "status", `Status "${status}" must be one of ${kStatuses.join(", ")}.`);
    }

    // Dates.
    const date = v("date");
    if (def.columns.includes("date") && date !== "") {
      if (!isValidMonthDay(date)) {
        fail(row, "date", `Date "${date}" must be a real month-day in MM-dd format, e.g. 01-31.`);
      } else if (seenDates.has(date) && seenDates.get(date).id !== id) {
        const first = seenDates.get(date);
        fail(row, "date", `Date ${date} is already used on row ${first.row} (${first.id}). Each date must be unique in the file.`);
        duplicatesInFile.push({ kind: "date", value: date, rows: [first.row, row] });
      } else if (!seenDates.has(date)) {
        seenDates.set(date, { row, id });
      }
    }

    // Links.
    const pathwayId = v("pathwayId");
    if (refs && pathwayId && def.columns.includes("pathwayId") &&
        !refs.pathways.has(pathwayId)) {
      fail(row, "pathwayId", `Pathway "${pathwayId}" does not exist. Import the pathway first or fix the ID.`);
    }
    const lessonId = v("lessonId");
    if (refs && lessonId && pathwayId && refs.pathways.has(pathwayId)) {
      const lessons = refs.lessons.get(pathwayId);
      if (!lessons || !lessons.has(lessonId)) {
        fail(row, "lessonId", `Lesson "${lessonId}" does not exist in pathway "${pathwayId}".`);
      }
    }

    // Quiz answer.
    let correctAnswer = "";
    if (type === "quiz_questions") {
      correctAnswer = v("correctAnswer").toUpperCase();
      if (correctAnswer !== "" && !kOptionLetters.includes(correctAnswer)) {
        fail(row, "correctAnswer", `correctAnswer "${v("correctAnswer")}" must be A, B, C or D.`);
      } else if (correctAnswer !== "" && v(`option${correctAnswer}_en`) === "") {
        fail(row, "correctAnswer", `correctAnswer is ${correctAnswer} but option${correctAnswer}_en is empty.`);
      }
    }
    let optionId = "";
    if (type === "assessment_questions") {
      optionId = v("optionId").toUpperCase();
      if (optionId !== "" && !/^[A-Z]$/.test(optionId)) {
        fail(row, "optionId", `optionId "${v("optionId")}" must be a single letter (A-Z).`);
      }
    }

    // Duplicate rows within the file.
    let rowKey = id;
    if (type === "quiz_questions") rowKey = `${id}#Q${v("questionNumber")}`;
    if (type === "assessment_questions") rowKey = `${id}#${optionId}`;
    if (id) {
      if (seenRowKeys.has(rowKey)) {
        const first = seenRowKeys.get(rowKey);
        const what = type === "quiz_questions"
          ? `question ${v("questionNumber")} of quiz ${id}`
          : type === "assessment_questions"
            ? `option ${optionId} of ${id}`
            : `stableId ${id}`;
        fail(row, def.idColumn, `Duplicate ${what}: already on row ${first}.`);
        duplicatesInFile.push({ kind: def.idColumn, value: rowKey, rows: [first, row] });
      } else {
        seenRowKeys.set(rowKey, row);
      }
    }

    if (type === "lessons" && pathwayId && ints.dayNumber !== undefined) {
      const k = `${pathwayId}|${ints.dayNumber}`;
      if (dayNumbers.has(k)) {
        warnings.push({ row, column: "dayNumber", message: `dayNumber ${ints.dayNumber} in ${pathwayId} is also used on row ${dayNumbers.get(k)}.` });
      } else {
        dayNumbers.set(k, row);
      }
    }

    // Localized values and translation status.
    const localized = {};
    const rowLangs = new Set();
    localizedHeaders.forEach(({ header, field, lang }) => {
      const text = v(header);
      if (text === "") return;
      localized[field] = localized[field] || {};
      localized[field][lang] = text;
      rowLangs.add(lang);
    });
    rowLangs.forEach((l) => (translationStatus[l] = (translationStatus[l] || 0) + 1));

    if (failedRows.has(row) || !id) continue;

    // Group rows into records.
    let record = recordsById.get(id);
    if (!record) {
      record = {
        id,
        rows: [],
        fields: {},
        localized: {},
        status: "",
        pathwayId: "",
      };
      if (type === "quiz_questions") record.questions = new Map();
      if (type === "assessment_questions") record.options = new Map();
      recordsById.set(id, record);
    }
    record.rows.push(row);

    // Record-level values must agree across rows of the same record.
    const setRecordValue = (key, value, column) => {
      if (value === "" || value === undefined) return;
      if (record.fields[key] !== undefined && record.fields[key] !== value) {
        fail(row, column, `"${column}" is ${JSON.stringify(value)} here but ${JSON.stringify(record.fields[key])} on row ${record.rows[0]} for the same ${def.idColumn}.`);
        return;
      }
      record.fields[key] = value;
    };

    if (status) {
      if (record.status && record.status !== status.toLowerCase()) {
        fail(row, "status", `Status differs from row ${record.rows[0]} for the same ${def.idColumn}.`);
      }
      record.status = status.toLowerCase();
    }
    if (pathwayId) {
      if (record.pathwayId && record.pathwayId !== pathwayId) {
        fail(row, "pathwayId", `pathwayId differs from row ${record.rows[0]} for the same ${def.idColumn}.`);
      }
      record.pathwayId = pathwayId;
    }

    switch (type) {
      case "pathways":
        setRecordValue("order", ints.order, "order");
        setRecordValue("durationDays", ints.durationDays, "durationDays");
        break;
      case "lessons":
        setRecordValue("pathwayId", pathwayId, "pathwayId");
        setRecordValue("dayNumber", ints.dayNumber, "dayNumber");
        setRecordValue("scriptureRef", v("scriptureRef"), "scriptureRef");
        break;
      case "quiz_questions":
        setRecordValue("pathwayId", pathwayId, "pathwayId");
        setRecordValue("lessonId", lessonId, "lessonId");
        setRecordValue("passingScore", ints.passingScore, "passingScore");
        record.questions.set(ints.questionNumber, {
          row,
          text: localized.question || {},
          options: {
            A: localized.optionA || {},
            B: localized.optionB || {},
            C: localized.optionC || {},
            D: localized.optionD || {},
          },
          correctAnswer,
        });
        break;
      case "daily_scripture":
        setRecordValue("date", date, "date");
        setRecordValue("dayNumber", ints.dayNumber, "dayNumber");
        setRecordValue("verseRef", v("verseRef"), "verseRef");
        setRecordValue("reference", v("verseRef"), "verseRef");
        setRecordValue("readInContext", v("readInContext"), "readInContext");
        break;
      case "encouragements":
        setRecordValue("date", date, "date");
        setRecordValue("dayNumber", ints.dayNumber, "dayNumber");
        setRecordValue("scriptureRef", v("scriptureRef"), "scriptureRef");
        setRecordValue("attribution", v("attribution"), "attribution");
        setRecordValue("rightsCleared", bools.rightsCleared, "rightsCleared");
        setRecordValue("collectionTheme", v("collectionTheme"), "collectionTheme");
        break;
      case "assessment_questions":
        setRecordValue("sequence", ints.sequence, "sequence");
        record.options.set(optionId, {
          row,
          answer: localized.answer || {},
          points: ints.points,
          triggerCode: v("triggerCode"),
          active: bools.active,
        });
        break;
    }

    // Localized record-level fields (not per question / option).
    const recordLocalized = type === "quiz_questions"
      ? ["title"]
      : type === "assessment_questions"
        ? ["question"]
        : def.localized;
    recordLocalized.forEach((field) => {
      const vals = localized[field] || {};
      record.localized[field] = record.localized[field] || {};
      Object.entries(vals).forEach(([lang, text]) => {
        const prev = record.localized[field][lang];
        if (prev !== undefined && prev !== text) {
          fail(row, `${field}_${lang}`, `${field}_${lang} differs from row ${record.rows[0]} for the same ${def.idColumn}.`);
          return;
        }
        record.localized[field][lang] = text;
      });
    });
  }

  if (type === "assessment_questions") {
    for (const record of recordsById.values()) {
      if (!record.localized.question || !record.localized.question.en) {
        currentId = record.id;
        fail(record.rows[0], "question_en", `"question_en" is required for ${record.id} (on at least one of its rows).`);
      }
    }
  }

  // A record with any failed row is not imported.
  if (grouped) {
    parsed.records.forEach((r) => {
      const id = (r.values[def.idColumn] || "").trim();
      if (failedIds.has(id)) failedRows.add(r.row);
    });
  }
  const records = [];
  for (const record of recordsById.values()) {
    if (failedIds.has(record.id) || record.rows.some((r) => failedRows.has(r))) {
      record.rows.forEach((r) => failedRows.add(r));
      continue;
    }
    records.push(record);
  }

  return {
    records,
    errors,
    warnings,
    rowCount: parsed.records.length,
    failedRows,
    duplicatesInFile,
    translationStatus,
  };
}

// ---------------------------------------------------------------------------
// Planning (diff against existing documents)
// ---------------------------------------------------------------------------

function getPath(obj, path) {
  let cur = obj;
  for (const part of path.split(".")) {
    if (cur === null || typeof cur !== "object") return undefined;
    cur = cur[part];
  }
  return cur;
}

function setPath(obj, path, value) {
  const parts = path.split(".");
  let cur = obj;
  for (let i = 0; i < parts.length - 1; i++) {
    if (cur[parts[i]] === null || typeof cur[parts[i]] !== "object" ||
        Array.isArray(cur[parts[i]])) {
      cur[parts[i]] = {};
    }
    cur = cur[parts[i]];
  }
  cur[parts[parts.length - 1]] = value;
}

function deepEqual(a, b) {
  if (a === b) return true;
  if (a === null || b === null || typeof a !== "object" || typeof b !== "object") {
    return false;
  }
  if (Array.isArray(a) !== Array.isArray(b)) return false;
  if (Array.isArray(a)) {
    return a.length === b.length && a.every((x, i) => deepEqual(x, b[i]));
  }
  const ka = Object.keys(a).filter((k) => a[k] !== undefined);
  const kb = Object.keys(b).filter((k) => b[k] !== undefined);
  return ka.length === kb.length && ka.every((k) => deepEqual(a[k], b[k]));
}

function mergeLocale(existing, incoming) {
  const out = Object.assign({}, existing && typeof existing === "object" ? existing : {});
  Object.entries(incoming || {}).forEach(([lang, text]) => (out[lang] = text));
  return out;
}

/**
 * Builds the merged questions array for a quiz: questions in the file are
 * merged (by questionNumber) into the existing array, keeping languages and
 * questions the file does not mention.
 */
function mergeQuizQuestions(existingQuestions, questionMap) {
  const out = Array.isArray(existingQuestions)
    ? existingQuestions.map((q) => (q && typeof q === "object" ? Object.assign({}, q) : {}))
    : [];
  const numbers = Array.from(questionMap.keys()).sort((a, b) => a - b);
  for (const num of numbers) {
    const q = questionMap.get(num);
    const idx = num - 1;
    while (out.length < idx) out.push({});
    const prev = out[idx] || {};
    const prevOptions = prev.options && typeof prev.options === "object" ? prev.options : {};
    const options = Object.assign({}, prevOptions);
    kOptionLetters.forEach((letter) => {
      if (Object.keys(q.options[letter]).length > 0) {
        options[letter] = mergeLocale(prevOptions[letter], q.options[letter]);
      }
    });
    out[idx] = Object.assign({}, prev, {
      text: mergeLocale(prev.text, q.text),
      options,
      correctAnswer: q.correctAnswer || prev.correctAnswer || "",
    });
  }
  return out;
}

/** Field-path -> value map for one record (without status / stableId). */
function recordFieldPaths(type, record, existingData) {
  const paths = {};
  Object.entries(record.fields).forEach(([k, val]) => {
    if (val !== undefined && val !== "") paths[k] = val;
  });
  Object.entries(record.localized).forEach(([field, langs]) => {
    Object.entries(langs).forEach(([lang, text]) => {
      paths[`${field}.${lang}`] = text;
    });
  });
  if (type === "quiz_questions") {
    paths.questions = mergeQuizQuestions(
      existingData ? existingData.questions : undefined,
      record.questions
    );
  }
  if (type === "assessment_questions") {
    paths.questionId = record.id;
    for (const [optionId, opt] of record.options) {
      Object.entries(opt.answer).forEach(([lang, text]) => {
        paths[`options.${optionId}.answer.${lang}`] = text;
      });
      if (opt.points !== undefined) paths[`options.${optionId}.points`] = opt.points;
      if (opt.triggerCode !== "") {
        paths[`options.${optionId}.triggerCode`] = opt.triggerCode;
      }
      if (opt.active !== undefined) paths[`options.${optionId}.active`] = opt.active;
    }
  }
  if (type === "lessons" || type === "quiz_questions") {
    paths.pathwayId = record.pathwayId;
  }
  return paths;
}

/** Collection path for a new record of `type`. */
function newDocPath(type, record, existing) {
  switch (type) {
    case "lessons": {
      const pathwayDoc = existing.pathwayDocIds
        ? existing.pathwayDocIds.get(record.pathwayId)
        : record.pathwayId;
      return `pathways/${pathwayDoc || record.pathwayId}/lessons/${record.id}`;
    }
    default:
      return `${kTypes[type].collection}/${record.id}`;
  }
}

function existingKey(type, record) {
  return type === "lessons" ? `${record.pathwayId}|${record.id}` : record.id;
}

/**
 * Diffs validated records against existing documents.
 *
 * `existing` = {
 *   byId: Map<key, [{path, data}]>   // key = stableId (lessons: `${pathwayId}|${stableId}`)
 *   byDate: Map<'MM-dd', [{path, data}]> // dailyScripture / encouragements only
 *   pathwayDocIds: Map<pathwayStableId, docId> // lessons only
 * }
 *
 * Returns {ops: [{action: 'create'|'update'|'unchanged', id, path, rows,
 *   set (create: nested object), update (update: field-path map),
 *   finalStatus}], errors, warnings, existingMatchedByStableId}.
 */
function buildPlan(type, records, existing) {
  existing = existing || {};
  const byId = existing.byId || new Map();
  const byDate = existing.byDate || new Map();
  const ops = [];
  const errors = [];
  const warnings = [];
  let existingMatchedByStableId = 0;
  const hasDates = type === "daily_scripture" || type === "encouragements";

  for (const record of records) {
    const matches = byId.get(existingKey(type, record)) || [];
    const match = matches[0];
    if (matches.length > 1) {
      warnings.push({
        row: record.rows[0],
        column: kTypes[type].idColumn,
        message: `${matches.length} existing documents have stableId ${record.id}; updating ${match.path} only. Please remove the extra copies.`,
      });
    }

    if (hasDates && record.fields.date) {
      const clash = (byDate.get(record.fields.date) || []).find(
        (d) => !match || d.path !== match.path
      );
      if (clash) {
        const clashId = (clash.data && clash.data.stableId) || clash.path;
        errors.push({
          row: record.rows[0],
          column: "date",
          message: `Date ${record.fields.date} is already used by another record (${clashId}). Change the date or use that record's stableId to update it.`,
        });
        ops.push({ action: "failed", id: record.id, rows: record.rows });
        continue;
      }
    }

    const fieldPaths = recordFieldPaths(type, record, match ? match.data : undefined);

    if (!match) {
      if (record.status && record.status !== "draft") {
        warnings.push({
          row: record.rows[0],
          column: "status",
          message: `${record.id} is new, so it is imported as draft (status "${record.status}" in the file is not applied).`,
        });
      }
      const set = { stableId: record.id, status: "draft" };
      Object.entries(fieldPaths).forEach(([p, val]) => setPath(set, p, val));
      ops.push({
        action: "create",
        id: record.id,
        path: newDocPath(type, record, existing),
        rows: record.rows,
        set,
        finalStatus: "draft",
      });
      continue;
    }

    existingMatchedByStableId++;
    const update = {};
    Object.entries(fieldPaths).forEach(([p, val]) => {
      if (!deepEqual(getPath(match.data, p), val)) update[p] = val;
    });
    if (!match.data || match.data.stableId !== record.id) {
      update.stableId = record.id;
    }
    const currentStatus = (match.data && match.data.status) || "";
    if (record.status && record.status !== currentStatus) {
      update.status = record.status;
    }
    const finalStatus = record.status || currentStatus || "draft";
    ops.push({
      action: Object.keys(update).length > 0 ? "update" : "unchanged",
      id: record.id,
      path: match.path,
      rows: record.rows,
      update,
      finalStatus,
    });
  }
  return { ops, errors, warnings, existingMatchedByStableId };
}

/**
 * Builds the report from validation + plan. Pure.
 */
function buildReport({ type, fileName, mode, importedAt, validation, plan, committed }) {
  const rowOutcome = new Map();
  validation.failedRows.forEach((r) => rowOutcome.set(r, "failed"));
  const planErrors = plan ? plan.errors : [];
  const planFailedRows = new Set();
  if (plan) {
    plan.ops.forEach((op) => {
      if (op.action === "failed") op.rows.forEach((r) => planFailedRows.add(r));
    });
  }
  planFailedRows.forEach((r) => rowOutcome.set(r, "failed"));
  const hasFailures = rowOutcome.size > 0 || validation.errors.length > 0 ||
    planErrors.length > 0;

  const rowResults = [];
  const publicationStatus = {};
  kStatuses.forEach((s) => (publicationStatus[s] = 0));
  const records = { inserted: 0, updated: 0, unchanged: 0 };
  if (plan) {
    plan.ops.forEach((op) => {
      if (op.action === "failed") return;
      const outcome = op.action === "create"
        ? "inserted"
        : op.action === "update" ? "updated" : "unchanged";
      records[outcome]++;
      publicationStatus[op.finalStatus] = (publicationStatus[op.finalStatus] || 0) + 1;
      op.rows.forEach((r) => {
        if (!rowOutcome.has(r)) rowOutcome.set(r, outcome);
      });
      rowResults.push({ id: op.id, path: op.path, rows: op.rows, outcome });
    });
  }

  const totals = { rows: validation.rowCount, inserted: 0, updated: 0, unchanged: 0, failed: 0 };
  rowOutcome.forEach((outcome) => totals[outcome]++);

  const errors = validation.errors.concat(planErrors)
    .sort((a, b) => a.row - b.row);
  const warnings = validation.warnings.concat(plan ? plan.warnings : [])
    .sort((a, b) => a.row - b.row);

  return {
    type,
    typeLabel: kTypes[type] ? kTypes[type].label : type,
    collection: kTypes[type] ? kTypes[type].collection : "",
    fileName,
    mode,
    importedAt,
    committed: !!committed,
    valid: !hasFailures,
    totals,
    records,
    duplicateCheck: {
      duplicatesInFile: validation.duplicatesInFile,
      existingMatchedByStableId: plan ? plan.existingMatchedByStableId : 0,
    },
    publicationStatus,
    translationStatus: validation.translationStatus,
    errors,
    warnings,
    rowResults,
  };
}

// ---------------------------------------------------------------------------
// Firestore layer
// ---------------------------------------------------------------------------

/** Finds docs in `collRef` whose stableId field (or doc id) is in `ids`. */
async function lookupByStableId(collRef, ids) {
  const found = new Map(); // id -> [{path, data}]
  const unique = Array.from(new Set(ids));
  for (let i = 0; i < unique.length; i += 30) {
    const chunk = unique.slice(i, i + 30);
    const snap = await collRef.where("stableId", "in", chunk).get();
    snap.docs.forEach((d) => {
      const id = d.get("stableId");
      if (!found.has(id)) found.set(id, []);
      found.get(id).push({ path: d.ref.path, data: d.data() });
    });
  }
  // Documents created with the stableId as doc id but no stableId field.
  const missing = unique.filter((id) => !found.has(id) && isValidDocId(id));
  for (let i = 0; i < missing.length; i += 100) {
    const refs = missing.slice(i, i + 100).map((id) => collRef.doc(id));
    const snaps = await collRef.firestore.getAll(...refs);
    snaps.forEach((s) => {
      if (s.exists) found.set(s.id, [{ path: s.ref.path, data: s.data() }]);
    });
  }
  return found;
}

async function loadRefs(db, type, parsed) {
  if (type !== "lessons" && type !== "quiz_questions") return null;
  const pathwayIds = new Set();
  const lessonIdsByPathway = new Map();
  parsed.records.forEach((r) => {
    const p = (r.values.pathwayId || "").trim();
    if (!p || !isValidDocId(p)) return;
    pathwayIds.add(p);
    const l = (r.values.lessonId || "").trim();
    if (type === "quiz_questions" && l && isValidDocId(l)) {
      if (!lessonIdsByPathway.has(p)) lessonIdsByPathway.set(p, new Set());
      lessonIdsByPathway.get(p).add(l);
    }
  });
  const pathways = await lookupByStableId(db.collection("pathways"), Array.from(pathwayIds));
  const pathwayDocIds = new Map();
  pathways.forEach((docs, id) => pathwayDocIds.set(id, docs[0].path.split("/")[1]));
  const lessons = new Map();
  for (const [p, ids] of lessonIdsByPathway) {
    if (!pathwayDocIds.has(p)) continue;
    const coll = db.collection("pathways").doc(pathwayDocIds.get(p)).collection("lessons");
    const found = await lookupByStableId(coll, Array.from(ids));
    lessons.set(p, new Set(found.keys()));
  }
  return { pathways: new Set(pathwayDocIds.keys()), lessons, pathwayDocIds };
}

async function loadExisting(db, type, records, refs) {
  const byId = new Map();
  const byDate = new Map();
  const def = kTypes[type];
  if (type === "lessons") {
    const idsByPathway = new Map();
    records.forEach((r) => {
      if (!idsByPathway.has(r.pathwayId)) idsByPathway.set(r.pathwayId, []);
      idsByPathway.get(r.pathwayId).push(r.id);
    });
    for (const [p, ids] of idsByPathway) {
      const coll = db.collection("pathways").doc(refs.pathwayDocIds.get(p)).collection("lessons");
      const found = await lookupByStableId(coll, ids);
      found.forEach((docs, id) => byId.set(`${p}|${id}`, docs));
    }
  } else {
    const coll = db.collection(def.collection);
    const found = await lookupByStableId(coll, records.map((r) => r.id));
    found.forEach((docs, id) => byId.set(id, docs));
    if (type === "daily_scripture" || type === "encouragements") {
      const dates = Array.from(new Set(records.map((r) => r.fields.date).filter(Boolean)));
      for (let i = 0; i < dates.length; i += 30) {
        const snap = await coll.where("date", "in", dates.slice(i, i + 30)).get();
        snap.docs.forEach((d) => {
          const date = d.get("date");
          if (!byDate.has(date)) byDate.set(date, []);
          byDate.get(date).push({ path: d.ref.path, data: d.data() });
        });
      }
    }
  }
  return { byId, byDate, pathwayDocIds: refs ? refs.pathwayDocIds : undefined };
}

async function commitPlan(db, admin, plan, jobId) {
  const writes = plan.ops.filter((op) => op.action === "create" || op.action === "update");
  const stamp = {
    lastImportJobId: jobId,
    lastImportedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
  for (let i = 0; i < writes.length; i += kBatchLimit) {
    const batch = db.batch();
    writes.slice(i, i + kBatchLimit).forEach((op) => {
      const ref = db.doc(op.path);
      if (op.action === "create") {
        batch.create(ref, Object.assign({}, op.set, stamp));
      } else {
        batch.update(ref, Object.assign({}, op.update, stamp));
      }
    });
    await batch.commit();
  }
  return writes.length;
}

function capForStorage(report) {
  const stored = Object.assign({}, report);
  if (stored.errors.length > kMaxStoredIssues) {
    stored.errors = stored.errors.slice(0, kMaxStoredIssues);
    stored.errorsTruncated = report.errors.length;
  }
  if (stored.warnings.length > kMaxStoredIssues) {
    stored.warnings = stored.warnings.slice(0, kMaxStoredIssues);
    stored.warningsTruncated = report.warnings.length;
  }
  if (stored.rowResults.length > kMaxStoredRowResults) {
    stored.rowResults = stored.rowResults.slice(0, kMaxStoredRowResults);
    stored.rowResultsTruncated = report.rowResults.length;
  }
  return stored;
}

async function runImport({ db, admin, functions, data, context }) {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Sign in to import content.");
  }
  const userSnap = await db.collection("users").doc(context.auth.uid).get();
  const role = userSnap.exists ? userSnap.get("role") : "";
  if (!["admin", "ministry_reviewer"].includes(role)) {
    throw new functions.https.HttpsError("permission-denied", "Only content admins can import content.");
  }

  const type = data && data.type;
  const fileName = String((data && data.fileName) || "").slice(0, 300);
  const csvText = data && data.csvText;
  const mode = data && data.mode === "commit" ? "commit" : "preview";
  if (!kTypes[type]) {
    throw new functions.https.HttpsError("invalid-argument", `Unknown content type "${type}". Use one of: ${Object.keys(kTypes).join(", ")}.`);
  }
  if (typeof csvText !== "string" || csvText.length === 0) {
    throw new functions.https.HttpsError("invalid-argument", "csvText is empty.");
  }
  if (csvText.length > kMaxCsvChars) {
    throw new functions.https.HttpsError("invalid-argument", "The CSV file is too large (max 8 MB).");
  }

  const jobRef = db.collection("importJobs").doc();
  const importedAt = new Date().toISOString();

  const parsed = parseCsv(csvText);
  const refs = await loadRefs(db, type, parsed);
  const validation = validateRows(type, parsed, refs);
  const existing = await loadExisting(db, type, validation.records, refs);
  const plan = buildPlan(type, validation.records, existing);
  let report = buildReport({ type, fileName, mode, importedAt, validation, plan, committed: false });

  let writes = 0;
  if (mode === "commit" && report.valid) {
    writes = await commitPlan(db, admin, plan, jobRef.id);
    report = buildReport({ type, fileName, mode, importedAt, validation, plan, committed: true });
  }

  report.jobId = jobRef.id;
  report.documentsWritten = writes;
  report.notes = [];
  if (type === "assessment_questions") {
    report.notes.push("Assessment questions are stored in the new assessmentItems collection; the legacy assessmentQuestions documents are not changed.");
  }
  if (mode === "commit" && !report.valid) {
    report.notes.push("Nothing was imported because the file has errors. Fix the rows listed and import the corrected file again.");
  }
  if (mode === "preview") {
    report.notes.push("Preview only: nothing was written.");
  }

  await jobRef.set(Object.assign(capForStorage(report), {
    uid: context.auth.uid,
    email: (context.auth.token && context.auth.token.email) || "",
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  }));
  return report;
}

module.exports = {
  parseCsv,
  validateRows,
  buildPlan,
  buildReport,
  kTypes,
};

// Firebase wiring. Skipped when the module is loaded by local tests without
// firebase-functions installed.
let functionsLib = null;
try {
  functionsLib = require("firebase-functions");
} catch (_) {
  functionsLib = null;
}
if (functionsLib) {
  const admin = require("firebase-admin");
  module.exports.importContentCsv = functionsLib
    .runWith({ timeoutSeconds: 300, memory: "1GB" })
    .https.onCall(async (data, context) => {
      if (!admin.apps.length) admin.initializeApp();
      const db = admin.firestore();
      try {
        return await runImport({ db, admin, functions: functionsLib, data, context });
      } catch (err) {
        if (err instanceof functionsLib.https.HttpsError) throw err;
        console.error("importContentCsv failed", err);
        throw new functionsLib.https.HttpsError("internal", `Import failed: ${err.message || err}`);
      }
    });
}
