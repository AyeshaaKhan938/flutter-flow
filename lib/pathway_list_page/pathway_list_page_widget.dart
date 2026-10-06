import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/custom_code/actions/index.dart' as actions;
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'pathway_list_page_model.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/custom_code/pathway_progression.dart';
export 'pathway_list_page_model.dart';

/// Browse available discipleship pathways.
///
/// Full lesson-by-lesson drill-down ships in Phase 2 (KH-14/15).
class PathwayListPageWidget extends StatefulWidget {
  const PathwayListPageWidget({super.key});

  static String routeName = 'PathwayListPage';
  static String routePath = '/pathways';

  @override
  State<PathwayListPageWidget> createState() => _PathwayListPageWidgetState();
}

class _PathwayListPageWidgetState extends State<PathwayListPageWidget> {
  late PathwayListPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PathwayListPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isLoading = true;
      safeSetState(() {});
      _model.pathwayLangProfile = await GetUserProfileV4Call.call(
        authToken: currentJwtToken,
      );

      if ((_model.pathwayLangProfile?.succeeded ?? true)) {
        _model.memberLanguage = UserProfileFullResponseStruct.maybeFromMap(
                (_model.pathwayLangProfile?.jsonBody ?? ''))
            ?.preferredLanguage;
        // CMS-added languages: the device choice wins (backend reports English).
        _model.memberLanguage =
            LanguageRegistry.resolveMemberLanguage(_model.memberLanguage);
      } else {
        // Offline with no saved profile: don't leave the list loading forever.
        _model.memberLanguage = await actions.deviceContentLanguage();
      }
      safeSetState(() {});
      try {
        _model.loadedPathways = await queryPathwaysRecordOnce(
          queryBuilder: (pathwaysRecord) => pathwaysRecord.where(
            'status',
            isEqualTo: 'published',
          ),
          limit: 100,
        );
        _model.pathwaysList = await _pathwaysWithLessons(
            _model.loadedPathways!.toList().cast<PathwaysRecord>());
      } catch (_) {
        _model.pathwaysList = [];
      }
      // Draft pathways Kingdom Heirs approved for a preview card only.
      try {
        final visible = _model.pathwaysList.map((p) => p.stableId).toSet();
        _previews = (await queryPathwaysRecordOnce(
          queryBuilder: (q) => q.where('previewApproved', isEqualTo: true),
          limit: 100,
        ))
            .where((p) => !visible.contains(p.stableId))
            .toList();
      } catch (_) {
        _previews = [];
      }
      // Core journey locks / completion (lessons + quizzes at 80%+).
      _progression = await PathwayProgressionService.instance.refresh();
      PathwayProgressionService.instance
          .issueEarnedCertificates(_progression!);
      _model.isLoading = false;
      safeSetState(() {});
    });
  }

  /// Locks and completion for the core journey; null while loading.
  PathwayProgression? _progression;

  /// Unreleased pathways shown only as "Coming soon" preview cards.
  List<PathwaysRecord> _previews = [];

  String _t(String english, [Map<String, String> args = const {}]) =>
      progressionText(english, _model.memberLanguage, args);

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  /// Published pathways that have at least one published lesson, in their
  /// CMS `order`, so unfinished or empty pathways never appear to members.
  Future<List<PathwaysRecord>> _pathwaysWithLessons(
    List<PathwaysRecord> pathways,
  ) async {
    final lessons = await queryLessonsRecordOnce(
      queryBuilder: (lessonsRecord) => lessonsRecord.where(
        'status',
        isEqualTo: 'published',
      ),
      limit: 1000,
    );
    final withLessons = lessons.map((l) => l.pathwayId).toSet();
    return pathways.where((p) => withLessons.contains(p.stableId)).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// "Core Pathway" (locked in order) and "Additional Studies" sections.
  List<Widget> _buildSections() {
    final visibleIds = _model.pathwaysList.map((p) => p.stableId).toSet();
    final progression = _progression ?? PathwayProgression.empty;
    final core =
        progression.core.where((s) => visibleIds.contains(s.stableId)).toList();
    final additional = progression.additional
        .where((s) => visibleIds.contains(s.stableId))
        .toList();
    // Anything the service could not place still shows, unlocked.
    final placed = {...core, ...additional}.map((s) => s.stableId).toSet();
    for (final p in _model.pathwaysList) {
      if (!placed.contains(p.stableId) &&
          PathwayProgressionService.trackOf(p) != 'core') {
        additional.add(PathwayStatus(
          pathway: p,
          track: 'additional',
          step: 0,
          completed: false,
          unlocked: true,
        ));
      }
    }

    return [
      if (core.isNotEmpty) ...[
        _sectionHeader(
          _t('Core Pathway'),
          _t('Complete each pathway in order. The next one unlocks when you finish all its lessons and pass its quizzes with 80% or higher.'),
        ),
        if (progression.coreJourneyCompleted)
          OutlinedButton.icon(
            onPressed: () => _openCertificate(kCoreCertificateId),
            icon: Icon(Icons.workspace_premium,
                color: FlutterFlowTheme.of(context).secondary),
            label: Text(_t('View Core Discipleship Certificate')),
          ),
        ..._inOrder(
          [for (final s in core) (s.pathway.order, _pathwayCard(s))],
          PathwayProgressionService.trackOf,
          'core',
        ),
      ],
      if (additional.isNotEmpty) ...[
        _sectionHeader(
          _t('Additional Studies — Continue Growing'),
          _t('Grow deeper at your own pace. These studies are always open.'),
        ),
        ..._inOrder(
          [for (final s in additional) (s.pathway.order, _pathwayCard(s))],
          PathwayProgressionService.trackOf,
          'additional',
        ),
      ],
      // Additional previews when no additional pathway is released yet.
      if (additional.isEmpty &&
          _previews.any(
              (p) => PathwayProgressionService.trackOf(p) == 'additional')) ...[
        _sectionHeader(
          _t('Additional Studies — Continue Growing'),
          _t('Grow deeper at your own pace. These studies are always open.'),
        ),
        ..._inOrder(const [], PathwayProgressionService.trackOf, 'additional'),
      ],
    ];
  }

  /// Released cards plus this track's preview cards, in CMS order.
  List<Widget> _inOrder(
    List<(int, Widget)> released,
    String Function(PathwaysRecord) trackOf,
    String track,
  ) {
    final all = [
      ...released,
      for (final p in _previews)
        if (trackOf(p) == track) (p.order, _previewCard(p)),
    ]..sort((a, b) => a.$1.compareTo(b.$1));
    return [for (final e in all) e.$2];
  }

  /// Name, description and cover of a pathway that is not released yet.
  /// It cannot be opened.
  Widget _previewCard(PathwaysRecord p) {
    final theme = FlutterFlowTheme.of(context);
    final lang = _model.memberLanguage;
    final cover = (p.snapshotData['coverImageUrl'] as String?) ?? '';
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_t('This pathway is not available yet.'))),
      ),
      child: Opacity(
        opacity: 0.75,
        child: Container(
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(16.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (cover.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: cover,
                  height: 110.0,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock_clock_outlined,
                            size: 18.0, color: theme.secondaryText),
                        const SizedBox(width: 6.0),
                        Text(
                          _t('Coming soon'),
                          style: theme.labelMedium.override(
                            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                            color: theme.secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      p.title.forLanguage(lang),
                      style: theme.titleMedium.override(
                        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        letterSpacing: 0.0,
                      ),
                    ),
                    if (p.description.en.isNotEmpty) ...[
                      const SizedBox(height: 4.0),
                      Text(
                        p.description.forLanguage(lang),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodySmall.override(
                          font: GoogleFonts.inter(),
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.titleLarge.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w700),
              color: theme.primary,
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            subtitle,
            style: theme.labelMedium.override(
              font: GoogleFonts.inter(),
              color: theme.secondaryText,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }

  void _openCertificate(String pathwayId) {
    context.pushNamed(
      CertificatePageWidget.routeName,
      queryParameters: {
        'pathwayId': serializeParam(pathwayId, ParamType.String),
      }.withoutNulls,
    );
  }

  Widget _pathwayCard(PathwayStatus status) {
    final theme = FlutterFlowTheme.of(context);
    final p = status.pathway;
    final lang = _model.memberLanguage;
    final locked = status.isCore && !status.unlocked;
    final lockedByTitle = status.lockedBy?.title.forLanguage(lang) ?? '';
    final lockMessage = _t('Complete {title} to unlock', {
      'title': lockedByTitle,
    });

    Widget leading() {
      if (!status.isCore) {
        return Icon(Icons.auto_stories_outlined,
            color: theme.secondary, size: 28.0);
      }
      final Color bg = status.completed
          ? theme.success
          : (locked ? theme.alternate : theme.primary);
      return Container(
        width: 36.0,
        height: 36.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: status.completed
            ? const Icon(Icons.check, color: Colors.white, size: 20.0)
            : locked
                ? Icon(Icons.lock_outline,
                    color: theme.secondaryText, size: 18.0)
                : Text(
                    '${status.step}',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                    ),
                  ),
      );
    }

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (locked) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(lockMessage),
              duration: const Duration(milliseconds: 3500),
            ),
          );
          return;
        }
        await context.pushNamed(
          PathwayOverviewPageWidget.routeName,
          queryParameters: {
            'pathwayId': serializeParam(p.stableId, ParamType.String),
          }.withoutNulls,
        );
        // Progress may have changed while the pathway was open.
        final updated = await PathwayProgressionService.instance.refresh();
        if (mounted) {
          safeSetState(() => _progression = updated);
          PathwayProgressionService.instance.issueEarnedCertificates(updated);
        }
      },
      child: Opacity(
        opacity: locked ? 0.65 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            boxShadow: const [
              BoxShadow(
                blurRadius: 12.0,
                color: Color(0x141E2A5A),
                offset: Offset(0.0, 4.0),
                spreadRadius: -4.0,
              )
            ],
            borderRadius: BorderRadius.circular(16.0),
            border: status.completed
                ? Border.all(color: theme.success, width: 1.2)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leading(),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (status.isCore)
                        Text(
                          _t('Step {n}', {'n': '${status.step}'}),
                          style: theme.labelSmall.override(
                            font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600),
                            color: theme.secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                      Text(
                        p.title.forLanguage(lang),
                        style: theme.titleMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: theme.titleMedium.fontWeight,
                            fontStyle: theme.titleMedium.fontStyle,
                          ),
                          color: theme.primaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                      Text(
                        p.description.forLanguage(lang),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.inter(),
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                      if (locked)
                        Row(
                          children: [
                            Icon(Icons.lock_outline,
                                size: 16.0, color: theme.secondaryText),
                            const SizedBox(width: 6.0),
                            Expanded(
                              child: Text(
                                lockMessage,
                                style: theme.labelMedium.override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600),
                                  color: theme.secondaryText,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (status.completed)
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8.0,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle,
                                    size: 16.0, color: theme.success),
                                const SizedBox(width: 4.0),
                                Text(
                                  _t('Completed'),
                                  style: theme.labelMedium.override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                    color: theme.success,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () => _openCertificate(p.stableId),
                              icon: Icon(Icons.workspace_premium_outlined,
                                  size: 16.0, color: theme.primary),
                              label: Text(
                                _t('View certificate'),
                                style: theme.labelMedium.override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600),
                                  color: theme.primary,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ].divide(const SizedBox(height: 4.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
              '8zakpprc' /* Pathways */,
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
          actions: [
            IconButton(
              icon: Icon(
                Icons.workspace_premium_outlined,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
              tooltip: _t('My certificates'),
              onPressed: () =>
                  context.pushNamed(MyCertificatesPageWidget.routeName),
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(22.0, 16.0, 22.0, 40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    FFLocalizations.of(context).getText(
                      '5rmrdz56' /* Pathways */,
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
                      '184lycny' /* Discipleship journeys you can ... */,
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
                  if (_model.isLoading ?? true)
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
                            '0zu33ilr' /* Loading… */,
                          ),
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
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                  // Unreviewed machine translation must be identified.
                  if (_model.pathwaysList.any((p) =>
                      p.title.isMachineTranslated(_model.memberLanguage) ||
                      p.description.isMachineTranslated(_model.memberLanguage)))
                    custom_widgets.MachineTranslationNotice(
                      language: _model.memberLanguage,
                    ),
                  if (!(_model.isLoading ?? true)) ..._buildSections(),
                ].divide(SizedBox(height: 18.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
