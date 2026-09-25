import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'pathway_list_page_widget.dart' show PathwayListPageWidget;
import 'package:flutter/material.dart';

class PathwayListPageModel extends FlutterFlowModel<PathwayListPageWidget> {
  ///  Local state fields for this page.

  List<PathwaysRecord> pathwaysList = [];
  void addToPathwaysList(PathwaysRecord item) => pathwaysList.add(item);
  void removeFromPathwaysList(PathwaysRecord item) => pathwaysList.remove(item);
  void removeAtIndexFromPathwaysList(int index) => pathwaysList.removeAt(index);
  void insertAtIndexInPathwaysList(int index, PathwaysRecord item) =>
      pathwaysList.insert(index, item);
  void updatePathwaysListAtIndex(
          int index, Function(PathwaysRecord) updateFn) =>
      pathwaysList[index] = updateFn(pathwaysList[index]);

  bool? isLoading = true;

  String? memberLanguage = 'en';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (GetUserProfileV4)] action in PathwayListPage widget.
  ApiCallResponse? pathwayLangProfile;
  // Stores action output result for [Firestore Query - Query a collection] action in PathwayListPage widget.
  List<PathwaysRecord>? loadedPathways;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
