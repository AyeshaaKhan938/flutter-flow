import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'rag_search_page_widget.dart' show RagSearchPageWidget;
import 'package:flutter/material.dart';

class RagSearchPageModel extends FlutterFlowModel<RagSearchPageWidget> {
  ///  Local state fields for this page.

  String? questionInput = '';

  String? answerText = '';

  String? citationsText = '';

  String? fallbackText = '';

  String? memberLanguage = 'en';

  ///  State fields for stateful widgets in this page.

  // State field(s) for RagQuestionField widget.
  FocusNode? ragQuestionFieldFocusNode;
  TextEditingController? ragQuestionFieldTextController;
  String? Function(BuildContext, String?)?
      ragQuestionFieldTextControllerValidator;
  // Stores action output result for [Backend Call - API (GetUserProfileV4)] action in RagSearchButton widget.
  ApiCallResponse? ragLangProfile;
  // Stores action output result for [Backend Call - API (RagQueryHttp)] action in RagSearchButton widget.
  ApiCallResponse? ragResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    ragQuestionFieldFocusNode?.dispose();
    ragQuestionFieldTextController?.dispose();
  }
}
