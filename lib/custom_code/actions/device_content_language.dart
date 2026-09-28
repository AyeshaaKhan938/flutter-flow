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

Future<String> deviceContentLanguage() async {
  final code = FFLocalizations.getStoredLocale()?.languageCode ?? '';
  // Pages fall back to English per field when a translation is missing.
  return (code == 'es' || code == 'ur' || code == 'lg') ? code : 'en';
}
