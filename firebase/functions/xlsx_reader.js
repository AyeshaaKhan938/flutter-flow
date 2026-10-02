// Minimal .xlsx reader (sheet names + cell text) built on jszip, so the
// importer can take Kingdom Heirs' original Excel masters directly.
const JSZip = require("jszip");

function decodeXml(s) {
  return s
    .replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g, '"')
    .replace(/&apos;/g, "'")
    .replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(Number(n)))
    .replace(/&#x([0-9a-fA-F]+);/g, (_, n) => String.fromCodePoint(parseInt(n, 16)))
    .replace(/&amp;/g, "&");
}

/** Text of all <t> runs inside an XML fragment (shared / inline strings). */
function runsText(xml) {
  const out = [];
  const re = /<(?:\w+:)?t(?:\s[^>]*)?>([\s\S]*?)<\/(?:\w+:)?t>|<(?:\w+:)?t(?:\s[^>]*)?\/>/g;
  let m;
  while ((m = re.exec(xml))) out.push(m[1] ? decodeXml(m[1]) : "");
  return out.join("");
}

function columnIndex(ref) {
  const letters = ref.replace(/[0-9]/g, "");
  let n = 0;
  for (const ch of letters) n = n * 26 + (ch.charCodeAt(0) - 64);
  return n - 1;
}

/** Returns [{ name, rows: string[][] }] for every sheet in the workbook. */
async function readXlsx(buffer) {
  const zip = await JSZip.loadAsync(buffer);
  const file = (p) => zip.file(p) ? zip.file(p).async("string") : Promise.resolve("");
  const workbook = await file("xl/workbook.xml");
  const rels = await file("xl/_rels/workbook.xml.rels");
  const relTargets = {};
  for (const m of rels.matchAll(/<(?:\w+:)?Relationship\b[^>]*>/g)) {
    const id = (m[0].match(/\bId="([^"]+)"/) || [])[1];
    const target = (m[0].match(/\bTarget="([^"]+)"/) || [])[1];
    if (id && target) relTargets[id] = target.replace(/^\/?(xl\/)?/, "xl/");
  }
  const shared = [];
  const sst = await file("xl/sharedStrings.xml");
  for (const m of sst.matchAll(/<(?:\w+:)?si>([\s\S]*?)<\/(?:\w+:)?si>/g)) shared.push(runsText(m[1]));

  const sheets = [];
  for (const m of workbook.matchAll(/<(?:\w+:)?sheet\b[^>]*\/?>/g)) {
    const name = decodeXml((m[0].match(/\bname="([^"]*)"/) || [])[1] || "");
    const rid = (m[0].match(/\br:id="([^"]+)"/) || [])[1];
    const xml = await file(relTargets[rid] || "");
    const rows = [];
    for (const r of xml.matchAll(/<(?:\w+:)?row\b[^>]*>([\s\S]*?)<\/(?:\w+:)?row>|<(?:\w+:)?row\b[^>]*\/>/g)) {
      const cells = [];
      const body = r[1] || "";
      for (const c of body.matchAll(/<(?:\w+:)?c\b([^>]*?)(?:\/>|>([\s\S]*?)<\/(?:\w+:)?c>)/g)) {
        const attrs = c[1];
        const inner = c[2] || "";
        const ref = (attrs.match(/\br="([A-Z]+\d+)"/) || [])[1];
        const type = (attrs.match(/\bt="([^"]+)"/) || [])[1];
        const v = (inner.match(/<(?:\w+:)?v>([\s\S]*?)<\/(?:\w+:)?v>/) || [])[1];
        let text = "";
        if (type === "s") text = shared[Number(v)] || "";
        else if (type === "inlineStr") text = runsText(inner);
        else if (type === "b") text = v === "1" ? "TRUE" : "FALSE";
        else if (v !== undefined) text = decodeXml(v);
        const idx = ref ? columnIndex(ref) : cells.length;
        while (cells.length < idx) cells.push("");
        cells[idx] = text;
      }
      rows.push(cells);
    }
    sheets.push({ name, rows });
  }
  return sheets;
}

module.exports = { readXlsx };
