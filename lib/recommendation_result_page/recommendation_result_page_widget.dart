import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/schema/structs/index.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recommendation_result_page_model.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/pathway_progression.dart';
export 'recommendation_result_page_model.dart';

/// Spec M11: show recommended starting pathway + allow browse/retake.
class RecommendationResultPageWidget extends StatefulWidget {
  const RecommendationResultPageWidget({super.key});

  static String routeName = 'RecommendationResultPage';
  static String routePath = '/assessment/recommendation';

  @override
  State<RecommendationResultPageWidget> createState() =>
      _RecommendationResultPageWidgetState();
}

class _RecommendationResultPageWidgetState
    extends State<RecommendationResultPageWidget> {
  late RecommendationResultPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Published pathways by stableId, so recommendations show the CMS name.
  Map<String, PathwaysRecord> _pathwaysById = {};

  Future<void> _loadPathwayNames() async {
    try {
      final pathways = await queryPathwaysRecordOnce(limit: 100);
      _pathwaysById = {for (final p in pathways) p.stableId: p};
      safeSetState(() {});
    } catch (_) {}
  }

  /// The pathway's CMS title in the app language, or its id if unknown.
  String _pathwayName(String? id) {
    final pathway = _pathwaysById[id ?? ''];
    if (pathway == null) {
      return id ?? '';
    }
    // Content language (may be a CMS-added language).
    return pathway.title.forLanguage(LanguageRegistry.contentLanguage);
  }

  /// Kingdom Heirs: every new member begins the core journey with Come & See,
  /// whatever the assessment recommends.
  static const _kStartingPathwayId = 'come-and-see';

  String _startingReason() => progressionText(
        'Every member begins the Kingdom Heirs core journey with {title}.',
        LanguageRegistry.contentLanguage,
        {
          'title': _pathwaysById.containsKey(_kStartingPathwayId)
              ? _pathwayName(_kStartingPathwayId)
              : 'Come & See',
        },
      );

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecommendationResultPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadPathwayNames();
      _model.recommendationProfile = await GetUserProfileV4Call.call(
        authToken: currentJwtToken,
      );

      if ((_model.recommendationProfile?.succeeded ?? true)) {
        _model.recommendedPathwayId =
            UserProfileFullResponseStruct.maybeFromMap(
                    (_model.recommendationProfile?.jsonBody ?? ''))
                ?.recommendedPathwayId;
        safeSetState(() {});
        _model.recommendationReason =
            UserProfileFullResponseStruct.maybeFromMap(
                    (_model.recommendationProfile?.jsonBody ?? ''))
                ?.recommendationReason;
        safeSetState(() {});
        _model.companionPathwayId = UserProfileFullResponseStruct.maybeFromMap(
                (_model.recommendationProfile?.jsonBody ?? ''))
            ?.companionPathwayId;
        safeSetState(() {});
        _model.totalScore = UserProfileFullResponseStruct.maybeFromMap(
                (_model.recommendationProfile?.jsonBody ?? ''))
            ?.latestAssessmentScore;
        safeSetState(() {});
      } else {
        _model.recommendedPathwayId = 'come-and-see';
        safeSetState(() {});
        _model.recommendationReason =
            'Come & See is a trusted starting pathway.';
        safeSetState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
              'h20hmmdb' /* Recommendation */,
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
            padding: EdgeInsets.all(24.0),
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
                          'https://firebasestorage.googleapis.com/v0/b/kingdom-heirs-discipleshipapp.firebasestorage.app/o/branding%2Fphoto_04.jpg?alt=media',
                      width: double.infinity,
                      height: 190.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      'wjzhtvic' /* Your recommended starting path... */,
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
                    _pathwayName(_kStartingPathwayId),
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).titleLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                  ),
                  Text(
                    _startingReason(),
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
                  // Every member starts the core journey with Come & See,
                  // so no companion pathway is suggested here.
                  FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(
                        PathwayOverviewPageWidget.routeName,
                        queryParameters: {
                          'pathwayId': serializeParam(
                            _kStartingPathwayId,
                            ParamType.String,
                          ),
                        }.withoutNulls,
                      );
                    },
                    text: FFLocalizations.of(context).getText(
                      'vihsxgf9' /* Start Recommended Pathway */,
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
                  FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(PathwayListPageWidget.routeName);
                    },
                    text: FFLocalizations.of(context).getText(
                      '8qk80eyh' /* Browse All Pathways */,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Colors.transparent,
                      textStyle: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      context
                          .pushNamed(AssessmentQuestionsPageWidget.routeName);
                    },
                    text: FFLocalizations.of(context).getText(
                      'prbzjx78' /* Retake Assessment */,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Colors.transparent,
                      textStyle: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).tertiary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
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
