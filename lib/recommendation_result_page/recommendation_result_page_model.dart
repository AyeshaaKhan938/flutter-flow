import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'recommendation_result_page_widget.dart'
    show RecommendationResultPageWidget;
import 'package:flutter/material.dart';

class RecommendationResultPageModel
    extends FlutterFlowModel<RecommendationResultPageWidget> {
  ///  Local state fields for this page.

  String? recommendedPathwayId = 'come-and-see';

  String? recommendationReason = '';

  String? companionPathwayId = '';

  String? companionExplanation = '';

  int? totalScore = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (GetUserProfileV4)] action in RecommendationResultPage widget.
  ApiCallResponse? recommendationProfile;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
