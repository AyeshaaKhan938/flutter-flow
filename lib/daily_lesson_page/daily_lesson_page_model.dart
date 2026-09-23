import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'daily_lesson_page_widget.dart' show DailyLessonPageWidget;
import 'package:flutter/material.dart';

class DailyLessonPageModel extends FlutterFlowModel<DailyLessonPageWidget> {
  ///  Local state fields for this page.

  List<LessonsRecord> lessonsList = [];
  void addToLessonsList(LessonsRecord item) => lessonsList.add(item);
  void removeFromLessonsList(LessonsRecord item) => lessonsList.remove(item);
  void removeAtIndexFromLessonsList(int index) => lessonsList.removeAt(index);
  void insertAtIndexInLessonsList(int index, LessonsRecord item) =>
      lessonsList.insert(index, item);
  void updateLessonsListAtIndex(int index, Function(LessonsRecord) updateFn) =>
      lessonsList[index] = updateFn(lessonsList[index]);

  String? reflectionInput = '';

  String? memberLanguage = 'en';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in DailyLessonPage widget.
  List<LessonsRecord>? loadedLessons;
  // Stores action output result for [Backend Call - API (GetPathwayProgress)] action in DailyLessonPage widget.
  ApiCallResponse? langResult;
  // Stores action output result for [Custom Action - RefreshConnectivityAndSync] action in DailyLessonPage widget.
  String? lessonConnectivityResult;
  // Stores action output result for [Custom Action - OpenScriptureReferenceSafe] action in ScriptureCard widget.
  String? bibleOpenResult;
  // State field(s) for ReflectionField widget.
  FocusNode? reflectionFieldFocusNode;
  TextEditingController? reflectionFieldTextController;
  String? Function(BuildContext, String?)?
      reflectionFieldTextControllerValidator;
  // Stores action output result for [Custom Action - SaveLessonProgressSmart] action in MarkCompleteButton widget.
  String? saveSmartResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    reflectionFieldFocusNode?.dispose();
    reflectionFieldTextController?.dispose();
  }
}
