/// Parses English Scripture references such as "John 3:16-17", "Psalm 23"
/// or "1 John 1:9" into USFM book codes, the format both API.Bible and
/// bible.com use.
class BibleReference {
  const BibleReference(this.book, this.chapter, [this.verse, this.endVerse]);

  final String book;
  final int chapter;
  final int? verse;
  final int? endVerse;

  static BibleReference? parse(String ref) {
    final match =
        RegExp(r'^([1-3]?\s*[A-Za-z ]+?)\s+(\d+)(?::(\d+))?(?:\s*-\s*(\d+))?')
            // Accept en/em dashes ("Matthew 4:12–17") as range separators.
            .firstMatch(ref.trim().replaceAll(RegExp('[–—]'), '-'));
    if (match == null) {
      return null;
    }
    final bookName =
        match.group(1)!.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
    final book = _usfmBooks[bookName];
    if (book == null) {
      return null;
    }
    final first = int.parse(match.group(2)!);
    final verse = match.group(3) == null ? null : int.parse(match.group(3)!);
    final end = match.group(4) == null ? null : int.parse(match.group(4)!);
    // One-chapter books are cited by verse alone: "Jude 20–21" is Jude 1:20-21.
    if (verse == null && _singleChapterBooks.contains(book)) {
      return BibleReference(book, 1, first, end);
    }
    // A chapter range without verses ("Psalm 23-24") opens the first chapter.
    return BibleReference(book, first, verse, verse == null ? null : end);
  }

  /// Splits a list of references into single passages:
  /// "John 1:1, 14" → ["John 1:1", "John 1:14"];
  /// "Revelation 19:11,16" → ["Revelation 19:11", "Revelation 19:16"];
  /// "Romans 8:1; Ephesians 2:4–10" → ["Romans 8:1", "Ephesians 2:4–10"].
  /// A single reference is returned as it is.
  static List<String> splitList(String ref) {
    final parts = ref
        .split(RegExp(r'\s*[;,]\s*'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.length < 2) {
      return [ref.trim()];
    }
    final out = <String>[];
    String? book;
    String? chapter;
    for (final p in parts) {
      final full = RegExp(r'^([1-3]?\s*[A-Za-z][A-Za-z ]*?)\s+\d').firstMatch(p);
      final name = full?.group(1)!.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
      if (name != null && _usfmBooks.containsKey(name.trim())) {
        book = full!.group(1)!.trim();
        chapter = RegExp(r'\s(\d+):').firstMatch(p)?.group(1);
        out.add(p);
      } else if (book != null && RegExp(r'^\d+:\d+').hasMatch(p)) {
        chapter = p.split(':').first;
        out.add('$book $p');
      } else if (book != null &&
          RegExp('^\\d+([-–—]\\d+)?\$').hasMatch(p)) {
        out.add(chapter == null ? '$book $p' : '$book $chapter:$p');
      } else {
        return [ref.trim()];
      }
    }
    return out;
  }

  /// API.Bible passage id, e.g. "JHN.3.16-JHN.3.17" or "PSA.23".
  String get apiBiblePassageId {
    if (verse == null) {
      return '$book.$chapter';
    }
    final start = '$book.$chapter.$verse';
    return endVerse == null ? start : '$start-$book.$chapter.$endVerse';
  }

  /// bible.com path segment, e.g. "JHN.3.16-17".
  String get bibleComPassage {
    if (verse == null) {
      return '$book.$chapter';
    }
    final start = '$book.$chapter.$verse';
    return endVerse == null ? start : '$start-$endVerse';
  }
}

const _singleChapterBooks = {'OBA', 'PHM', '2JN', '3JN', 'JUD'};

const _usfmBooks = {
  'genesis': 'GEN',
  'exodus': 'EXO',
  'leviticus': 'LEV',
  'numbers': 'NUM',
  'deuteronomy': 'DEU',
  'joshua': 'JOS',
  'judges': 'JDG',
  'ruth': 'RUT',
  '1 samuel': '1SA',
  '2 samuel': '2SA',
  '1 kings': '1KI',
  '2 kings': '2KI',
  '1 chronicles': '1CH',
  '2 chronicles': '2CH',
  'ezra': 'EZR',
  'nehemiah': 'NEH',
  'esther': 'EST',
  'job': 'JOB',
  'psalm': 'PSA',
  'psalms': 'PSA',
  'proverbs': 'PRO',
  'ecclesiastes': 'ECC',
  'song of solomon': 'SNG',
  'song of songs': 'SNG',
  'isaiah': 'ISA',
  'jeremiah': 'JER',
  'lamentations': 'LAM',
  'ezekiel': 'EZK',
  'daniel': 'DAN',
  'hosea': 'HOS',
  'joel': 'JOL',
  'amos': 'AMO',
  'obadiah': 'OBA',
  'jonah': 'JON',
  'micah': 'MIC',
  'nahum': 'NAM',
  'habakkuk': 'HAB',
  'zephaniah': 'ZEP',
  'haggai': 'HAG',
  'zechariah': 'ZEC',
  'malachi': 'MAL',
  'matthew': 'MAT',
  'mark': 'MRK',
  'luke': 'LUK',
  'john': 'JHN',
  'acts': 'ACT',
  'romans': 'ROM',
  '1 corinthians': '1CO',
  '2 corinthians': '2CO',
  'galatians': 'GAL',
  'ephesians': 'EPH',
  'philippians': 'PHP',
  'colossians': 'COL',
  '1 thessalonians': '1TH',
  '2 thessalonians': '2TH',
  '1 timothy': '1TI',
  '2 timothy': '2TI',
  'titus': 'TIT',
  'philemon': 'PHM',
  'hebrews': 'HEB',
  'james': 'JAS',
  '1 peter': '1PE',
  '2 peter': '2PE',
  '1 john': '1JN',
  '2 john': '2JN',
  '3 john': '3JN',
  'jude': 'JUD',
  'revelation': 'REV',
};
