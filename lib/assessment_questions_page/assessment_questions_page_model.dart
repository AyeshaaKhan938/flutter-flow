import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'assessment_questions_page_widget.dart'
    show AssessmentQuestionsPageWidget;
import 'package:flutter/material.dart';

class AssessmentQuestionsPageModel
    extends FlutterFlowModel<AssessmentQuestionsPageWidget> {
  ///  Local state fields for this page.

  int? q1 = -1;

  String? needs = '';

  String? habits = '';

  String? goals = '';

  int? q2 = -1;

  int? q3 = -1;

  int? q4 = -1;

  int? q5 = -1;

  int? q6 = -1;

  int? q7 = -1;

  int? q8 = -1;

  int? q9 = -1;

  int? q10 = -1;

  int? currentStep = 1;

  String? ans1 = '';

  String? ans2 = '';

  String? ans3 = '';

  String? ans4 = '';

  String? ans5 = '';

  String? ans6 = '';

  String? ans7 = '';

  String? ans8 = '';

  String? ans9 = '';

  String? ans10 = '';

  String? memberLanguage = 'en';

  List<AssessmentQuestionsRecord> questionsList = [];
  void addToQuestionsList(AssessmentQuestionsRecord item) =>
      questionsList.add(item);
  void removeFromQuestionsList(AssessmentQuestionsRecord item) =>
      questionsList.remove(item);
  void removeAtIndexFromQuestionsList(int index) =>
      questionsList.removeAt(index);
  void insertAtIndexInQuestionsList(
          int index, AssessmentQuestionsRecord item) =>
      questionsList.insert(index, item);
  void updateQuestionsListAtIndex(
          int index, Function(AssessmentQuestionsRecord) updateFn) =>
      questionsList[index] = updateFn(questionsList[index]);

  String? q1Label = 'Question 1';

  String? q1A = 'A';

  String? q1B = 'B';

  String? q1C = 'C';

  String? q1D = 'D';

  String? q2Label = 'Question 2';

  String? q2A = 'A';

  String? q2B = 'B';

  String? q2C = 'C';

  String? q2D = 'D';

  String? q3Label = 'Question 3';

  String? q3A = 'A';

  String? q3B = 'B';

  String? q3C = 'C';

  String? q3D = 'D';

  String? q4Label = 'Question 4';

  String? q4A = 'A';

  String? q4B = 'B';

  String? q4C = 'C';

  String? q4D = 'D';

  String? q5Label = 'Question 5';

  String? q5A = 'A';

  String? q5B = 'B';

  String? q5C = 'C';

  String? q5D = 'D';

  String? q6Label = 'Question 6';

  String? q6A = 'A';

  String? q6B = 'B';

  String? q6C = 'C';

  String? q6D = 'D';

  String? q7Label = 'Question 7';

  String? q7A = 'A';

  String? q7B = 'B';

  String? q7C = 'C';

  String? q7D = 'D';

  String? q8Label = 'Question 8';

  String? q8A = 'A';

  String? q8B = 'B';

  String? q8C = 'C';

  String? q8D = 'D';

  String? q9Label = 'Question 9';

  String? q9A = 'A';

  String? q9B = 'B';

  String? q9C = 'C';

  String? q9D = 'D';

  String? q10Label = 'Question 10';

  String? q10A = 'A';

  String? q10B = 'B';

  String? q10C = 'C';

  String? q10D = 'D';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (GetUserProfileV5)] action in AssessmentQuestionsPage widget.
  ApiCallResponse? assessmentLangProfile;
  // Stores action output result for [Backend Call - API (GetAssessmentQuestions)] action in AssessmentQuestionsPage widget.
  ApiCallResponse? loadedAssessmentCopy;
  // Stores action output result for [Backend Call - API (GetAssessmentQuestions)] action in AssessmentQuestionsPage widget.
  ApiCallResponse? loadedAssessmentCopyFallback;
  // Stores action output result for [Backend Call - API (SubmitAssessmentV2)] action in SubmitAssessmentButton widget.
  ApiCallResponse? submitAssessmentResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
