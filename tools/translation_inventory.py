#!/usr/bin/env python3
"""Translation inventory for Kingdom Heirs (read-only).

Reads the published content and the machine-translation drafts from
production Firestore with the public web key (the same read access the app
has) and writes, for every language:

  translation_inventory_summary.csv  one row per language and content area
  translation_inventory_items.csv    one row per text and language, with
                                     empty Reviewer / Due / Notes columns
                                     so Kingdom Heirs can assign reviewers

Nothing is written to Firestore.

Status of a text in a language:
  approved        an administrator approved it (Admin > Languages >
                  Translation review), or the language itself is approved
                  and the text is stored in the content
  stored_draft    translated text is stored in the content (imported or
                  generated) but not yet approved
  machine_draft   a machine draft is waiting for review
  partial_draft   a long text with drafts for only some of its parts
  none            no translation exists; English is shown

Long texts are split into parts exactly as the app does
(lib/custom_code/languages/translation_service.dart, splitForTranslation),
so the draft for each part can be found.

Usage:  python3 tools/translation_inventory.py [output_dir]
Default output_dir: docs/handover/evidence
"""

import csv
import hashlib
import re
import sys
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import content_inventory as ci  # noqa: E402

LANGUAGES = ["es", "ur", "lg"]
LANGUAGE_NAMES = {"es": "Spanish", "ur": "Urdu", "lg": "Luganda"}
# Built-in defaults (lib/custom_code/languages/language_registry.dart);
# a `languages/{code}` document overrides them.
DEFAULT_BIBLES = {
    "en": "NIV (New International Version)",
    "es": "RVR1909 (Reina-Valera 1909)",
    "ur": "OUCV (Urdu Bible, Old Urdu Common Version)",
    "lg": "EEEE (Luganda Bible)",
}
MAX_PART = 5000

CORE = [
    "come-and-see",
    "rooted-in-christ",
    "journey-into-discipleship-evangelism",
    "holy-spirit-in-the-life-of-every-christian",
    "kingdom-heirs-foundations",
    "inner-healing-and-deliverance",
    "counterfeit-gospels",
]
LESSON_FIELDS = ["title", "body", "reflectionPrompt", "application", "prayer"]


# ---- Same split as the app ------------------------------------------------

def _segments(text, sep):
    out, start = [], 0
    for m in sep.finditer(text):
        out.append((text[start:m.start()], m.group(0)))
        start = m.end()
    out.append((text[start:], ""))
    return out


def _split_lines(text, max_len):
    out, buf, pending = [], "", ""
    for seg, sep in _segments(text, re.compile(r"\n")):
        if buf and len(buf) + len(pending) + len(seg) > max_len:
            out.append((buf, pending))
            buf, pending = "", ""
        if buf:
            buf += pending
        buf += seg
        pending = sep
    if buf:
        out.append((buf, pending))
    return out


def split_for_translation(text, max_len=MAX_PART):
    if len(text) <= max_len:
        return [text]
    parts, buf, pending = [], "", ""
    for para, sep in _segments(text, re.compile(r"\n[ \t]*\n\s*")):
        if buf and len(buf) + len(pending) + len(para) > max_len:
            parts.append(buf)
            buf, pending = "", ""
        if not buf and len(para) > max_len:
            parts += [t for t, _ in _split_lines(para, max_len)]
            continue
        if buf:
            buf += pending
        buf += para
        pending = sep
    if buf:
        parts.append(buf)
    return parts


def draft_id(lang, text):
    return f"{lang}_{hashlib.sha256(text.encode('utf-8')).hexdigest()}"


# ---- Inventory -------------------------------------------------------------

def localized(value, lang):
    if isinstance(value, dict):
        return (value.get(lang) or "").strip()
    return ""


def main(out_dir):
    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)

    languages = {ci.fields(d).get("code") or ci.doc_path(d).split("/")[-1]:
                 ci.fields(d) for d in ci.list_docs("languages")}
    approved_languages = {c for c, f in languages.items()
                          if f.get("tier") == "approved"}
    bibles = dict(DEFAULT_BIBLES)
    for c, f in languages.items():
        if f.get("bibleName"):
            bibles[c] = f["bibleName"]

    drafts = {}
    for d in ci.list_docs("machineTranslations"):
        f = ci.fields(d)
        drafts[ci.doc_path(d).split("/")[-1]] = f

    rows = []  # one per text and language

    def add(priority, area, pathway, record, field, value, scripture=False):
        en = ci.english(value)
        if not en:
            return
        for lang in LANGUAGES:
            stored = localized(value, lang)
            parts = split_for_translation(en)
            found = [drafts.get(draft_id(lang, p)) for p in parts]
            if scripture:
                status = "scripture_not_translated"
            elif stored and lang in approved_languages:
                status = "approved"
            elif all(f and f.get("status") == "approved" for f in found):
                status = "approved"
            elif stored:
                status = "stored_draft"
            elif all(found):
                status = "machine_draft"
            elif any(found):
                status = "partial_draft"
            else:
                status = "none"
            reviewed = [f for f in found if f and f.get("status") == "approved"]
            rows.append({
                "priority": priority,
                "area": area,
                "pathway": pathway,
                "record": record,
                "field": field,
                "language": lang,
                "status": status,
                "english_words": len(en.split()),
                "parts": len(parts),
                "reviewed_by": ";".join(sorted({f.get("reviewedBy", "")
                                                for f in reviewed} - {""})),
                "english_start": en[:80].replace("\n", " "),
                "reviewer": "",
                "due": "",
                "notes": "",
            })

    pathways = {}
    for d in ci.list_docs("pathways"):
        f = ci.fields(d)
        if f.get("status") != "published":
            continue
        pid = f.get("stableId") or ci.doc_path(d).split("/")[-1]
        pathways[ci.doc_path(d)] = (pid, f)

    def pathway_priority(pid):
        if pid == "come-and-see":
            return 1
        return 3 if pid in CORE else 4

    for _, (pid, f) in pathways.items():
        pr = pathway_priority(pid)
        add(pr, "pathway titles", pid, pid, "title", f.get("title"))
        add(pr, "pathway titles", pid, pid, "description", f.get("description"))

    for d in ci.collection_group("lessons"):
        f = ci.fields(d)
        if f.get("status") != "published":
            continue
        parent = ci.doc_path(d).rsplit("/lessons/", 1)[0]
        if parent not in pathways:
            continue
        pid = pathways[parent][0]
        lid = f.get("stableId") or ci.doc_path(d).split("/")[-1]
        for field in LESSON_FIELDS:
            add(pathway_priority(pid), "lessons", pid, lid, field, f.get(field))

    for d in ci.collection_group("quizzes"):
        f = ci.fields(d)
        if f.get("status") not in (None, "published"):
            continue
        pid = f.get("pathwayId") or ""
        qid = f.get("stableId") or ci.doc_path(d).split("/")[-1]
        pr = pathway_priority(pid)
        add(pr, "quizzes", pid, qid, "title", f.get("title"))
        for i, q in enumerate(f.get("questions") or [], 1):
            add(pr, "quizzes", pid, qid, f"q{i} question", q.get("text"))
            for letter, opt in sorted((q.get("options") or {}).items()):
                add(pr, "quiz choices", pid, qid, f"q{i} choice {letter}", opt)
            add(pr, "quiz explanations", pid, qid, f"q{i} explanation",
                q.get("explanation"))

    for d in ci.list_docs("assessmentQuestions"):
        f = ci.fields(d)
        if f.get("status") != "published":
            continue
        add(2, "assessment", "", f.get("stableId", ""), "label", f.get("label"))
    for d in ci.list_docs("onboardingQuestions"):
        f = ci.fields(d)
        if f.get("status") != "published":
            continue
        add(2, "onboarding", "", f.get("stableId", ""), "label", f.get("label"))

    for d in ci.list_docs("dailyScripture"):
        f = ci.fields(d)
        if f.get("status") != "published":
            continue
        rid = f.get("stableId", "")
        add(2, "Today: Daily Truth", "", rid, "theme", f.get("theme"))
        add(2, "Today: Daily Truth", "", rid, "commentary", f.get("text"))
        add(2, "Today: Scripture", "", rid, "verse preview",
            f.get("versePreview"), scripture=True)
    for d in ci.list_docs("encouragements"):
        f = ci.fields(d)
        if f.get("status") != "published":
            continue
        rid = f.get("stableId", "")
        add(2, "Today: encouragement", "", rid, "title", f.get("title"))
        add(2, "Today: encouragement", "", rid, "quote", f.get("quote"))
    for d in ci.list_docs("announcements"):
        f = ci.fields(d)
        rid = ci.doc_path(d).split("/")[-1]
        add(2, "notifications and announcements", "", rid, "title", f.get("title"))
        add(2, "notifications and announcements", "", rid, "body", f.get("body"))

    # ---- Write ------------------------------------------------------------
    items_path = out / "translation_inventory_items.csv"
    with items_path.open("w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
        w.writeheader()
        for r in sorted(rows, key=lambda r: (r["priority"], r["language"],
                                             r["area"], r["pathway"],
                                             r["record"], r["field"])):
            w.writerow(r)

    statuses = ["approved", "stored_draft", "machine_draft", "partial_draft",
                "none", "scripture_not_translated"]
    summary = defaultdict(lambda: defaultdict(int))
    words = defaultdict(int)
    for r in rows:
        key = (r["language"], r["priority"], r["area"])
        summary[key][r["status"]] += 1
        summary[key]["total"] += 1
        if r["status"] != "approved":
            words[key] += r["english_words"]

    summary_path = out / "translation_inventory_summary.csv"
    with summary_path.open("w", newline="", encoding="utf-8") as fh:
        w = csv.writer(fh)
        w.writerow(["language", "bible", "priority", "area", "texts",
                    "approved", "stored drafts awaiting review",
                    "machine drafts awaiting review", "partial drafts",
                    "no translation (English shown)",
                    "Scripture (approved Bible, never translated)",
                    "English words still to review"])
        for (lang, pr, area) in sorted(summary):
            s = summary[(lang, pr, area)]
            w.writerow([f"{lang} ({LANGUAGE_NAMES[lang]})", bibles.get(lang, ""),
                        pr, area, s["total"]] +
                       [s[k] for k in statuses] + [words[(lang, pr, area)]])
    stamp = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    print(f"{stamp}: {len(rows)} rows")
    print(f"  {summary_path}")
    print(f"  {items_path}")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "docs/handover/evidence")
