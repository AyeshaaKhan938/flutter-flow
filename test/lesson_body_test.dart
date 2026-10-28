import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_heirs_discipleship_app/custom_code/widgets/lesson_body.dart';

List<String> _words(String s) => s
    .replaceAll(RegExp(r'^\s*#{1,3}\s+', multiLine: true), '')
    .replaceAll(RegExp(r'^\s*[-•]\s+', multiLine: true), '')
    .split(RegExp(r'\s+'))
    .where((w) => w.isNotEmpty)
    .toList();

List<String> _blockWords(List<LessonBlock> blocks) =>
    blocks.expand((b) => b.lines).expand((l) => _words(l)).toList();

void main() {
  test('PDF line breaks are joined and page numbers left out', () {
    const text = 'Faith is one of the most important foundations of the\n'
        'Christian life. Without faith, it is impossible to please\n'
        'God.\n\n'
        'Faith does not depend upon feelings, opinions, or\n'
        'visible evidence.\n'
        '                            30\n\n'
        'Every believer will face situations.';
    final blocks = parseLessonText(text);
    expect(blocks.map((b) => b.kind), everyElement(LessonBlockKind.paragraph));
    expect(blocks.length, 3);
    expect(blocks.first.lines.first,
        startsWith('Faith is one of the most important foundations of the Christian life.'));
    expect(_blockWords(blocks).contains('30'), isFalse);
  });

  test('stand-alone title lines become headings', () {
    final blocks = parseLessonText('The Invitation Has Reached You\n\n'
        'Every human soul is searching. It does not matter where you were born.\n\n'
        '## You Were Created for More\n\n'
        'You are not an accident.');
    expect(blocks.map((b) => b.kind).toList(), [
      LessonBlockKind.heading,
      LessonBlockKind.paragraph,
      LessonBlockKind.heading,
      LessonBlockKind.paragraph,
    ]);
    expect(blocks[2].lines.first, 'You Were Created for More');
  });

  test('ordinary short sentences stay paragraphs', () {
    for (final s in [
      'Faith becomes a choice.',
      'But Nazareth?',
      'So Nathanael came.',
      'He answered them with love and patience',
    ]) {
      expect(parseLessonText(s).single.kind, LessonBlockKind.paragraph,
          reason: s);
    }
  });

  test('Scripture, reference lists, labels and lists', () {
    final blocks = parseLessonText('Scripture\n\n'
        'Therefore, if anyone is in Christ, the new creation has come.\n\n'
        'Additional Scriptures\n\n'
        'Romans 8:1; Ephesians 2:4–10; Galatians 2:20\n\n'
        'Reflection\n\n'
        '- Where do you need His grace?\n'
        '- Who can you encourage today?\n\n'
        '1. Pray.\n2. Read John 1.\n\n'
        '“For God so loved the world that He gave His one and only Son.” (John 3:16)');
    expect(blocks.map((b) => b.kind).toList(), [
      LessonBlockKind.heading,
      LessonBlockKind.scripture,
      LessonBlockKind.heading,
      LessonBlockKind.references,
      LessonBlockKind.heading,
      LessonBlockKind.bullets,
      LessonBlockKind.numbered,
      LessonBlockKind.scripture,
    ]);
    expect(blocks[5].lines, ['Where do you need His grace?', 'Who can you encourage today?']);
  });

  test('no words are added or lost', () {
    const text = 'The Invitation Has Reached You\n\n'
        'Every human soul is searching. Who am I? Why am I here?\n\n'
        '- One item\n- Two items';
    expect(_blockWords(parseLessonText(text)), _words(text));
  });
}
