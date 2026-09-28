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
import 'package:http/http.dart' as http;

/// Fetches live Scripture text from the free Bible API (bible-api.com).
///
/// bible-api.com only serves English-language translations without an API
/// key, so this is used as the primary source for English users. Callers
/// should fall back to the locally stored Scripture text (or the
/// BibleGateway deep link) for other languages, offline devices, or when
/// this returns an empty string.
Future<String> fetchBibleVerseApi(
  String scriptureRef,
  String languageCode,
) async {
  final ref = scriptureRef.trim();
  if (ref.isEmpty || languageCode.trim().toLowerCase() != 'en') {
    return '';
  }

  final uri = Uri.https('bible-api.com', '/$ref', {'translation': 'kjv'});

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) {
      return '';
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['text'] as String? ?? '').trim();
  } catch (_) {
    return '';
  }
}
