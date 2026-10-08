#!/usr/bin/env python3
"""Split Kingdom Heirs book manuscripts into searchable sections (local only).

Reads the manuscripts in content_private/manuscripts/ (gitignored), detects
chapters / days / subheadings and writes one JSONL file per source to
content_private/manuscripts/sections/<sourceId>.jsonl plus a summary report
content_private/manuscripts/manuscript_report.csv.

Nothing is uploaded anywhere; this only reads and writes local files.

Requirements:
  * PDFs: pypdf (font sizes/bold are read via pypdf's text visitor so that
    headings can be told apart from body text). Not installed system-wide;
    run with a venv that has it, e.g.
        python3 -m venv /tmp/mvenv && /tmp/mvenv/bin/pip install pypdf
        /tmp/mvenv/bin/python tools/manuscript_sections.py
  * DOCX: parsed straight from the zip XML (no python-docx needed).

Usage:
  python tools/manuscript_sections.py              # process every manuscript
  python tools/manuscript_sections.py --only come-and-see --debug
      (--debug prints the detected heading outline for eyeballing)
"""

import argparse
import collections
import csv
import json
import math
import os
import re
import sys
import zipfile
import xml.etree.ElementTree as ET

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MS_DIR = os.path.join(ROOT, "content_private", "manuscripts")
OUT_DIR = os.path.join(MS_DIR, "sections")
REPORT = os.path.join(MS_DIR, "manuscript_report.csv")

DEFAULT_AUTHOR = "Rev. James Maddalone"
MIN_WORDS, MAX_WORDS, TARGET_SPLIT = 300, 1200, 900

CORE = {
    "come-and-see", "rooted-in-christ", "journey-into-discipleship-evangelism",
    "holy-spirit-in-the-life-of-every-christian", "kingdom-heirs-foundations",
    "inner-healing-and-deliverance", "counterfeit-gospels",
}

# One entry per expected manuscript. `files` lists candidate source files in
# order of preference; the first one that exists and parses cleanly is used.
# Chapters normally start at "CHAPTER n" / "C H A P T E R  O N E" / "Day n" /
# "Week n" markers, a bare chapter number >= 28pt ("01"), front/back-matter
# headings (Preface, Introduction, Appendix...), or docx Heading 1 / Title.
# "PART n" headings become the `part` context. Per-book tuning knobs:
#   chapter_size  - PDF: any (non-numeric) heading at least this many points
#                   starts a chapter even without a marker
#                   (Foundations: 16pt for Our Convictions, Five Guiding Principles...)
#   markers_only  - DOCX: only CHAPTER/DAY markers start chapters; Heading 1 are
#                   subsections (Inner Healing uses Heading 2 "CHAPTER n" + Title)
#   chapter_level - DOCX heading level(s) that start a chapter (default: 1)
#   number_marker_size - min size of a bare "01" chapter opener (default 28)
#   outline       - "outline" / "curriculum": not a full book manuscript
SOURCES = [
    dict(pathwayId="come-and-see", title="Come and See: An Invitation to Know Jesus",
         files=["Come_and_See manuscript.pdf"], edition="2026 manuscript (\u00a9 2026)"),
    dict(pathwayId="rooted-in-christ", title="Rooted in Christ: 30 Day Devotional",
         files=["Rooted in Christ 30 Day devotional. Rev James Maddalone 2.pdf"],
         edition="v2 (file name suffix \"2\")"),
    dict(pathwayId="journey-into-discipleship-evangelism",
         title="Journey into Discipleship & Evangelism: 90 Day Devotional",
         # The .docx (3 identical copies in Downloads) is a PDF->Word conversion:
         # most "DAY n" labels and some section labels are lost (day numbers
         # become stray "2", "3" paragraphs). The PDF keeps them, so prefer it.
         files=["JOURNEY INTO DISCIPLESHIP & EVANGELISM - 90 DAY DEVOTIONAL - REV JAMES.pdf",
                "JOURNEY INTO DISCIPLESHIP & EVANGELISM - 90 DAY DEVOTIONAL - REV JAMES.docx"],
         edition="90-day devotional (\u00a9 2026)"),
    dict(pathwayId="holy-spirit-in-the-life-of-every-christian",
         title="The Holy Spirit in the Life of Every Christian",
         files=["The Holy Spirit in the Life of Every Christian.pdf",
                "The Holy Spirit in the Life of Every Christian.docx"],
         cover_only=["The Holy Spirit in the Life of Every Christian - KDP Cover - Supplied Front.pdf"],
         edition=""),
    dict(pathwayId="kingdom-heirs-foundations", title="Kingdom Heirs Foundations",
         files=["Kingdom_Heirs_Foundation - Rev James  @2026 - Edition.pdf"],
         edition="2026 Edition", chapter_size=16),
    dict(pathwayId="inner-healing-and-deliverance", title="Inner Healing and Deliverance",
         files=["Inner_Healing_and_Deliverance_Master_Manuscript.docx"],
         edition="Master Manuscript (\u00a9 2026)", markers_only=True),
    dict(pathwayId="counterfeit-gospels",
         title="Counterfeit Gospels: The Truth Stick",
         files=["Counterfeit gospel the true stick polished edition.pdf"],
         edition="Polished edition"),
    dict(pathwayId="the-new-man",
         title="The New Man: A 90-Day Christian Journey to Freedom from Pornography, Shame and Sexual Addiction",
         files=["The New Man - 90-day Christian Journey to freddom from pornography, shame and sexual addiction - Rev. James Maddalone.docx"],
         edition="\u00a9 2026 (copyright page also says \"First Printing Edition, 2019\")"),
    dict(pathwayId="a-letter-to-my-catholic-family",
         title="A Letter to My Catholic Neighbor (Book Outline)",
         files=["A_Letter_to_My_Catholic_Neighbor_Book_Outline.docx"],
         edition="Book development outline", outline="outline"),
    dict(pathwayId="who-is-isa-al-masih",
         title="Who Is Isa al-Masih? An Invitation to Meet Yeshua in the Earliest Witnesses",
         files=["Who_Is_Isa_Al_Masih_Manuscript_Thomas_F_Jacob.pdf"],
         author="Thomas F. Jacob", edition="Manuscript (KDP paperback, 6x9, 248 pp)"),
    dict(pathwayId="joseph-the-dreamer-and-the-holy-spirit",
         title="The Holy Spirit and Joseph the Dreamer: 30 Days Devotional",
         # Revised manuscript (adds Day 16); the earlier PDF is the fallback.
         files=["The_Holy_Spirit_and_Joseph_the_Dreamer_30_Day_Devotional_Advised_16.docx",
                "THE HOLY SPIRIT AND JOSEPH THE DREAMER - 30 DAYS DEVOTIONAL.pdf"],
         edition="30-day devotional (\u00a9 2025)"),
    dict(pathwayId="the-heart-of-a-king", title="The Heart of a King: 30 Day App Curriculum",
         files=["The_Heart_of_a_King_30_Day_App_Curriculum.docx"],
         edition="30-day app curriculum adaptation", outline="curriculum"),
    dict(pathwayId="shepherds-lantern-allegory", title="The Shepherd's Lantern",
         files=["THE SHEPERD’S LANTERN - Reverend James @2026.docx"],
         edition="2026 (file name; \u00a9 2025)"),
]

# --------------------------------------------------------------------------
# Heading classification helpers
# --------------------------------------------------------------------------

NUM_WORDS = {w: i for i, w in enumerate(
    "zero one two three four five six seven eight nine ten eleven twelve thirteen "
    "fourteen fifteen sixteen seventeen eighteen nineteen twenty".split())}
for _t, _v in (("thirty", 30), ("forty", 40), ("fifty", 50)):
    NUM_WORDS[_t] = _v


def roman_to_int(s):
    vals = dict(i=1, v=5, x=10, l=50, c=100)
    s = s.lower()
    if not s or any(ch not in vals for ch in s):
        return None
    total = 0
    for a, b in zip(s, s[1:] + " "):
        v = vals[a]
        total += -v if b in vals and vals[b] > v else v
    return total


def parse_number(tok):
    tok = tok.strip().strip(".:").lower()
    if tok.isdigit():
        return int(tok)
    if tok in NUM_WORDS:
        return NUM_WORDS[tok]
    m = re.match(r"^(twenty|thirty|forty|fifty)[-\s]?(one|two|three|four|five|six|seven|eight|nine)$", tok)
    if m:
        return NUM_WORDS[m.group(1)] + NUM_WORDS[m.group(2)]
    return roman_to_int(tok)


def despace(s):
    """'C H A P T E R   O N E' / 'P A R T 0 2' -> 'CHAPTER ONE' / 'PART 02'."""
    t = s.strip()
    toks = t.split()
    if len(toks) >= 4 and sum(len(x) == 1 for x in toks) >= len(toks) - 1:
        if re.search(r"\s{2,}", t):
            return " ".join(w.replace(" ", "") for w in re.split(r"\s{2,}", t))
        joined = "".join(toks)
        m = re.match(r"^(chapter|day|part|lesson|week|session|module)(.+)$", joined, re.I)
        if m:
            return f"{m.group(1)} {m.group(2)}"
        return joined
    return s


MARKER_RE = re.compile(
    r"^(chapter|day|lesson|week|session|module)\s+"
    r"((?:twenty|thirty|forty|fifty)[-\s](?:one|two|three|four|five|six|seven|eight|nine)|[0-9]+|[ivxlc]+\b|[a-z]+)"
    r"\s*[:.–—-]*\s*(.*)$", re.I)
PART_RE = re.compile(r"^part\s+(\S+)\s*[:.–—-]*\s*(.*)$", re.I)

FRONT_BACK = re.compile(
    r"^(dedication|acknowledg(e)?ments?|preface|foreword|introduction|prologue|epilogue|"
    r"conclusion|afterword|appendix|about the author|author bio|a final word|final word|"
    r"closing|a closing|benediction|glossary|bibliography|notes|endnotes|references|"
    r"a note|note to the reader|how to use)\b", re.I)
# back matter that ends a numbered chapter even when it shares the
# chapter-heading size (unlike e.g. "Closing Prayer" inside a chapter)
BACK_STRONG = re.compile(r"^(appendix|appendices|about the author|author bio|epilogue|afterword|"
                         r"a final word|bibliography|glossary|endnotes)\b", re.I)
TOC_RE = re.compile(r"^(table of contents|contents)\s*$", re.I)


def classify_marker(text):
    """Return (kind, number, rest) for chapter/day/part markers, else None."""
    t = despace(text).strip()
    m = PART_RE.match(t)
    if m and parse_number(m.group(1)) is not None:
        return "part", parse_number(m.group(1)), m.group(2).strip()
    m = MARKER_RE.match(t)
    if m:
        n = parse_number(m.group(2))
        if n is not None:
            rest = re.sub(r"^of\s+\d+\b\s*[:.\u2013\u2014-]*\s*", "", m.group(3).strip(), flags=re.I)  # "Day 1 of 30"
            return m.group(1).lower(), n, rest
    if re.fullmatch(r"\d{1,3}", t):
        return "number", int(t), ""
    return None


def wc(s):
    return len(re.findall(r"\b[\w'’]+\b", s))


def norm_title(s):
    s = re.sub(r"\s+", " ", s).strip(" –—-:|“”\"")
    if s.isupper() and len(s) > 3:
        small = {"a", "an", "and", "the", "of", "in", "on", "to", "for", "with", "by", "at", "or"}
        out = []
        for i, w in enumerate(s.split()):
            lw = w.lower()
            if re.fullmatch(r"\(?[A-Z]{2,4}\)?|[IVX]+", w) and (w.startswith("(") or re.fullmatch(r"[IVX]+", w)):
                out.append(w)  # (ASV), roman numerals
            elif i and lw in small:
                out.append(lw)
            else:
                out.append(re.sub(r"[a-z]", lambda m: m.group(0).upper(), lw, count=1))
        s = " ".join(out)
    return s


# --------------------------------------------------------------------------
# PDF extraction (pypdf visitor -> lines with font size / bold)
# --------------------------------------------------------------------------

def _mult(a, b):
    return [a[0] * b[0] + a[1] * b[2], a[0] * b[1] + a[1] * b[3],
            a[2] * b[0] + a[3] * b[2], a[2] * b[1] + a[3] * b[3],
            a[4] * b[0] + a[5] * b[2] + b[4], a[4] * b[1] + a[5] * b[3] + b[5]]


def _is_bold(font_name):
    return bool(re.search(r"bold|black|heavy|semibold|demi", font_name, re.I))


def pdf_lines(path, notes):
    import logging
    logging.getLogger("pypdf").setLevel(logging.ERROR)
    import pypdf
    reader = pypdf.PdfReader(path)
    pages = []
    empty = 0
    for pno, page in enumerate(reader.pages, 1):
        frags = []

        def visit(text, cm, tm, fd, fs):
            if not text:
                return
            m = _mult(tm, cm)
            size = abs(fs * math.hypot(m[2], m[3])) or abs(fs)
            name = str(fd.get("/BaseFont", "")) if fd else ""
            frags.append((m[5], m[4], round(size, 1), _is_bold(name), text.replace("\n", " ")))

        try:
            page.extract_text(visitor_text=visit)
        except Exception as e:  # pragma: no cover
            notes.append(f"p{pno} extract error {e}")
        frags = [f for f in frags if f[4]]
        if not "".join(f[4] for f in frags).strip():
            empty += 1
            pages.append([])
            continue
        # Build lines in content-stream order (reading order for these
        # Word/InDesign exports): a fragment joins the current line when it
        # sits on the same baseline. Side-bar boxes (e.g. a scripture box
        # beside the body) are drawn after the body, so they become their own
        # lines instead of being interleaved with body text.
        lines = []
        for f in frags:
            if lines and not f[4].strip():
                lines[-1]["frags"].append(f)  # whitespace fragment: keep with current line
                continue
            for ln in lines[-1:-4:-1]:  # same baseline as one of the last few lines?
                if abs(ln["y"] - f[0]) <= max(2.0, 0.35 * f[2]):
                    ln["frags"].append(f)
                    break
            else:
                lines.append({"y": f[0], "frags": [f]})
        for ln in lines:
            ln["frags"].sort(key=lambda f: f[1])
        out = []
        for ln in lines:
            fr = ln["frags"]
            text = "".join(f[4] for f in fr)
            text = re.sub(r"\s+", " ", text).strip()
            if not text:
                continue
            visible = [f for f in fr if f[4].strip()]
            weights = collections.Counter()
            for f in visible:
                weights[f[2]] += len(f[4].strip())
            size = weights.most_common(1)[0][0]
            bold = all(f[3] for f in visible)
            if out and ln["y"] > out[-1]["y"] + 1:  # second column restarts at the top
                out.append({"page": pno, "y": 9999, "text": "", "size": size, "bold": False, "colbreak": True})
            out.append({"page": pno, "y": ln["y"], "text": text, "size": size, "bold": bold})
        pages.append(out)
    if empty:
        notes.append(f"{empty} empty/image-only page(s) of {len(reader.pages)}")
    return pages, len(reader.pages)


def pdf_blocks(path, cfg, notes):
    pages, npages = pdf_lines(path, notes)
    all_lines = [l for p in pages for l in p]
    if not all_lines:
        return [], npages
    # body font size = char-weighted mode
    sizes = collections.Counter()
    for l in all_lines:
        sizes[l["size"]] += len(l["text"])
    body = sizes.most_common(1)[0][0]
    # typical line spacing of body text
    gaps = []
    for p in pages:
        for a, b in zip(p, p[1:]):
            if a["size"] == body and b["size"] == body:
                d = a["y"] - b["y"]
                if 0 < d < 3 * body:
                    gaps.append(d)
    spacing = sorted(gaps)[len(gaps) // 2] if gaps else body * 1.3

    # running headers/footers: identical short lines on many pages
    rep = collections.Counter(re.sub(r"\d+", "#", l["text"]) for l in all_lines if len(l["text"]) < 80)
    running = {k for k, v in rep.items() if v >= max(5, 0.25 * npages) and re.search(r"[A-Za-z]", k)}

    blocks = []  # dicts: kind heading/para, text, size, page
    skip_pages = set()
    for p in pages:
        txt = " ".join(l["text"] for l in p)
        if re.search(r"all rights reserved|ISBN", txt, re.I) and wc(txt) < 400:
            skip_pages.add(p[0]["page"] if p else None)
    if skip_pages - {None}:
        notes.append(f"skipped copyright page(s) {sorted(skip_pages - {None})}")

    for p in pages:
        if not p or p[0]["page"] in skip_pages:
            continue
        prev = None
        for i, l in enumerate(p):
            t = l["text"]
            if l.get("colbreak"):
                prev = None
                continue
            if (len(t.split()) >= 4 and sum(len(x) == 1 for x in t.split()) >= len(t.split()) - 1
                    and l["size"] < body and not classify_marker(t)):
                continue  # letter-spaced decorative kicker / running title
            key = re.sub(r"\d+", "#", t)
            if key in running and l["size"] < body * 1.12 and (i == 0 or i == len(p) - 1):
                continue  # running header/footer
            if (re.fullmatch(r"\d{1,4}|[ivxlc]{1,6}", t, re.I) and (i == len(p) - 1 or i == 0)
                    and l["size"] < body * 1.3):
                continue  # page number
            if re.search(r"\.{3,}[\s.]*\d{1,3}\s*$", t):
                continue  # TOC dot-leader line
            gap_before = (prev["y"] - l["y"]) if prev else 999
            nxt = p[i + 1] if i + 1 < len(p) else None
            gap_after = (l["y"] - nxt["y"]) if nxt else 999
            big = l["size"] >= body * 1.12 and re.search(r"[A-Za-z0-9]", t)
            words = t.split()
            bold_head = (l["bold"] and l["size"] >= body * (0.85 if t.isupper() else 0.95) and len(words) <= 12
                         and not re.search(r"[.,;!?”\"]$", t)
                         and not re.match(r"^[—–\-“\"(]", t)
                         and gap_before > spacing * 1.25
                         and (gap_after > spacing * 1.15 or t.isupper() or l["size"] > body))
            marker = classify_marker(t)
            standalone = gap_before > spacing * 1.25 and gap_after > spacing * 1.15
            is_head = bool(big or bold_head or (marker and marker[0] != "number" and len(despace(t).split()) <= 12
                                                and (l["bold"] or standalone)))
            if is_head and len(words) > 25:
                is_head = False
            if is_head:
                last = blocks[-1] if blocks else None
                if (last and last["kind"] == "heading" and last["page"] == l["page"]
                        and abs(last["size"] - l["size"]) < 0.6 and prev is not None
                        and last["bold"] == l["bold"]
                        and gap_before <= l["size"] * 1.6 and not marker
                        and (not classify_marker(last["text"]) or classify_marker(last["text"])[2])):
                    last["text"] += " " + t  # multi-line heading
                else:
                    blocks.append({"kind": "heading", "text": t, "size": l["size"], "page": l["page"],
                                   "bold": l["bold"]})
            else:
                last = blocks[-1] if blocks else None
                new_para = (last is None or last["kind"] != "para" or gap_before > spacing * 1.4
                            or (prev is None and re.search(r"[.!?”\"]\s*$", last["text"])))
                if new_para:
                    blocks.append({"kind": "para", "text": t, "size": l["size"], "page": l["page"]})
                else:
                    # keep end-of-line hyphens (compounds like "self-discovery")
                    sep = "" if re.search(r"\w-$", last["text"]) else " "
                    last["text"] = last["text"] + sep + t
            prev = l
    for b in blocks:
        b["text"] = b["text"].strip()
        # long "headings" that read like sentences are epigraphs / pull quotes
        if b["kind"] == "heading" and (wc(b["text"]) > 25 or (wc(b["text"]) > 12 and
                                                               re.search(r"[.!?\u201d\"]$", b["text"]))):
            b["kind"] = "para"
    long_pages = {b["page"] for b in blocks if b["kind"] == "para" and wc(b["text"]) >= 25
                  and abs(b["size"] - body) <= 0.6 and len(re.findall(r"[.!?]", b["text"])) >= 2}
    for b in blocks:
        b["longpage"] = b["page"] in long_pages
    return blocks, npages


# --------------------------------------------------------------------------
# DOCX extraction (zip XML)
# --------------------------------------------------------------------------

W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"


def docx_blocks(path, cfg, notes):
    z = zipfile.ZipFile(path)
    styles = {}
    try:
        st = ET.fromstring(z.read("word/styles.xml"))
        for s in st.iter(W + "style"):
            sid = s.get(W + "styleId")
            name = s.find(W + "name")
            lvl = s.find(f"{W}pPr/{W}outlineLvl")
            styles[sid] = (name.get(W + "val") if name is not None else sid,
                           int(lvl.get(W + "val")) if lvl is not None else None)
    except KeyError:
        pass
    doc = ET.fromstring(z.read("word/document.xml"))
    body = doc.find(W + "body")
    imgs = sum(1 for n in z.namelist() if n.startswith("word/media/"))
    if imgs:
        notes.append(f"{imgs} embedded image(s) ignored")

    def ptext(p):
        out = []
        for node in p.iter():
            if node.tag == W + "t" and node.text:
                out.append(node.text)
            elif node.tag == W + "tab":
                out.append("\t")
            elif node.tag in (W + "br", W + "cr"):
                out.append("\n")
        return re.sub(r"[ \t]+", " ", "".join(out)).strip()

    def pstyle(p):
        ps = p.find(f"{W}pPr/{W}pStyle")
        sid = ps.get(W + "val") if ps is not None else "Normal"
        name, lvl = styles.get(sid, (sid, None))
        ol = p.find(f"{W}pPr/{W}outlineLvl")
        if ol is not None:
            lvl = int(ol.get(W + "val"))
        return name, lvl

    def pbold(p):
        runs = [r for r in p.iter(W + "r") if "".join(t.text or "" for t in r.iter(W + "t")).strip()]
        if not runs:
            return False
        for r in runs:
            b = r.find(f"{W}rPr/{W}b")
            if b is None or b.get(W + "val") in ("0", "false"):
                return False
        return True

    blocks = []
    tables = 0

    def handle_p(p, in_table=False):
        t = ptext(p)
        if not t:
            return
        name, lvl = pstyle(p)
        lname = name.lower()
        if lname.startswith("toc"):
            return  # table-of-contents entry
        level = None
        if lname == "title":
            level = 1
        elif lname.startswith("heading") and lvl is not None:
            level = lvl + 1
        elif re.match(r"heading\s*\d", lname):
            level = int(re.findall(r"\d", lname)[0])
        elif lname in ("chapter heading",):
            level = 1
        elif lname == "subtitle":
            level = None  # treat subtitles as text (usually a tagline)
        elif (not in_table and pbold(p) and len(t.split()) <= 10
              and not re.search(r"[.,;!?”\"]$", t)):
            level = 9  # bold standalone line -> minor subheading
        if level is not None and len(t.split()) <= 25:
            blocks.append({"kind": "heading", "text": t, "level": level, "style": name})
        else:
            if "\n" in t:
                for part in t.split("\n"):
                    if part.strip():
                        blocks.append({"kind": "para", "text": part.strip()})
            else:
                blocks.append({"kind": "para", "text": t})

    for child in body:
        if child.tag == W + "p" and re.search(r"all rights reserved|\bISBN\b|^\s*\+?\d[\d ()-]{8,}\s*$",
                                              ptext(child), re.I):
            continue  # copyright notice / contact line
        if child.tag == W + "p":
            handle_p(child)
        elif child.tag == W + "tbl":
            tables += 1
            for row in child.iter(W + "tr"):
                cells = []
                for c in row.iter(W + "tc"):
                    ct = " ".join(ptext(p) for p in c.iter(W + "p") if ptext(p))
                    if ct:
                        cells.append(ct)
                if cells:
                    blocks.append({"kind": "para", "text": " | ".join(cells)})
        elif child.tag == W + "sdt":  # content controls (TOC etc.)
            for p in child.iter(W + "p"):
                handle_p(p)
    if tables:
        notes.append(f"{tables} table(s) flattened to ' | ' rows")
    # a heading repeated many times is a running title (e.g. the book title
    # styled as "Title" above every chapter) -> drop it
    counts = collections.Counter(b["text"].strip().lower() for b in blocks
                                 if b["kind"] == "heading" and b.get("style", "").lower() == "title")
    running = {t for t, n in counts.items() if n >= 4 and not classify_marker(t)
               and not FRONT_BACK.match(t) and len(t.split()) >= 3}
    if running:
        blocks = [b for b in blocks if not (b["kind"] == "heading" and b["text"].strip().lower() in running)]
        notes.append("dropped repeated running title(s): " + "; ".join(sorted(running))[:80])
    return blocks, None


# --------------------------------------------------------------------------
# Structure: blocks -> chapters -> sections
# --------------------------------------------------------------------------

def build_chapters(blocks, cfg, is_pdf, notes, debug=False):
    """Group blocks into chapters: dict(number, title, kind, part, front, units=[[subtitle, [paras]]])."""
    chapter_size = cfg.get("chapter_size")
    chapter_levels = set(cfg.get("chapter_level", []))
    num_size = cfg.get("number_marker_size", 28)  # bare "01" opener (PDF) must be at least this big
    hsizes = [b["size"] for b in blocks if b["kind"] == "heading" and is_pdf]
    max_head = max(hsizes) if hsizes else 0

    chapters = []
    part = None
    cur = None
    in_toc = False

    def new_chapter(number, title, kind, front=False):
        nonlocal cur
        cur = {"number": number, "title": title, "kind": kind, "part": part, "front": front,
               "units": [[None, []]]}
        chapters.append(cur)

    def cur_is(ht):
        return cur is not None and cur["title"] == norm_title(ht)

    def is_chapter_heading(b):
        ht = despace(b["text"])
        if is_pdf:
            if chapter_size and b["size"] >= chapter_size and not re.fullmatch(r"[\d\s]+", ht):
                return True
            return bool(FRONT_BACK.match(ht) and b.get("bold") and ht.isupper())
        if cfg.get("markers_only"):
            return False
        if chapter_levels:
            return b.get("level") in chapter_levels
        return b.get("level") == 1

    i = 0
    while i < len(blocks):
        b = blocks[i]
        t = b["text"]
        if b["kind"] == "heading":
            ht = despace(t)
            if TOC_RE.match(ht.strip()):
                in_toc = True
                i += 1
                continue
            if in_toc:
                # PDF: the contents run until the first page with real prose.
                # DOCX: until the next chapter-level heading.
                if (is_pdf and not b.get("longpage")) or (not is_pdf and not (
                        (b.get("level") or 9) <= 2 and (is_chapter_heading(b) or classify_marker(ht)))):
                    i += 1
                    continue
                in_toc = False
            marker = classify_marker(ht)
            if marker and marker[0] == "number" and not (is_pdf and b["size"] >= num_size):
                marker = None
            if marker and marker[0] == "part":
                part = norm_title(ht)
                j = i + 1
                while j < len(blocks) and j - i <= 2 and blocks[j]["kind"] == "heading" \
                        and not classify_marker(despace(blocks[j]["text"])) and not is_chapter_heading(blocks[j]) \
                        and (not is_pdf or blocks[j]["size"] <= b["size"] + 0.1):
                    part += " \u2014 " + norm_title(blocks[j]["text"])
                    j += 1
                new_chapter(None, part, "part", front=True)  # holds any part introduction text
                i = j
                continue
            if marker:
                kind, num, rest = marker
                title = rest
                j = i + 1
                # '01' / 'CHAPTER ONE' / 'PART 01 . COME HOME' / Title, in any order
                while j < len(blocks) and blocks[j]["kind"] == "heading" and j - i <= 4:
                    nt = despace(blocks[j]["text"])
                    nm = classify_marker(nt)
                    if nm and nm[0] == "part":
                        part = norm_title(nt)
                        j += 1
                        continue
                    if nm and nm[0] != "number" and nm[1] == num:
                        kind = nm[0]
                        title = title or nm[2]
                        j += 1
                        continue
                    if nm or title or is_chapter_heading(blocks[j]) and not is_pdf:
                        break
                    title = blocks[j]["text"]
                    j += 1
                if kind == "number":
                    kind = "chapter"
                if cur and cur["number"] == num and cur["kind"] == kind and len(cur["units"]) == 1 \
                        and not cur["units"][0][1]:
                    cur["title"] = cur["title"] or norm_title(title)  # repeated marker (docx)
                else:
                    new_chapter(num, norm_title(title), kind)
                i = j
                continue
            if (not is_pdf and b.get("level") == 1 and re.match(r"^[\u2013\u2014-]\s*\S", ht) and cur
                    and cur["kind"] == "day" and cur["number"] is not None):
                # "– Title" heading whose "DAY n" label comes from Word list
                # numbering (not in the text): continue the day sequence
                new_chapter(cur["number"] + 1, norm_title(ht), "day")
                notes.append(f"day {cur['number']} number inferred (label is Word auto-numbering)")
                i += 1
                continue
            if (not is_pdf and FRONT_BACK.match(ht) and (cur is None or cur["number"] is None or BACK_STRONG.match(ht))
                    and not cur_is(ht)):
                new_chapter(None, norm_title(ht), "front", front=True)
                i += 1
                continue
            if is_chapter_heading(b) or (is_pdf and FRONT_BACK.match(ht) and b["size"] >= max_head - 0.1 and (
                    cur is None or cur["number"] is None or BACK_STRONG.match(ht))):
                front = bool(FRONT_BACK.match(ht))
                if cur and not front and cur["number"] is not None and not any(u[1] for u in cur["units"]) \
                        and len(cur["units"]) == 1 and (not cur["title"] or norm_title(ht) == cur["title"]):
                    cur["title"] = norm_title(ht)  # title line right after a marker
                else:
                    new_chapter(None, norm_title(ht), "front" if front else "chapter", front=front)
                i += 1
                continue
            if cur is None:
                new_chapter(None, "Front matter", "front", front=True)
            if cur_is(ht) and not any(u[1] for u in cur["units"]):
                i += 1
                continue  # chapter title repeated right below its marker
            cur["units"].append([norm_title(ht), []])
            i += 1
            continue
        # paragraph
        if in_toc:
            if (is_pdf and not b.get("longpage")) or (not is_pdf and (
                    wc(t) < 25 or len(re.findall(r"[.!?]", t)) < 2)):
                i += 1
                continue
            in_toc = False
        if cur is None:
            new_chapter(None, "Front matter", "front", front=True)
        cur["units"][-1][1].append(t)
        i += 1

    # Drop overview lists that look like chapters (mostly "Day n - Title"
    # lines), then de-duplicate repeated chapter numbers.
    def cwords(c):
        return sum(wc(p) for u in c["units"] for p in u[1])

    def vocab(c):
        return set(re.findall(r"[a-z']+", " ".join(p for u in c["units"] for p in u[1]).lower()))

    kept = []
    for c in chapters:
        paras = [p for u in c["units"] for p in u[1]]
        markers = sum(1 for p in paras if classify_marker(p) or re.search(r"\.{3,}[\s.]*\d{1,3}\s*$", p))
        if paras and markers >= 0.6 * len(paras) and cwords(c) < 400:
            continue
        kept.append(c)
    best = {}
    for c in kept:
        if c["number"] is not None:
            k = (c["kind"], c["number"])
            if k not in best or cwords(c) > cwords(best[k]):
                best[k] = c
    out = []
    for c in kept:
        if c["number"] is None or best[(c["kind"], c["number"])] is c:
            out.append(c)
            continue
        bc = best[(c["kind"], c["number"])]
        if cwords(c) < 150:
            continue  # contents / overview stub
        va, vb = vocab(c), vocab(bc)
        sim = len(va & vb) / max(1, len(va))  # share of this copy's vocabulary found in the fuller copy
        if sim >= 0.85:
            notes.append(f"duplicate {c['kind']} {c['number']} ({cwords(c)} words, {sim:.0%} contained in the "
                         f"fuller copy) dropped")
            continue
        notes.append(f"{c['kind']} {c['number']} appears twice with different text (both kept)")
        out.append(c)
    chapters = [c for c in out if not (c["number"] is None and cwords(c) < 30)]  # title pages, dividers

    nums = collections.defaultdict(set)
    for c in chapters:
        if c["number"] is not None:
            nums[c["kind"]].add(c["number"])
    for kind, ns in nums.items():
        if kind in ("chapter", "day") and len(ns) > 3:
            gaps = sorted(set(range(1, max(ns) + 1)) - ns)
            if gaps:
                notes.append(f"{kind} number(s) not found: {gaps}")

    if debug:
        for c in chapters:
            subs = [u[0] for u in c["units"] if u[0]]
            print(f"  [{c['kind']} {c['number']}] {c['title']!r}  part={c['part']!r} words={cwords(c)} "
                  f"subs={len(subs)}: {subs[:6]}")
    return chapters


def split_paras(paras, max_words=MAX_WORDS):
    """Split a list of paragraphs into chunks of <= max_words (balanced)."""
    out = []
    # break oversized single paragraphs at sentence boundaries
    flat = []
    for p in paras:
        if wc(p) > max_words:
            sents = re.split(r"(?<=[.!?”])\s+", p)
            buf = ""
            for s in sents:
                if buf and wc(buf) + wc(s) > TARGET_SPLIT:
                    flat.append(buf)
                    buf = s
                else:
                    buf = (buf + " " + s).strip()
            if buf:
                flat.append(buf)
        else:
            flat.append(p)
    total = sum(wc(p) for p in flat)
    n = max(1, math.ceil(total / max_words))
    target = total / n
    cur, cw = [], 0
    for p in flat:
        w = wc(p)
        if cur and cw + w > max_words or (cur and cw >= target and len(out) < n - 1):
            out.append(cur)
            cur, cw = [], 0
        cur.append(p)
        cw += w
    if cur:
        out.append(cur)
    return out


GENERIC = re.compile(r"^(kingdom insight|truth stick insight|truth stick challenge|reflection|scripture( focus)?|"
                     r"prayer( of the day)?|faith reflection|application for today|practical application|"
                     r"questions for reflection|additional scriptures|memory verse|chapter (introduction|quote)|"
                     r"stage \w+|meet your neighbor|notes?)$", re.I)


def make_sections(chapters):
    """Chapter -> subheading units -> sections of ~MIN_WORDS..MAX_WORDS words.

    Small subheading units are merged forward within a chapter (never across
    chapters, so every section cites a single chapter/day); oversized ones are
    split at paragraph boundaries. Subheadings stay in the text as their own
    lines so merged sections remain readable.
    """
    sections = []
    for c in chapters:
        units, carry = [], []
        for title, paras in c["units"]:
            lines = carry + ([title] if title else [])
            if not paras:
                carry = lines  # heading with no body: keep it for the next unit
                continue
            carry = []
            units.append({"title": title, "paras": lines + list(paras), "words": sum(wc(p) for p in paras)})
        if carry and units:
            units[-1]["paras"] += carry
        if not units:
            continue
        groups = []
        for u in units:
            if groups and groups[-1]["words"] < MIN_WORDS and groups[-1]["words"] + u["words"] <= MAX_WORDS:
                g = groups[-1]
                g["paras"] += u["paras"]
                g["words"] += u["words"]
                g["titles"] += [u["title"]] if u["title"] else []
            else:
                groups.append({"titles": [u["title"]] if u["title"] else [], "paras": list(u["paras"]),
                               "words": u["words"], "first": not groups, "start": u["title"]})
        if len(groups) > 1 and groups[-1]["words"] < MIN_WORDS and \
                groups[-2]["words"] + groups[-1]["words"] <= MAX_WORDS:
            last = groups.pop()
            groups[-1]["paras"] += last["paras"]
            groups[-1]["words"] += last["words"]
            groups[-1]["titles"] += last["titles"]
        for g in groups:
            if g["first"] and c["title"] and (len(groups) == 1 or not g["start"] or len(g["titles"]) > 1):
                st = c["title"]  # opening section of the chapter
            else:
                st = g["start"] or c["title"] or ""
                if GENERIC.match(st):  # e.g. "Truth Stick Insight": prefer a descriptive subheading
                    st = next((t for t in g["titles"] if not GENERIC.match(t)), st)
            chunks = split_paras(g["paras"]) if g["words"] > MAX_WORDS else [g["paras"]]
            for k, ch in enumerate(chunks):
                sections.append({"chapter": c, "paras": ch,
                                 "sectionTitle": f"{st} (part {k + 1} of {len(chunks)})" if len(chunks) > 1 else st})
    return sections


# --------------------------------------------------------------------------
# Language detection (stopword heuristic)
# --------------------------------------------------------------------------

STOP = {
    "en": "the and of to in that is for it with as was his he be on not by this are you".split(),
    "es": "el la de que y en los se del las por un una con para es su al lo".split(),
    "pt": "o a de que e do da em um para com não uma os no se na por".split(),
    "fr": "le la les de des et est un une que qui dans pour pas sur au du".split(),
}


def detect_language(text):
    words = re.findall(r"[a-záéíóúñçàèêôãõ]+", text.lower()[:200000])
    cnt = collections.Counter(words)
    scores = {lang: sum(cnt[w] for w in ws) for lang, ws in STOP.items()}
    best = max(scores, key=scores.get)
    return best if scores[best] else "und"


# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------

def process(cfg, debug=False):
    pid = cfg["pathwayId"]
    track = "core" if pid in CORE else "additional"
    row = {"sourceId": pid, "title": cfg["title"], "sourceFile": "", "language": "", "pathway": pid,
           "track": track, "chapters detected": 0, "sections created": 0, "total words": 0, "skipped/failed notes": ""}
    notes = []
    path = None
    for f in cfg["files"]:
        p = os.path.join(MS_DIR, f)
        if os.path.exists(p):
            path = p
            break
    if path is None:
        msg = "MISSING: no full manuscript found"
        if cfg.get("cover_only"):
            have = [f for f in cfg["cover_only"] if os.path.exists(os.path.join(MS_DIR, f))]
            if have:
                msg += f" (only cover PDF present: {have[0]}; not ingested)"
        row["skipped/failed notes"] = msg
        out = os.path.join(OUT_DIR, f"{pid}.jsonl")
        if os.path.exists(out):
            os.remove(out)
        return row
    if path.endswith(".pdf") and cfg["files"].index(os.path.basename(path)) == 0 and \
            any(x.endswith(".docx") for x in cfg["files"][1:]):
        notes.append("used PDF over .docx (docx is a lossy PDF conversion: DAY labels missing)")
    row["sourceFile"] = os.path.basename(path)
    is_pdf = path.lower().endswith(".pdf")
    if debug:
        print(f"== {pid}: {row['sourceFile']}")
    blocks, npages = (pdf_blocks if is_pdf else docx_blocks)(path, cfg, notes)
    if not blocks:
        row["skipped/failed notes"] = "FAILED: no text extracted (scanned/image PDF?)"
        return row
    chapters = build_chapters(blocks, cfg, is_pdf, notes, debug)
    sections = make_sections(chapters)
    tiny = [s for s in sections if wc("\n".join(s["paras"])) < 15]
    if tiny:
        sections = [s for s in sections if s not in tiny]
        notes.append(f"{len(tiny)} near-empty section(s) (<15 words) dropped")
    full_text = "\n".join(b["text"] for b in blocks)
    lang = detect_language(full_text)
    # every file names Rev. James Maddalone (some copyrights are held by
    # Kingdom Heirs Foundation); per-source override via cfg["author"]
    author = cfg.get("author", DEFAULT_AUTHOR)
    os.makedirs(OUT_DIR, exist_ok=True)
    total = 0
    with open(os.path.join(OUT_DIR, f"{pid}.jsonl"), "w", encoding="utf-8") as fh:
        for idx, s in enumerate(sections, 1):
            c = s["chapter"]
            text = "\n\n".join(s["paras"]).strip()
            n = wc(text)
            total += n
            label = c["title"]
            if c["number"] is not None:
                kind = "Chapter" if c["kind"] in ("chapter", "number") else c["kind"].title()
                label = f"{kind} {c['number']}" + (f": {c['title']}" if c["title"] else "")
            path_parts = [x for x in (c["part"], label, s["sectionTitle"]) if x]
            rec = {
                "sourceId": pid,
                "title": cfg["title"],
                "author": author,
                "edition": cfg.get("edition", ""),
                "pathwayId": pid,
                "pathwayTrack": track,
                "language": lang,
                "chapterNumber": c["number"],
                "chapterKind": "front/back matter" if c["front"] else c["kind"],
                "chapterTitle": c["title"],
                "part": c["part"],
                "sectionTitle": s["sectionTitle"],
                "headingPath": path_parts,
                "sectionIndex": idx,
                "text": text,
                "wordCount": n,
                "sourceFile": row["sourceFile"],
                "documentType": cfg.get("outline") or "manuscript",
                "status": "draft",
            }
            fh.write(json.dumps(rec, ensure_ascii=False) + "\n")
    with_text = {id(s["chapter"]) for s in sections}
    numbered = [c for c in chapters if c["number"] is not None and id(c) in with_text]
    unnumbered = [c for c in chapters if c["number"] is None and not c["front"] and id(c) in with_text]
    if unnumbered:
        notes.append(f"+{len(unnumbered)} unnumbered chapter-level heading(s)")
    small = sum(1 for s in sections if wc("\n".join(s["paras"])) < MIN_WORDS)
    big = sum(1 for s in sections if wc("\n".join(s["paras"])) > MAX_WORDS)
    if small:
        notes.append(f"{small} section(s) <{MIN_WORDS} words (short chapter/day kept whole)")
    if big:
        notes.append(f"{big} section(s) >{MAX_WORDS} words")
    if cfg.get("outline") == "outline":
        notes.insert(0, "OUTLINE ONLY (planning/chapter summaries), not a full manuscript")
    elif cfg.get("outline") == "curriculum":
        notes.insert(0, "APP CURRICULUM adaptation (full daily devotional text + tables), not the book manuscript")
    if npages:
        notes.append(f"{npages} pages")
    row.update({"language": lang, "chapters detected": len(numbered), "sections created": len(sections),
                "total words": total, "skipped/failed notes": "; ".join(notes)})
    return row


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", help="process only this pathwayId")
    ap.add_argument("--debug", action="store_true")
    args = ap.parse_args()
    rows = []
    for cfg in SOURCES:
        if args.only and cfg["pathwayId"] != args.only:
            continue
        rows.append(process(cfg, args.debug))
        r = rows[-1]
        print(f"{r['sourceId']:45} ch={r['chapters detected']:>4} sec={r['sections created']:>4} "
              f"words={r['total words']:>7}  {r['skipped/failed notes']}", file=sys.stderr)
    if not args.only:
        with open(REPORT, "w", newline="", encoding="utf-8") as fh:
            w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
        print(f"wrote {REPORT}", file=sys.stderr)


if __name__ == "__main__":
    main()
