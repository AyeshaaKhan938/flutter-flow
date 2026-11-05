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

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '/backend/push_notifications/push_notifications_util.dart';

Future<String> requestNotificationPermission() async {
  if (kIsWeb) {
    return 'web_skipped';
  }
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  if (notificationsAllowed(settings.authorizationStatus)) {
    try {
      await registerCurrentDeviceToken();
    } catch (_) {
      // Registered again on the next sign-in or token refresh.
    }
  }
  return settings.authorizationStatus.name;
}
