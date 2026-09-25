import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'profile_timezone_page_widget.dart' show ProfileTimezonePageWidget;
import 'package:flutter/material.dart';

class ProfileTimezonePageModel
    extends FlutterFlowModel<ProfileTimezonePageWidget> {
  ///  Local state fields for this page.

  String? country = '';

  String? regionCity = '';

  String? timezone = '';

  String? preferredLanguage = 'en';

  String? displayName = '';

  String? phone = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for DisplayNameField widget.
  FocusNode? displayNameFieldFocusNode;
  TextEditingController? displayNameFieldTextController;
  String? Function(BuildContext, String?)?
      displayNameFieldTextControllerValidator;
  // State field(s) for PhoneField widget.
  FocusNode? phoneFieldFocusNode;
  TextEditingController? phoneFieldTextController;
  String? Function(BuildContext, String?)? phoneFieldTextControllerValidator;
  // State field(s) for CountryField widget.
  FocusNode? countryFieldFocusNode;
  TextEditingController? countryFieldTextController;
  String? Function(BuildContext, String?)? countryFieldTextControllerValidator;
  // State field(s) for RegionCityField widget.
  FocusNode? regionCityFieldFocusNode;
  TextEditingController? regionCityFieldTextController;
  String? Function(BuildContext, String?)?
      regionCityFieldTextControllerValidator;
  // State field(s) for TimezoneField widget.
  FocusNode? timezoneFieldFocusNode;
  TextEditingController? timezoneFieldTextController;
  String? Function(BuildContext, String?)? timezoneFieldTextControllerValidator;
  // Stores action output result for [Backend Call - API (SaveProfileDetailsV2)] action in SaveProfileDetailsButton widget.
  ApiCallResponse? saveProfileDetailsResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    displayNameFieldFocusNode?.dispose();
    displayNameFieldTextController?.dispose();

    phoneFieldFocusNode?.dispose();
    phoneFieldTextController?.dispose();

    countryFieldFocusNode?.dispose();
    countryFieldTextController?.dispose();

    regionCityFieldFocusNode?.dispose();
    regionCityFieldTextController?.dispose();

    timezoneFieldFocusNode?.dispose();
    timezoneFieldTextController?.dispose();
  }
}
