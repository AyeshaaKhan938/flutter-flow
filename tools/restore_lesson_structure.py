#!/usr/bin/env python3
"""Restore headings and paragraph breaks in lesson bodies from the manuscripts.

Kingdom Heirs' lesson import files hold each lesson's teaching as flat text
(headings run into the following sentence, PDF line breaks, page numbers).
The manuscripts sectioned by tools/manuscript_sections.py keep paragraphs and
sub-headings. This tool matches every lesson body word for word against its
pathway's manuscript and rebuilds the body with:

  * a blank line between paragraphs (where the manuscript or the original
    body starts a new paragraph);
  * "## " before a manuscript sub-heading, on its own line;
  * PDF hard line breaks joined, and lines holding only a page number left out.

The words themselves are never changed: the rebuilt body must have exactly
the original words (page numbers excepted) or the lesson is left as it is.

It also reports where the body and manuscript disagree, so Kingdom Heirs can
review possible missing text (nothing is filled in):
  * manuscript text missing between two consecutive body words;
  * body text not found in the manuscript.

Usage:
  python3 tools/restore_lesson_structure.py --out DIR           # dry run
  python3 tools/restore_lesson_structure.py --out DIR --apply \
      --email ADMIN_EMAIL --password-file FILE                  # write

Reads lessons with the public Firestore REST API. --apply signs in as a
content admin (users/{uid}.role admin) and updates only body.en of changed
lessons, so Firestore rules apply as for the admin pages.
"""
import argparse
import csv
import difflib
import json
import os
import re
import sys
import urllib.parse
import urllib.request

PROJECT = "kingdom-heirs-discipleshipapp"
API_KEY = "AIzaSyAaA-mK4eyGOOLPwdmwr1j1TKpodQaPv3E"  # public web key
BASE = f"https://firestore.googleapis.com/v1/projects/{PROJECT}/databases/(default)/documents"
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SECTIONS = os.path.join(ROOT, "content_private", "manuscripts", "sections")

PAGE_NUMBER = re.compile(r"^\s*\d{1,3}\s*$")
MINOR = {"a", "an", "the", "and", "or", "but", "of", "in", "on", "to", "for",
         "at", "by", "from", "with", "as", "is", "into", "nor", "so", "yet", "be"}
LABELS = {"scripture", "scriptures", "additional scriptures", "reflection",
          "reflection questions", "application", "prayer", "declaration",
          "key truth", "memory verse"}


def get(url, token=None):
    req = urllib.request.Request(url)
    if token:
        req.add_header("Authorization", "Bearer " + token)
    return json.load(urllib.request.urlopen(req))


def post(url, body, token=None, method="POST"):
    req = urllib.request.Request(url, json.dumps(body).encode(), method=method)
    req.add_header("Content-Type", "application/json")
    if token:
        req.add_header("Authorization", "Bearer " + token)
    return json.load(urllib.request.urlopen(req))


def list_docs(path):
    docs, tok = [], None
    while True:
        url = f"{BASE}/{path}?pageSize=300&key={API_KEY}" + (f"&pageToken={tok}" if tok else "")
        d = get(url)
        docs += d.get("documents", [])
        tok = d.get("nextPageToken")
        if not tok:
            return docs


def norm(word):
    w = word.lower().replace("’", "'").replace("‘", "'")
    return re.sub(r"[^a-z0-9]", "", w)


def is_heading(par):
    t = par.strip()
    if not t or len(t) > 80:
        return False
    if t.lower().rstrip(":") in LABELS:
        return True
    words = t.split()
    if len(words) > 10 or re.search(r"[.,;!?…\"”’]$", t) or re.search(r"\d+:\d+", t):
        return False
    if not re.match(r"^[A-Z“\"‘]", t):
        return False
    sig = [w for w in words if w.lower() not in MINOR]
    if not sig:
        return False
    caps = sum(1 for w in sig if re.match(r"^[“\"‘(]?[A-Z0-9]", w))
    return caps / len(sig) >= 0.75


def manuscript_stream(source):
    """Word keys with paragraph-start flags and heading paragraph ids."""
    keys, para_start, heading_of = [], [], []
    heading_words = {}
    hid = 0
    with open(os.path.join(SECTIONS, source + ".jsonl")) as f:
        for line in f:
            sec = json.loads(line)
            for par in re.split(r"\n\s*\n", sec["text"]):
                words = [w for w in par.split() if norm(w)]
                if not words:
                    continue
                head = is_heading(par)
                if head:
                    hid += 1
                    heading_words[hid] = len(words)
                for k, w in enumerate(words):
                    keys.append(norm(w))
                    para_start.append(k == 0)
                    heading_of.append(hid if head else 0)
    return keys, para_start, heading_of, heading_words


def body_tokens(body):
    """Original words with the break before each: 'para', 'line' or 'space'.
    Lines holding only a page number are dropped (counted separately)."""
    tokens, dropped = [], 0
    for p_i, par in enumerate(re.split(r"\n\s*\n", body.replace("\r\n", "\n"))):
        first_in_par = True
        for line in par.split("\n"):
            if PAGE_NUMBER.match(line):
                if line.strip():
                    dropped += 1
                continue
            for w in line.split():
                brk = "para" if (first_in_par and p_i > 0) else "space"
                tokens.append([w, brk])
                first_in_par = False
    return tokens, dropped


def locate(body_keys, ms_index, n=5):
    """Start of the manuscript window that best matches the body."""
    votes = {}
    for i in range(0, max(1, len(body_keys) - n), max(1, len(body_keys) // 40)):
        gram = tuple(body_keys[i:i + n])
        for pos in ms_index.get(gram, []):
            start = pos - i
            votes[start // 200] = votes.get(start // 200, 0) + 1
    if not votes:
        return None
    best = max(votes, key=votes.get)
    return best * 200


def restore(body, ms):
    keys, para_start, heading_of, heading_words, ms_index = ms
    tokens, dropped = body_tokens(body)
    bkeys = [norm(t[0]) for t in tokens]
    start = locate([k for k in bkeys if k], ms_index)
    if start is None:
        return None, {"status": "no manuscript match"}
    lo = max(0, start - 400)
    hi = min(len(keys), start + int(len(bkeys) * 1.6) + 800)
    # Match only real words (punctuation-only tokens such as "—" ride along).
    idx = [i for i, k in enumerate(bkeys) if k]
    sm = difflib.SequenceMatcher(None, [bkeys[i] for i in idx], keys[lo:hi], autojunk=False)
    match = {}
    for a, b, size in sm.get_matching_blocks():
        for d in range(size):
            match[idx[a + d]] = lo + b + d
    matched = len(match) / max(1, len(idx))

    # Gaps for the review report.
    gaps, extra = [], []
    prev_i = prev_j = None
    run = []
    for i in idx:
        j = match.get(i)
        if j is None:
            run.append(tokens[i][0])
            continue
        if len(run) >= 3:
            extra.append(" ".join(run))
        run = []
        if prev_j is not None and j - prev_j > 5:
            gaps.append({
                "before": " ".join(t[0] for t in tokens[max(0, prev_i - 6):prev_i + 1]),
                "after": " ".join(t[0] for t in tokens[i:i + 6]),
                "missingWords": j - prev_j - 1,
            })
        prev_i, prev_j = i, j
    if len(run) >= 3:
        extra.append(" ".join(run))

    # Rebuild: one space between words, a blank line at paragraph starts,
    # and headings on their own line.
    out = []
    i = 0
    n = len(tokens)
    while i < n:
        w, brk = tokens[i]
        j = match.get(i)
        # A manuscript paragraph start counts only after a finished sentence:
        # the PDF manuscripts also break paragraphs at page ends.
        prev = tokens[i - 1][0] if i else ""
        sentence_end = bool(re.search(r"[.!?:”\"’)]$", prev))
        new_par = brk == "para" or (j is not None and para_start[j] and sentence_end)
        hid = heading_of[j] if j is not None else 0
        if hid and para_start[j]:
            size = heading_words[hid]
            span = list(range(i, min(n, i + size)))
            if (len(span) == size and all(match.get(s) == j + k for k, s in enumerate(span))):
                out.append(("\n\n" if out else "") + "## " + " ".join(tokens[s][0] for s in span))
                i += size
                if i < n:
                    tokens[i][1] = "para"
                continue
        out.append(("\n\n" if (new_par and out) else (" " if out else "")) + w)
        i += 1
    new = "".join(out)

    def words(s):
        s = re.sub(r"(?m)^## ", "", s)
        return s.split()
    original_words = [t[0] for t in body_tokens(body)[0]]
    if words(new) != original_words:
        return None, {"status": "word check failed"}
    return new, {
        "status": "ok",
        "matched": round(matched, 3),
        "headings": new.count("## "),
        "paragraphs": new.count("\n\n") + 1,
        "pageNumbersRemoved": dropped,
        "gaps": gaps,
        "notInManuscript": extra,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--min-match", type=float, default=0.75)
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--email")
    ap.add_argument("--password-file")
    args = ap.parse_args()
    os.makedirs(args.out, exist_ok=True)

    manuscripts = {}
    for fn in os.listdir(SECTIONS):
        if fn.endswith(".jsonl"):
            src = fn[:-6]
            keys, ps, ho, hw = manuscript_stream(src)
            index = {}
            for p in range(len(keys) - 5):
                index.setdefault(tuple(keys[p:p + 5]), []).append(p)
            manuscripts[src] = (keys, ps, ho, hw, index)

    results, changes = [], {}
    for pw in list_docs("pathways"):
        pid = pw["name"].split("/")[-1]
        for doc in list_docs(f"pathways/{pid}/lessons"):
            f = doc["fields"]
            body = f.get("body", {}).get("mapValue", {}).get("fields", {}).get("en", {}).get("stringValue", "")
            title = f.get("title", {}).get("mapValue", {}).get("fields", {}).get("en", {}).get("stringValue", "")
            row = {"pathway": pid, "lesson": doc["name"].split("/")[-1], "title": title,
                   "status": f.get("status", {}).get("stringValue", "")}
            if not body.strip():
                results.append(row | {"result": "no body"})
                continue
            if re.search(r"(?m)^## ", body):
                # Already restored (headings added by an earlier run).
                results.append(row | {"result": "already restored"})
                continue
            if pid not in manuscripts:
                results.append(row | {"result": "no manuscript"})
                continue
            new, stats = restore(body, manuscripts[pid])
            ok = new is not None and stats.get("matched", 0) >= args.min_match
            results.append(row | {"result": "restored" if ok and new != body else
                                  ("unchanged" if ok else stats["status"] if new is None else "low match"),
                                  **{k: v for k, v in stats.items() if k != "status"}})
            if ok and new != body:
                changes[doc["name"]] = {"old": body, "new": new}

    with open(os.path.join(args.out, "lesson_structure_changes.json"), "w") as fh:
        json.dump(changes, fh, ensure_ascii=False, indent=1)
    with open(os.path.join(args.out, "lesson_structure_report.json"), "w") as fh:
        json.dump(results, fh, ensure_ascii=False, indent=1)
    with open(os.path.join(args.out, "lesson_text_review.csv"), "w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["Pathway", "Lesson", "Title", "Status", "Issue", "Text before", "Text after", "Manuscript words missing"])
        for r in results:
            for g in r.get("gaps", []):
                w.writerow([r["pathway"], r["lesson"], r["title"], r["status"], "Possible missing text",
                            g["before"], g["after"], g["missingWords"]])
            for e in r.get("notInManuscript", []):
                w.writerow([r["pathway"], r["lesson"], r["title"], r["status"], "Not found in manuscript", e, "", ""])

    by = {}
    for r in results:
        by[r["result"]] = by.get(r["result"], 0) + 1
    print("lessons:", len(results), by)
    print("changes:", len(changes))

    if args.apply:
        password = open(args.password_file).read().strip()
        auth = post(f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={API_KEY}",
                    {"email": args.email, "password": password, "returnSecureToken": True})
        token = auth["idToken"]
        for name, ch in changes.items():
            path = name.split("/documents/", 1)[1]
            url = f"https://firestore.googleapis.com/v1/{name}?updateMask.fieldPaths=body.en&updateMask.fieldPaths=structureRestoredAt"
            post(url, {"fields": {
                "body": {"mapValue": {"fields": {"en": {"stringValue": ch["new"]}}}},
                "structureRestoredAt": {"timestampValue": __import__("datetime").datetime.utcnow().isoformat() + "Z"},
            }}, token, method="PATCH")
            print("updated", path)


if __name__ == "__main__":
    sys.exit(main())
