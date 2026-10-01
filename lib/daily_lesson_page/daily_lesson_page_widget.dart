import 'dart:ui' as ui;

import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'daily_lesson_page_model.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
export 'daily_lesson_page_model.dart';

/// Renders a single lesson: Scripture, reflection prompt, capture, and
/// completion.
class DailyLessonPageWidget extends StatefulWidget {
  const DailyLessonPageWidget({
    super.key,
    this.pathwayId,
    this.lessonId,
  });

  final String? pathwayId;
  final String? lessonId;

  static String routeName = 'DailyLessonPage';
  static String routePath = '/pathway/lesson';

  @override
  State<DailyLessonPageWidget> createState() => _DailyLessonPageWidgetState();
}

class _DailyLessonPageWidgetState extends State<DailyLessonPageWidget> {
  late DailyLessonPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DailyLessonPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.langResult = await GetPathwayProgressCall.call(
        authToken: currentJwtToken,
        pathwayId: widget.pathwayId,
      );

      if ((_model.langResult?.succeeded ?? true)) {
        _model.memberLanguage = PathwayProgressResponseStruct.maybeFromMap(
                (_model.langResult?.jsonBody ?? ''))
            ?.preferredLanguage;
        // CMS-added languages: the device choice wins (backend reports English).
        _model.memberLanguage =
            LanguageRegistry.resolveMemberLanguage(_model.memberLanguage);
        safeSetState(() {});
        _model.loadedLessons = await queryLessonsRecordOnce(
          queryBuilder: (lessonsRecord) => lessonsRecord.where(
            'status',
            isEqualTo: 'published',
          ),
          // Lessons are filtered by pathway on the client, so load them all.
          limit: 1000,
        );
        _model.lessonsList =
            _model.loadedLessons!.toList().cast<LessonsRecord>();
        safeSetState(() {});
        _model.lessonConnectivityResult =
            await actions.refreshConnectivityAndSync(
          currentJwtToken,
        );
      } else {
        _model.lessonDeviceLanguage = await actions.deviceContentLanguage();
        _model.memberLanguage = _model.lessonDeviceLanguage;
        safeSetState(() {});
        _model.loadedLessonsOffline = await queryLessonsRecordOnce(
          queryBuilder: (lessonsRecord) => lessonsRecord.where(
            'status',
            isEqualTo: 'published',
          ),
          // Lessons are filtered by pathway on the client, so load them all.
          limit: 1000,
        );
        _model.lessonsList =
            _model.loadedLessonsOffline!.toList().cast<LessonsRecord>();
        safeSetState(() {});
      }
      final savedReflection = await actions.loadSavedReflection(
        currentUserUid,
        widget.lessonId,
      );
      if (savedReflection.isNotEmpty &&
          _model.reflectionFieldTextController!.text.isEmpty) {
        _model.reflectionFieldTextController!.text = savedReflection;
        _model.reflectionInput = savedReflection;
        safeSetState(() {});
      }
    });

    _model.reflectionFieldTextController ??= TextEditingController();
    _model.reflectionFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }


  /// Quizzes linked before quizzes carried a lessonId; kept as a fallback.
  static const _legacyQuizIds = {
    'LESSON-COME-007': 'come-and-see-quiz-1',
    'LESSON-COME-014': 'come-and-see-quiz-2',
    'LESSON-ROOTED-005': 'rooted-in-christ-quiz-1',
  };

  /// The published quiz that follows this lesson, if any. All quizzes are
  /// loaded and filtered here because a filtered collection-group query
  /// would need an extra Firestore index.
  Future<String?> _quizIdForLesson() async {
    try {
      final quizzes = await queryQuizzesRecordOnce();
      for (final quiz in quizzes) {
        if (quiz.lessonId == widget.lessonId && quiz.status == 'published') {
          return quiz.stableId.isNotEmpty ? quiz.stableId : quiz.reference.id;
        }
      }
    } catch (_) {}
    return _legacyQuizIds[widget.lessonId];
  }

  static const _sectionLabels = {
    'application': {
      'en': 'Application',
      'es': 'Aplicación',
      'ur': 'عملی اطلاق',
      'lg': 'Okukikozesa',
    },
    'prayer': {
      'en': 'Prayer',
      'es': 'Oración',
      'ur': 'دعا',
      'lg': 'Okusaba',
    },
    'fallback': {
      'en': '',
      'es':
          'Parte de esta lección se muestra en inglés porque la traducción aún no está disponible.',
      'ur': 'اس سبق کا کچھ حصہ انگریزی میں دکھایا گیا ہے کیونکہ ترجمہ ابھی دستیاب نہیں۔',
      'lg':
          'Ebimu ku ssomo lino biri mu Lungereza kubanga okuvvuunula tekunnaba kubaawo.',
    },
  };

  String _label(String key) {
    final labels = _sectionLabels[key]!;
    // CMS-added languages: reviewed/machine translation of the English.
    return labels[_model.memberLanguage] ??
        TranslationService.instance
            .translate(labels['en']!, _model.memberLanguage);
  }

  static const _fallbackEnglish =
      'Part of this lesson is shown in English because the translation is '
      'not yet available.';

  /// Kingdom Heirs-authored lesson text (machine translation allowed).
  List<LocaleTextStruct> _commentaryFields(LessonsRecord lesson) => [
        lesson.title,
        lesson.reflectionPrompt,
        lesson.application,
        lesson.prayer,
      ];

  /// True when some lesson text is unreviewed machine translation.
  bool _usesMachineTranslation(LessonsRecord lesson) => _commentaryFields(
          lesson)
      .any((t) => t.isMachineTranslated(_model.memberLanguage));

  /// True when the member reads a non-English language and at least one
  /// lesson field has no translation, so English is shown in its place.
  bool _usesEnglishFallback(LessonsRecord lesson) {
    final lang = _model.memberLanguage;
    if (lang == null || lang == 'en') {
      return false;
    }
    // Scripture is never machine-translated, so it is English whenever no
    // stored translation exists.
    if (lesson.scriptureText.en.isNotEmpty &&
        lesson.scriptureText.storedText(lang).isEmpty) {
      return true;
    }
    return _commentaryFields(lesson).any((t) => t.isEnglishFallback(lang));
  }

  Widget _buildFallbackNotice() {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.alternate,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.translate, size: 18.0, color: theme.secondaryText),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _label('fallback').isNotEmpty
                  ? _label('fallback')
                  : TranslationService.instance
                      .translate(_fallbackEnglish, _model.memberLanguage),
              style: theme.labelMedium.override(
                font: GoogleFonts.inter(),
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Application and prayer sections, shown only when the lesson has them.
  List<Widget> _buildApplicationAndPrayer(LessonsRecord lesson) {
    final theme = FlutterFlowTheme.of(context);
    Widget section(String labelKey, LocaleTextStruct text) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _label(labelKey),
              style: theme.titleMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                letterSpacing: 0.0,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              text.forLanguage(_model.memberLanguage),
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
          ],
        );
    return [
      if (lesson.application.en.isNotEmpty)
        section('application', lesson.application),
      if (lesson.prayer.en.isNotEmpty) section('prayer', lesson.prayer),
    ];
  }

  /// Full Scripture passage, kept visually apart from lesson commentary and
  /// labelled with its translation and copyright as API.Bible requires.
  Future<void> _showPassageDialog(actions.BiblePassage passage) {
    final theme = FlutterFlowTheme.of(context);
    // The English Bible (no approved Bible for the language) reads LTR.
    final rtl = !passage.englishFallback &&
        LanguageRegistry.instance.isRtl(_model.memberLanguage);
    return showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: rtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: AlertDialog(
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
                if (passage.englishFallback) ...[
                  const SizedBox(height: 12.0),
                  custom_widgets.MachineTranslationNotice(
                    language: _model.memberLanguage,
                    message: kEnglishBibleNotice,
                    icon: Icons.menu_book_outlined,
                    compact: true,
                  ),
                ],
                if (passage.fromCache) ...[
                  const SizedBox(height: 12.0),
                  Text(
                    'Offline: showing the copy saved on this device.',
                    style: theme.labelSmall.override(
                      font: GoogleFonts.inter(),
                      color: theme.secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                ],
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
              '08fffnlc' /* Today's Lesson */,
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
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/kingdom-heirs-discipleshipapp.firebasestorage.app/o/branding%2Fphoto_02.jpg?alt=media',
                      width: double.infinity,
                      height: 180.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final lessonsListItem = _model.lessonsList.toList();

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: lessonsListItem.length,
                        separatorBuilder: (_, __) => SizedBox(height: 20.0),
                        itemBuilder: (context, lessonsListItemIndex) {
                          final lessonsListItemItem =
                              lessonsListItem[lessonsListItemIndex];
                          return Visibility(
                            visible:
                                lessonsListItemItem.stableId == widget.lessonId,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (_usesMachineTranslation(
                                    lessonsListItemItem))
                                  custom_widgets.MachineTranslationNotice(
                                    language: _model.memberLanguage,
                                  ),
                                if (_usesEnglishFallback(lessonsListItemItem))
                                  _buildFallbackNotice(),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!['es', 'ur']
                                        .contains(_model.memberLanguage))
                                      Text(
                                        lessonsListItemItem.title
                                            .forLanguage(_model.memberLanguage),
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    if (_model.memberLanguage == 'es')
                                      Text(
                                        lessonsListItemItem.title
                                            .forLanguage('es'),
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    if (_model.memberLanguage == 'ur')
                                      Text(
                                        lessonsListItemItem.title
                                            .forLanguage('ur'),
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .headlineSmall
                                                      .fontStyle,
                                            ),
                                      ),
                                  ],
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    final passage =
                                        await actions.fetchBiblePassage(
                                      lessonsListItemItem.scriptureRef,
                                      _model.memberLanguage,
                                    );
                                    if (passage != null) {
                                      await _showPassageDialog(passage);
                                      return;
                                    }
                                    _model.bibleOpenResult = await actions
                                        .openScriptureReferenceSafe(
                                      lessonsListItemItem.scriptureRef,
                                      _model.memberLanguage ?? 'en',
                                    );
                                    if (_model.bibleOpenResult == 'opened') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Opened Scripture passage.',
                                            style: TextStyle(),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                        ),
                                      );
                                      await actions.cacheLessonForOffline(
                                        lessonsListItemItem.stableId,
                                        lessonsListItemItem.title
                                            .forLanguage(_model.memberLanguage),
                                        lessonsListItemItem.scriptureRef,
                                        lessonsListItemItem.scriptureText
                                            .scriptureForLanguage(_model.memberLanguage),
                                        lessonsListItemItem.reflectionPrompt
                                            .forLanguage(_model.memberLanguage),
                                      );
                                    } else if (_model.bibleOpenResult ==
                                        'fallback') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Bible link unavailable. Read the Scripture text in this lesson.',
                                            style: TextStyle(),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                        ),
                                      );
                                      await actions.cacheLessonForOffline(
                                        lessonsListItemItem.stableId,
                                        lessonsListItemItem.title
                                            .forLanguage(_model.memberLanguage),
                                        lessonsListItemItem.scriptureRef,
                                        lessonsListItemItem.scriptureText
                                            .scriptureForLanguage(_model.memberLanguage),
                                        lessonsListItemItem.reflectionPrompt
                                            .forLanguage(_model.memberLanguage),
                                      );
                                    } else if (_model.bibleOpenResult ==
                                        'empty') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'No Scripture reference set.',
                                            style: TextStyle(),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                        ),
                                      );
                                      await actions.cacheLessonForOffline(
                                        lessonsListItemItem.stableId,
                                        lessonsListItemItem.title
                                            .forLanguage(_model.memberLanguage),
                                        lessonsListItemItem.scriptureRef,
                                        lessonsListItemItem.scriptureText
                                            .scriptureForLanguage(_model.memberLanguage),
                                        lessonsListItemItem.reflectionPrompt
                                            .forLanguage(_model.memberLanguage),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Bible link unavailable. Read the Scripture text in this lesson.',
                                            style: TextStyle(),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                        ),
                                      );
                                      await actions.cacheLessonForOffline(
                                        lessonsListItemItem.stableId,
                                        lessonsListItemItem.title
                                            .forLanguage(_model.memberLanguage),
                                        lessonsListItemItem.scriptureRef,
                                        lessonsListItemItem.scriptureText
                                            .scriptureForLanguage(_model.memberLanguage),
                                        lessonsListItemItem.reflectionPrompt
                                            .forLanguage(_model.memberLanguage),
                                      );
                                    }

                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(18.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            lessonsListItemItem.scriptureRef,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Text(
                                            FFLocalizations.of(context).getText(
                                              'ulfcisps' /* Tap to open full passage */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .labelSmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelSmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelSmall
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelSmall
                                                          .fontStyle,
                                                ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (![
                                                'es',
                                                'ur'
                                              ].contains(_model.memberLanguage))
                                                Text(
                                                  lessonsListItemItem
                                                      .scriptureText
                                                      .scriptureForLanguage(_model
                                                          .memberLanguage),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        font: GoogleFonts.lora(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              if (_model.memberLanguage == 'es')
                                                Text(
                                                  lessonsListItemItem
                                                      .scriptureText
                                                      .scriptureForLanguage('es'),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        font: GoogleFonts.lora(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                              if (_model.memberLanguage == 'ur')
                                                Text(
                                                  lessonsListItemItem
                                                      .scriptureText
                                                      .scriptureForLanguage('ur'),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        font: GoogleFonts.lora(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                ),
                                            ],
                                          ),
                                        ].divide(SizedBox(height: 6.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'a9sggm4d' /* Reflection */,
                                  ),
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
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!['es', 'ur']
                                        .contains(_model.memberLanguage))
                                      Text(
                                        lessonsListItemItem.reflectionPrompt
                                            .forLanguage(_model.memberLanguage),
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
                                        lessonsListItemItem.reflectionPrompt
                                            .forLanguage('es'),
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
                                        lessonsListItemItem.reflectionPrompt
                                            .forLanguage('ur'),
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
                                ..._buildApplicationAndPrayer(
                                    lessonsListItemItem),
                              ].divide(SizedBox(height: 20.0)),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  if (FFAppState().offlineLessonId == widget.lessonId)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'mxafye6w' /* Offline copy */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                            Text(
                              FFAppState().offlineLessonTitle,
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                            ),
                            Text(
                              FFAppState().offlineLessonScriptureRef,
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                            ),
                            Text(
                              FFAppState().offlineLessonScriptureText,
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.lora(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
                                  ),
                            ),
                            Text(
                              FFLocalizations.of(context).getText(
                                'iqt2xhma' /* Reflection */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                            ),
                            Text(
                              FFAppState().offlineLessonReflection,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
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
                          ].divide(SizedBox(height: 10.0)),
                        ),
                      ),
                    ),
                  TextFormField(
                    controller: _model.reflectionFieldTextController,
                    focusNode: _model.reflectionFieldFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.reflectionFieldTextController',
                      Duration(milliseconds: 2000),
                      () async {
                        _model.reflectionInput =
                            _model.reflectionFieldTextController!.text;
                        safeSetState(() {});
                      },
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: FFLocalizations.of(context).getText(
                        'tcuq774j' /* Write your reflection */,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      filled: true,
                    ),
                    style: TextStyle(),
                    maxLines: null,
                    validator: _model.reflectionFieldTextControllerValidator
                        .asValidator(context),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      // Don't lose text typed within the 2s debounce window.
                      _model.reflectionInput =
                          _model.reflectionFieldTextController!.text;
                      _model.saveSmartResult =
                          await actions.saveLessonProgressSmart(
                        currentJwtToken,
                        widget.pathwayId,
                        widget.lessonId,
                        '0',
                        _model.reflectionInput,
                      );
                      if (_model.saveSmartResult == 'queued') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Saved offline. Progress will sync when you reconnect.',
                              style: TextStyle(),
                            ),
                            duration: Duration(milliseconds: 4000),
                          ),
                        );

                        context.pushNamed(
                          PathwayOverviewPageWidget.routeName,
                          queryParameters: {
                            'pathwayId': serializeParam(
                              widget.pathwayId,
                              ParamType.String,
                            ),
                          }.withoutNulls,
                        );
                      } else if (_model.saveSmartResult == 'saved') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Lesson marked complete!',
                              style: TextStyle(),
                            ),
                            duration: Duration(milliseconds: 4000),
                          ),
                        );
                        final quizId = await _quizIdForLesson();
                        if (quizId != null) {
                          context.pushNamed(
                            QuizPageWidget.routeName,
                            queryParameters: {
                              'pathwayId': serializeParam(
                                widget.pathwayId,
                                ParamType.String,
                              ),
                              'quizId': serializeParam(
                                quizId,
                                ParamType.String,
                              ),
                            }.withoutNulls,
                          );
                        } else {
                          context.pushNamed(
                            PathwayOverviewPageWidget.routeName,
                            queryParameters: {
                              'pathwayId': serializeParam(
                                widget.pathwayId,
                                ParamType.String,
                              ),
                            }.withoutNulls,
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Could not save progress. Please try again.',
                              style: TextStyle(),
                            ),
                            duration: Duration(milliseconds: 4000),
                          ),
                        );
                      }

                      safeSetState(() {});
                    },
                    text: FFLocalizations.of(context).getText(
                      'uf1bp2bt' /* Mark Complete */,
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
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ].divide(SizedBox(height: 20.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
