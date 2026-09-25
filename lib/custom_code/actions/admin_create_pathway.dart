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

Future<String> adminCreatePathway(String? title, String? stableId) async {
  title ??= '';
  stableId ??= '';
  final trimmedTitle = title.trim();
  final trimmedId = stableId.trim();
  if (trimmedTitle.isEmpty || trimmedId.isEmpty) {
    return 'missing_fields';
  }

  await FirebaseFirestore.instance.collection('pathways').add({
    'stableId': trimmedId,
    'status': 'draft',
    'durationDays': 14,
    'order': 99,
    'title': {'en': trimmedTitle, 'es': trimmedTitle, 'ur': trimmedTitle},
    'description': {
      'en': 'Draft pathway',
      'es': 'Draft pathway',
      'ur': 'Draft pathway',
    },
  });
  return 'created';
}
