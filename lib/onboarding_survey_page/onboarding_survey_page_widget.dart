import '/auth/firebase_auth/auth_util.dart';
import '/custom_code/onboarding_flow.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_survey_page_model.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
export 'onboarding_survey_page_model.dart';

/// After sign-up: the member chooses a language (the phone's language is
/// pre-selected) and goes straight to Home. The phone's time zone is saved
/// automatically. The survey questions are asked with the assessment.
class OnboardingSurveyPageWidget extends StatefulWidget {
  const OnboardingSurveyPageWidget({super.key});

  static String routeName = 'OnboardingSurveyPage';
  static String routePath = '/onboarding';

  @override
  State<OnboardingSurveyPageWidget> createState() =>
      _OnboardingSurveyPageWidgetState();
}

class _OnboardingSurveyPageWidgetState
    extends State<OnboardingSurveyPageWidget> {
  late OnboardingSurveyPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingSurveyPageModel());

    _model.preferredLanguage = initialLanguage(
      stored: FFLocalizations.getStoredLocale()?.languageCode,
      device: WidgetsBinding.instance.platformDispatcher.locale.languageCode,
    );
  }

  bool _continuing = false;

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
              '7yk94zey' /* Welcome */,
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
                  Text(
                    FFLocalizations.of(context).getText(
                      't2tw8glq' /* Choose your language */,
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
                      'xh51k31m' /* English, Spanish, Urdu (RTL), ... */,
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
                  // Languages come from the CMS (`languages`), so new ones
                  // need no app update.
                  custom_widgets.LanguageSelector(
                    selected: _model.preferredLanguage,
                    onSelected: (code) async {
                      _model.preferredLanguage = code;
                      safeSetState(() {});
                      await actions.setPreferredLanguage(
                        context,
                        currentJwtToken,
                        code,
                      );
                      safeSetState(() {});
                    },
                  ),
                  FFButtonWidget(
                    key: const ValueKey('onboardingContinue'),
                    onPressed: _continuing
                        ? null
                        : () async {
                            safeSetState(() => _continuing = true);
                            final code = _model.preferredLanguage ?? 'en';
                            // Saves the language even if the pre-selected
                            // one was kept, and the phone's time zone.
                            await Future.wait([
                              actions.setPreferredLanguage(
                                context,
                                currentJwtToken,
                                code,
                              ),
                              saveDeviceTimezone(),
                            ]);
                            if (!context.mounted) return;
                            context.goNamed(HomePageWidget.routeName);
                          },
                    text: FFLocalizations.of(context).getText(
                      'h4l5v7tc' /* Continue */,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 48.0,
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
                ].divide(SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
