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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/main.dart';

Future<String> setPreferredLanguage(
  BuildContext context,
  String authToken,
  String languageCode,
) async {
  var code = languageCode.trim().toLowerCase();
  if (code.isEmpty) code = 'en';
  final appLocale = code;
  try {
    await FFLocalizations.storeLocale(appLocale);
    MyApp.of(context).setLocale(appLocale);
  } catch (_) {}

  if (authToken.isNotEmpty) {
    try {
      await http.post(
        Uri.parse(
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'authToken': authToken,
          'preferredLanguage': code,
        }),
      );
    } catch (_) {}
  }
  return code;
}
