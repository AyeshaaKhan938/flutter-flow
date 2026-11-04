import '/flutter_flow/flutter_flow_util.dart';
import 'admin_notifications_page_widget.dart' show AdminNotificationsPageWidget;
import 'package:flutter/material.dart';

class AdminNotificationsPageModel
    extends FlutterFlowModel<AdminNotificationsPageWidget> {
  /// null while the role lookup is in flight.
  bool? isAdmin;

  final titleController = TextEditingController();
  final messageController = TextEditingController();

  /// 'All', 'iOS' or 'Android' (matched against fcm_tokens.device_type).
  String audience = 'All';

  /// Language code, or null for every language.
  String? language;

  /// Pathway id, or null for every pathway.
  String? pathwayId;

  /// Send time, or null to send now.
  DateTime? scheduledTime;

  bool sending = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
  }
}
