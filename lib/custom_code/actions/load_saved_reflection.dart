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

/// Returns the member's most recent reflection for a lesson, so the lesson
/// page can pre-fill the reflection field instead of starting blank.
///
/// Checks reflections still queued offline first (they are newer than
/// anything on the server), then the `reflections` collection. Returns an
/// empty string when nothing has been saved yet.
Future<String> loadSavedReflection(String? userId, String? lessonId) async {
  userId ??= '';
  lessonId ??= '';
  if (userId.isEmpty || lessonId.isEmpty) {
    return '';
  }

  final pending = FFAppState().pendingOfflineWrites;
  if (pending is Map) {
    final queued = List<dynamic>.from(pending['reflections'] ?? const [])
        .whereType<Map>()
        .where((r) => r['lessonId'] == lessonId)
        .toList();
    if (queued.isNotEmpty) {
      return (queued.last['text'] as String? ?? '').trim();
    }
  }

  try {
    final saved = await queryReflectionsRecordOnce(
      queryBuilder: (reflectionsRecord) => reflectionsRecord
          .where('userId', isEqualTo: userId)
          .where('lessonId', isEqualTo: lessonId),
    );
    if (saved.isEmpty) {
      return '';
    }
    // Sorted client-side to avoid needing a composite Firestore index.
    saved.sort((a, b) => (a.createdAt ?? DateTime(0))
        .compareTo(b.createdAt ?? DateTime(0)));
    return saved.last.text.trim();
  } catch (_) {
    return '';
  }
}
