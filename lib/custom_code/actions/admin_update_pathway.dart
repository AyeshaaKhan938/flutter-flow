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

Future<String> adminUpdatePathway(
  String stableId,
  String title,
  String status,
) async {
  final id = stableId.trim();
  if (id.isEmpty) {
    return 'missing_fields';
  }
  final match = await FirebaseFirestore.instance
      .collection('pathways')
      .where('stableId', isEqualTo: id)
      .limit(1)
      .get();
  if (match.docs.isEmpty) {
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
  if (status.trim().isNotEmpty) {
    updates['status'] = status.trim();
  }
  if (updates.isEmpty) {
    return 'missing_fields';
  }
  await match.docs.first.reference.set(updates, SetOptions(merge: true));
  return 'updated';
}
