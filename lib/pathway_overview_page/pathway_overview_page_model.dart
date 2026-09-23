import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'pathway_overview_page_widget.dart' show PathwayOverviewPageWidget;
import 'package:flutter/material.dart';

class PathwayOverviewPageModel
    extends FlutterFlowModel<PathwayOverviewPageWidget> {
  ///  Local state fields for this page.

  List<LessonsRecord> lessonsList = [];
  void addToLessonsList(LessonsRecord item) => lessonsList.add(item);
  void removeFromLessonsList(LessonsRecord item) => lessonsList.remove(item);
  void removeAtIndexFromLessonsList(int index) => lessonsList.removeAt(index);
  void insertAtIndexInLessonsList(int index, LessonsRecord item) =>
      lessonsList.insert(index, item);
  void updateLessonsListAtIndex(int index, Function(LessonsRecord) updateFn) =>
      lessonsList[index] = updateFn(lessonsList[index]);

  int? completedCount = 0;

  int? totalLessons = 0;

  String? pathwayTitle = 'Pathway';

  String? memberLanguage = 'en';

  String? completedLessonsCsv = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in PathwayOverviewPage widget.
  List<LessonsRecord>? loadedLessons;
  // Stores action output result for [Backend Call - API (GetPathwayProgress)] action in PathwayOverviewPage widget.
  ApiCallResponse? progressResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
