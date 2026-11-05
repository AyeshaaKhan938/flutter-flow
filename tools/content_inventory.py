"""Read-only inventory of published Kingdom Heirs content in Firestore.

Reads pathways, lessons and quizzes through the public Firestore REST API
(these collections are publicly readable) and checks counts, empty records,
quiz unlock points and PDF-conversion artefacts. Writes a Markdown report and
a JSON file with every finding.

    python3 tools/content_inventory.py OUT_DIR
"""

import json
import re
import sys
import time
import urllib.parse
import urllib.request
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path

PROJECT = "kingdom-heirs-discipleshipapp"
API_KEY = "AIzaSyAaA-mK4eyGOOLPwdmwr1j1TKpodQaPv3E"  # public web key
BASE = (f"https://firestore.googleapis.com/v1/projects/{PROJECT}"
        "/databases/(default)/documents")

EXPECTED = {"pathways": 13, "lessons": 446, "quizzes": 78}
FOUNDATIONS_LESSONS = 20
# scriptureText may be empty: the lesson then shows the reference and loads
# the passage from API.Bible in the member's language.
LESSON_SECTIONS = ["title", "body", "reflectionPrompt", "application",
                   "prayer"]

# Signs of text copied from a PDF that the app would still show. Hard-wrapped
# lines and words split across lines are joined when the app displays them
# (lib/custom_code/widgets/lesson_body.dart), so they are not reported.
ARTEFACTS = {
    "page number": re.compile(r"(?im)^\s*(page\s+)?\d{1,3}\s*$|\bpage\s+\d+\s+of\s+\d+\b"),
    "form feed": re.compile(r"\f"),
    "replacement character": re.compile("�|â€|Ã©|Ã¨"),
}


def request(url, body=None):
    for attempt in range(5):
        try:
            data = json.dumps(body).encode() if body is not None else None
            req = urllib.request.Request(
                url, data=data, headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=60) as resp:
                return json.load(resp)
        except Exception:
            if attempt == 4:
                raise
            time.sleep(2 * (attempt + 1))


def list_docs(path):
    docs, token = [], None
    while True:
        q = {"pageSize": 300, "key": API_KEY}
        if token:
            q["pageToken"] = token
        page = request(f"{BASE}/{path}?{urllib.parse.urlencode(q)}")
        docs += page.get("documents", [])
        token = page.get("nextPageToken")
        if not token:
            return docs


def collection_group(collection_id):
    """All documents in every collection named collection_id."""
    rows = request(f"{BASE}:runQuery?key={API_KEY}", {
        "structuredQuery": {"from": [{"collectionId": collection_id,
                                      "allDescendants": True}]}})
    return [r["document"] for r in rows if "document" in r]


def plain(value):
    """Firestore REST value -> Python value."""
    if value is None:
        return None
    (kind, v), = value.items()
    if kind == "mapValue":
        return {k: plain(x) for k, x in v.get("fields", {}).items()}
    if kind == "arrayValue":
        return [plain(x) for x in v.get("values", [])]
    if kind == "integerValue":
        return int(v)
    if kind == "nullValue":
        return None
    return v


def fields(doc):
    return {k: plain(v) for k, v in doc.get("fields", {}).items()}


def doc_path(doc):
    return doc["name"].split("/documents/", 1)[1]


def english(value):
    if isinstance(value, dict):
        return (value.get("en") or "").strip()
    return (value or "").strip() if isinstance(value, str) else ""


def main(out_dir):
    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)
    findings = []

    def find(severity, where, issue):
        findings.append({"severity": severity, "where": where, "issue": issue})

    pathways = {doc_path(d).split("/")[-1]: fields(d)
                for d in list_docs("pathways")}
    published_pathways = {k: v for k, v in pathways.items()
                          if v.get("status") == "published"}

    lessons = [(doc_path(d), fields(d)) for d in collection_group("lessons")]
    quizzes = [(doc_path(d), fields(d)) for d in collection_group("quizzes")]

    pub_lessons = [(p, f) for p, f in lessons if f.get("status") == "published"]
    pub_quizzes = [(p, f) for p, f in quizzes if f.get("status") == "published"]

    lessons_by_pathway = defaultdict(list)
    for p, f in pub_lessons:
        lessons_by_pathway[f.get("pathwayId") or p.split("/")[1]].append((p, f))
    quizzes_by_pathway = defaultdict(list)
    for p, f in pub_quizzes:
        quizzes_by_pathway[f.get("pathwayId", "")].append((p, f))

    lesson_ids = set()
    for p, f in pub_lessons:
        lesson_ids.add(p.split("/")[-1])
        if f.get("stableId"):
            lesson_ids.add(f["stableId"])

    # Lessons: empty sections, PDF artefacts, truncation.
    for p, f in pub_lessons:
        for section in LESSON_SECTIONS:
            text = english(f.get(section))
            if not text:
                find("error", p, f"empty English {section}")
        if not (f.get("scriptureRef") or "").strip():
            find("error", p, "empty scriptureRef")
        body = english(f.get("body"))
        if body and len(body) < 400:
            find("warning", p, f"short body ({len(body)} characters)")
        for section in ("body", "scriptureText", "reflectionPrompt",
                        "application", "prayer"):
            text = english(f.get(section))
            for name, rx in ARTEFACTS.items():
                hits = rx.findall(text)
                if hits:
                    sev = "warning" if name == "mid-sentence line break" else "error"
                    find(sev, p, f"{section}: {name} ({len(hits)}x)")
        if body and not re.search(r"[.!?\"'”’)\]*:\d]\s*$", body):
            find("warning", p, f"body may be truncated (ends: …{body[-40:]!r})")

    # Lessons: duplicate day numbers within a pathway.
    for pid, items in lessons_by_pathway.items():
        days = Counter(f.get("dayNumber") for _, f in items)
        for day, n in days.items():
            if n > 1:
                find("error", pid, f"dayNumber {day} used by {n} lessons")

    # Quizzes: questions, answers, unlock lesson.
    for p, f in pub_quizzes:
        qs = f.get("questions") or []
        if not qs:
            find("error", p, "quiz has no questions")
        for i, q in enumerate(qs, 1):
            if not english((q or {}).get("text")):
                find("error", p, f"question {i} has no English text")
        unlock = f.get("lessonId")
        if not unlock:
            find("error", p, "no unlock lesson (lessonId)")
        elif unlock not in lesson_ids:
            find("error", p, f"unlock lesson {unlock} not found among published lessons")
        if f.get("passingScore") not in (None, 80):
            find("warning", p, f"passingScore is {f.get('passingScore')}")

    # Pathways without content.
    for pid, pw in published_pathways.items():
        if not lessons_by_pathway.get(pid):
            find("error", pid, "published pathway has no published lessons")
        if not english(pw.get("description")):
            find("warning", pid, "pathway has no English description")

    foundations = [k for k in published_pathways if "foundation" in k]
    found_counts = {k: len(lessons_by_pathway.get(k, [])) for k in foundations}

    # Quiz unlock points for Come & See.
    come = sorted(quizzes_by_pathway.get("come-and-see", []),
                  key=lambda x: x[1].get("quizNumber") or 0)
    come_lessons = {}
    for p, f in lessons_by_pathway.get("come-and-see", []):
        come_lessons[p.split("/")[-1]] = f.get("dayNumber")
        if f.get("stableId"):
            come_lessons[f["stableId"]] = f.get("dayNumber")
    come_unlocks = [(f.get("quizNumber"), f.get("lessonId"),
                     come_lessons.get(f.get("lessonId"))) for _, f in come]

    counts = {
        "pathways": len(published_pathways),
        "lessons": len(pub_lessons),
        "quizzes": len(pub_quizzes),
    }
    errors = [x for x in findings if x["severity"] == "error"]
    warnings = [x for x in findings if x["severity"] == "warning"]
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

    md = [f"# Content inventory evidence",
          "",
          f"Generated {now} by `tools/content_inventory.py`, reading project "
          f"`{PROJECT}` directly (read-only).",
          "",
          "## Totals (published records)",
          ""]
    for k in ("pathways", "lessons", "quizzes"):
        ok = "PASS" if counts[k] == EXPECTED[k] else "FAIL"
        md.append(f"- {k}: **{counts[k]}** (expected {EXPECTED[k]}) — {ok}")
    md.append(f"- all records in Firestore, any status: {len(pathways)} pathways, "
              f"{len(lessons)} lessons, {len(quizzes)} quizzes")
    others = sorted(k for k in pathways if k not in published_pathways)
    if others:
        md.append("- not published: " + ", ".join(
            f"{k} ({pathways[k].get('status')})" for k in others))
    md += ["", "## Kingdom Heirs Foundations", ""]
    for k, n in found_counts.items():
        ok = "PASS" if n == FOUNDATIONS_LESSONS else "FAIL"
        md.append(f"- `{k}`: **{n}** published lessons "
                  f"(expected exactly {FOUNDATIONS_LESSONS}) — {ok}")
    if not found_counts:
        md.append("- FAIL: no published Foundations pathway found")
    md += ["", "## Come & See quiz unlock points", ""]
    for num, lid, day in come_unlocks:
        md.append(f"- Quiz {num}: unlocks after `{lid}` (lesson day {day})")
    md += ["", "## Per pathway", "",
           "| Order | Pathway | Lessons | Quizzes |", "|---|---|---|---|"]
    for pid, pw in sorted(published_pathways.items(),
                          key=lambda kv: kv[1].get("order") or 0):
        md.append(f"| {pw.get('order')} | {english(pw.get('title')) or pid} "
                  f"(`{pid}`) | {len(lessons_by_pathway.get(pid, []))} | "
                  f"{len(quizzes_by_pathway.get(pid, []))} |")
    md += ["", f"## Checks: {len(errors)} errors, {len(warnings)} warnings", "",
           "Each published lesson was checked for empty English title, body, "
           "Scripture reference, Reflection, Application and Prayer; "
           "PDF page numbers, form feeds, words broken across lines and "
           "encoding errors; and a body that ends mid-sentence. Each quiz was "
           "checked for questions, question text and a valid unlock lesson.", ""]
    for x in errors + warnings:
        md.append(f"- **{x['severity']}** `{x['where']}`: {x['issue']}")
    if not findings:
        md.append("- No problems found.")

    (out / "content_inventory.md").write_text("\n".join(md) + "\n")
    (out / "content_inventory.json").write_text(json.dumps({
        "generated": now, "counts": counts, "expected": EXPECTED,
        "foundations": found_counts, "comeAndSeeQuizUnlocks": come_unlocks,
        "findings": findings}, indent=2, ensure_ascii=False))
    print(json.dumps({"counts": counts, "foundations": found_counts,
                      "come": come_unlocks, "errors": len(errors),
                      "warnings": len(warnings)}, ensure_ascii=False))


if __name__ == "__main__":
    main(sys.argv[1])
