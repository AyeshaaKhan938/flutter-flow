import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'reset_password_page_widget.dart' show ResetPasswordPageWidget;
import 'package:flutter/material.dart';

class ResetPasswordPageModel extends FlutterFlowModel<ResetPasswordPageWidget> {
  ///  Local state fields for this page.

  String? email = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for ResetEmailField widget.
  FocusNode? resetEmailFieldFocusNode;
  TextEditingController? resetEmailFieldTextController;
  String? Function(BuildContext, String?)?
      resetEmailFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    resetEmailFieldFocusNode?.dispose();
    resetEmailFieldTextController?.dispose();
  }
}
