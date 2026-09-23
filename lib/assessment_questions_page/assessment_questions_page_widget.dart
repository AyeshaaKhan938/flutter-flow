import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/schema/structs/index.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'assessment_questions_page_model.dart';
export 'assessment_questions_page_model.dart';

/// Spec M10 scaffold: capture bible confidence/needs/habits/goals.
class AssessmentQuestionsPageWidget extends StatefulWidget {
  const AssessmentQuestionsPageWidget({super.key});

  static String routeName = 'AssessmentQuestionsPage';
  static String routePath = '/assessment/questions';

  @override
  State<AssessmentQuestionsPageWidget> createState() =>
      _AssessmentQuestionsPageWidgetState();
}

class _AssessmentQuestionsPageWidgetState
    extends State<AssessmentQuestionsPageWidget> {
  late AssessmentQuestionsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AssessmentQuestionsPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.currentStep = 1;
      safeSetState(() {});
      _model.assessmentLangProfile = await GetUserProfileV5Call.call(
        authToken: currentJwtToken,
      );

      if ((_model.assessmentLangProfile?.succeeded ?? true)) {
        _model.memberLanguage = UserProfileFullResponseStruct.maybeFromMap(
                (_model.assessmentLangProfile?.jsonBody ?? ''))
            ?.preferredLanguage;
        safeSetState(() {});
        _model.loadedAssessmentCopy = await GetAssessmentQuestionsCall.call(
          authToken: currentJwtToken,
          locale: _model.memberLanguage,
        );

        if ((_model.loadedAssessmentCopy?.succeeded ?? true)) {
          _model.q1Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q1Label;
          safeSetState(() {});
          _model.q1A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q1A;
          safeSetState(() {});
          _model.q1B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q1B;
          safeSetState(() {});
          _model.q1C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q1C;
          safeSetState(() {});
          _model.q1D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q1D;
          safeSetState(() {});
          _model.q2Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q2Label;
          safeSetState(() {});
          _model.q2A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q2A;
          safeSetState(() {});
          _model.q2B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q2B;
          safeSetState(() {});
          _model.q2C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q2C;
          safeSetState(() {});
          _model.q2D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q2D;
          safeSetState(() {});
          _model.q3Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q3Label;
          safeSetState(() {});
          _model.q3A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q3A;
          safeSetState(() {});
          _model.q3B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q3B;
          safeSetState(() {});
          _model.q3C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q3C;
          safeSetState(() {});
          _model.q3D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q3D;
          safeSetState(() {});
          _model.q4Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q4Label;
          safeSetState(() {});
          _model.q4A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q4A;
          safeSetState(() {});
          _model.q4B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q4B;
          safeSetState(() {});
          _model.q4C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q4C;
          safeSetState(() {});
          _model.q4D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q4D;
          safeSetState(() {});
          _model.q5Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q5Label;
          safeSetState(() {});
          _model.q5A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q5A;
          safeSetState(() {});
          _model.q5B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q5B;
          safeSetState(() {});
          _model.q5C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q5C;
          safeSetState(() {});
          _model.q5D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q5D;
          safeSetState(() {});
          _model.q6Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q6Label;
          safeSetState(() {});
          _model.q6A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q6A;
          safeSetState(() {});
          _model.q6B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q6B;
          safeSetState(() {});
          _model.q6C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q6C;
          safeSetState(() {});
          _model.q6D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q6D;
          safeSetState(() {});
          _model.q7Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q7Label;
          safeSetState(() {});
          _model.q7A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q7A;
          safeSetState(() {});
          _model.q7B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q7B;
          safeSetState(() {});
          _model.q7C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q7C;
          safeSetState(() {});
          _model.q7D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q7D;
          safeSetState(() {});
          _model.q8Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q8Label;
          safeSetState(() {});
          _model.q8A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q8A;
          safeSetState(() {});
          _model.q8B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q8B;
          safeSetState(() {});
          _model.q8C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q8C;
          safeSetState(() {});
          _model.q8D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q8D;
          safeSetState(() {});
          _model.q9Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q9Label;
          safeSetState(() {});
          _model.q9A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q9A;
          safeSetState(() {});
          _model.q9B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q9B;
          safeSetState(() {});
          _model.q9C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q9C;
          safeSetState(() {});
          _model.q9D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q9D;
          safeSetState(() {});
          _model.q10Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q10Label;
          safeSetState(() {});
          _model.q10A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q10A;
          safeSetState(() {});
          _model.q10B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q10B;
          safeSetState(() {});
          _model.q10C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q10C;
          safeSetState(() {});
          _model.q10D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopy?.jsonBody ?? ''))
              ?.q10D;
          safeSetState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not load assessment questions. Using defaults.',
                style: TextStyle(),
              ),
              duration: Duration(milliseconds: 4000),
            ),
          );
        }
      } else {
        _model.loadedAssessmentCopyFallback =
            await GetAssessmentQuestionsCall.call(
          locale: 'en',
          authToken: currentJwtToken,
        );

        if ((_model.loadedAssessmentCopyFallback?.succeeded ?? true)) {
          _model.q1Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q1Label;
          safeSetState(() {});
          _model.q1A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q1A;
          safeSetState(() {});
          _model.q1B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q1B;
          safeSetState(() {});
          _model.q1C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q1C;
          safeSetState(() {});
          _model.q1D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q1D;
          safeSetState(() {});
          _model.q2Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q2Label;
          safeSetState(() {});
          _model.q2A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q2A;
          safeSetState(() {});
          _model.q2B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q2B;
          safeSetState(() {});
          _model.q2C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q2C;
          safeSetState(() {});
          _model.q2D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q2D;
          safeSetState(() {});
          _model.q3Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q3Label;
          safeSetState(() {});
          _model.q3A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q3A;
          safeSetState(() {});
          _model.q3B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q3B;
          safeSetState(() {});
          _model.q3C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q3C;
          safeSetState(() {});
          _model.q3D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q3D;
          safeSetState(() {});
          _model.q4Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q4Label;
          safeSetState(() {});
          _model.q4A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q4A;
          safeSetState(() {});
          _model.q4B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q4B;
          safeSetState(() {});
          _model.q4C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q4C;
          safeSetState(() {});
          _model.q4D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q4D;
          safeSetState(() {});
          _model.q5Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q5Label;
          safeSetState(() {});
          _model.q5A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q5A;
          safeSetState(() {});
          _model.q5B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q5B;
          safeSetState(() {});
          _model.q5C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q5C;
          safeSetState(() {});
          _model.q5D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q5D;
          safeSetState(() {});
          _model.q6Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q6Label;
          safeSetState(() {});
          _model.q6A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q6A;
          safeSetState(() {});
          _model.q6B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q6B;
          safeSetState(() {});
          _model.q6C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q6C;
          safeSetState(() {});
          _model.q6D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q6D;
          safeSetState(() {});
          _model.q7Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q7Label;
          safeSetState(() {});
          _model.q7A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q7A;
          safeSetState(() {});
          _model.q7B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q7B;
          safeSetState(() {});
          _model.q7C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q7C;
          safeSetState(() {});
          _model.q7D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q7D;
          safeSetState(() {});
          _model.q8Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q8Label;
          safeSetState(() {});
          _model.q8A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q8A;
          safeSetState(() {});
          _model.q8B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q8B;
          safeSetState(() {});
          _model.q8C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q8C;
          safeSetState(() {});
          _model.q8D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q8D;
          safeSetState(() {});
          _model.q9Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q9Label;
          safeSetState(() {});
          _model.q9A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q9A;
          safeSetState(() {});
          _model.q9B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q9B;
          safeSetState(() {});
          _model.q9C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q9C;
          safeSetState(() {});
          _model.q9D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q9D;
          safeSetState(() {});
          _model.q10Label = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q10Label;
          safeSetState(() {});
          _model.q10A = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q10A;
          safeSetState(() {});
          _model.q10B = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q10B;
          safeSetState(() {});
          _model.q10C = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q10C;
          safeSetState(() {});
          _model.q10D = AssessmentQuestionsFlatResponseStruct.maybeFromMap(
                  (_model.loadedAssessmentCopyFallback?.jsonBody ?? ''))
              ?.q10D;
          safeSetState(() {});
        }
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
              'fpbwh2bz' /* Assessment */,
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
                      '7vtg9s4j' /* Choose the answer that most ho... */,
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
                  Text(
                    _model.currentStep!.toString(),
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).tertiary,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                  ),
                  if (_model.currentStep == 1)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _model.q1Label!,
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
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans1 = 'A';
                                safeSetState(() {});
                              },
                              text: _model.q1A!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans1 = 'B';
                                safeSetState(() {});
                              },
                              text: _model.q1B!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans1 = 'C';
                                safeSetState(() {});
                              },
                              text: _model.q1C!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans1 = 'D';
                                safeSetState(() {});
                              },
                              text: _model.q1D!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  if (_model.currentStep == 2)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _model.q2Label!,
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
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans2 = 'A';
                                safeSetState(() {});
                              },
                              text: _model.q2A!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans2 = 'B';
                                safeSetState(() {});
                              },
                              text: _model.q2B!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans2 = 'C';
                                safeSetState(() {});
                              },
                              text: _model.q2C!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans2 = 'D';
                                safeSetState(() {});
                              },
                              text: _model.q2D!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  if (_model.currentStep == 3)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _model.q3Label!,
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
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans3 = 'A';
                                safeSetState(() {});
                              },
                              text: _model.q3A!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans3 = 'B';
                                safeSetState(() {});
                              },
                              text: _model.q3B!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans3 = 'C';
                                safeSetState(() {});
                              },
                              text: _model.q3C!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans3 = 'D';
                                safeSetState(() {});
                              },
                              text: _model.q3D!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  if (_model.currentStep == 4)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _model.q4Label!,
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
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans4 = 'A';
                                safeSetState(() {});
                              },
                              text: _model.q4A!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans4 = 'B';
                                safeSetState(() {});
                              },
                              text: _model.q4B!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans4 = 'C';
                                safeSetState(() {});
                              },
                              text: _model.q4C!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans4 = 'D';
                                safeSetState(() {});
                              },
                              text: _model.q4D!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  if (_model.currentStep == 5)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _model.q5Label!,
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
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans5 = 'A';
                                safeSetState(() {});
                              },
                              text: _model.q5A!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans5 = 'B';
                                safeSetState(() {});
                              },
                              text: _model.q5B!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans5 = 'C';
                                safeSetState(() {});
                              },
                              text: _model.q5C!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans5 = 'D';
                                safeSetState(() {});
                              },
                              text: _model.q5D!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  if (_model.currentStep == 6)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _model.q6Label!,
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
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans6 = 'A';
                                safeSetState(() {});
                              },
                              text: _model.q6A!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans6 = 'B';
                                safeSetState(() {});
                              },
                              text: _model.q6B!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans6 = 'C';
                                safeSetState(() {});
                              },
                              text: _model.q6C!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans6 = 'D';
                                safeSetState(() {});
                              },
                              text: _model.q6D!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  if (_model.currentStep == 7)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _model.q7Label!,
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
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans7 = 'A';
                                safeSetState(() {});
                              },
                              text: _model.q7A!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans7 = 'B';
                                safeSetState(() {});
                              },
                              text: _model.q7B!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans7 = 'C';
                                safeSetState(() {});
                              },
                              text: _model.q7C!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans7 = 'D';
                                safeSetState(() {});
                              },
                              text: _model.q7D!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  if (_model.currentStep == 8)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _model.q8Label!,
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
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans8 = 'A';
                                safeSetState(() {});
                              },
                              text: _model.q8A!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans8 = 'B';
                                safeSetState(() {});
                              },
                              text: _model.q8B!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans8 = 'C';
                                safeSetState(() {});
                              },
                              text: _model.q8C!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans8 = 'D';
                                safeSetState(() {});
                              },
                              text: _model.q8D!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  if (_model.currentStep == 9)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _model.q9Label!,
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
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans9 = 'A';
                                safeSetState(() {});
                              },
                              text: _model.q9A!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans9 = 'B';
                                safeSetState(() {});
                              },
                              text: _model.q9B!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans9 = 'C';
                                safeSetState(() {});
                              },
                              text: _model.q9C!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans9 = 'D';
                                safeSetState(() {});
                              },
                              text: _model.q9D!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  if (_model.currentStep == 10)
                    Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _model.q10Label!,
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
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans10 = 'A';
                                safeSetState(() {});
                              },
                              text: _model.q10A!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans10 = 'B';
                                safeSetState(() {});
                              },
                              text: _model.q10B!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans10 = 'C';
                                safeSetState(() {});
                              },
                              text: _model.q10C!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                _model.ans10 = 'D';
                                safeSetState(() {});
                              },
                              text: _model.q10D!,
                              options: FFButtonOptions(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Colors.transparent,
                                textStyle: TextStyle(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ].divide(SizedBox(height: 8.0)),
                        ),
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          if (_model.currentStep == 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'You are on the first question.',
                                  style: TextStyle(),
                                ),
                                duration: Duration(milliseconds: 4000),
                              ),
                            );
                          } else {
                            _model.currentStep = _model.currentStep! + -1;
                            safeSetState(() {});
                          }
                        },
                        text: FFLocalizations.of(context).getText(
                          '4fcxos8p' /* Back */,
                        ),
                        options: FFButtonOptions(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Colors.transparent,
                          textStyle: TextStyle(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      if (!(_model.currentStep == 10))
                        FFButtonWidget(
                          onPressed: () async {
                            _model.currentStep = _model.currentStep! + 1;
                            safeSetState(() {});
                          },
                          text: FFLocalizations.of(context).getText(
                            'zuc5p36d' /* Next */,
                          ),
                          options: FFButtonOptions(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).secondary,
                            textStyle: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                  if (_model.currentStep == 10)
                    FFButtonWidget(
                      onPressed: () async {
                        _model.submitAssessmentResult =
                            await SubmitAssessmentV2Call.call(
                          authToken: currentJwtToken,
                          q1: _model.ans1,
                          q2: _model.ans2,
                          q3: _model.ans3,
                          q4: _model.ans4,
                          q5: _model.ans5,
                          q6: _model.ans6,
                          q7: _model.ans7,
                          q8: _model.ans8,
                          q9: _model.ans9,
                          q10: _model.ans10,
                        );

                        if ((_model.submitAssessmentResult?.succeeded ??
                            true)) {
                          context.pushNamed(
                              RecommendationResultPageWidget.routeName);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please answer every question before submitting.',
                                style: TextStyle(),
                              ),
                              duration: Duration(milliseconds: 4000),
                            ),
                          );
                        }

                        safeSetState(() {});
                      },
                      text: FFLocalizations.of(context).getText(
                        'n7b1yro2' /* See My Recommendation */,
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
                ].divide(SizedBox(height: 14.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
