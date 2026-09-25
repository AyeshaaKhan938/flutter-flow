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

Future<String> adminUpdateLesson(
    String? pathwayStableId,
    String? stableId,
    String? title,
    String? scriptureRef,
    String? reflectionPrompt,
    String? status) async {
  pathwayStableId ??= '';
  stableId ??= '';
  title ??= '';
  scriptureRef ??= '';
  reflectionPrompt ??= '';
  status ??= '';
  final pathwayId = pathwayStableId.trim();
  final lessonId = stableId.trim();
  if (pathwayId.isEmpty || lessonId.isEmpty) {
    return 'missing_fields';
  }

  final pathwayMatch = await FirebaseFirestore.instance
      .collection('pathways')
      .where('stableId', isEqualTo: pathwayId)
      .limit(1)
      .get();
  if (pathwayMatch.docs.isEmpty) {
    return 'pathway_not_found';
  }

  final lessons = await pathwayMatch.docs.first.reference
      .collection('lessons')
      .where('stableId', isEqualTo: lessonId)
      .limit(1)
      .get();
  if (lessons.docs.isEmpty) {
    return 'not_found';
  }

  final updates = <String, dynamic>{};
  if (title.trim().isNotEmpty) {
    updates['title'] = {
      'en': title.trim(),
      'es': title.trim(),
      'ur': title.trim(),
    };
  }
  if (scriptureRef.trim().isNotEmpty) {
    updates['scriptureRef'] = scriptureRef.trim();
    updates['scriptureText'] = {
      'en': scriptureRef.trim(),
      'es': scriptureRef.trim(),
      'ur': scriptureRef.trim(),
    };
  }
  if (reflectionPrompt.trim().isNotEmpty) {
    updates['reflectionPrompt'] = {
      'en': reflectionPrompt.trim(),
      'es': reflectionPrompt.trim(),
      'ur': reflectionPrompt.trim(),
    };
  }
  if (status.trim().isNotEmpty) {
    updates['status'] = status.trim();
  }
  if (updates.isEmpty) {
    return 'missing_fields';
  }
  await lessons.docs.first.reference.set(updates, SetOptions(merge: true));
  return 'updated';
}
