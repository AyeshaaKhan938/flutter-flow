import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  bool? isOnboardingComplete = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (GetUserProfileV2)] action in HomePage widget.
  ApiCallResponse? profileResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
