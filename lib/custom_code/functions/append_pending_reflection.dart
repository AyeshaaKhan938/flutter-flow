import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

/// Appends a reflection entry (with clientWriteId) to
/// pendingOfflineWrites.reflections.
dynamic appendPendingReflection(
  dynamic current,
  String? lessonId,
  String? text,
) {
  final map = current is Map
      ? Map<String, dynamic>.from(current as Map)
      : <String, dynamic>{'reflections': [], 'progress': []};
  final reflections = List<dynamic>.from(map['reflections'] ?? []);
  final now = DateTime.now();
  final clientWriteId =
      '${now.microsecondsSinceEpoch.toRadixString(36)}-${now.microsecond}';
  reflections.add({
    'clientWriteId': clientWriteId,
    'lessonId': lessonId,
    'text': text,
    'createdAt': now.toIso8601String(),
  });
  map['reflections'] = reflections;
  map['progress'] = map['progress'] ?? [];
  return map;
}
