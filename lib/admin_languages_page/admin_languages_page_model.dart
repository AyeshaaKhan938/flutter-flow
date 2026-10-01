import '/flutter_flow/flutter_flow_util.dart';
import 'admin_languages_page_widget.dart' show AdminLanguagesPageWidget;
import 'package:flutter/material.dart';

class AdminLanguagesPageModel
    extends FlutterFlowModel<AdminLanguagesPageWidget> {
  /// null while the role lookup is in flight.
  bool? isAdmin;

  /// Language whose translations are being reviewed.
  String? reviewLanguage;

  /// 'machine' (awaiting review), 'approved', or null for all.
  String? reviewStatus = 'machine';

  String reviewSearch = '';

  /// Progress text of "Generate translations", null when idle.
  String? generateProgress;

  /// Corrected-text editors, by machineTranslations doc id.
  final Map<String, TextEditingController> editors = {};

  /// Doc ids with an approve/reject in flight.
  final Set<String> busy = {};

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    for (final c in editors.values) {
      c.dispose();
    }
  }
}
