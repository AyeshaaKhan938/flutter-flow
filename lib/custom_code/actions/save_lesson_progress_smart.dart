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
import 'package:firebase_auth/firebase_auth.dart';

Future<String> saveLessonProgressSmart(String? authToken, String? pathwayId,
    String? lessonId, String? dayNumber, String? reflectionText) async {
  authToken ??= '';
  pathwayId ??= '';
  lessonId ??= '';
  dayNumber ??= '';
  reflectionText ??= '';
  final results = await Connectivity().checkConnectivity();
  final offline =
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);

  FFAppState().update(() {
    FFAppState().isOffline = offline;
  });

  final now = DateTime.now();
  final clientWriteId =
      '${now.microsecondsSinceEpoch.toRadixString(36)}-${now.microsecond}';

  // Non-null copies: parameters reassigned above don't stay promoted
  // inside the closure below.
  final reflection = reflectionText;
  final day = dayNumber;

  // Queue the completion (and reflection) locally; it syncs on reconnect.
  String queueOffline() {
    final pending = FFAppState().pendingOfflineWrites;
    final map = pending is Map
        ? Map<String, dynamic>.from(pending as Map)
        : <String, dynamic>{'reflections': [], 'progress': []};

    final reflections = List<dynamic>.from(map['reflections'] ?? const []);
    final progress = List<dynamic>.from(map['progress'] ?? const []);

    if (reflection.trim().isNotEmpty) {
      reflections.add({
        // Tag queued work with its owner so it never syncs under another
        // account signed in on the same device.
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'clientWriteId': clientWriteId,
        'lessonId': lessonId,
        'text': reflection,
        'createdAt': now.toIso8601String(),
      });
    }

    progress.add({
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'pathwayId': pathwayId,
      'currentDay': int.tryParse(day) ?? 0,
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

  if (offline) {
    return queueOffline();
  }

  final http.Response response;
  try {
    response = await http.post(
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
  } catch (_) {
    // On a network but can't reach the server: keep the member's work.
    return queueOffline();
  }

  if (response.statusCode < 200 || response.statusCode >= 300) {
    return 'error';
  }

  // Flush anything queued offline by this member (filtered per user).
  try {
    await refreshConnectivityAndSync(authToken);
  } catch (_) {}

  return 'saved';
}
