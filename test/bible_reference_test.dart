import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_heirs_discipleship_app/custom_code/bible_reference.dart';

void main() {
  test('one-chapter books are cited by verse', () {
    expect(BibleReference.parse('Jude 20–21')!.apiBiblePassageId,
        'JUD.1.20-JUD.1.21');
    expect(BibleReference.parse('Jude 17–25')!.apiBiblePassageId,
        'JUD.1.17-JUD.1.25');
    expect(BibleReference.parse('Philemon 6')!.apiBiblePassageId, 'PHM.1.6');
  });

  test('ordinary references are unchanged', () {
    expect(BibleReference.parse('John 3:16-17')!.apiBiblePassageId,
        'JHN.3.16-JHN.3.17');
    expect(BibleReference.parse('2 Corinthians 5:18–21')!.apiBiblePassageId,
        '2CO.5.18-2CO.5.21');
    expect(BibleReference.parse('Psalm 23')!.apiBiblePassageId, 'PSA.23');
    expect(BibleReference.parse('Galatians 5:16')!.apiBiblePassageId,
        'GAL.5.16');
  });

  test('verse lists are split', () {
    expect(BibleReference.splitList('John 1:1, 14'), ['John 1:1', 'John 1:14']);
    expect(BibleReference.splitList('Revelation 19:11,16'),
        ['Revelation 19:11', 'Revelation 19:16']);
    expect(BibleReference.splitList('Revelation 22:12, 20'),
        ['Revelation 22:12', 'Revelation 22:20']);
    expect(BibleReference.splitList('Romans 8:1; Ephesians 2:4–10'),
        ['Romans 8:1', 'Ephesians 2:4–10']);
    expect(BibleReference.splitList('Galatians 5:13–26'), ['Galatians 5:13–26']);
  });
}
