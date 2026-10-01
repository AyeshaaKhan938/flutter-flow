import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One entry of the `languages/{code}` CMS collection.
///
/// - [tier] 'approved': content reviewed by Kingdom Heirs.
///   'machine': Google machine translation, shown with a notice until an
///   administrator approves each text.
/// - [bibleId]: API.Bible id for Scripture in this language. Empty means the
///   English Bible is shown with a note. Scripture is never machine-translated.
class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.name,
    required this.englishName,
    this.rtl = false,
    this.tier = 'machine',
    this.active = true,
    this.order = 100,
    this.bibleId = '',
    this.bibleName = '',
    this.googleCode = '',
  });

  final String code;
  final String name;
  final String englishName;
  final bool rtl;
  final String tier;
  final bool active;
  final int order;
  final String bibleId;
  final String bibleName;

  /// Code Google Cloud Translation uses, when it differs from [code].
  final String googleCode;

  bool get isApproved => tier == 'approved';

  Map<String, dynamic> toMap() => {
        'code': code,
        'name': name,
        'englishName': englishName,
        'rtl': rtl,
        'tier': tier,
        'active': active,
        'order': order,
        'bibleId': bibleId,
        'bibleName': bibleName,
        'googleCode': googleCode,
      };

  static AppLanguage? fromMap(Map<String, dynamic> m, [String? id]) {
    final code = '${m['code'] ?? id ?? ''}'.trim().toLowerCase();
    if (code.isEmpty) {
      return null;
    }
    return AppLanguage(
      code: code,
      name: '${m['name'] ?? ''}'.trim().isNotEmpty ? '${m['name']}' : code,
      englishName: '${m['englishName'] ?? m['name'] ?? code}',
      rtl: m['rtl'] == true,
      tier: m['tier'] == 'approved' ? 'approved' : 'machine',
      active: m['active'] != false,
      order: (m['order'] is num) ? (m['order'] as num).toInt() : 100,
      bibleId: '${m['bibleId'] ?? ''}'.trim(),
      bibleName: '${m['bibleName'] ?? ''}'.trim(),
      googleCode: '${m['googleCode'] ?? ''}'.trim(),
    );
  }
}

/// Languages the app knows without the CMS (also the seed for `languages`).
/// Bible ids match the ones approved in firebase/functions/index.js.
const kDefaultLanguages = <AppLanguage>[
  AppLanguage(
    code: 'en',
    name: 'English',
    englishName: 'English',
    tier: 'approved',
    order: 1,
    bibleId: '78a9f6124f344018-01',
    bibleName: 'NIV',
  ),
  AppLanguage(
    code: 'es',
    name: 'Español',
    englishName: 'Spanish',
    tier: 'approved',
    order: 2,
    bibleId: '592420522e16049f-01',
    bibleName: 'RVR1909',
  ),
  AppLanguage(
    code: 'ur',
    name: 'اردو',
    englishName: 'Urdu',
    rtl: true,
    tier: 'approved',
    order: 3,
    bibleId: 'eecbca904435fce9-01',
    bibleName: 'OUCV',
  ),
  AppLanguage(
    code: 'lg',
    name: 'Luganda',
    englishName: 'Luganda',
    tier: 'approved',
    order: 4,
    bibleId: 'f276be3571f516cb-01',
    bibleName: 'EEEE',
  ),
];

/// UI languages compiled into the app (FFLocalizations / supportedLocales).
/// Any other language uses an English framework locale; its UI labels and
/// content come from TranslationService.
const kCompiledLanguages = {'en', 'es', 'ur', 'lg'};

/// Languages the backend Cloud Functions (getTodayContent, getQuiz, ...)
/// return text for. For any other language they return English, which the
/// app translates on the device.
const kBackendLanguages = {'en', 'es', 'ur', 'lg'};

/// Right-to-left scripts, used when a language is not in the registry yet.
const _kRtlCodes = {'ar', 'fa', 'he', 'iw', 'ps', 'sd', 'ur', 'yi', 'dv', 'ug', 'ckb'};

const _kPrefsKey = 'languages_registry_v1';
const _kLocaleStorageKey = '__locale_key__';

/// Languages offered to members, loaded from the `languages` Firestore
/// collection (cached on the device for offline use). Falls back to the
/// built-in English, Spanish, Urdu and Luganda when the collection is empty
/// or unreachable, so the app never depends on the CMS to start.
class LanguageRegistry extends ChangeNotifier {
  LanguageRegistry._();
  static final LanguageRegistry instance = LanguageRegistry._();

  List<AppLanguage> _all = kDefaultLanguages;
  bool _fromCms = false;

  /// The member's content language (any code, not only compiled ones).
  static String _contentLanguage = 'en';
  static String get contentLanguage => _contentLanguage;

  /// All languages in the registry (active and inactive), by order.
  List<AppLanguage> get all => List.unmodifiable(_all);

  /// True once the list came from the CMS rather than the built-in defaults.
  bool get loadedFromCms => _fromCms;

  List<AppLanguage> get active => _all.where((l) => l.active).toList();
  List<AppLanguage> get approved =>
      active.where((l) => l.isApproved).toList();
  List<AppLanguage> get machine =>
      active.where((l) => !l.isApproved).toList();

  AppLanguage? byCode(String? code) {
    final c = (code ?? '').trim().toLowerCase();
    for (final l in _all) {
      if (l.code == c) {
        return l;
      }
    }
    return null;
  }

  bool isRtl(String? code) {
    final c = (code ?? '').trim().toLowerCase();
    return byCode(c)?.rtl ?? _kRtlCodes.contains(c.split('_').first);
  }

  /// Whether text for [code] may be machine-translated (an active language).
  bool allowsMachineTranslation(String? code) {
    final c = (code ?? '').trim().toLowerCase();
    if (c.isEmpty || c == 'en') {
      return false;
    }
    final lang = byCode(c);
    return lang != null && lang.active;
  }

  /// Display label of a language, e.g. "Français (French)".
  String labelFor(String code) {
    final l = byCode(code);
    if (l == null) {
      return code;
    }
    return l.name == l.englishName ? l.name : '${l.name} (${l.englishName})';
  }

  /// Flutter locale for [code]: compiled languages map to themselves, any
  /// other to English (framework widgets only ship the compiled locales).
  static String frameworkLocaleFor(String? code) {
    final c = (code ?? '').trim();
    if (kCompiledLanguages.contains(c)) {
      return c;
    }
    final base = c.split('_').first.toLowerCase();
    return kCompiledLanguages.contains(base) ? base : 'en';
  }

  /// True when backend-returned text for [code] is English and must be
  /// translated on the device.
  static bool needsClientTranslation(String? code) {
    final c = (code ?? '').trim().toLowerCase();
    return c.isNotEmpty && !kBackendLanguages.contains(c);
  }

  /// The language pages should use: the device's content language wins when
  /// it is one the backend does not know (the backend reports English for
  /// those), otherwise the server value.
  static String resolveMemberLanguage(String? serverValue) {
    final device = _contentLanguage;
    if (needsClientTranslation(device)) {
      return device;
    }
    final s = (serverValue ?? '').trim().toLowerCase();
    if (s.isNotEmpty) {
      return s;
    }
    return device.isNotEmpty ? device : 'en';
  }

  void setContentLanguage(String code) {
    final c = code.trim().toLowerCase();
    final next = c.isEmpty ? 'en' : c;
    if (next != _contentLanguage) {
      _contentLanguage = next;
      notifyListeners();
    }
  }

  /// Reads the member's language and the cached registry from the device,
  /// then refreshes from Firestore in the background.
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_kLocaleStorageKey) ?? '';
      _contentLanguage = stored.trim().isEmpty ? 'en' : stored.trim().toLowerCase();
      final cached = prefs.getString(_kPrefsKey);
      if (cached != null) {
        final list = (jsonDecode(cached) as List)
            .whereType<Map>()
            .map((m) => AppLanguage.fromMap(m.cast<String, dynamic>()))
            .whereType<AppLanguage>()
            .toList();
        if (list.isNotEmpty) {
          _setAll(list, fromCms: true);
        }
      }
    } catch (_) {}
    unawaited(refresh());
  }

  /// Loads `languages` from Firestore. Keeps the current list on failure.
  Future<void> refresh() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('languages')
          .get()
          .timeout(const Duration(seconds: 15));
      final list = snap.docs
          .map((d) => AppLanguage.fromMap(d.data(), d.id))
          .whereType<AppLanguage>()
          .toList();
      if (list.isEmpty) {
        return; // Not seeded yet: keep the built-in languages.
      }
      _setAll(list, fromCms: true);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _kPrefsKey, jsonEncode(list.map((l) => l.toMap()).toList()));
      notifyListeners();
    } catch (_) {}
  }

  void _setAll(List<AppLanguage> list, {required bool fromCms}) {
    final byCode = {for (final l in list) l.code: l};
    // English is the master source and is always available.
    byCode.putIfAbsent('en', () => kDefaultLanguages.first);
    final sorted = byCode.values.toList()
      ..sort((a, b) => a.order != b.order
          ? a.order.compareTo(b.order)
          : a.englishName.compareTo(b.englishName));
    _all = sorted;
    _fromCms = fromCms;
  }
}
