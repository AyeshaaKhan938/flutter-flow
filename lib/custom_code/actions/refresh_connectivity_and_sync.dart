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
import 'package:shared_preferences/shared_preferences.dart';

/// Set by setPreferredLanguage when the member changes language offline.
const kPendingLanguageSyncKey = 'pending_language_sync';

Future<void> _syncPendingLanguage(String authToken) async {
  final prefs = await SharedPreferences.getInstance();
  final code = prefs.getString(kPendingLanguageSyncKey) ?? '';
  if (code.isEmpty || authToken.isEmpty) {
    return;
  }
  try {
    final response = await http.post(
      Uri.parse(
        'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'authToken': authToken,
        'preferredLanguage': code,
      }),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      await prefs.remove(kPendingLanguageSyncKey);
    }
  } catch (_) {}
}

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

  await _syncPendingLanguage(authToken);

  final pending = FFAppState().pendingOfflineWrites;
  final map = pending is Map
      ? Map<String, dynamic>.from(pending as Map)
      : <String, dynamic>{'reflections': [], 'progress': []};
  // Only sync work queued by the member signed in now; entries from
  // another account stay queued until that member signs back in.
  final uid = FirebaseAuth.instance.currentUser?.uid;
  bool mine(dynamic e) =>
      e is Map && (e['userId'] == null || e['userId'] == uid);
  final allReflections = List<dynamic>.from(map['reflections'] ?? const []);
  final allProgress = List<dynamic>.from(map['progress'] ?? const []);
  final reflections = allReflections.where(mine).toList();
  final progress = allProgress.where(mine).toList();

  if (reflections.isEmpty && progress.isEmpty) {
    return 'online';
  }

  if (authToken.isEmpty) {
    return 'online_pending_auth';
  }

  final http.Response response;
  try {
    response = await http.post(
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
  } catch (_) {
    // Connected to a network without internet; keep the queue for later.
    return 'sync_failed';
  }

  if (response.statusCode >= 200 && response.statusCode < 300) {
    FFAppState().update(() {
      FFAppState().pendingOfflineWrites = {
        'reflections': allReflections.where((e) => !mine(e)).toList(),
        'progress': allProgress.where((e) => !mine(e)).toList(),
      };
    });
    return 'synced';
  }

  return 'sync_failed';
}
