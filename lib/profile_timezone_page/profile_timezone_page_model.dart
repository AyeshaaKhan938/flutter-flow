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

  ///  State fields for stateful widgets in this page.

  // State field(s) for DisplayNameField widget.
  FocusNode? displayNameFieldFocusNode;
  TextEditingController? displayNameFieldTextController;
  String? Function(BuildContext, String?)?
      displayNameFieldTextControllerValidator;
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    displayNameFieldFocusNode?.dispose();
    displayNameFieldTextController?.dispose();

    countryFieldFocusNode?.dispose();
    countryFieldTextController?.dispose();

    regionCityFieldFocusNode?.dispose();
    regionCityFieldTextController?.dispose();

    timezoneFieldFocusNode?.dispose();
    timezoneFieldTextController?.dispose();
  }
}
