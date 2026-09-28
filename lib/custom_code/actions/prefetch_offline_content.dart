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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/backend/api_requests/api_calls.dart';

const _kLastPrefetchKey = 'offline_prefetch_last';
const _kPrefetchInterval = Duration(minutes: 30);

bool _prefetchRunning = false;

/// Downloads everything the member may open, in the background, so the
/// whole app works offline, including screens never opened before.
///
/// - Firestore: all published pathways, lessons and quizzes, and the
///   member's reflections, go into the offline cache.
/// - Backend calls: profile, today's content, progress for every pathway,
///   and every quiz, made with the exact parameters the pages use, so
///   OfflineApiCache can answer them offline.
///
/// Runs at most every 30 minutes; pass [force] to run anyway.
Future prefetchOfflineContent({bool force = false}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null || _prefetchRunning) {
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  final last = DateTime.tryParse(prefs.getString(_kLastPrefetchKey) ?? '');
  if (!force &&
      last != null &&
      DateTime.now().difference(last) < _kPrefetchInterval) {
    return;
  }
  _prefetchRunning = true;
  try {
    final token = await user.getIdToken() ?? '';

    // Profile calls used across pages (each is cached separately).
    final profile = await GetUserProfileV4Call.call(authToken: token);
    if (!profile.succeeded) {
      return; // Offline or server down: try again later.
    }
    final language =
        (profile.jsonBody is Map ? profile.jsonBody['preferredLanguage'] : null)
                as String? ??
            '';
    await Future.wait([
      GetUserProfileV2Call.call(authToken: token),
      GetUserProfileV3Call.call(authToken: token),
      GetUserProfileV5Call.call(authToken: token),
      GetTodayContentCall.call(authToken: token),
      GetAssessmentQuestionsCall.call(authToken: token, locale: language),
      GetAssessmentQuestionsCall.call(authToken: token, locale: 'en'),
    ]);

    // Content for the Firestore offline cache.
    final pathways = await queryPathwaysRecordOnce(limit: 100);
    await queryLessonsRecordOnce(
      queryBuilder: (q) => q.where('status', isEqualTo: 'published'),
      limit: 1000,
    );
    final quizzes = await queryQuizzesRecordOnce();
    await queryReflectionsRecordOnce(
      queryBuilder: (q) => q.where('userId', isEqualTo: user.uid),
    );

    for (final pathway in pathways) {
      if (pathway.status == 'published' && pathway.stableId.isNotEmpty) {
        await GetPathwayProgressCall.call(
          authToken: token,
          pathwayId: pathway.stableId,
        );
      }
    }

    // Same quiz ids the lesson page opens (stableId, else document id).
    final quizIds = {
      for (final quiz in quizzes)
        if (quiz.status == 'published')
          quiz.stableId.isNotEmpty ? quiz.stableId : quiz.reference.id,
      'come-and-see-quiz-1',
      'come-and-see-quiz-2',
      'rooted-in-christ-quiz-1',
    };
    for (final quizId in quizIds) {
      await GetQuizV2Call.call(
        authToken: token,
        quizId: quizId,
        locale: language,
      );
      await GetQuizAttemptCall.call(authToken: token, quizId: quizId);
    }

    await prefs.setString(_kLastPrefetchKey, DateTime.now().toIso8601String());
  } catch (_) {
    // Best effort: whatever was fetched stays cached.
  } finally {
    _prefetchRunning = false;
  }
}
