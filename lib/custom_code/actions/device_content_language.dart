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

import '/custom_code/languages/language_registry.dart';

Future<String> deviceContentLanguage() async {
  // Any language from the CMS registry. Pages fall back per field to the
  // reviewed/machine translation of the English text, then to English.
  final code = LanguageRegistry.contentLanguage;
  return code.isNotEmpty ? code : 'en';
}
