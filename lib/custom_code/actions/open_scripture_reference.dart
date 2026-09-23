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

import 'package:url_launcher/url_launcher.dart';

Future openScriptureReference(String scriptureRef, String languageCode) async {
  final ref = scriptureRef.trim();
  if (ref.isEmpty) {
    return;
  }

  final lang = languageCode.trim().toLowerCase();
  final version = switch (lang) {
    'es' => 'RVR1960',
    'ur' => 'URDULB',
    'lg' => 'NIV',
    _ => 'NIV',
  };

  final uri = Uri.https('www.biblegateway.com', '/passage/', {
    'search': ref,
    'version': version,
  });

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    throw Exception('Could not open Bible passage for $ref');
  }
}
