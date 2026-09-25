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
import 'package:connectivity_plus/connectivity_plus.dart';

Future<String> openScriptureReferenceSafe(
    String? scriptureRef, String? languageCode) async {
  scriptureRef ??= '';
  languageCode ??= '';
  final ref = scriptureRef.trim();
  if (ref.isEmpty) {
    return 'empty';
  }

  final results = await Connectivity().checkConnectivity();
  final offline =
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);
  if (offline) {
    return 'fallback';
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

  try {
    final can = await canLaunchUrl(uri);
    if (!can) {
      return 'fallback';
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    return launched ? 'opened' : 'fallback';
  } catch (_) {
    return 'fallback';
  }
}
