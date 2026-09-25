import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'sign_up_page_widget.dart' show SignUpPageWidget;
import 'package:flutter/material.dart';

class SignUpPageModel extends FlutterFlowModel<SignUpPageWidget> {
  ///  Local state fields for this page.

  String? fullName = '';

  String? email = '';

  String? password = '';

  String? phone = '';

  String? country = '';

  String? regionCity = '';

  bool? isSubmitting = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for FullNameField widget.
  FocusNode? fullNameFieldFocusNode;
  TextEditingController? fullNameFieldTextController;
  String? Function(BuildContext, String?)? fullNameFieldTextControllerValidator;
  // State field(s) for PhoneField widget.
  FocusNode? phoneFieldFocusNode;
  TextEditingController? phoneFieldTextController;
  String? Function(BuildContext, String?)? phoneFieldTextControllerValidator;
  // State field(s) for SignUpEmailField widget.
  FocusNode? signUpEmailFieldFocusNode;
  TextEditingController? signUpEmailFieldTextController;
  String? Function(BuildContext, String?)?
      signUpEmailFieldTextControllerValidator;
  // State field(s) for SignUpPasswordField widget.
  FocusNode? signUpPasswordFieldFocusNode;
  TextEditingController? signUpPasswordFieldTextController;
  late bool signUpPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      signUpPasswordFieldTextControllerValidator;
  // Stores action output result for [Custom Action - SaveSignupProfile] action in SignUpSubmitButton widget.
  String? signupSaveResult;

  @override
  void initState(BuildContext context) {
    signUpPasswordFieldVisibility = false;
  }

  @override
  void dispose() {
    fullNameFieldFocusNode?.dispose();
    fullNameFieldTextController?.dispose();

    phoneFieldFocusNode?.dispose();
    phoneFieldTextController?.dispose();

    signUpEmailFieldFocusNode?.dispose();
    signUpEmailFieldTextController?.dispose();

    signUpPasswordFieldFocusNode?.dispose();
    signUpPasswordFieldTextController?.dispose();
  }
}
