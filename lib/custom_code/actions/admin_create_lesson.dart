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

Future<String> adminCreateLesson(String? title, String? stableId,
    String? pathwayStableId, String? scriptureRef) async {
  title ??= '';
  stableId ??= '';
  pathwayStableId ??= '';
  scriptureRef ??= '';
  final trimmedTitle = title.trim();
  final trimmedId = stableId.trim();
  final trimmedPathway = pathwayStableId.trim();
  final trimmedRef = scriptureRef.trim();
  if (trimmedTitle.isEmpty || trimmedId.isEmpty || trimmedPathway.isEmpty) {
    return 'missing_fields';
  }

  final match = await FirebaseFirestore.instance
      .collection('pathways')
      .where('stableId', isEqualTo: trimmedPathway)
      .limit(1)
      .get();
  if (match.docs.isEmpty) {
    return 'pathway_not_found';
  }

  await match.docs.first.reference.collection('lessons').add({
    'stableId': trimmedId,
    'pathwayId': trimmedPathway,
    'status': 'draft',
    'dayNumber': 1,
    'scriptureRef': trimmedRef,
    'mediaUrl': '',
    'title': {'en': trimmedTitle, 'es': trimmedTitle, 'ur': trimmedTitle},
    'scriptureText': {
      'en': trimmedRef,
      'es': trimmedRef,
      'ur': trimmedRef,
    },
    'reflectionPrompt': {
      'en': 'What is God showing you today?',
      'es': 'What is God showing you today?',
      'ur': 'What is God showing you today?',
    },
  });
  return 'created';
}
