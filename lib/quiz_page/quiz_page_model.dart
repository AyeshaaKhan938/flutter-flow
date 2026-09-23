import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'quiz_page_widget.dart' show QuizPageWidget;
import 'package:flutter/material.dart';

class QuizPageModel extends FlutterFlowModel<QuizPageWidget> {
  ///  Local state fields for this page.

  String? quizTitle = 'Quiz';

  int? passingScore = 80;

  bool? submitted = false;

  int? percentage = 0;

  bool? passed = false;

  String? q1Text = '';

  String? q1A = '';

  String? q1B = '';

  String? q1C = '';

  String? q1D = '';

  String? q1Answer = '';

  String? q2Text = '';

  String? q2A = '';

  String? q2B = '';

  String? q2C = '';

  String? q2D = '';

  String? q2Answer = '';

  String? q3Text = '';

  String? q3A = '';

  String? q3B = '';

  String? q3C = '';

  String? q3D = '';

  String? q3Answer = '';

  String? q4Text = '';

  String? q4A = '';

  String? q4B = '';

  String? q4C = '';

  String? q4D = '';

  String? q4Answer = '';

  String? q5Text = '';

  String? q5A = '';

  String? q5B = '';

  String? q5C = '';

  String? q5D = '';

  String? q5Answer = '';

  String? q6Text = '';

  String? q6A = '';

  String? q6B = '';

  String? q6C = '';

  String? q6D = '';

  String? q6Answer = '';

  String? q7Text = '';

  String? q7A = '';

  String? q7B = '';

  String? q7C = '';

  String? q7D = '';

  String? q7Answer = '';

  String? q8Text = '';

  String? q8A = '';

  String? q8B = '';

  String? q8C = '';

  String? q8D = '';

  String? q8Answer = '';

  String? q9Text = '';

  String? q9A = '';

  String? q9B = '';

  String? q9C = '';

  String? q9D = '';

  String? q9Answer = '';

  String? q10Text = '';

  String? q10A = '';

  String? q10B = '';

  String? q10C = '';

  String? q10D = '';

  String? q10Answer = '';

  String? memberLanguage = 'en';

  int? attemptCount = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (GetUserProfileV3)] action in QuizPage widget.
  ApiCallResponse? quizLangProfileResult;
  // Stores action output result for [Backend Call - API (GetQuizV2)] action in QuizPage widget.
  ApiCallResponse? quizResult;
  // Stores action output result for [Backend Call - API (GetQuizAttempt)] action in QuizPage widget.
  ApiCallResponse? priorAttemptResult;
  // Stores action output result for [Backend Call - API (SubmitQuizAttemptV2)] action in SubmitQuizButton widget.
  ApiCallResponse? submitResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
