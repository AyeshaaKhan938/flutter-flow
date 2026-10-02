import '/flutter_flow/flutter_flow_util.dart';
import 'admin_import_page_widget.dart' show AdminImportPageWidget;
import 'package:flutter/material.dart';

/// Content types accepted by the `importContentCsv` Cloud Function, with the
/// label shown in the dropdown. Formats: docs/import/README.md.
const kImportContentTypes = <String, String>{
  'pathways': 'Pathways',
  'lessons': 'Lessons',
  'quiz_questions': 'Quiz questions',
  'daily_scripture': 'Daily Scripture',
  'encouragements': 'Encouragements',
  'assessment_questions': 'Assessment questions',
};

class AdminImportPageModel extends FlutterFlowModel<AdminImportPageWidget> {
  ///  Local state fields for this page.

  /// null while the role lookup is in flight.
  bool? isAdmin;

  String contentType = 'pathways';

  /// The chosen file.
  String? fileName;
  String? csvText;
  // Kingdom Heirs original files (.xlsx masters, the .zip package) are sent
  // as base64 and read on the server.
  String? fileBase64;

  /// 'preview' or 'commit' while a call is in flight, else null.
  String? runningMode;

  /// The report on screen (from the last run, or a past job tapped).
  Map<String, dynamic>? report;

  /// Error from the last call (network, permission, ...).
  String? callError;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
