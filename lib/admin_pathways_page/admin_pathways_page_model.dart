import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/simple_list_tile_widget.dart';
import '/components/status_badge_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'admin_pathways_page_widget.dart' show AdminPathwaysPageWidget;
import 'package:flutter/material.dart';

class AdminPathwaysPageModel extends FlutterFlowModel<AdminPathwaysPageWidget> {
  ///  Local state fields for this page.

  List<PathwayEntryStruct> pathwaysList = [];
  void addToPathwaysList(PathwayEntryStruct item) => pathwaysList.add(item);
  void removeFromPathwaysList(PathwayEntryStruct item) =>
      pathwaysList.remove(item);
  void removeAtIndexFromPathwaysList(int index) => pathwaysList.removeAt(index);
  void insertAtIndexInPathwaysList(int index, PathwayEntryStruct item) =>
      pathwaysList.insert(index, item);
  void updatePathwaysListAtIndex(
          int index, Function(PathwayEntryStruct) updateFn) =>
      pathwaysList[index] = updateFn(pathwaysList[index]);

  List<PathwaysRecord> livePathwaysList = [];
  void addToLivePathwaysList(PathwaysRecord item) => livePathwaysList.add(item);
  void removeFromLivePathwaysList(PathwaysRecord item) =>
      livePathwaysList.remove(item);
  void removeAtIndexFromLivePathwaysList(int index) =>
      livePathwaysList.removeAt(index);
  void insertAtIndexInLivePathwaysList(int index, PathwaysRecord item) =>
      livePathwaysList.insert(index, item);
  void updateLivePathwaysListAtIndex(
          int index, Function(PathwaysRecord) updateFn) =>
      livePathwaysList[index] = updateFn(livePathwaysList[index]);

  List<DailyScriptureRecord> liveScriptureList = [];
  void addToLiveScriptureList(DailyScriptureRecord item) =>
      liveScriptureList.add(item);
  void removeFromLiveScriptureList(DailyScriptureRecord item) =>
      liveScriptureList.remove(item);
  void removeAtIndexFromLiveScriptureList(int index) =>
      liveScriptureList.removeAt(index);
  void insertAtIndexInLiveScriptureList(int index, DailyScriptureRecord item) =>
      liveScriptureList.insert(index, item);
  void updateLiveScriptureListAtIndex(
          int index, Function(DailyScriptureRecord) updateFn) =>
      liveScriptureList[index] = updateFn(liveScriptureList[index]);

  List<LessonsRecord> liveLessonsList = [];
  void addToLiveLessonsList(LessonsRecord item) => liveLessonsList.add(item);
  void removeFromLiveLessonsList(LessonsRecord item) =>
      liveLessonsList.remove(item);
  void removeAtIndexFromLiveLessonsList(int index) =>
      liveLessonsList.removeAt(index);
  void insertAtIndexInLiveLessonsList(int index, LessonsRecord item) =>
      liveLessonsList.insert(index, item);
  void updateLiveLessonsListAtIndex(
          int index, Function(LessonsRecord) updateFn) =>
      liveLessonsList[index] = updateFn(liveLessonsList[index]);

  List<QuizzesRecord> liveQuizzesList = [];
  void addToLiveQuizzesList(QuizzesRecord item) => liveQuizzesList.add(item);
  void removeFromLiveQuizzesList(QuizzesRecord item) =>
      liveQuizzesList.remove(item);
  void removeAtIndexFromLiveQuizzesList(int index) =>
      liveQuizzesList.removeAt(index);
  void insertAtIndexInLiveQuizzesList(int index, QuizzesRecord item) =>
      liveQuizzesList.insert(index, item);
  void updateLiveQuizzesListAtIndex(
          int index, Function(QuizzesRecord) updateFn) =>
      liveQuizzesList[index] = updateFn(liveQuizzesList[index]);

  String? importCollection = 'lessons';

  String? importCsvText = '';

  int? importCreated = 0;

  int? importUpdated = 0;

  int? importUnchanged = 0;

  int? importErrorCount = 0;

  String? importFirstError = '';

  bool? importPreviewed = false;

  String? newPathwayTitle = '';

  String? newPathwayStableId = '';

  String? newLessonTitle = '';

  String? newLessonStableId = '';

  String? newLessonPathwayId = '';

  String? newLessonScriptureRef = '';

  String? editPathwayStableId = '';

  String? editPathwayTitle = '';

  String? editPathwayStatus = 'draft';

  String? editLessonPathwayId = '';

  String? editLessonStableId = '';

  String? editLessonTitle = '';

  String? editLessonScriptureRef = '';

  String? editLessonReflection = '';

  String? editLessonStatus = 'draft';

  int? reportPathwayCount = 0;

  int? reportLessonCount = 0;

  int? reportQuizCount = 0;

  int? reportMemberCount = 0;

  String? reportLastImport = '';

  String? reportLastRag = '';

  String? reportNote = '';

  String? cfgVersion = '1.0';

  String? cfgScoreBandsJson = '';

  String? cfgOverridesJson = '';

  String? cfgExplanationsJson = '';

  String? cfgPointMapJson = '';

  String? cfgNote = '';

  String? annTitleEn = '';

  String? annTitleEs = '';

  String? annTitleUr = '';

  String? annBodyEn = '';

  String? annBodyEs = '';

  String? annBodyUr = '';

  String? annNote = '';

  String? translationNote = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in AdminPathwaysPage widget.
  List<LessonsRecord>? loadedLessonsAdmin;
  // Stores action output result for [Firestore Query - Query a collection] action in AdminPathwaysPage widget.
  List<QuizzesRecord>? loadedQuizzesAdmin;
  // State field(s) for AnnTitleEnField widget.
  FocusNode? annTitleEnFieldFocusNode;
  TextEditingController? annTitleEnFieldTextController;
  String? Function(BuildContext, String?)?
      annTitleEnFieldTextControllerValidator;
  // State field(s) for AnnTitleEsField widget.
  FocusNode? annTitleEsFieldFocusNode;
  TextEditingController? annTitleEsFieldTextController;
  String? Function(BuildContext, String?)?
      annTitleEsFieldTextControllerValidator;
  // State field(s) for AnnTitleUrField widget.
  FocusNode? annTitleUrFieldFocusNode;
  TextEditingController? annTitleUrFieldTextController;
  String? Function(BuildContext, String?)?
      annTitleUrFieldTextControllerValidator;
  // State field(s) for AnnBodyEnField widget.
  FocusNode? annBodyEnFieldFocusNode;
  TextEditingController? annBodyEnFieldTextController;
  String? Function(BuildContext, String?)?
      annBodyEnFieldTextControllerValidator;
  // State field(s) for AnnBodyEsField widget.
  FocusNode? annBodyEsFieldFocusNode;
  TextEditingController? annBodyEsFieldTextController;
  String? Function(BuildContext, String?)?
      annBodyEsFieldTextControllerValidator;
  // State field(s) for AnnBodyUrField widget.
  FocusNode? annBodyUrFieldFocusNode;
  TextEditingController? annBodyUrFieldTextController;
  String? Function(BuildContext, String?)?
      annBodyUrFieldTextControllerValidator;
  // Stores action output result for [Backend Call - API (PublishAnnouncement)] action in PublishAnnouncementPushButton widget.
  ApiCallResponse? publishAnnResult;
  // Stores action output result for [Backend Call - API (LogAnalyticsEvent)] action in PublishAnnouncementPushButton widget.
  ApiCallResponse? annAnalytics;
  // Stores action output result for [Backend Call - API (PublishAnnouncement)] action in PublishAnnouncementOnlyButton widget.
  ApiCallResponse? publishAnnOnlyResult;
  // Stores action output result for [Backend Call - API (GenerateTranslationDrafts)] action in GenPathwayTranslationDraftsButton widget.
  ApiCallResponse? pathwayDraftsResult;
  // Stores action output result for [Backend Call - API (GenerateTranslationDrafts)] action in GenLessonTranslationDraftsButton widget.
  ApiCallResponse? lessonDraftsResult;
  // Stores action output result for [Backend Call - API (GetAssessmentConfig)] action in LoadAssessmentConfigButton widget.
  ApiCallResponse? loadedAssessmentConfig;
  // State field(s) for CfgVersionField widget.
  FocusNode? cfgVersionFieldFocusNode;
  TextEditingController? cfgVersionFieldTextController;
  String? Function(BuildContext, String?)?
      cfgVersionFieldTextControllerValidator;
  // State field(s) for CfgBandsField widget.
  FocusNode? cfgBandsFieldFocusNode;
  TextEditingController? cfgBandsFieldTextController;
  String? Function(BuildContext, String?)? cfgBandsFieldTextControllerValidator;
  // State field(s) for CfgOverridesField widget.
  FocusNode? cfgOverridesFieldFocusNode;
  TextEditingController? cfgOverridesFieldTextController;
  String? Function(BuildContext, String?)?
      cfgOverridesFieldTextControllerValidator;
  // State field(s) for CfgExplanationsField widget.
  FocusNode? cfgExplanationsFieldFocusNode;
  TextEditingController? cfgExplanationsFieldTextController;
  String? Function(BuildContext, String?)?
      cfgExplanationsFieldTextControllerValidator;
  // State field(s) for CfgPointMapField widget.
  FocusNode? cfgPointMapFieldFocusNode;
  TextEditingController? cfgPointMapFieldTextController;
  String? Function(BuildContext, String?)?
      cfgPointMapFieldTextControllerValidator;
  // Stores action output result for [Backend Call - API (UpdateAssessmentConfig)] action in SaveAssessmentConfigButton widget.
  ApiCallResponse? savedAssessmentConfig;
  // Stores action output result for [Backend Call - API (GetAdminReport)] action in RefreshAdminReportButton widget.
  ApiCallResponse? adminReportResult;
  // State field(s) for NewPathwayTitleField widget.
  FocusNode? newPathwayTitleFieldFocusNode;
  TextEditingController? newPathwayTitleFieldTextController;
  String? Function(BuildContext, String?)?
      newPathwayTitleFieldTextControllerValidator;
  // State field(s) for NewPathwayStableIdField widget.
  FocusNode? newPathwayStableIdFieldFocusNode;
  TextEditingController? newPathwayStableIdFieldTextController;
  String? Function(BuildContext, String?)?
      newPathwayStableIdFieldTextControllerValidator;
  // Stores action output result for [Custom Action - AdminCreatePathway] action in CreatePathwayButton widget.
  String? boCreatePathwayResult;
  // Stores action output result for [Firestore Query - Query a collection] action in CreatePathwayButton widget.
  List<PathwaysRecord>? boPathwaysAfterCreate;
  // State field(s) for NewLessonTitleField widget.
  FocusNode? newLessonTitleFieldFocusNode;
  TextEditingController? newLessonTitleFieldTextController;
  String? Function(BuildContext, String?)?
      newLessonTitleFieldTextControllerValidator;
  // State field(s) for NewLessonStableIdField widget.
  FocusNode? newLessonStableIdFieldFocusNode;
  TextEditingController? newLessonStableIdFieldTextController;
  String? Function(BuildContext, String?)?
      newLessonStableIdFieldTextControllerValidator;
  // State field(s) for NewLessonPathwayIdField widget.
  FocusNode? newLessonPathwayIdFieldFocusNode;
  TextEditingController? newLessonPathwayIdFieldTextController;
  String? Function(BuildContext, String?)?
      newLessonPathwayIdFieldTextControllerValidator;
  // State field(s) for NewLessonScriptureRefField widget.
  FocusNode? newLessonScriptureRefFieldFocusNode;
  TextEditingController? newLessonScriptureRefFieldTextController;
  String? Function(BuildContext, String?)?
      newLessonScriptureRefFieldTextControllerValidator;
  // Stores action output result for [Custom Action - AdminCreateLesson] action in CreateLessonButton widget.
  String? boCreateLessonResult;
  // State field(s) for EditPathwayStableIdField widget.
  FocusNode? editPathwayStableIdFieldFocusNode;
  TextEditingController? editPathwayStableIdFieldTextController;
  String? Function(BuildContext, String?)?
      editPathwayStableIdFieldTextControllerValidator;
  // State field(s) for EditPathwayTitleField widget.
  FocusNode? editPathwayTitleFieldFocusNode;
  TextEditingController? editPathwayTitleFieldTextController;
  String? Function(BuildContext, String?)?
      editPathwayTitleFieldTextControllerValidator;
  // State field(s) for EditPathwayStatusField widget.
  FocusNode? editPathwayStatusFieldFocusNode;
  TextEditingController? editPathwayStatusFieldTextController;
  String? Function(BuildContext, String?)?
      editPathwayStatusFieldTextControllerValidator;
  // Stores action output result for [Custom Action - AdminUpdatePathway] action in UpdatePathwayButton widget.
  String? boUpdatePathwayResult;
  // Stores action output result for [Firestore Query - Query a collection] action in UpdatePathwayButton widget.
  List<PathwaysRecord>? boPathwaysAfterEdit;
  // State field(s) for EditLessonPathwayIdField widget.
  FocusNode? editLessonPathwayIdFieldFocusNode;
  TextEditingController? editLessonPathwayIdFieldTextController;
  String? Function(BuildContext, String?)?
      editLessonPathwayIdFieldTextControllerValidator;
  // State field(s) for EditLessonStableIdField widget.
  FocusNode? editLessonStableIdFieldFocusNode;
  TextEditingController? editLessonStableIdFieldTextController;
  String? Function(BuildContext, String?)?
      editLessonStableIdFieldTextControllerValidator;
  // State field(s) for EditLessonTitleField widget.
  FocusNode? editLessonTitleFieldFocusNode;
  TextEditingController? editLessonTitleFieldTextController;
  String? Function(BuildContext, String?)?
      editLessonTitleFieldTextControllerValidator;
  // State field(s) for EditLessonScriptureRefField widget.
  FocusNode? editLessonScriptureRefFieldFocusNode;
  TextEditingController? editLessonScriptureRefFieldTextController;
  String? Function(BuildContext, String?)?
      editLessonScriptureRefFieldTextControllerValidator;
  // State field(s) for EditLessonReflectionField widget.
  FocusNode? editLessonReflectionFieldFocusNode;
  TextEditingController? editLessonReflectionFieldTextController;
  String? Function(BuildContext, String?)?
      editLessonReflectionFieldTextControllerValidator;
  // State field(s) for EditLessonStatusField widget.
  FocusNode? editLessonStatusFieldFocusNode;
  TextEditingController? editLessonStatusFieldTextController;
  String? Function(BuildContext, String?)?
      editLessonStatusFieldTextControllerValidator;
  // Stores action output result for [Custom Action - AdminUpdateLesson] action in UpdateLessonButton widget.
  String? boUpdateLessonResult;
  // Models for SimpleListTile.
  late FlutterFlowDynamicModels<SimpleListTileModel> simpleListTileModels1;
  // Models for StatusBadge.
  late FlutterFlowDynamicModels<StatusBadgeModel> statusBadgeModels1;
  // Stores action output result for [Firestore Query - Query a collection] action in SubmitPathwayCrudButton widget.
  List<PathwaysRecord>? boPathwaysAfterSubmit;
  // Stores action output result for [Firestore Query - Query a collection] action in PublishPathwayCrudButton widget.
  List<PathwaysRecord>? boPathwaysAfterPublish;
  // Stores action output result for [Firestore Query - Query a collection] action in UnpublishPathwayCrudButton widget.
  List<PathwaysRecord>? boPathwaysAfterUnpublish;
  // Stores action output result for [Firestore Query - Query a collection] action in DeletePathwayButton widget.
  List<PathwaysRecord>? boPathwaysAfterDelete;
  // Models for SimpleListTile.
  late FlutterFlowDynamicModels<SimpleListTileModel> simpleListTileModels2;
  // Models for StatusBadge.
  late FlutterFlowDynamicModels<StatusBadgeModel> statusBadgeModels2;
  // Models for SimpleListTile.
  late FlutterFlowDynamicModels<SimpleListTileModel> simpleListTileModels3;
  // Models for StatusBadge.
  late FlutterFlowDynamicModels<StatusBadgeModel> statusBadgeModels3;
  // Stores action output result for [Firestore Query - Query a collection] action in LessonSubmitForReviewButton widget.
  List<LessonsRecord>? loadedLessonsAdminAfterSubmit;
  // Stores action output result for [Firestore Query - Query a collection] action in LessonApproveButton widget.
  List<LessonsRecord>? loadedLessonsAdminAfterApprove;
  // Stores action output result for [Firestore Query - Query a collection] action in LessonBackToDraftButton widget.
  List<LessonsRecord>? loadedLessonsAdminAfterReject;
  // Stores action output result for [Firestore Query - Query a collection] action in LessonUnpublishButton widget.
  List<LessonsRecord>? loadedLessonsAdminAfterUnpublish;
  // Models for SimpleListTile.
  late FlutterFlowDynamicModels<SimpleListTileModel> simpleListTileModels4;
  // Models for StatusBadge.
  late FlutterFlowDynamicModels<StatusBadgeModel> statusBadgeModels4;
  // Stores action output result for [Firestore Query - Query a collection] action in QuizSubmitForReviewButton widget.
  List<QuizzesRecord>? loadedQuizzesAdminAfterSubmit;
  // Stores action output result for [Firestore Query - Query a collection] action in QuizApproveButton widget.
  List<QuizzesRecord>? loadedQuizzesAdminAfterApprove;
  // Stores action output result for [Firestore Query - Query a collection] action in QuizBackToDraftButton widget.
  List<QuizzesRecord>? loadedQuizzesAdminAfterReject;
  // Stores action output result for [Firestore Query - Query a collection] action in QuizUnpublishButton widget.
  List<QuizzesRecord>? loadedQuizzesAdminAfterUnpublish;
  // State field(s) for ImportCsvField widget.
  FocusNode? importCsvFieldFocusNode;
  TextEditingController? importCsvFieldTextController;
  String? Function(BuildContext, String?)?
      importCsvFieldTextControllerValidator;
  // Stores action output result for [Backend Call - API (ImportCurriculum)] action in PreviewImportButton widget.
  ApiCallResponse? previewResult;
  // Stores action output result for [Backend Call - API (ImportCurriculum)] action in ConfirmImportButton widget.
  ApiCallResponse? commitResult;

  @override
  void initState(BuildContext context) {
    simpleListTileModels1 =
        FlutterFlowDynamicModels(() => SimpleListTileModel());
    statusBadgeModels1 = FlutterFlowDynamicModels(() => StatusBadgeModel());
    simpleListTileModels2 =
        FlutterFlowDynamicModels(() => SimpleListTileModel());
    statusBadgeModels2 = FlutterFlowDynamicModels(() => StatusBadgeModel());
    simpleListTileModels3 =
        FlutterFlowDynamicModels(() => SimpleListTileModel());
    statusBadgeModels3 = FlutterFlowDynamicModels(() => StatusBadgeModel());
    simpleListTileModels4 =
        FlutterFlowDynamicModels(() => SimpleListTileModel());
    statusBadgeModels4 = FlutterFlowDynamicModels(() => StatusBadgeModel());
  }

  @override
  void dispose() {
    annTitleEnFieldFocusNode?.dispose();
    annTitleEnFieldTextController?.dispose();

    annTitleEsFieldFocusNode?.dispose();
    annTitleEsFieldTextController?.dispose();

    annTitleUrFieldFocusNode?.dispose();
    annTitleUrFieldTextController?.dispose();

    annBodyEnFieldFocusNode?.dispose();
    annBodyEnFieldTextController?.dispose();

    annBodyEsFieldFocusNode?.dispose();
    annBodyEsFieldTextController?.dispose();

    annBodyUrFieldFocusNode?.dispose();
    annBodyUrFieldTextController?.dispose();

    cfgVersionFieldFocusNode?.dispose();
    cfgVersionFieldTextController?.dispose();

    cfgBandsFieldFocusNode?.dispose();
    cfgBandsFieldTextController?.dispose();

    cfgOverridesFieldFocusNode?.dispose();
    cfgOverridesFieldTextController?.dispose();

    cfgExplanationsFieldFocusNode?.dispose();
    cfgExplanationsFieldTextController?.dispose();

    cfgPointMapFieldFocusNode?.dispose();
    cfgPointMapFieldTextController?.dispose();

    newPathwayTitleFieldFocusNode?.dispose();
    newPathwayTitleFieldTextController?.dispose();

    newPathwayStableIdFieldFocusNode?.dispose();
    newPathwayStableIdFieldTextController?.dispose();

    newLessonTitleFieldFocusNode?.dispose();
    newLessonTitleFieldTextController?.dispose();

    newLessonStableIdFieldFocusNode?.dispose();
    newLessonStableIdFieldTextController?.dispose();

    newLessonPathwayIdFieldFocusNode?.dispose();
    newLessonPathwayIdFieldTextController?.dispose();

    newLessonScriptureRefFieldFocusNode?.dispose();
    newLessonScriptureRefFieldTextController?.dispose();

    editPathwayStableIdFieldFocusNode?.dispose();
    editPathwayStableIdFieldTextController?.dispose();

    editPathwayTitleFieldFocusNode?.dispose();
    editPathwayTitleFieldTextController?.dispose();

    editPathwayStatusFieldFocusNode?.dispose();
    editPathwayStatusFieldTextController?.dispose();

    editLessonPathwayIdFieldFocusNode?.dispose();
    editLessonPathwayIdFieldTextController?.dispose();

    editLessonStableIdFieldFocusNode?.dispose();
    editLessonStableIdFieldTextController?.dispose();

    editLessonTitleFieldFocusNode?.dispose();
    editLessonTitleFieldTextController?.dispose();

    editLessonScriptureRefFieldFocusNode?.dispose();
    editLessonScriptureRefFieldTextController?.dispose();

    editLessonReflectionFieldFocusNode?.dispose();
    editLessonReflectionFieldTextController?.dispose();

    editLessonStatusFieldFocusNode?.dispose();
    editLessonStatusFieldTextController?.dispose();

    simpleListTileModels1.dispose();
    statusBadgeModels1.dispose();
    simpleListTileModels2.dispose();
    statusBadgeModels2.dispose();
    simpleListTileModels3.dispose();
    statusBadgeModels3.dispose();
    simpleListTileModels4.dispose();
    statusBadgeModels4.dispose();
    importCsvFieldFocusNode?.dispose();
    importCsvFieldTextController?.dispose();
  }
}
