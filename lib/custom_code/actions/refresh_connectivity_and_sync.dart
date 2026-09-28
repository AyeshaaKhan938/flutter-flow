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

Future<String> refreshConnectivityAndSync(String authToken) async {
  final results = await Connectivity().checkConnectivity();
  final offline =
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);

  FFAppState().update(() {
    FFAppState().isOffline = offline;
  });

  if (offline) {
    return 'offline';
  }

  final pending = FFAppState().pendingOfflineWrites;
  final map = pending is Map
      ? Map<String, dynamic>.from(pending as Map)
      : <String, dynamic>{'reflections': [], 'progress': []};
  final reflections = List<dynamic>.from(map['reflections'] ?? const []);
  final progress = List<dynamic>.from(map['progress'] ?? const []);

  if (reflections.isEmpty && progress.isEmpty) {
    return 'online';
  }

  if (authToken.isEmpty) {
    return 'online_pending_auth';
  }

  final response = await http.post(
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

  if (response.statusCode >= 200 && response.statusCode < 300) {
    FFAppState().update(() {
      FFAppState().pendingOfflineWrites = jsonDecode(
        '{"reflections":[],"progress":[]}',
      );
    });
    return 'synced';
  }

  return 'sync_failed';
}
