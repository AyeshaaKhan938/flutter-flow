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

import 'package:shared_preferences/shared_preferences.dart';

// The quiz API only returns a score for past attempts, not the answers, so
// the member's last submitted answers are kept on the device to let them
// review a completed quiz without retaking it.

String _quizAnswersKey(String userId, String quizId) =>
    'quiz_answers_${userId}_$quizId';

Future saveQuizAnswers(
  String? userId,
  String? quizId,
  List<String> answers,
) async {
  if ((userId ?? '').isEmpty || (quizId ?? '').isEmpty) {
    return;
  }
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_quizAnswersKey(userId!, quizId!), answers);
  } catch (_) {}
}

/// Returns the last submitted answers ('A'-'D' or '' per question), or an
/// empty list if none are stored on this device.
Future<List<String>> loadQuizAnswers(String? userId, String? quizId) async {
  if ((userId ?? '').isEmpty || (quizId ?? '').isEmpty) {
    return [];
  }
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_quizAnswersKey(userId!, quizId!)) ?? [];
  } catch (_) {
    return [];
  }
}
