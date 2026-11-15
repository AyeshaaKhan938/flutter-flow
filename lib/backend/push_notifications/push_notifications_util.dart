
import '../../auth/firebase_auth/auth_util.dart';
import '../cloud_functions/cloud_functions.dart';

import 'package:flutter/foundation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

export 'push_notifications_handler.dart';
export 'serialization_util.dart';

class UserTokenInfo {
  const UserTokenInfo(this.userPath, this.fcmToken);
  final String userPath;
  final String fcmToken;
}

/// Authorized, or iOS provisional (delivered quietly to Notification Centre).
bool notificationsAllowed(AuthorizationStatus status) =>
    status == AuthorizationStatus.authorized ||
    status == AuthorizationStatus.provisional;

/// Registers this device for the signed-in member. Used after the member
/// allows notifications on the permission screen, since the sign-in stream
/// has already run by then.
Future<void> registerCurrentDeviceToken() async {
  final userPath = currentUserReference?.path;
  if (kIsWeb || userPath == null) {
    return;
  }
  final token = await FirebaseMessaging.instance.getToken();
  if (token == null || token.isEmpty) {
    return;
  }
  await makeCloudCall('addFcmToken', {
    'userDocPath': userPath,
    'fcmToken': token,
    'deviceType':
        defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : 'Android',
  });
}

Stream<UserTokenInfo> getFcmTokenStream(String userPath) => Stream.value(
        !kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android))
    .where((shouldGetToken) => shouldGetToken)
    .asyncMap<String?>((_) async {
      // Permission is not asked at sign-in. It is offered after the member
      // finishes a lesson (onboarding_flow.dart) or from Profile; until then
      // only an existing permission is used.
      final settings =
          await FirebaseMessaging.instance.getNotificationSettings();
      return notificationsAllowed(settings.authorizationStatus)
          ? FirebaseMessaging.instance.getToken()
          : null;
    })
    .switchMap((fcmToken) =>
        Stream.value(fcmToken).merge(FirebaseMessaging.instance.onTokenRefresh))
    .where((fcmToken) => fcmToken != null && fcmToken.isNotEmpty)
    .map((token) => UserTokenInfo(userPath, token!));

final fcmTokenUserStream = authenticatedUserStream
    .where((user) => user != null)
    .map((user) => user!.reference.path)
    .distinct()
    .switchMap(getFcmTokenStream)
    .map(
      (userTokenInfo) => makeCloudCall(
        'addFcmToken',
        {
          'userDocPath': userTokenInfo.userPath,
          'fcmToken': userTokenInfo.fcmToken,
          'deviceType':
              defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : 'Android',
        },
      ),
    );
