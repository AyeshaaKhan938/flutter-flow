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

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

Future<String> saveLessonProgressSmart(
  String authToken,
  String pathwayId,
  String lessonId,
  String dayNumber,
  String reflectionText,
) async {
  final results = await Connectivity().checkConnectivity();
  final offline =
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);

  FFAppState().update(() {
    FFAppState().isOffline = offline;
  });

  final now = DateTime.now();
  final clientWriteId =
      '${now.microsecondsSinceEpoch.toRadixString(36)}-${now.microsecond}';

  if (offline) {
    final pending = FFAppState().pendingOfflineWrites;
    final map = pending is Map
        ? Map<String, dynamic>.from(pending as Map)
        : <String, dynamic>{'reflections': [], 'progress': []};

    final reflections = List<dynamic>.from(map['reflections'] ?? const []);
    final progress = List<dynamic>.from(map['progress'] ?? const []);

    if (reflectionText.trim().isNotEmpty) {
      reflections.add({
        'clientWriteId': clientWriteId,
        'lessonId': lessonId,
        'text': reflectionText,
        'createdAt': now.toIso8601String(),
      });
    }

    progress.add({
      'pathwayId': pathwayId,
      'currentDay': int.tryParse(dayNumber) ?? 0,
      'completedLessons': [lessonId],
      'quizScores': <String, dynamic>{},
    });

    map['reflections'] = reflections;
    map['progress'] = progress;

    FFAppState().update(() {
      FFAppState().pendingOfflineWrites = map;
    });
    return 'queued';
  }

  final response = await http.post(
    Uri.parse(
      'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/saveLessonProgress',
    ),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'authToken': authToken,
      'pathwayId': pathwayId,
      'lessonId': lessonId,
      'dayNumber': dayNumber,
      'reflectionText': reflectionText,
      'clientWriteId': clientWriteId,
    }),
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    return 'error';
  }

  final pending = FFAppState().pendingOfflineWrites;
  final map = pending is Map
      ? Map<String, dynamic>.from(pending as Map)
      : <String, dynamic>{'reflections': [], 'progress': []};
  final reflections = List<dynamic>.from(map['reflections'] ?? const []);
  final progress = List<dynamic>.from(map['progress'] ?? const []);
  if (reflections.isNotEmpty || progress.isNotEmpty) {
    final syncResponse = await http.post(
      Uri.parse(
        'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/syncOfflineProgressHttp',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authToken': authToken,
        'reflections': reflections,
        'progress': progress,
      }),
    );
    if (syncResponse.statusCode >= 200 && syncResponse.statusCode < 300) {
      FFAppState().update(() {
        FFAppState().pendingOfflineWrites = jsonDecode(
          '{"reflections":[],"progress":[]}',
        );
      });
    }
  }

  return 'saved';
}
