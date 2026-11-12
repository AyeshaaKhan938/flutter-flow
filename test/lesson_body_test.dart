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

  test('section text joins PDF line breaks and keeps paragraphs', () {
    const prayer = 'Father, reveal Yourself through Your Son. Guard\n'
        'my heart from deception, pride, and self-\n'
        'reliance.\n\n'
        'In Jesus\' name, Amen.';
    expect(reflowLessonText(prayer),
        'Father, reveal Yourself through Your Son. Guard my heart from '
        'deception, pride, and self-reliance.\n\nIn Jesus\' name, Amen.');
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

  group('Application and action steps', () {
    test('numbered steps in a section become a list', () {
      const raw = '1. Listen for His Voice. The world is full of noise but the\n'
          'Shepherd’s voice cuts through it all.\n'
          '2. Stay Close to His Presence.\n'
          'Walk beside Him.\n'
          '3. Rest in His Care.';
      final blocks = parseSectionText(raw);
      expect(blocks.length, 1);
      expect(blocks.first.kind, LessonBlockKind.numbered);
      expect(blocks.first.lines, [
        'Listen for His Voice. The world is full of noise but the '
            'Shepherd’s voice cuts through it all.',
        'Stay Close to His Presence. Walk beside Him.',
        'Rest in His Care.',
      ]);
    });

    test('a paragraph before the steps stays a paragraph', () {
      final blocks =
          parseSectionText('This week, practise these:\n- Pray daily\n- Serve');
      expect(blocks.map((b) => b.kind),
          [LessonBlockKind.paragraph, LessonBlockKind.bullets]);
      expect(blocks.last.lines, ['Pray daily', 'Serve']);
    });

    test('plain application text is one paragraph, words unchanged', () {
      const raw = 'Read the Scripture reference in your own Bible. Write one\n'
          'honest question.';
      final blocks = parseSectionText(raw);
      expect(blocks.single.kind, LessonBlockKind.paragraph);
      expect(blocks.single.lines.single,
          'Read the Scripture reference in your own Bible. Write one honest question.');
    });

    test('a book name with a number is not a list item', () {
      final blocks = parseSectionText('Read\n1 Corinthians 13 tonight.');
      expect(blocks.single.kind, LessonBlockKind.paragraph);
    });

    test('action headings used in the lessons are recognised', () {
      for (final h in [
        'Application for Today',
        'Personal Response',
        'This Week’s Practice',
        'The Disciple’s Response',
        'Truth Stick Challenge',
        'Application:',
      ]) {
        expect(isActionHeading(h), isTrue, reason: h);
      }
      expect(isActionHeading('The Ache Beneath the Practice'), isFalse);
      expect(isActionHeading('Reflection'), isFalse);
    });
  });
}

