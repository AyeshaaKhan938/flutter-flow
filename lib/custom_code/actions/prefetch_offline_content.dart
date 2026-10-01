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
import '/backend/api_requests/api_manager.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';
import '/flutter_flow/internationalization.dart' show kTranslationsMap;

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
    // Pick up languages added or changed in the CMS.
    await LanguageRegistry.instance.refresh();
    // Same resolution the pages use, so cached calls match theirs.
    final language = LanguageRegistry.resolveMemberLanguage(
        (profile.jsonBody is Map ? profile.jsonBody['preferredLanguage'] : null)
                as String? ??
            '');
    final backendCalls = await Future.wait([
      GetUserProfileV2Call.call(authToken: token),
      GetUserProfileV3Call.call(authToken: token),
      GetUserProfileV5Call.call(authToken: token),
      GetTodayContentCall.call(authToken: token),
      GetAssessmentQuestionsCall.call(authToken: token, locale: language),
      GetAssessmentQuestionsCall.call(authToken: token, locale: 'en'),
    ]);

    // Content for the Firestore offline cache.
    final pathways = await queryPathwaysRecordOnce(limit: 100);
    final lessons = await queryLessonsRecordOnce(
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
    final quizResponses = <ApiCallResponse>[];
    for (final quizId in quizIds) {
      quizResponses.add(await GetQuizV2Call.call(
        authToken: token,
        quizId: quizId,
        locale: language,
      ));
      await GetQuizAttemptCall.call(authToken: token, quizId: quizId);
    }

    await _prefetchTranslations(
      language,
      force: force,
      pathways: pathways,
      lessons: lessons,
      today: backendCalls[3],
      assessment: backendCalls[4],
      quizzes: quizResponses,
    );

    await prefs.setString(_kLastPrefetchKey, DateTime.now().toIso8601String());
  } catch (_) {
    // Best effort: whatever was fetched stays cached.
  } finally {
    _prefetchRunning = false;
  }
}

/// Downloads machine/reviewed translations of everything the member may
/// read in [language], so CMS-added languages also work offline. Best
/// effort. Scripture (lesson scriptureText, Bible passages) is never sent.
Future<void> _prefetchTranslations(
  String language, {
  required bool force,
  required List<PathwaysRecord> pathways,
  required List<LessonsRecord> lessons,
  required ApiCallResponse today,
  required ApiCallResponse assessment,
  required List<ApiCallResponse> quizzes,
}) async {
  if (!LanguageRegistry.instance.allowsMachineTranslation(language)) {
    return;
  }
  try {
    final texts = <String>{
      kMachineTranslationNotice,
      kEnglishBibleNotice,
    };
    void add(LocaleTextStruct t) {
      if (t.storedText(language).isEmpty && t.en.isNotEmpty) {
        texts.add(t.en);
      }
    }

    for (final p in pathways.where((p) => p.status == 'published')) {
      add(p.title);
      add(p.description);
    }
    for (final l in lessons) {
      add(l.title);
      add(l.reflectionPrompt);
      add(l.application);
      add(l.prayer);
    }
    final announcements = await queryAnnouncementsRecordOnce(limit: 20);
    for (final a in announcements) {
      add(a.title);
      add(a.body);
    }
    // Daily Truth commentary and encouragements for the coming week.
    final now = DateTime.now();
    final dates = {
      for (var i = 0; i < 7; i++)
        DateFormat('MM-dd').format(now.add(Duration(days: i))),
    };
    final daily = await queryDailyScriptureRecordOnce(
      queryBuilder: (q) => q.where('date', whereIn: dates.toList()),
    );
    for (final d in daily.where((d) => d.status == 'published')) {
      add(d.text);
    }
    final encouragements = await queryEncouragementsRecordOnce(
      queryBuilder: (q) => q.where('date', whereIn: dates.toList()),
    );
    for (final e in encouragements.where((e) => e.status == 'published')) {
      add(e.quote);
    }

    if (LanguageRegistry.needsClientTranslation(language)) {
      // The backend answers these languages in English.
      void addJson(ApiCallResponse r, RegExp keys) {
        final body = r.jsonBody;
        if (r.succeeded && body is Map) {
          body.forEach((k, v) {
            if (v is String && v.isNotEmpty && keys.hasMatch('$k')) {
              texts.add(v);
            }
          });
        }
      }

      addJson(today, RegExp(r'^(scriptureText|encouragementText)$'));
      addJson(assessment, kAssessmentTextKeys);
      for (final q in quizzes) {
        addJson(q, kQuizTextKeys);
      }
      // UI labels (compiled languages have their own).
      for (final entry in kTranslationsMap.values) {
        final en = entry['en'] ?? '';
        if (en.isNotEmpty) {
          texts.add(en);
        }
      }
    }
    await TranslationService.instance.prefetch(texts, language, refresh: force);
  } catch (_) {}
}
