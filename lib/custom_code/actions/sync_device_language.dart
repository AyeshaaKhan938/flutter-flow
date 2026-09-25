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
import '/main.dart';
import '/flutter_flow/nav/nav.dart';

const _profileBase =
    'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net';

Future<String> syncDeviceLanguage() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'no_user';
    final token = await user.getIdToken();
    final deviceCode = FFLocalizations.getStoredLocale()?.languageCode ?? '';

    if (deviceCode.isNotEmpty) {
      // Phone already has a language: make the profile match it.
      unawaited(http
          .post(
            Uri.parse('$_profileBase/updateUserProfile'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(
                {'authToken': token, 'preferredLanguage': deviceCode}),
          )
          .timeout(const Duration(seconds: 20))
          .then((_) {}, onError: (_) {}));
      return deviceCode;
    }

    // No language on this phone yet: use the one saved on the profile.
    final res = await http
        .post(
          Uri.parse('$_profileBase/getUserProfile'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authToken': token}),
        )
        .timeout(const Duration(seconds: 15));
    final profileCode = '${jsonDecode(res.body)['preferredLanguage'] ?? ''}';
    if (profileCode.isEmpty || profileCode == 'en') return 'en';
    await FFLocalizations.storeLocale(profileCode);
    final ctx = appNavigatorKey.currentContext;
    if (ctx != null) MyApp.of(ctx).setLocale(profileCode);
    return profileCode;
  } catch (_) {
    return 'error';
  }
}
