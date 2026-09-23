import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'sign_in_page_widget.dart' show SignInPageWidget;
import 'package:flutter/material.dart';

class SignInPageModel extends FlutterFlowModel<SignInPageWidget> {
  ///  Local state fields for this page.

  String? email = '';

  String? password = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for City widget.
  FocusNode? cityFocusNode1;
  TextEditingController? cityTextController1;
  String? Function(BuildContext, String?)? cityTextController1Validator;
  // State field(s) for EmailField widget.
  FocusNode? emailFieldFocusNode1;
  TextEditingController? emailFieldTextController1;
  String? Function(BuildContext, String?)? emailFieldTextController1Validator;
  // State field(s) for City widget.
  FocusNode? cityFocusNode2;
  TextEditingController? cityTextController2;
  String? Function(BuildContext, String?)? cityTextController2Validator;
  // State field(s) for EmailField widget.
  FocusNode? emailFieldFocusNode2;
  TextEditingController? emailFieldTextController2;
  String? Function(BuildContext, String?)? emailFieldTextController2Validator;
  // State field(s) for PasswordField widget.
  FocusNode? passwordFieldFocusNode;
  TextEditingController? passwordFieldTextController;
  late bool passwordFieldVisibility;
  String? Function(BuildContext, String?)? passwordFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordFieldVisibility = false;
  }

  @override
  void dispose() {
    cityFocusNode1?.dispose();
    cityTextController1?.dispose();

    emailFieldFocusNode1?.dispose();
    emailFieldTextController1?.dispose();

    cityFocusNode2?.dispose();
    cityTextController2?.dispose();

    emailFieldFocusNode2?.dispose();
    emailFieldTextController2?.dispose();

    passwordFieldFocusNode?.dispose();
    passwordFieldTextController?.dispose();
  }
}
