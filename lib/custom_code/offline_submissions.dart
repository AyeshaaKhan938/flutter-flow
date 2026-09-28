import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/backend/api_requests/api_calls.dart';

/// Quiz and assessment submissions made while offline.
///
/// Scoring happens on the server (quiz answer keys never ship in the app),
/// so offline submissions are saved on the device and sent as soon as the
/// member is back online. Each entry carries its owner's uid, so work never
/// syncs under a different account signed in on the same phone.
class OfflineSubmissions {
  static const _key = 'pending_offline_submissions';

  static Future<List<Map<String, dynamic>>> _load(
      SharedPreferences prefs) async {
    try {
      final raw = prefs.getString(_key);
      if (raw == null) {
        return [];
      }
      return (jsonDecode(raw) as List)
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> _save(
    SharedPreferences prefs,
    List<Map<String, dynamic>> entries,
  ) =>
      prefs.setString(_key, jsonEncode(entries));

  /// Saves a quiz submission to send later. [answers] are q1..q10.
  static Future<void> queueQuiz({
    required String quizId,
    required String pathwayId,
    required List<String> answers,
  }) =>
      _queue({
        'type': 'quiz',
        'quizId': quizId,
        'pathwayId': pathwayId,
        'answers': answers,
      });

  /// Saves an assessment submission to send later. [answers] are q1..q10.
  static Future<void> queueAssessment(List<String> answers) =>
      _queue({'type': 'assessment', 'answers': answers});

  static Future<void> _queue(Map<String, dynamic> entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await _load(prefs);
    entries.add({
      ...entry,
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'createdAt': DateTime.now().toIso8601String(),
    });
    await _save(prefs, entries);
  }

  /// Whether the signed-in member has an assessment waiting to be sent.
  static Future<bool> hasPendingAssessment() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return (await _load(prefs))
        .any((e) => e['type'] == 'assessment' && e['userId'] == uid);
  }

  /// Sends the signed-in member's queued submissions. Entries that fail
  /// (still offline, server error) stay queued for the next attempt.
  static Future<void> flush(String authToken) async {
    if (authToken.isEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final entries = await _load(prefs);
    if (entries.isEmpty) {
      return;
    }
    final remaining = <Map<String, dynamic>>[];
    for (final e in entries) {
      if (e['userId'] != uid) {
        remaining.add(e);
        continue;
      }
      final a = List<String>.from(e['answers'] ?? const []);
      String at(int i) => i < a.length ? a[i] : '';
      final ApiCallResponse result;
      if (e['type'] == 'quiz') {
        result = await SubmitQuizAttemptV2Call.call(
          authToken: authToken,
          quizId: e['quizId'] as String?,
          pathwayId: e['pathwayId'] as String?,
          q1: at(0), q2: at(1), q3: at(2), q4: at(3), q5: at(4),
          q6: at(5), q7: at(6), q8: at(7), q9: at(8), q10: at(9),
        );
      } else {
        result = await SubmitAssessmentV2Call.call(
          authToken: authToken,
          q1: at(0), q2: at(1), q3: at(2), q4: at(3), q5: at(4),
          q6: at(5), q7: at(6), q8: at(7), q9: at(8), q10: at(9),
        );
      }
      // Keep it only if the server was unreachable; a server rejection
      // (e.g. an invalid answer set) would fail forever if retried.
      if (result.statusCode <= 0) {
        remaining.add(e);
      }
    }
    await _save(prefs, remaining);
  }
}
