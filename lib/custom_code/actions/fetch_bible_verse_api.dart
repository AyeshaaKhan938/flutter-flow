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

import 'dart:convert';
import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '/custom_code/bible_reference.dart';
import '/custom_code/languages/language_registry.dart';

/// Passages normally come from the `getBiblePassage` Cloud Function, which
/// holds the API.Bible key in Secret Manager so it is never in the app.
/// A build-time key (`--dart-define-from-file=api_keys.json`) is only a
/// transitional fallback for builds made before that function is deployed;
/// release builds should be made without it.
const _apiBibleKey = String.fromEnvironment('API_BIBLE_KEY');

/// Default Bible per built-in language (API.Bible ids). A language's
/// `bibleId` in the CMS `languages` collection takes precedence; a language
/// with neither shows the English Bible with a note. Scripture is never
/// machine-translated.
const _bibleIds = {
  'en': '78a9f6124f344018-01', // New International Version 2011
  'es': '592420522e16049f-01', // Reina Valera 1909
  'ur': 'eecbca904435fce9-01', // Biblica Open Urdu Contemporary Version
  'lg': 'f276be3571f516cb-01', // Biblica Open Luganda Contemporary Bible
};

const _versionNames = {
  'en': 'NIV',
  'es': 'RVR1909',
  'ur': 'OUCV',
  'lg': 'EEEE',
};

/// The Bible to use for [languageCode]: (language key, bibleId, version).
/// Falls back to English when the language has no approved Bible.
({String lang, String bibleId, String version}) _bibleFor(String languageCode) {
  final lang = LanguageRegistry.instance.byCode(languageCode);
  if (lang != null && lang.bibleId.isNotEmpty) {
    return (
      lang: lang.code,
      bibleId: lang.bibleId,
      version: lang.bibleName.isNotEmpty
          ? lang.bibleName
          : (_versionNames[lang.code] ?? ''),
    );
  }
  final code = _bibleIds.containsKey(languageCode) ? languageCode : 'en';
  return (lang: code, bibleId: _bibleIds[code]!, version: _versionNames[code]!);
}

/// A Scripture passage with the attribution API.Bible requires us to show.
class BiblePassage {
  const BiblePassage({
    required this.reference,
    required this.text,
    required this.version,
    required this.copyright,
    this.fromCache = false,
    this.englishFallback = false,
  });

  /// True when the member's language has no approved Bible, so the English
  /// Bible is shown (the reader must say so).
  final bool englishFallback;

  BiblePassage withEnglishFallback(bool value) => BiblePassage(
        reference: reference,
        text: text,
        version: version,
        copyright: copyright,
        fromCache: fromCache,
        englishFallback: value,
      );

  final String reference;
  final String text;
  final String version;
  final String copyright;

  /// True when shown from the on-device copy because the member is offline.
  final bool fromCache;

  Map<String, dynamic> toMap() => {
        'reference': reference,
        'text': text,
        'version': version,
        'copyright': copyright,
      };

  static BiblePassage fromMap(Map<String, dynamic> m,
          {bool fromCache = false}) =>
      BiblePassage(
        reference: m['reference'] as String? ?? '',
        text: m['text'] as String? ?? '',
        version: m['version'] as String? ?? '',
        copyright: m['copyright'] as String? ?? '',
        fromCache: fromCache,
      );
}

/// Fetches the full passage for [scriptureRef] in the member's language.
///
/// Uses API.Bible through the server, otherwise bible-api.com (English KJV
/// only). Every fetched passage is kept on the device, so a passage
/// opened once is still readable offline. Returns null when nothing can be
/// shown; callers then fall back to the Bible deep link.
Future<BiblePassage?> fetchBiblePassage(
  String scriptureRef,
  String? languageCode,
) async {
  final ref = scriptureRef.trim();
  if (ref.isEmpty) {
    return null;
  }
  final requested = (languageCode ?? 'en').trim().toLowerCase();
  final bible = _bibleFor(requested.isEmpty ? 'en' : requested);
  final lang = bible.lang;
  final englishFallback = lang == 'en' && requested.isNotEmpty && requested != 'en';
  final cacheKey = 'bible_passage_${lang}_$ref';

  BiblePassage? passage;
  try {
    passage = await _fetchFromServer(ref, bible.bibleId, bible.version);
    if (passage == null && _apiBibleKey.isNotEmpty) {
      passage = await _fetchFromApiBible(ref, bible.bibleId, bible.version);
    }
    if (passage == null && lang == 'en') {
      passage = await _fetchFromBibleApiCom(ref);
    }
  } catch (_) {
    passage = null;
  }

  final prefs = await SharedPreferences.getInstance();
  if (passage != null && passage.text.isNotEmpty) {
    try {
      await prefs.setString(cacheKey, jsonEncode(passage.toMap()));
    } catch (_) {}
    return passage.withEnglishFallback(englishFallback);
  }

  final cached = prefs.getString(cacheKey);
  if (cached != null) {
    try {
      return BiblePassage.fromMap(
        Map<String, dynamic>.from(jsonDecode(cached) as Map),
        fromCache: true,
      ).withEnglishFallback(englishFallback);
    } catch (_) {}
  }
  return null;
}

String _cleanPassageText(String content) => content
    .replaceAll(RegExp(r'[ \t]+'), ' ')
    .replaceAll(RegExp(r'\s*\n\s*'), '\n')
    .trim();

/// API.Bible through the `getBiblePassage` Cloud Function (key stays on the
/// server). Returns null when the function is unreachable or not deployed.
Future<BiblePassage?> _fetchFromServer(
    String ref, String bibleId, String version) async {
  final parsed = BibleReference.parse(ref);
  if (parsed == null) {
    return null;
  }
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable(
          'getBiblePassage',
          options: HttpsCallableOptions(timeout: const Duration(seconds: 15)),
        )
        .call({
      'bibleId': bibleId,
      'passageId': parsed.apiBiblePassageId,
    });
    final data = Map<String, dynamic>.from(result.data as Map);
    final fumsToken = data['fumsToken'] as String? ?? '';
    if (fumsToken.isNotEmpty) {
      _reportFums(fumsToken);
    }
    return BiblePassage(
      reference: data['reference'] as String? ?? ref,
      text: _cleanPassageText(data['content'] as String? ?? ''),
      version: version,
      copyright: (data['copyright'] as String? ?? '').trim(),
    );
  } catch (_) {
    return null;
  }
}

Future<BiblePassage?> _fetchFromApiBible(
    String ref, String bibleId, String version) async {
  final parsed = BibleReference.parse(ref);
  if (parsed == null) {
    return null;
  }
  final uri = Uri.https(
    'api.scripture.api.bible',
    '/v1/bibles/$bibleId/passages/${parsed.apiBiblePassageId}',
    {
      'content-type': 'text',
      'include-notes': 'false',
      'include-titles': 'false',
      'include-chapter-numbers': 'false',
      'include-verse-numbers': 'true',
    },
  );
  final response = await http.get(uri,
      headers: {'api-key': _apiBibleKey}).timeout(const Duration(seconds: 10));
  if (response.statusCode != 200) {
    return null;
  }
  final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  final data = Map<String, dynamic>.from(body['data'] as Map? ?? const {});
  final fumsToken = (body['meta'] as Map?)?['fumsToken'] as String?;
  if (fumsToken != null && fumsToken.isNotEmpty) {
    _reportFums(fumsToken);
  }
  final text = _cleanPassageText(data['content'] as String? ?? '');
  return BiblePassage(
    reference: data['reference'] as String? ?? ref,
    text: text,
    version: version,
    copyright: (data['copyright'] as String? ?? '').trim(),
  );
}

Future<BiblePassage?> _fetchFromBibleApiCom(String ref) async {
  final uri = Uri.https('bible-api.com', '/$ref', {'translation': 'kjv'});
  final response = await http.get(uri).timeout(const Duration(seconds: 8));
  if (response.statusCode != 200) {
    return null;
  }
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  return BiblePassage(
    reference: data['reference'] as String? ?? ref,
    text: (data['text'] as String? ?? '').trim(),
    version: 'KJV',
    copyright: 'King James Version (public domain)',
  );
}

final _fumsSessionId = _randomId();

/// API.Bible's Fair Use Management System: each displayed passage must be
/// reported with its fumsToken. Fire-and-forget; never blocks the reader.
Future<void> _reportFums(String token) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString('fums_device_id');
    if (deviceId == null) {
      deviceId = _randomId();
      await prefs.setString('fums_device_id', deviceId);
    }
    await http
        .get(Uri.https('fums.api.bible', '/f3', {
          't': token,
          'dId': deviceId,
          'sId': _fumsSessionId,
        }))
        .timeout(const Duration(seconds: 10));
  } catch (_) {}
}

String _randomId() {
  final rng = Random.secure();
  return List.generate(
      16, (_) => rng.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
}

/// Plain-text passage for older callers; empty when unavailable.
Future<String> fetchBibleVerseApi(
  String scriptureRef,
  String languageCode,
) async {
  final passage = await fetchBiblePassage(scriptureRef, languageCode);
  return passage?.text ?? '';
}
