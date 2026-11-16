// The simplified first experience (approved by Kingdom Heirs, November 2026):
//
//   Sign up -> choose language -> Home.
//
// - The time zone is taken from the phone, never typed.
// - Notification permission is asked after the member finishes a lesson.
// - The assessment is offered by a card on Home after the first lesson or
//   from the second day. It can be dismissed and is always available from
//   Profile.

import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/custom_code/actions/index.dart' as actions;
import '/custom_code/languages/language_registry.dart';

const _kProfileUrl =
    'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile';

/// Information pages for the two future modules (Phase 1: text only).
const kSchoolClubsInfo =
    'Kingdom Heirs School Clubs will meet at schools, churches and other '
    'approved locations. Each club will follow about 35 weekly lessons led by '
    'a trained club leader, and every club member will also be welcomed into '
    'the Kingdom Heirs discipleship pathways. Coming soon.';
const kSportsTournamentsInfo =
    'Young people will be able to register for Kingdom Heirs sporting events '
    'here. After each tournament, players are invited into the Kingdom Heirs '
    'discipleship pathways so the relationship continues beyond the game. '
    'Coming soon.';

const kAssessmentInviteDismissedKey = 'kh_assessment_invite_dismissed';
const kReminderAskedKey = 'kh_reminder_asked';

/// The language pre-selected on the language screen: the one already chosen
/// on this phone, else the phone's language if Kingdom Heirs offers it,
/// else English.
String initialLanguage({
  required String? stored,
  required String? device,
  bool Function(String code)? isOffered,
}) {
  final s = (stored ?? '').trim().toLowerCase();
  if (s.isNotEmpty) return s;
  final d = (device ?? '').trim().toLowerCase();
  final offered = isOffered ??
      (c) => LanguageRegistry.instance.selectable.any((l) => l.code == c);
  return d.isNotEmpty && offered(d) ? d : 'en';
}

/// The phone's IANA time zone ("Africa/Kampala"), or '' if unavailable.
Future<String> deviceTimezone() async {
  if (kIsWeb) return '';
  try {
    final tz = await FlutterTimezone.getLocalTimezone();
    return validTimezone(tz.identifier);
  } catch (_) {
    return '';
  }
}

/// [raw] if it looks like an IANA zone name ("Area/City" or "UTC"),
/// otherwise ''. The server treats an empty time zone as UTC.
String validTimezone(String? raw) {
  final tz = (raw ?? '').trim();
  if (tz == 'UTC' || tz == 'Etc/UTC') return tz;
  return RegExp(r'^[A-Za-z]+(?:/[A-Za-z0-9_+\-]+)+$').hasMatch(tz) ? tz : '';
}

/// Saves only the given profile fields (the server leaves other fields as
/// they are). Returns true on success.
Future<bool> saveProfileFields(Map<String, String> fields) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || fields.isEmpty) return false;
    final token = await user.getIdToken();
    final res = await http
        .post(
          Uri.parse(_kProfileUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'authToken': token, ...fields}),
        )
        .timeout(const Duration(seconds: 20));
    return res.statusCode >= 200 && res.statusCode < 300;
  } catch (_) {
    return false;
  }
}

/// Sends the phone's time zone to the profile. Used on the language screen,
/// so every new member gets local-time reminders without typing anything.
Future<void> saveDeviceTimezone() async {
  final tz = await deviceTimezone();
  if (tz.isNotEmpty) await saveProfileFields({'timezone': tz});
}

/// Whether Home shows the assessment invitation card.
///
/// Shown when the assessment has not been done, the member has not
/// dismissed the card, and either a lesson is finished or the account is at
/// least one day old.
bool shouldShowAssessmentInvite({
  required bool? onboardingCompleted,
  required bool dismissed,
  required int lessonsCompleted,
  required DateTime? accountCreated,
  required DateTime now,
}) {
  if (onboardingCompleted == true || dismissed) return false;
  if (lessonsCompleted > 0) return true;
  if (accountCreated == null) return false;
  return now.difference(accountCreated) >= const Duration(days: 1);
}

Future<bool> assessmentInviteDismissed() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kAssessmentInviteDismissedKey) ?? false;
  } catch (_) {
    return false;
  }
}

Future<void> dismissAssessmentInvite() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kAssessmentInviteDismissedKey, true);
  } catch (_) {}
}

/// After a lesson is finished: offers a daily reminder once, if the member
/// has not yet answered the phone's notification question. Never blocks the
/// lesson flow; any error is ignored.
Future<void> maybeOfferDailyReminder(
  BuildContext context, {
  required String Function(String) t,
}) async {
  if (kIsWeb) return;
  try {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(kReminderAskedKey) ?? false) return;
    final settings =
        await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.notDetermined) {
      await prefs.setBool(kReminderAskedKey, true);
      return;
    }
    if (!context.mounted) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const ValueKey('dailyReminderDialog'),
        icon: const Icon(Icons.notifications_active_outlined),
        title: Text(t('Would you like a daily reminder?')),
        content: Text(t(
            'We can remind you each day to read Scripture and continue your lessons.')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('Not now')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('Yes, remind me')),
          ),
        ],
      ),
    );
    await prefs.setBool(kReminderAskedKey, true);
    if (yes == true) await actions.requestNotificationPermission();
  } catch (_) {}
}
