// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future persistPathwayProgressLocal(
  String? completedLessonsCsv,
  int? completedCount,
  int? totalLessons,
  String? pathwayTitle,
) async {
  final csv = completedLessonsCsv ?? '';
  final done = completedCount ?? 0;
  final total = totalLessons ?? 0;
  final title = pathwayTitle ?? '';
  FFAppState().update(() {
    FFAppState().localProgressCsv = csv;
    FFAppState().localCompletedCount = done;
    FFAppState().localTotalLessons = total;
    FFAppState().localPathwayTitle = title;
  });
}
