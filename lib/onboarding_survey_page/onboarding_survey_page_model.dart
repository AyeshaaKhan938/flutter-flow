import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'onboarding_survey_page_widget.dart' show OnboardingSurveyPageWidget;
import 'package:flutter/material.dart';

class OnboardingSurveyPageModel
    extends FlutterFlowModel<OnboardingSurveyPageWidget> {
  ///  Local state fields for this page.

  String? preferredLanguage = 'en';

  String? hearAbout = '';

  String? growthGoal = '';

  List<OnboardingQuestionsRecord> questionsList = [];
  void addToQuestionsList(OnboardingQuestionsRecord item) =>
      questionsList.add(item);
  void removeFromQuestionsList(OnboardingQuestionsRecord item) =>
      questionsList.remove(item);
  void removeAtIndexFromQuestionsList(int index) =>
      questionsList.removeAt(index);
  void insertAtIndexInQuestionsList(
          int index, OnboardingQuestionsRecord item) =>
      questionsList.insert(index, item);
  void updateQuestionsListAtIndex(
          int index, Function(OnboardingQuestionsRecord) updateFn) =>
      questionsList[index] = updateFn(questionsList[index]);

  String selectedLanguage = 'en';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - SetPreferredLanguage] action in LangEnSelected widget.
  String? pickLangEnA;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in LangEnUnselected widget.
  String? pickLangEnB;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in LangEsSelected widget.
  String? pickLangEsA;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in LangEsUnselected widget.
  String? pickLangEsB;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in LangUrSelected widget.
  String? pickLangUrA;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in LangUrUnselected widget.
  String? pickLangUrB;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in LangLgSelected widget.
  String? pickLangLgA;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in LangLgUnselected widget.
  String? pickLangLgB;
  // State field(s) for HearAboutField widget.
  FocusNode? hearAboutFieldFocusNode;
  TextEditingController? hearAboutFieldTextController;
  String? Function(BuildContext, String?)?
      hearAboutFieldTextControllerValidator;
  // State field(s) for GrowthGoalField widget.
  FocusNode? growthGoalFieldFocusNode;
  TextEditingController? growthGoalFieldTextController;
  String? Function(BuildContext, String?)?
      growthGoalFieldTextControllerValidator;
  // Stores action output result for [Backend Call - API (SaveOnboardingSurvey)] action in OnboardingContinueButton widget.
  ApiCallResponse? onboardingSaveResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    hearAboutFieldFocusNode?.dispose();
    hearAboutFieldTextController?.dispose();

    growthGoalFieldFocusNode?.dispose();
    growthGoalFieldTextController?.dispose();
  }
}
