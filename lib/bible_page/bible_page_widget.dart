import '/custom_code/actions/index.dart' as actions;
import 'bible_book_names.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A book of the Bible: English name (as understood by BibleReference and
/// API.Bible lookups) and its number of chapters.
class _Book {
  const _Book(this.name, this.chapters);
  final String name;
  final int chapters;
}

const _oldTestament = [
  _Book('Genesis', 50),
  _Book('Exodus', 40),
  _Book('Leviticus', 27),
  _Book('Numbers', 36),
  _Book('Deuteronomy', 34),
  _Book('Joshua', 24),
  _Book('Judges', 21),
  _Book('Ruth', 4),
  _Book('1 Samuel', 31),
  _Book('2 Samuel', 24),
  _Book('1 Kings', 22),
  _Book('2 Kings', 25),
  _Book('1 Chronicles', 29),
  _Book('2 Chronicles', 36),
  _Book('Ezra', 10),
  _Book('Nehemiah', 13),
  _Book('Esther', 10),
  _Book('Job', 42),
  _Book('Psalms', 150),
  _Book('Proverbs', 31),
  _Book('Ecclesiastes', 12),
  _Book('Song of Songs', 8),
  _Book('Isaiah', 66),
  _Book('Jeremiah', 52),
  _Book('Lamentations', 5),
  _Book('Ezekiel', 48),
  _Book('Daniel', 12),
  _Book('Hosea', 14),
  _Book('Joel', 3),
  _Book('Amos', 9),
  _Book('Obadiah', 1),
  _Book('Jonah', 4),
  _Book('Micah', 7),
  _Book('Nahum', 3),
  _Book('Habakkuk', 3),
  _Book('Zephaniah', 3),
  _Book('Haggai', 2),
  _Book('Zechariah', 14),
  _Book('Malachi', 4),
];

const _newTestament = [
  _Book('Matthew', 28),
  _Book('Mark', 16),
  _Book('Luke', 24),
  _Book('John', 21),
  _Book('Acts', 28),
  _Book('Romans', 16),
  _Book('1 Corinthians', 16),
  _Book('2 Corinthians', 13),
  _Book('Galatians', 6),
  _Book('Ephesians', 6),
  _Book('Philippians', 4),
  _Book('Colossians', 4),
  _Book('1 Thessalonians', 5),
  _Book('2 Thessalonians', 3),
  _Book('1 Timothy', 6),
  _Book('2 Timothy', 4),
  _Book('Titus', 3),
  _Book('Philemon', 1),
  _Book('Hebrews', 13),
  _Book('James', 5),
  _Book('1 Peter', 5),
  _Book('2 Peter', 3),
  _Book('1 John', 5),
  _Book('2 John', 1),
  _Book('3 John', 1),
  _Book('Jude', 1),
  _Book('Revelation', 22),
];

const _kLastReadKey = 'bible_last_read';

/// Labels for the compiled languages; other languages use the CMS
/// translation service (English source). Bible text itself always comes
/// from API.Bible and is never machine-translated.
const _labels = {
  'Bible': {'es': 'Biblia', 'ur': 'بائبل', 'lg': 'Baibuli'},
  'Old Testament': {
    'es': 'Antiguo Testamento',
    'ur': 'پرانا عہد نامہ',
    'lg': 'Endagaano Enkadde',
  },
  'New Testament': {
    'es': 'Nuevo Testamento',
    'ur': 'نیا عہد نامہ',
    'lg': 'Endagaano Empya',
  },
  'Chapter': {'es': 'Capítulo', 'ur': 'باب', 'lg': 'Essuula'},
  'Choose a chapter': {
    'es': 'Elige un capítulo',
    'ur': 'باب منتخب کریں',
    'lg': 'Londa essuula',
  },
  'Previous': {'es': 'Anterior', 'ur': 'پچھلا', 'lg': 'Emabega'},
  'Next': {'es': 'Siguiente', 'ur': 'اگلا', 'lg': 'Ekiddako'},
  'Books': {'es': 'Libros', 'ur': 'کتابیں', 'lg': 'Ebitabo'},
  'Offline: showing the copy saved on this device.': {
    'es': 'Sin conexión: se muestra la copia guardada en este dispositivo.',
    'ur': 'آف لائن: اس ڈیوائس پر محفوظ نقل دکھائی جا رہی ہے۔',
    'lg': 'Tolina yintaneeti: kiraga kopi eterekeddwa ku ssimu eno.',
  },
  'This chapter could not be loaded. Connect to the internet and try again.': {
    'es':
        'No se pudo cargar este capítulo. Conéctate a internet e inténtalo de nuevo.',
    'ur': 'یہ باب لوڈ نہیں ہو سکا۔ انٹرنیٹ سے جڑیں اور دوبارہ کوشش کریں۔',
    'lg':
        'Essuula eno tesobodde kujja. Yungibwa ku yintaneeti oddemu ogezeeko.',
  },
  'Try again': {
    'es': 'Intentar de nuevo',
    'ur': 'دوبارہ کوشش کریں',
    'lg': 'Ddamu ogezeeko',
  },
};

/// The Bible tab: read any book and chapter in the member's language,
/// from the approved API.Bible translation for that language, with its
/// translation name and copyright. Chapters already opened stay readable
/// offline.
class BiblePageWidget extends StatefulWidget {
  const BiblePageWidget({super.key});

  static String routeName = 'BiblePage';
  static String routePath = '/bible';

  @override
  State<BiblePageWidget> createState() => _BiblePageWidgetState();
}

class _BiblePageWidgetState extends State<BiblePageWidget> {
  _Book? _book;
  int _chapter = 1;
  bool _loading = false;
  actions.BiblePassage? _passage;
  bool _failed = false;

  String get _lang => LanguageRegistry.contentLanguage;

  /// The book's name in the member's Bible translation, else English.
  String _bookName(_Book book) {
    final names = kBibleBookNames[_lang];
    final index = [..._oldTestament, ..._newTestament].indexOf(book);
    return names != null && index >= 0 && index < names.length
        ? names[index]
        : book.name;
  }

  String _t(String english) {
    final compiled = _labels[english]?[_lang];
    if (compiled != null) {
      return compiled;
    }
    return _lang == 'en'
        ? english
        : TranslationService.instance.translate(english, _lang);
  }

  @override
  void initState() {
    super.initState();
    _restoreLastRead();
  }

  Future<void> _restoreLastRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_kLastReadKey);
      if (saved == null) {
        return;
      }
      final i = saved.lastIndexOf(' ');
      final name = saved.substring(0, i);
      final chapter = int.tryParse(saved.substring(i + 1)) ?? 1;
      final book = [..._oldTestament, ..._newTestament]
          .where((b) => b.name == name)
          .firstOrNull;
      if (book != null) {
        _open(book, chapter);
      }
    } catch (_) {}
  }

  Future<void> _open(_Book book, int chapter) async {
    setState(() {
      _book = book;
      _chapter = chapter.clamp(1, book.chapters);
      _loading = true;
      _failed = false;
      _passage = null;
    });
    final passage = await actions.fetchBiblePassage(
      '${book.name} $_chapter',
      _lang,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
      _passage = passage;
      _failed = passage == null || passage.text.isEmpty;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLastReadKey, '${book.name} $_chapter');
    } catch (_) {}
  }

  void _step(int delta) {
    final book = _book;
    if (book == null) {
      return;
    }
    final books = [..._oldTestament, ..._newTestament];
    var index = books.indexOf(book);
    var chapter = _chapter + delta;
    if (chapter < 1 && index > 0) {
      index--;
      chapter = books[index].chapters;
    } else if (chapter > book.chapters && index < books.length - 1) {
      index++;
      chapter = 1;
    }
    _open(books[index], chapter);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return ListenableBuilder(
      listenable: TranslationService.instance,
      builder: (context, _) => Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.primaryBackground,
          automaticallyImplyLeading: false,
          leading: _book == null
              ? null
              : IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.primaryText),
                  tooltip: _t('Books'),
                  onPressed: () => setState(() {
                    _book = null;
                    _passage = null;
                  }),
                ),
          title: Text(
            _book == null
                ? _t('Bible')
                : (_passage?.reference ?? '${_bookName(_book!)} $_chapter'),
            style: theme.titleLarge.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              letterSpacing: 0.0,
            ),
          ),
          actions: [
            if (_book != null)
              IconButton(
                icon:
                    Icon(Icons.format_list_numbered, color: theme.primaryText),
                tooltip: _t('Choose a chapter'),
                onPressed: () => _pickChapter(_book!),
              ),
          ],
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: _book == null ? _buildBookList(theme) : _buildChapter(theme),
        ),
      ),
    );
  }

  Widget _buildBookList(FlutterFlowTheme theme) {
    Widget section(String title, List<_Book> books) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                _t(title),
                style: theme.titleMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            for (final book in books)
              ListTile(
                title: Text(_bookName(book),
                    style: theme.bodyLarge.override(
                      font: GoogleFonts.inter(),
                      letterSpacing: 0.0,
                    )),
                trailing: Text('${book.chapters}',
                    style: theme.labelMedium.override(
                      font: GoogleFonts.inter(),
                      color: theme.secondaryText,
                      letterSpacing: 0.0,
                    )),
                onTap: () =>
                    book.chapters == 1 ? _open(book, 1) : _pickChapter(book),
              ),
          ],
        );
    return ListView(
      children: [
        section('Old Testament', _oldTestament),
        section('New Testament', _newTestament),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _pickChapter(_Book book) async {
    final theme = FlutterFlowTheme.of(context);
    final chapter = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: theme.secondaryBackground,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${_bookName(book)} · ${_t('Choose a chapter')}',
                style: theme.titleMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  letterSpacing: 0.0,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: GridView.count(
                  crossAxisCount: 6,
                  shrinkWrap: true,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    for (var c = 1; c <= book.chapters; c++)
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.pop(sheetContext, c),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: theme.alternate,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('$c',
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(),
                                letterSpacing: 0.0,
                              )),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (chapter != null) {
      _open(book, chapter);
    }
  }

  Widget _buildChapter(FlutterFlowTheme theme) {
    final passage = _passage;
    final note = TextStyle(
      fontFamily: GoogleFonts.inter().fontFamily,
      fontSize: 12,
      color: theme.secondaryText,
    );
    return Column(
      children: [
        Expanded(
          child: _loading
              ? Center(child: CircularProgressIndicator(color: theme.primary))
              : _failed
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cloud_off,
                                color: theme.secondaryText, size: 36),
                            const SizedBox(height: 12),
                            Text(
                              _t('This chapter could not be loaded. Connect to the internet and try again.'),
                              textAlign: TextAlign.center,
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(),
                                letterSpacing: 0.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => _open(_book!, _chapter),
                              child: Text(_t('Try again')),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      children: [
                        if (passage!.englishFallback)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              TranslationService.instance
                                  .translate(kEnglishBibleNotice, _lang),
                              style: note,
                            ),
                          ),
                        Text(
                          passage.text,
                          style: theme.bodyLarge.override(
                            font: GoogleFonts.lora(),
                            letterSpacing: 0.0,
                            lineHeight: 1.7,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (passage.fromCache)
                          Text(
                            _t('Offline: showing the copy saved on this device.'),
                            style: note,
                          ),
                        const Divider(height: 24),
                        Text(
                          [
                            passage.version,
                            if (passage.copyright.isNotEmpty) passage.copyright,
                          ].join(' · '),
                          style: note,
                        ),
                      ],
                    ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: _loading ? null : () => _step(-1),
                icon: const Icon(Icons.chevron_left),
                label: Text(_t('Previous')),
              ),
              const Spacer(),
              Text('${_t('Chapter')} $_chapter / ${_book!.chapters}',
                  style: note),
              const Spacer(),
              TextButton.icon(
                onPressed: _loading ? null : () => _step(1),
                icon: const Icon(Icons.chevron_right),
                label: Text(_t('Next')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
