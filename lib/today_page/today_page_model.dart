import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'today_page_widget.dart' show TodayPageWidget;
import 'package:flutter/material.dart';

class TodayPageModel extends FlutterFlowModel<TodayPageWidget> {
  ///  Local state fields for this page.

  List<DailyScriptureRecord> scriptureList = [];
  void addToScriptureList(DailyScriptureRecord item) => scriptureList.add(item);
  void removeFromScriptureList(DailyScriptureRecord item) =>
      scriptureList.remove(item);
  void removeAtIndexFromScriptureList(int index) =>
      scriptureList.removeAt(index);
  void insertAtIndexInScriptureList(int index, DailyScriptureRecord item) =>
      scriptureList.insert(index, item);
  void updateScriptureListAtIndex(
          int index, Function(DailyScriptureRecord) updateFn) =>
      scriptureList[index] = updateFn(scriptureList[index]);

  List<EncouragementsRecord> encouragementList = [];
  void addToEncouragementList(EncouragementsRecord item) =>
      encouragementList.add(item);
  void removeFromEncouragementList(EncouragementsRecord item) =>
      encouragementList.remove(item);
  void removeAtIndexFromEncouragementList(int index) =>
      encouragementList.removeAt(index);
  void insertAtIndexInEncouragementList(int index, EncouragementsRecord item) =>
      encouragementList.insert(index, item);
  void updateEncouragementListAtIndex(
          int index, Function(EncouragementsRecord) updateFn) =>
      encouragementList[index] = updateFn(encouragementList[index]);

  List<AnnouncementsRecord> announcementList = [];
  void addToAnnouncementList(AnnouncementsRecord item) =>
      announcementList.add(item);
  void removeFromAnnouncementList(AnnouncementsRecord item) =>
      announcementList.remove(item);
  void removeAtIndexFromAnnouncementList(int index) =>
      announcementList.removeAt(index);
  void insertAtIndexInAnnouncementList(int index, AnnouncementsRecord item) =>
      announcementList.insert(index, item);
  void updateAnnouncementListAtIndex(
          int index, Function(AnnouncementsRecord) updateFn) =>
      announcementList[index] = updateFn(announcementList[index]);

  String? memberLanguage = 'en';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (GetUserProfileV4)] action in TodayPage widget.
  ApiCallResponse? langProfileResult;
  // Stores action output result for [Firestore Query - Query a collection] action in TodayPage widget.
  List<AnnouncementsRecord>? loadedAnnouncements;
  // Stores action output result for [Firestore Query - Query a collection] action in TodayPage widget.
  List<DailyScriptureRecord>? loadedScriptureToday;
  // Stores action output result for [Firestore Query - Query a collection] action in TodayPage widget.
  List<EncouragementsRecord>? loadedEncouragementsToday;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
