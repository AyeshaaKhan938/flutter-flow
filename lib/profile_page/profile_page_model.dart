import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_page_widget.dart' show ProfilePageWidget;
import 'package:flutter/material.dart';

class ProfilePageModel extends FlutterFlowModel<ProfilePageWidget> {
  ///  Local state fields for this page.

  UserProfileEntryStruct? profile;
  void updateProfileStruct(Function(UserProfileEntryStruct) updateFn) {
    updateFn(profile ??= UserProfileEntryStruct());
  }

  String? userRole = 'member';

  String? currentLanguage = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (GetUserProfileV3)] action in ProfilePage widget.
  ApiCallResponse? profileResult;
  // Stores action output result for [Backend Call - API (GetUserProfileV3)] action in ProfileAdminContainer widget.
  ApiCallResponse? profileAdminGateResult;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in ProfileLangEnSelected widget.
  String? profileLangLangEnA;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in ProfileLangEnUnselected widget.
  String? profileLangLangEnB;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in ProfileLangEsSelected widget.
  String? profileLangLangEsA;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in ProfileLangEsUnselected widget.
  String? profileLangLangEsB;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in ProfileLangUrSelected widget.
  String? profileLangLangUrA;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in ProfileLangUrUnselected widget.
  String? profileLangLangUrB;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in ProfileLangLgSelected widget.
  String? profileLangLangLgA;
  // Stores action output result for [Custom Action - SetPreferredLanguage] action in ProfileLangLgUnselected widget.
  String? profileLangLangLgB;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
