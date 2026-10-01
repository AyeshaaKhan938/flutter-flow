import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/encouragement_rotation.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'today_page_model.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
export 'today_page_model.dart';

/// Member home: daily scripture, daily encouragement, announcements, and
/// pathway entry point.
class TodayPageWidget extends StatefulWidget {
  const TodayPageWidget({super.key});

  static String routeName = 'TodayPage';
  static String routePath = '/today';

  @override
  State<TodayPageWidget> createState() => _TodayPageWidgetState();
}

class _TodayPageWidgetState extends State<TodayPageWidget> {
  late TodayPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TodayPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.todayContentResult = await GetTodayContentCall.call(
        authToken: currentJwtToken,
      );

      if ((_model.todayContentResult?.succeeded ?? true)) {
        _model.todayScriptureRef = TodayContentResponseStruct.maybeFromMap(
                (_model.todayContentResult?.jsonBody ?? ''))
            ?.scriptureRef;
        safeSetState(() {});
        _model.todayScriptureText = TodayContentResponseStruct.maybeFromMap(
                (_model.todayContentResult?.jsonBody ?? ''))
            ?.scriptureText;
        safeSetState(() {});
        _model.todayEncouragementText = TodayContentResponseStruct.maybeFromMap(
                (_model.todayContentResult?.jsonBody ?? ''))
            ?.encouragementText;
        safeSetState(() {});
        _model.todayEncouragementRef = TodayContentResponseStruct.maybeFromMap(
                (_model.todayContentResult?.jsonBody ?? ''))
            ?.encouragementRef;
        safeSetState(() {});
        _model.memberLanguage = TodayContentResponseStruct.maybeFromMap(
                (_model.todayContentResult?.jsonBody ?? ''))
            ?.language;
        // CMS-added languages: the device choice wins (backend reports English).
        _model.memberLanguage =
            LanguageRegistry.resolveMemberLanguage(_model.memberLanguage);
        safeSetState(() {});
        // The verse itself comes from API.Bible; the CMS text for the day is
        // Kingdom Heirs commentary and is shown separately as Daily Truth.
        if ((_model.todayScriptureRef ?? '').isNotEmpty) {
          _todayPassage = await actions.fetchBiblePassage(
            _model.todayScriptureRef!,
            _model.memberLanguage,
          );
          _todayPassageLoaded = true;
          safeSetState(() {});
        }
        _model.loadedAnnouncements = await queryAnnouncementsRecordOnce(
          limit: 20,
        );
        _model.announcementList =
            _model.loadedAnnouncements!.toList().cast<AnnouncementsRecord>();
        safeSetState(() {});
      }
      await _loadDailyExperience();
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  static const _englishFallbackNote = {
    'es': '(Se muestra en inglés: la traducción aún no está disponible.)',
    'ur': '(انگریزی میں دکھایا گیا ہے: ترجمہ ابھی دستیاب نہیں۔)',
    'lg': '(Kiragiddwa mu Lungereza: okuvvuunula tekunnabaawo.)',
  };

  /// Announcement body in the member's language. When the translation is
  /// missing, the English text is shown with a note saying so, so English
  /// is never presented under a translated screen without being identified.
  String _announcementBody(LocaleTextStruct body) {
    final lang = _model.memberLanguage;
    final text = body.forLanguage(lang);
    final note = _englishFallbackNote[lang];
    final isFallback = note != null && body.en.isNotEmpty && text == body.en;
    return isFallback ? '$text\n$note' : text;
  }

  /// Backend text for today (Daily Truth commentary, encouragement). The
  /// backend answers CMS-added languages in English, so those are
  /// translated on the device (never the Bible passage).
  String _backendText(String? text) {
    final value = text ?? '';
    return LanguageRegistry.needsClientTranslation(_model.memberLanguage)
        ? TranslationService.instance.translate(value, _model.memberLanguage)
        : value;
  }

  bool _backendTextIsMachine(String? text) =>
      LanguageRegistry.needsClientTranslation(_model.memberLanguage) &&
      TranslationService.instance.isMachine(text ?? '', _model.memberLanguage);

  actions.BiblePassage? _todayPassage;
  bool _todayPassageLoaded = false;

  /// Today's Scripture Encounter (title, verse preview, Read in Context,
  /// Bible Gateway link) from the CMS record for this day of the year, and
  /// today's encouragement from the random rotation. Read from Firestore
  /// (cached), so this also works offline. Only published records show.
  DailyScriptureRecord? _encounter;

  Future<void> _loadDailyExperience() async {
    _model.memberLanguage =
        LanguageRegistry.resolveMemberLanguage(_model.memberLanguage);
    final lang = _model.memberLanguage;
    // Backend text for CMS-added languages is translated on display, so it
    // is stored in English here; compiled languages use stored text.
    String pick(LocaleTextStruct t) =>
        LanguageRegistry.needsClientTranslation(lang)
            ? t.en
            : t.forLanguage(lang);
    try {
      final now = DateTime.now();
      // The library has 365 days; 29 February shows 28 February.
      final day = now.month == 2 && now.day == 29 ? 28 : now.day;
      final date = '${now.month.toString().padLeft(2, '0')}-'
          '${day.toString().padLeft(2, '0')}';
      final records = await queryDailyScriptureRecordOnce(
        queryBuilder: (q) => q.where('date', isEqualTo: date),
      );
      _encounter = records.where((r) => r.status == 'published').firstOrNull;
      final encounter = _encounter;
      if (encounter != null) {
        if ((_model.todayScriptureRef ?? '').isEmpty) {
          _model.todayScriptureRef = encounter.verseRef;
        }
        if ((_model.todayScriptureText ?? '').isEmpty) {
          _model.todayScriptureText = pick(encounter.text);
        }
        if (_todayPassage == null && encounter.verseRef.isNotEmpty) {
          _todayPassage = await actions.fetchBiblePassage(
            encounter.verseRef,
            lang,
          );
        }
      }
      _todayPassageLoaded = true;
      safeSetState(() {});
    } catch (_) {}
    try {
      final encouragement = await EncouragementRotation.today();
      if (encouragement != null) {
        _model.todayEncouragementText = pick(encouragement.quote);
        _model.todayEncouragementRef = [
          pick(LocaleTextStruct.maybeFromMap(
                  encouragement.snapshotData['title']) ??
              LocaleTextStruct()),
          if (encouragement.snapshotData['scriptureRef'] is String)
            encouragement.snapshotData['scriptureRef'] as String,
        ].where((s) => s.trim().isNotEmpty).join(' · ');
        safeSetState(() {});
      }
    } catch (_) {}
  }

  String _localizedField(String field) {
    final raw = _encounter?.snapshotData[field];
    final t = LocaleTextStruct.maybeFromMap(raw);
    if (t == null) {
      return '';
    }
    return LanguageRegistry.needsClientTranslation(_model.memberLanguage)
        ? TranslationService.instance.translate(t.en, _model.memberLanguage)
        : t.forLanguage(_model.memberLanguage);
  }

  static const _dailyLabels = {
    'Read in context': {
      'es': 'Leer en contexto',
      'ur': 'سیاق و سباق میں پڑھیں',
      'lg': 'Soma mu mbeera yaakyo',
    },
    'Open in Bible Gateway': {
      'es': 'Abrir en Bible Gateway',
      'ur': 'Bible Gateway میں کھولیں',
      'lg': 'Ggulawo mu Bible Gateway',
    },
  };

  String _dailyLabel(String english) =>
      _dailyLabels[english]?[_model.memberLanguage] ??
      (_model.memberLanguage == 'en'
          ? english
          : TranslationService.instance
              .translate(english, _model.memberLanguage));

  Future<void> _openReadInContext(String ref) async {
    final passage = await actions.fetchBiblePassage(ref, _model.memberLanguage);
    if (!mounted) {
      return;
    }
    if (passage == null) {
      final url = _encounter?.snapshotData['bibleGatewayUrl'] as String?;
      if (url != null && url.isNotEmpty) {
        await launchURL(url);
      }
      return;
    }
    final theme = FlutterFlowTheme.of(context);
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${passage.reference} (${passage.version})'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                passage.text,
                style: theme.bodyLarge.override(
                  font: GoogleFonts.lora(),
                  letterSpacing: 0.0,
                  lineHeight: 1.5,
                ),
              ),
              if (passage.copyright.isNotEmpty) ...[
                const Divider(height: 24.0),
                Text(
                  passage.copyright,
                  style: theme.labelSmall.override(
                    font: GoogleFonts.inter(),
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              MaterialLocalizations.of(dialogContext).closeButtonLabel,
            ),
          ),
        ],
      ),
    );
  }

  static const _dailyTruthLabel = {
    'en': 'Today’s Truth',
    'es': 'La verdad de hoy',
    'ur': 'آج کی سچائی',
    'lg': 'Amazima ga Leero',
  };

  /// Today's verse (from API.Bible, with its translation and copyright),
  /// then the Kingdom Heirs commentary under its own Daily Truth heading,
  /// so commentary is never presented as Scripture.
  List<Widget> _buildScriptureAndDailyTruth(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final passage = _todayPassage;
    final commentary = _backendText(_model.todayScriptureText);
    final title = _localizedField('theme');
    final preview = _localizedField('versePreview');
    final readInContext =
        (_encounter?.snapshotData['readInContext'] as String?) ?? '';
    final gatewayUrl =
        (_encounter?.snapshotData['bibleGatewayUrl'] as String?) ?? '';
    return [
      if (title.isNotEmpty)
        Text(
          title,
          style: theme.titleMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w700),
            letterSpacing: 0.0,
          ),
        ),
      // Licensed NIV preview from the CMS, shown only if the full passage
      // could not be loaded (e.g. offline before it was ever opened).
      if (passage == null && _todayPassageLoaded && preview.isNotEmpty) ...[
        Text(
          preview,
          style: theme.bodyLarge.override(
            font: GoogleFonts.lora(),
            letterSpacing: 0.0,
            lineHeight: 1.5,
          ),
        ),
        Text(
          (_encounter?.snapshotData['translation'] as String?) ?? 'NIV',
          style: theme.labelSmall.override(
            font: GoogleFonts.inter(),
            color: theme.secondaryText,
            letterSpacing: 0.0,
          ),
        ),
      ],
      if (passage != null) ...[
        Text(
          passage.text,
          style: theme.bodyLarge.override(
            font: GoogleFonts.lora(),
            letterSpacing: 0.0,
            lineHeight: 1.5,
          ),
        ),
        Text(
          [
            passage.version,
            if (passage.copyright.isNotEmpty) passage.copyright,
          ].join(' · '),
          style: theme.labelSmall.override(
            font: GoogleFonts.inter(),
            color: theme.secondaryText,
            letterSpacing: 0.0,
          ),
        ),
        if (passage.englishFallback)
          custom_widgets.MachineTranslationNotice(
            language: _model.memberLanguage,
            message: kEnglishBibleNotice,
            icon: Icons.menu_book_outlined,
            compact: true,
          ),
      ] else if (!_todayPassageLoaded)
        LinearProgressIndicator(color: theme.primary, minHeight: 2.0),
      if (commentary.isNotEmpty) ...[
        const SizedBox(height: 8.0),
        Text(
          _dailyTruthLabel[_model.memberLanguage] ??
              TranslationService.instance
                  .translate(_dailyTruthLabel['en']!, _model.memberLanguage),
          style: theme.titleSmall.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            letterSpacing: 0.0,
          ),
        ),
        Text(
          commentary,
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            letterSpacing: 0.0,
          ),
        ),
        if (_backendTextIsMachine(_model.todayScriptureText))
          custom_widgets.MachineTranslationNotice(
            language: _model.memberLanguage,
            compact: true,
          ),
      ],
      if (readInContext.isNotEmpty || gatewayUrl.isNotEmpty)
        Wrap(
          spacing: 8.0,
          children: [
            if (readInContext.isNotEmpty)
              TextButton.icon(
                onPressed: () => _openReadInContext(readInContext),
                icon: const Icon(Icons.menu_book_outlined, size: 18.0),
                label:
                    Text('${_dailyLabel('Read in context')}: $readInContext'),
              ),
            if (gatewayUrl.isNotEmpty)
              TextButton.icon(
                onPressed: () => launchURL(gatewayUrl),
                icon: const Icon(Icons.open_in_new, size: 18.0),
                label: Text(_dailyLabel('Open in Bible Gateway')),
              ),
          ],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: true,
          title: Text(
            FFLocalizations.of(context).getText(
              '3vonyhg4' /* Today */,
            ),
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(22.0, 12.0, 22.0, 40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(RagSearchPageWidget.routeName);
                    },
                    text: FFLocalizations.of(context).getText(
                      'pymmndk7' /* Ask Kingdom Heirs */,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).secondary,
                      textStyle: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32.0),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      imageUrl:
                          'https://storage.googleapis.com/kingdom-heirs-discipleshipapp.firebasestorage.app/branding/kingdom_heirs_crown_logo.png',
                      width: 64.0,
                      height: 64.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      'yhb29ikd' /* Kingdom Heirs */,
                    ),
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      '6yw0o7zm' /* Growing together. Living the m... */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/kingdom-heirs-discipleshipapp.firebasestorage.app/o/branding%2Fphoto_02.jpg?alt=media',
                      width: double.infinity,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      '9k0upj1o' /* Today's Scripture */,
                    ),
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleLarge
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_model.todayScriptureText == '')
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularPercentIndicator(
                                  percent: 0.0,
                                  radius: 11.0,
                                  lineWidth: 3.0,
                                  animation: false,
                                  animateFromLastPercent: true,
                                ),
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'uxvknhqk' /* Loading… */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 10.0)),
                            ),
                          if (!(_model.todayScriptureText == ''))
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _model.todayScriptureRef!,
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                                ..._buildScriptureAndDailyTruth(context),
                              ].divide(SizedBox(height: 6.0)),
                            ),
                        ].divide(SizedBox(height: 6.0)),
                      ),
                    ),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      'zxk458lu' /* Encouragement */,
                    ),
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleLarge
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_model.todayEncouragementText == '')
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularPercentIndicator(
                                  percent: 0.0,
                                  radius: 11.0,
                                  lineWidth: 3.0,
                                  animation: false,
                                  animateFromLastPercent: true,
                                ),
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'btry4vm7' /* Loading… */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(width: 10.0)),
                            ),
                          if (!(_model.todayEncouragementText == ''))
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _model.todayEncouragementRef!,
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                ),
                                if (_backendTextIsMachine(
                                    _model.todayEncouragementText))
                                  custom_widgets.MachineTranslationNotice(
                                    language: _model.memberLanguage,
                                    compact: true,
                                  ),
                                Text(
                                  _backendText(_model.todayEncouragementText),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 6.0)),
                            ),
                        ].divide(SizedBox(height: 6.0)),
                      ),
                    ),
                  ),
                  if (_model.announcementList.any((a) =>
                      a.title.isMachineTranslated(_model.memberLanguage) ||
                      a.body.isMachineTranslated(_model.memberLanguage)))
                    custom_widgets.MachineTranslationNotice(
                      language: _model.memberLanguage,
                    ),
                  Text(
                    FFLocalizations.of(context).getText(
                      'c3m7uoy7' /* Announcements */,
                    ),
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleLarge
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Builder(
                      builder: (context) {
                        final announcementListItem =
                            _model.announcementList.toList();

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: announcementListItem.length,
                          separatorBuilder: (_, __) => SizedBox(height: 8.0),
                          itemBuilder: (context, announcementListItemIndex) {
                            final announcementListItemItem =
                                announcementListItem[announcementListItemIndex];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!['es', 'ur']
                                        .contains(_model.memberLanguage))
                                      Text(
                                        announcementListItemItem.title
                                            .forLanguage(_model.memberLanguage),
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    if (_model.memberLanguage == 'es')
                                      Text(
                                        announcementListItemItem.title
                                            .forLanguage('es'),
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    if (_model.memberLanguage == 'ur')
                                      Text(
                                        announcementListItemItem.title
                                            .forLanguage('ur'),
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!['es', 'ur']
                                        .contains(_model.memberLanguage))
                                      Text(
                                        _announcementBody(
                                            announcementListItemItem.body),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    if (_model.memberLanguage == 'es')
                                      Text(
                                        _announcementBody(
                                            announcementListItemItem.body),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    if (_model.memberLanguage == 'ur')
                                      Text(
                                        _announcementBody(
                                            announcementListItemItem.body),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                  ],
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ].divide(SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
