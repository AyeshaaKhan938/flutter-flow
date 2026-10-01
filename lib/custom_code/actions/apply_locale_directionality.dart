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
import '/main.dart';
import '/custom_code/languages/language_registry.dart';

Future<String> applyLocaleDirectionality(
  BuildContext context,
  String languageCode,
) async {
  final code = languageCode.trim().toLowerCase();
  final appLocale = (code.isEmpty ? 'en' : code);
  try {
    await FFLocalizations.storeLocale(appLocale);
    MyApp.of(context).setLocale(appLocale);
  } catch (_) {}
  return LanguageRegistry.instance.isRtl(appLocale) ? 'rtl' : 'ltr';
}
