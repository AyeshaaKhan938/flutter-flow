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
  String completedLessonsCsv,
  int completedCount,
  int totalLessons,
  String pathwayTitle,
) async {
  FFAppState().update(() {
    FFAppState().localProgressCsv = completedLessonsCsv;
    FFAppState().localCompletedCount = completedCount;
    FFAppState().localTotalLessons = totalLessons;
    FFAppState().localPathwayTitle = pathwayTitle;
  });
}
