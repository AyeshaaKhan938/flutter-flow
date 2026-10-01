import 'dart:async';
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/backend/api_requests/api_manager.dart';
import 'language_registry.dart';

/// Shown wherever unreviewed machine translation is displayed.
const kMachineTranslationNotice =
    'Machine-translated — not yet reviewed by Kingdom Heirs';

/// Shown in the passage view when a language has no approved Bible.
const kEnglishBibleNotice =
    'Bible shown in English — no approved translation for this language';

enum TranslationStatus { none, machine, approved }

class _Entry {
  const _Entry(this.text, this.approved);
  final String text;
  final bool approved;
}

/// Translations of Kingdom Heirs-authored English text (never Scripture)
/// into the member's language.
///
/// Texts come from the `translateTexts` Cloud Function, which answers from
/// the shared `machineTranslations` cache (reviewed text first) and only
/// calls Google Cloud Translation for texts never translated before.
/// Results are kept in memory and on the device (SharedPreferences), so a
/// text is requested at most once per device and is readable offline.
///
/// [translate] never blocks: it returns the cached translation, or English
/// while a batched request is made; listeners are notified when it lands.
class TranslationService extends ChangeNotifier {
  TranslationService._();
  static final TranslationService instance = TranslationService._();

  static const _kPrefsPrefix = 'mt_cache_v1_';
  static const _kBatchSize = 100;
  static const _kMaxTextLength = 5000;

  /// language -> English source -> translation.
  final Map<String, Map<String, _Entry>> _cache = {};
  final Map<String, Future<void>> _loading = {};
  final Map<String, Set<String>> _pending = {};

  /// Texts that failed recently (offline / quota), so builds don't retry
  /// them in a loop. Cleared after [_kRetryAfter].
  final Map<String, DateTime> _failedAt = {};
  static const _kRetryAfter = Duration(minutes: 2);

  Timer? _flushTimer;
  Timer? _saveTimer;
  final Set<String> _dirtyLanguages = {};

  String _key(String lang, String text) => '$lang\u0000$text';

  /// Loads the device copy for [lang] (once).
  Future<void> loadLanguage(String lang) {
    final code = lang.trim().toLowerCase();
    if (code.isEmpty || code == 'en') {
      return Future.value();
    }
    return _loading.putIfAbsent(code, () async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final raw = prefs.getString('$_kPrefsPrefix$code');
        if (raw != null) {
          final map = jsonDecode(raw) as Map;
          final target = _cache.putIfAbsent(code, () => {});
          map.forEach((k, v) {
            if (v is List && v.isNotEmpty) {
              target.putIfAbsent(
                  '$k', () => _Entry('${v[0]}', v.length > 1 && v[1] == 1));
            }
          });
          notifyListeners();
        }
      } catch (_) {}
    });
  }

  bool _translatable(String english, String lang) =>
      english.trim().isNotEmpty &&
      english.length <= _kMaxTextLength &&
      LanguageRegistry.instance.allowsMachineTranslation(lang);

  /// [english] in [lang]: reviewed text, else machine text, else English
  /// (and a background request is scheduled).
  String translate(String english, String? lang) {
    final code = (lang ?? '').trim().toLowerCase();
    if (!_translatable(english, code)) {
      return english;
    }
    final entry = _cache[code]?[english];
    if (entry != null) {
      return entry.text;
    }
    loadLanguage(code);
    _schedule(english, code);
    return english;
  }

  TranslationStatus statusOf(String english, String? lang) {
    final code = (lang ?? '').trim().toLowerCase();
    final entry = _cache[code]?[english];
    if (entry == null) {
      return TranslationStatus.none;
    }
    return entry.approved
        ? TranslationStatus.approved
        : TranslationStatus.machine;
  }

  /// True when [english] is shown to the member as unreviewed machine text.
  bool isMachine(String english, String? lang) =>
      statusOf(english, lang) == TranslationStatus.machine;

  void _schedule(String english, String lang) {
    final failed = _failedAt[_key(lang, english)];
    if (failed != null && DateTime.now().difference(failed) < _kRetryAfter) {
      return;
    }
    if (FirebaseAuth.instance.currentUser == null) {
      return; // translateTexts is for signed-in members.
    }
    _pending.putIfAbsent(lang, () => {}).add(english);
    _flushTimer ??= Timer(const Duration(milliseconds: 400), _flush);
  }

  Future<void> _flush() async {
    _flushTimer = null;
    final work = Map<String, Set<String>>.from(_pending);
    _pending.clear();
    for (final entry in work.entries) {
      await _fetch(entry.key, entry.value.toList());
    }
  }

  /// Requests [texts] for [lang] from the server in batches. Returns true if
  /// every batch succeeded.
  Future<bool> _fetch(String lang, List<String> texts) async {
    var ok = true;
    var changed = false;
    for (var i = 0; i < texts.length; i += _kBatchSize) {
      final batch = texts.sublist(
          i, i + _kBatchSize > texts.length ? texts.length : i + _kBatchSize);
      try {
        final result = await FirebaseFunctions.instance
            .httpsCallable(
              'translateTexts',
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 60)),
            )
            .call({'targetLanguage': lang, 'texts': batch});
        final data = Map<String, dynamic>.from(result.data as Map);
        final list = (data['translations'] as List?) ?? const [];
        final target = _cache.putIfAbsent(lang, () => {});
        final now = DateTime.now();
        for (var j = 0; j < batch.length; j++) {
          final item = j < list.length
              ? Map<String, dynamic>.from(list[j] as Map)
              : const <String, dynamic>{};
          final text = '${item['text'] ?? ''}';
          if (text.isEmpty) {
            // No translation: don't re-request it on every rebuild.
            _failedAt[_key(lang, batch[j])] = now;
            continue;
          }
          final entry = _Entry(text, item['status'] == 'approved');
          final old = target[batch[j]];
          if (old == null ||
              old.text != entry.text ||
              old.approved != entry.approved) {
            target[batch[j]] = entry;
            changed = true;
          }
        }
        _dirtyLanguages.add(lang);
      } catch (_) {
        ok = false;
        final now = DateTime.now();
        for (final t in batch) {
          _failedAt[_key(lang, t)] = now;
        }
      }
    }
    if (changed) {
      _scheduleSave();
      notifyListeners();
    }
    return ok;
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      final langs = _dirtyLanguages.toList();
      _dirtyLanguages.clear();
      try {
        final prefs = await SharedPreferences.getInstance();
        for (final lang in langs) {
          final map = _cache[lang] ?? const {};
          await prefs.setString(
            '$_kPrefsPrefix$lang',
            jsonEncode({
              for (final e in map.entries)
                e.key: [e.value.text, e.value.approved ? 1 : 0],
            }),
          );
        }
      } catch (_) {}
    });
  }

  /// Downloads translations for [texts] now (e.g. for offline use).
  /// With [refresh], texts already cached as machine text are requested
  /// again so newly approved corrections reach the device.
  Future<bool> prefetch(
    Iterable<String> texts,
    String? lang, {
    bool refresh = false,
  }) async {
    final code = (lang ?? '').trim().toLowerCase();
    if (!LanguageRegistry.instance.allowsMachineTranslation(code)) {
      return true;
    }
    await loadLanguage(code);
    final cached = _cache[code] ?? const {};
    final wanted = texts
        .where((t) => _translatable(t, code))
        .where((t) {
          final e = cached[t];
          return e == null || (refresh && !e.approved);
        })
        .toSet()
        .toList();
    if (wanted.isEmpty) {
      return true;
    }
    return _fetch(code, wanted);
  }

  /// Returns a copy of a backend response whose text fields ([keys]) are
  /// translated into [lang], for languages the backend does not return
  /// (it answers those in English). Waits briefly for missing translations.
  Future<ApiCallResponse?> translateApiResponse(
    ApiCallResponse? response,
    String? lang,
    RegExp keys,
  ) async {
    if (response == null ||
        !LanguageRegistry.needsClientTranslation(lang) ||
        response.jsonBody is! Map) {
      return response;
    }
    final body = Map<String, dynamic>.from(response.jsonBody as Map);
    final texts = [
      for (final e in body.entries)
        if (e.value is String && keys.hasMatch(e.key)) e.value as String,
    ];
    try {
      await prefetch(texts, lang).timeout(const Duration(seconds: 20));
    } catch (_) {}
    for (final e in body.entries.toList()) {
      if (e.value is String && keys.hasMatch(e.key)) {
        body[e.key] = translate(e.value as String, lang);
      }
    }
    return ApiCallResponse(
      body,
      response.headers,
      response.statusCode,
      response: response.response,
      exception: response.exception,
    );
  }
}

/// Text fields of getQuiz responses (never answer letters or scores).
final kQuizTextKeys = RegExp(r'^(quizTitle|q\d+(Text|[A-D]))$');

/// Text fields of getAssessmentQuestions responses.
final kAssessmentTextKeys = RegExp(r'^q\d+(Label|[A-D])$');
