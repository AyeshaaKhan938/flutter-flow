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

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

Future<String> saveSignupProfile(String? displayName, String? phone,
    String? country, String? regionCity) async {
  displayName ??= '';
  phone ??= '';
  country ??= '';
  regionCity ??= '';
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'no_user';
    final token = await user.getIdToken();
    final p = phone.trim();
    final validPhone = RegExp(r'^[+()\-\s\d]{6,20}$').hasMatch(p) ? p : '';
    // Fire-and-forget so sign-up navigates immediately; failures are harmless
    // (the profile can be completed later).
    unawaited(http
        .post(
          Uri.parse(
            'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'authToken': token,
            'displayName': displayName.trim(),
            'phone': validPhone,
            'country': country.trim(),
            'regionCity': regionCity.trim(),
          }),
        )
        .timeout(const Duration(seconds: 20))
        .then((_) {}, onError: (_) {}));
    return 'started';
  } catch (_) {
    return 'error';
  }
}
