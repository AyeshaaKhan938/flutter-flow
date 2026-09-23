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

/// Appends a progress entry to pendingOfflineWrites.progress.
dynamic appendPendingProgress(
  dynamic current,
  String? pathwayId,
  int? currentDay,
  String? completedLessonId,
) {
  final map = current is Map
      ? Map<String, dynamic>.from(current as Map)
      : <String, dynamic>{'reflections': [], 'progress': []};
  final progress = List<dynamic>.from(map['progress'] ?? []);
  progress.add({
    'pathwayId': pathwayId,
    'currentDay': currentDay,
    'completedLessons': [completedLessonId],
    'quizScores': <String, dynamic>{},
  });
  map['progress'] = progress;
  map['reflections'] = map['reflections'] ?? [];
  return map;
}
