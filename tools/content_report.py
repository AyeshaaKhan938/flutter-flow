#!/usr/bin/env python3
"""Pathway-by-pathway content completion report, read from production
Firestore (published and draft content is readable by rule).

    python3 tools/content_report.py            # prints the report
    python3 tools/content_report.py --csv out.csv

A lesson counts as "populated" when it has an English title that is not a
working title ("Lesson 12"), teaching body or Scripture, and a reflection
prompt. Translation completeness counts lessons whose title and reflection
exist in that language (body too when the lesson has one).
"""
import csv
import json
import re
import sys
import urllib.request
from collections import Counter, defaultdict

API_KEY = "AIzaSyAaA-mK4eyGOOLPwdmwr1j1TKpodQaPv3E"  # public web key
BASE = ("https://firestore.googleapis.com/v1/projects/"
        "kingdom-heirs-discipleshipapp/databases/(default)/documents")
LANGS = ["es", "ur", "lg"]
# Planned lesson counts from the Kingdom Heirs content package.
EXPECTED = {
    "come-and-see": 14,
    "rooted-in-christ": 30,
    "journey-into-discipleship-evangelism": 90,
    "the-new-man": 90,
    "kingdom-heirs-foundations": 120,
    "counterfeit-gospels": None,
}


def _val(v):
    for k in ("stringValue", "integerValue", "booleanValue",
              "timestampValue", "doubleValue"):
        if k in v:
            return v[k]
    if "mapValue" in v:
        return {k: _val(x) for k, x in v["mapValue"].get("fields", {}).items()}
    if "arrayValue" in v:
        return [_val(x) for x in v["arrayValue"].get("values", [])]
    return None


def query(collection, all_descendants=False):
    body = {"structuredQuery": {"from": [{
        "collectionId": collection, "allDescendants": all_descendants}]}}
    req = urllib.request.Request(
        f"{BASE}:runQuery?key={API_KEY}", data=json.dumps(body).encode(),
        headers={"Content-Type": "application/json"})
    out = []
    for r in json.load(urllib.request.urlopen(req, timeout=120)):
        if "document" in r:
            doc = {k: _val(v) for k, v in r["document"].get("fields", {}).items()}
            doc["_path"] = r["document"]["name"].split("/documents/")[1]
            out.append(doc)
    return out


def text(doc, field, lang="en"):
    v = doc.get(field)
    return (v.get(lang) or "").strip() if isinstance(v, dict) else ""


def lesson_populated(l):
    title = text(l, "title")
    working = re.fullmatch(r"lesson\s*\d+", title.lower() or "lesson 0")
    has_content = text(l, "body") or text(l, "scriptureText") or l.get("scriptureRef")
    return bool(title and not working and has_content and text(l, "reflectionPrompt"))


def main():
    pathways = query("pathways")
    lessons = query("lessons", True)
    quizzes = query("quizzes", True)
    by_path = defaultdict(list)
    for l in lessons:
        by_path[l.get("pathwayId", "")].append(l)
    rows = []
    for p in sorted(pathways, key=lambda p: int(p.get("order") or 99)):
        pid = p.get("stableId") or p["_path"].split("/")[-1]
        ls = by_path.get(pid, [])
        populated = [l for l in ls if lesson_populated(l)]
        status = Counter(l.get("status", "") or "draft" for l in ls)
        qs = [q for q in quizzes if q.get("pathwayId") == pid]
        questions = sum(len(q.get("questions") or []) for q in qs)
        explained = sum(1 for q in qs for x in (q.get("questions") or [])
                        if isinstance(x, dict) and text(x, "explanation"))
        trans = {}
        for lang in LANGS:
            done = 0
            for l in populated:
                need = ["title", "reflectionPrompt"] + (["body"] if text(l, "body") else [])
                if all(text(l, f, lang) for f in need):
                    done += 1
            trans[lang] = f"{done}/{len(populated)}"
        fallback = sum(1 for l in populated
                       if any(not text(l, "title", lang) for lang in LANGS))
        rows.append({
            "pathway": text(p, "title") or pid,
            "pathwayStatus": p.get("status", ""),
            "expectedLessons": EXPECTED.get(pid) if EXPECTED.get(pid) is not None else "TBD",
            "lessonRecords": len(ls),
            "populatedLessons": len(populated),
            "emptyLessons": len(ls) - len(populated),
            "publishedLessons": status.get("published", 0),
            "draftLessons": sum(v for k, v in status.items() if k != "published"),
            "quizzes": len(qs),
            "quizQuestions": questions,
            "questionsWithExplanation": explained,
            "es": trans["es"], "ur": trans["ur"], "lg": trans["lg"],
            "lessonsShowingEnglishFallback": fallback,
        })

    if "--csv" in sys.argv:
        out = sys.argv[sys.argv.index("--csv") + 1]
        with open(out, "w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0]))
            w.writeheader()
            w.writerows(rows)
        print(f"Wrote {out}")
    for r in rows:
        print(f"\n{r['pathway']}  [{r['pathwayStatus']}]")
        print(f"  lessons: expected {r['expectedLessons']}, records {r['lessonRecords']}, "
              f"populated {r['populatedLessons']}, empty {r['emptyLessons']}, "
              f"published {r['publishedLessons']}, draft {r['draftLessons']}")
        print(f"  quizzes: {r['quizzes']} ({r['quizQuestions']} questions, "
              f"{r['questionsWithExplanation']} with explanations)")
        print(f"  translations (populated lessons): es {r['es']}, ur {r['ur']}, lg {r['lg']}; "
              f"English fallback shown in {r['lessonsShowingEnglishFallback']}")

    for coll, field in [("dailyScripture", "text"), ("encouragements", "quote")]:
        docs = query(coll)
        status = Counter(d.get("status", "") for d in docs)
        filled = {lang: sum(1 for d in docs if text(d, field, lang)) for lang in ["en"] + LANGS}
        ts = {lang: Counter((d.get("translationStatus") or {}).get(lang, "")
                            for d in docs) for lang in LANGS}
        print(f"\n{coll}: {len(docs)} records, status {dict(status)}, "
              f"text filled {filled}")
        for lang in LANGS:
            print(f"  translationStatus.{lang}: {dict(ts[lang])}")


if __name__ == "__main__":
    main()
