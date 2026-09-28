import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_manager.dart';

/// Keeps the last successful response of each read-only API call on the
/// device, so pages still render when the member is offline.
///
/// Every backend call is a POST, so read calls are recognised by name
/// (`Get...` / `List...`). The auth token rotates hourly, so it is left out
/// of the key; the signed-in user's uid is included instead so members
/// sharing a device never see each other's data.
class OfflineApiCache {
  static const _prefix = 'ff_offline_api_';
  // Same key FFLocalizations uses for the member's chosen app language.
  static const _kLocaleStorageKey = '__locale_key__';

  static bool isCacheable(String callName) =>
      (callName.startsWith('Get') || callName.startsWith('List')) &&
      callName != 'GetAdminReport';

  static String? _key(String callName, String? body) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return null;
    }
    var normalizedBody = body ?? '';
    try {
      final decoded = json.decode(normalizedBody);
      if (decoded is Map) {
        final map = Map<String, dynamic>.from(decoded)..remove('authToken');
        final sortedKeys = map.keys.toList()..sort();
        normalizedBody = json.encode({for (final k in sortedKeys) k: map[k]});
      }
    } catch (_) {}
    return '$_prefix$uid|$callName|$normalizedBody';
  }

  static Future<void> save(
    String callName,
    String? body,
    ApiCallResponse response,
  ) async {
    final key = _key(callName, body);
    if (key == null || response.jsonBody == null) {
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, json.encode(response.jsonBody));
    } catch (_) {}
  }

  /// Returns the cached response as a 200, or null if there is none.
  static Future<ApiCallResponse?> load(String callName, String? body) async {
    final key = _key(callName, body);
    if (key == null) {
      return null;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(key);
      if (cached == null) {
        return null;
      }
      var jsonBody = json.decode(cached);
      // The member may have switched language while offline; that choice is
      // stored on the device and should win over the cached server value.
      final storedLocale = prefs.getString(_kLocaleStorageKey) ?? '';
      if (jsonBody is Map &&
          jsonBody.containsKey('preferredLanguage') &&
          storedLocale.isNotEmpty) {
        jsonBody = Map<String, dynamic>.from(jsonBody)
          ..['preferredLanguage'] = storedLocale;
      }
      return ApiCallResponse(jsonBody, const {}, 200);
    } catch (_) {
      return null;
    }
  }
}
