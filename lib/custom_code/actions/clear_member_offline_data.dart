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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Removes the signed-out member's private data from the device, so the
/// next member on the same phone can never see it, even offline.
///
/// Call before signing out. Work queued offline but not yet synced is kept
/// (it is tied to its owner and syncs when they sign back in); everything
/// else private (cached profile and progress responses, quiz answers, the
/// offline lesson copy with its reflection, and the Firestore offline
/// cache, which holds the member's reflections) is cleared.
Future clearMemberOfflineData() async {
  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  try {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys().toList()) {
      final private = (uid.isNotEmpty &&
              (key.startsWith('ff_offline_api_$uid') ||
                  key.startsWith('quiz_answers_$uid'))) ||
          key == 'offline_prefetch_last';
      if (private) {
        await prefs.remove(key);
      }
    }
  } catch (_) {}

  FFAppState().update(() {
    FFAppState().offlineLessonId = '';
    FFAppState().offlineLessonTitle = '';
    FFAppState().offlineLessonScriptureRef = '';
    FFAppState().offlineLessonScriptureText = '';
    FFAppState().offlineLessonReflection = '';
    FFAppState().userProfileCache = UserProfileEntryStruct();
  });

  // Firestore's offline cache can only be cleared while it is not in use.
  // The next member's sign-in downloads published content again.
  try {
    await FirebaseFirestore.instance.terminate();
    await FirebaseFirestore.instance.clearPersistence();
  } catch (_) {}
}
