import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/custom_code/bible_reference.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// Kinds of block a lesson's teaching text is split into.
enum LessonBlockKind { heading, paragraph, bullets, numbered, scripture, references }

class LessonBlock {
  const LessonBlock(this.kind, this.lines);

  final LessonBlockKind kind;

  /// One entry for a heading, paragraph or Scripture block; one per item
  /// for a list.
  final List<String> lines;
}

/// Headings the Kingdom Heirs devotionals use inside a lesson.
const _kLabelHeadings = {
  'scripture',
  'scriptures',
  'additional scriptures',
  'additional scripture',
  'key scripture',
  'scripture reading',
  'reflection',
  'reflection questions',
  'questions for reflection',
  'application',
  'prayer',
  'a prayer',
  'closing prayer',
  'declaration',
  'key truth',
  'key truths',
  'memory verse',
};

final _kBullet = RegExp(r'^\s*(?:[-*•◦▪–]|•)\s+');
final _kNumbered = RegExp(r'^\s*(\d{1,2})[.)]\s+');
final _kPageNumber = RegExp(r'^\s*\d{1,3}\s*$');
final _kMarkdownHeading = RegExp(r'^\s*#{1,3}\s+');
final _kQuoteMarker = RegExp(r'^\s*>\s?');

/// Splits stored lesson text into display blocks without changing its words.
///
/// The text may be structured ("## Heading", blank lines between
/// paragraphs, "- " list items, "> " Scripture) or come from a PDF with hard
/// line breaks and page numbers; both read as paragraphs here. Line breaks
/// inside a paragraph are joined, and lines holding only a page number are
/// left out.
List<LessonBlock> parseLessonText(String raw) {
  final text = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();
  if (text.isEmpty) return const [];
  final blocks = <LessonBlock>[];
  var afterScriptureHeading = false;

  for (final chunk in text.split(RegExp(r'\n\s*\n'))) {
    final lines = chunk
        .split('\n')
        .map((l) => l.trimRight())
        .where((l) => l.trim().isNotEmpty && !_kPageNumber.hasMatch(l))
        .toList();
    if (lines.isEmpty) continue;

    // Markdown-style heading on the first line of the chunk.
    if (_kMarkdownHeading.hasMatch(lines.first)) {
      blocks.add(LessonBlock(LessonBlockKind.heading,
          [lines.first.replaceFirst(_kMarkdownHeading, '').trim()]));
      lines.removeAt(0);
      if (lines.isEmpty) continue;
    }

    // Explicit Scripture quotation ("> ...").
    if (lines.every((l) => _kQuoteMarker.hasMatch(l))) {
      blocks.add(LessonBlock(LessonBlockKind.scripture,
          [_joinLines(lines.map((l) => l.replaceFirst(_kQuoteMarker, '')))]));
      afterScriptureHeading = false;
      continue;
    }

    // Lists: every line (or every new item) starts with a marker.
    if (_kBullet.hasMatch(lines.first) || _kNumbered.hasMatch(lines.first)) {
      final numbered = _kNumbered.hasMatch(lines.first);
      final marker = numbered ? _kNumbered : _kBullet;
      final items = <String>[];
      for (final l in lines) {
        if (marker.hasMatch(l)) {
          items.add(l.replaceFirst(marker, '').trim());
        } else if (items.isNotEmpty) {
          items[items.length - 1] = _joinLines([items.last, l]);
        } else {
          items.add(l.trim());
        }
      }
      if (items.length > 1 || numbered) {
        blocks.add(LessonBlock(
            numbered ? LessonBlockKind.numbered : LessonBlockKind.bullets,
            items));
        afterScriptureHeading = false;
        continue;
      }
    }

    final joined = _joinLines(lines);
    if (isLessonHeading(joined)) {
      blocks.add(LessonBlock(LessonBlockKind.heading, [joined]));
      final lower = joined.toLowerCase();
      afterScriptureHeading = lower.contains('scripture') ||
          lower == 'memory verse' ||
          lower == 'scripture reading';
      continue;
    }
    if (_isReferenceList(joined)) {
      blocks.add(LessonBlock(LessonBlockKind.references, [joined]));
      afterScriptureHeading = false;
      continue;
    }
    if (afterScriptureHeading || _looksLikeQuotedScripture(joined)) {
      blocks.add(LessonBlock(LessonBlockKind.scripture, [joined]));
      afterScriptureHeading = false;
      continue;
    }
    blocks.add(LessonBlock(LessonBlockKind.paragraph, [joined]));
  }
  return blocks;
}

/// Joins hard-wrapped lines into one paragraph. A line ending in a hyphen
/// before a lower-case word is a word split by the PDF ("self-" "control"
/// stays "self-control").
String _joinLines(Iterable<String> lines) {
  final out = StringBuffer();
  for (final l in lines.map((l) => l.trim()).where((l) => l.isNotEmpty)) {
    if (out.isEmpty) {
      out.write(l);
      continue;
    }
    final prev = out.toString();
    out.write(prev.endsWith('-') || prev.endsWith('—') ? l : ' $l');
  }
  return out.toString();
}

/// A short stand-alone line written as a title: a section heading.
bool isLessonHeading(String s) {
  final t = s.trim();
  if (t.isEmpty || t.length > 80) return false;
  if (_kLabelHeadings.contains(t.toLowerCase().replaceAll(':', '').trim())) {
    return true;
  }
  final words = t.split(RegExp(r'\s+'));
  if (words.length > 10) return false;
  if (RegExp(r'[.,;!?…"”’]$').hasMatch(t)) return false;
  if (RegExp(r'\d+:\d+').hasMatch(t)) return false;
  if (!RegExp(r'^[A-Z“"‘]').hasMatch(t)) return false;
  const minor = {
    'a', 'an', 'the', 'and', 'or', 'but', 'of', 'in', 'on', 'to', 'for',
    'at', 'by', 'from', 'with', 'as', 'is', 'into', 'nor', 'so', 'yet', 'be',
  };
  final significant =
      words.where((w) => !minor.contains(w.toLowerCase())).toList();
  if (significant.isEmpty) return false;
  final capitalized = significant
      .where((w) => RegExp(r'^[“"‘(]?[A-Z0-9]').hasMatch(w))
      .length;
  return capitalized / significant.length >= 0.75;
}

/// "Romans 8:1; Ephesians 2:4–10; Colossians 3:9–10"
bool _isReferenceList(String s) {
  final parts = s.split(RegExp(r'\s*;\s*')).where((p) => p.isNotEmpty);
  return parts.isNotEmpty &&
      s.length < 200 &&
      parts.every((p) => BibleReference.parse(p) != null &&
          RegExp(r'^[1-3]?\s*[A-Za-z ]+\s+\d+(:\d+)?([\-–—,]\s*\d+)*(:\d+)?$')
              .hasMatch(p.trim()));
}

/// A quotation that ends with its reference: “...” (John 3:16) or “...” —
/// John 3:16.
bool _looksLikeQuotedScripture(String s) {
  final t = s.trim();
  if (!RegExp(r'^[“"]').hasMatch(t) || t.length > 700) return false;
  final m = RegExp(r'(?:\(|[—–-]\s*)([1-3]?\s*[A-Za-z ]+\s+\d+:\d+[\d\-–,: ]*)\)?\.?$')
      .firstMatch(t);
  return m != null && BibleReference.parse(m.group(1)!) != null;
}

/// Renders a lesson's teaching text as a devotional: section headings,
/// paragraphs, lists and Scripture cards, with even spacing.
class LessonBody extends StatelessWidget {
  const LessonBody({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final body = GoogleFonts.lora(
      fontSize: 17.0,
      height: 1.65,
      color: theme.primaryText,
    );
    final blocks = parseLessonText(text);
    final children = <Widget>[];
    for (var i = 0; i < blocks.length; i++) {
      final b = blocks[i];
      final spaceBefore = i == 0
          ? 0.0
          : b.kind == LessonBlockKind.heading
              ? 28.0
              : blocks[i - 1].kind == LessonBlockKind.heading
                  ? 10.0
                  : 16.0;
      if (spaceBefore > 0) children.add(SizedBox(height: spaceBefore));
      children.add(_block(context, b, body));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _block(BuildContext context, LessonBlock b, TextStyle body) {
    final theme = FlutterFlowTheme.of(context);
    switch (b.kind) {
      case LessonBlockKind.heading:
        return Semantics(
          header: true,
          child: Text(
            b.lines.first,
            style: GoogleFonts.lora(
              fontSize: 21.0,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: theme.primary,
            ),
          ),
        );
      case LessonBlockKind.paragraph:
        return Text(b.lines.first, style: body);
      case LessonBlockKind.bullets:
      case LessonBlockKind.numbered:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < b.lines.length; i++)
              Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 28.0,
                      child: Text(
                        b.kind == LessonBlockKind.numbered ? '${i + 1}.' : '•',
                        style: body.copyWith(
                            color: theme.secondary,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(child: Text(b.lines[i], style: body)),
                  ],
                ),
              ),
          ],
        );
      case LessonBlockKind.scripture:
        return ScriptureCard(text: b.lines.first);
      case LessonBlockKind.references:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3.0, right: 8.0),
              child: Icon(Icons.menu_book_outlined,
                  size: 18.0, color: theme.secondary),
            ),
            Expanded(
              child: Text(
                b.lines.first,
                style: GoogleFonts.inter(
                  fontSize: 15.0,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: theme.secondaryText,
                ),
              ),
            ),
          ],
        );
    }
  }
}

/// Scripture set apart from the teaching: a soft gold card with a book icon,
/// the passage in serif type, and an optional reference and action.
class ScriptureCard extends StatelessWidget {
  const ScriptureCard({
    super.key,
    required this.text,
    this.reference = '',
    this.actionLabel,
    this.onAction,
  });

  final String text;
  final String reference;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EFDF),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFE6D7B3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_outlined,
                  size: 20.0, color: Color(0xFF8A6D2B)),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  reference.isEmpty ? 'SCRIPTURE' : reference.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8A6D2B),
                  ),
                ),
              ),
            ],
          ),
          if (text.trim().isNotEmpty) ...[
            const SizedBox(height: 10.0),
            Text(
              text.trim(),
              style: GoogleFonts.lora(
                fontSize: 17.0,
                height: 1.6,
                fontStyle: FontStyle.italic,
                color: theme.primaryText,
              ),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 6.0),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 44.0),
                  foregroundColor: const Color(0xFF8A6D2B),
                ),
                icon: const Icon(Icons.open_in_new, size: 18.0),
                label: Text(
                  actionLabel!,
                  style: GoogleFonts.inter(
                      fontSize: 14.0, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A labelled closing section (Reflection, Application, Prayer).
class LessonSection extends StatelessWidget {
  const LessonSection({
    super.key,
    required this.label,
    required this.icon,
    required this.text,
    this.prayer = false,
    this.child,
  });

  final String label;
  final IconData icon;
  final String text;
  final bool prayer;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: prayer ? const Color(0xFFEEF2EA) : theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
            color: prayer ? const Color(0xFFD7E0D2) : theme.alternate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 20.0,
                  color: prayer ? const Color(0xFF4F6E55) : theme.secondary),
              const SizedBox(width: 8.0),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    label,
                    style: GoogleFonts.lora(
                      fontSize: 19.0,
                      fontWeight: FontWeight.w700,
                      color: theme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (text.trim().isNotEmpty) ...[
            const SizedBox(height: 10.0),
            Text(
              text.trim(),
              style: GoogleFonts.lora(
                fontSize: 17.0,
                height: 1.6,
                fontStyle: prayer ? FontStyle.italic : FontStyle.normal,
                color: theme.primaryText,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 12.0),
            child!,
          ],
        ],
      ),
    );
  }
}
