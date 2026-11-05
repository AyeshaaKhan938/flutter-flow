import 'dart:ui' as ui;

import '/admin_content_page/admin_content_page_model.dart'
    show kContentAdminRoles;
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_notifications_page_model.dart';
export 'admin_notifications_page_model.dart';

/// Languages the push function can target (kSupportedLanguages in
/// firebase/functions/index.js).
const _kLanguages = {
  'en': 'English',
  'es': 'Spanish',
  'ur': 'Urdu',
  'lg': 'Luganda',
};

/// Admin page for sending push notifications to members.
///
/// Writes a document to `ff_push_notifications`. The
/// `sendPushNotificationsTrigger` function sends it immediately, or
/// `sendScheduledPushNotifications` sends it at `scheduled_time` (checked
/// every 5 minutes). Optional targeting by device, language and pathway
/// uses the fields documented in docs/notifications-and-assistant.md.
///
/// Gated on `users/{uid}.role` in [kContentAdminRoles]; Firestore rules
/// enforce the same check.
class AdminNotificationsPageWidget extends StatefulWidget {
  const AdminNotificationsPageWidget({super.key});

  static String routeName = 'AdminNotificationsPage';
  static String routePath = '/admin/notifications';

  @override
  State<AdminNotificationsPageWidget> createState() =>
      _AdminNotificationsPageWidgetState();
}

class _AdminNotificationsPageWidgetState
    extends State<AdminNotificationsPageWidget> {
  late AdminNotificationsPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference<Map<String, dynamic>> get _notificationsRef =>
      FirebaseFirestore.instance.collection('ff_push_notifications');

  Stream<QuerySnapshot<Map<String, dynamic>>>? _recentStream;
  List<PathwaysRecord> _pathways = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminNotificationsPageModel());
    SchedulerBinding.instance.addPostFrameCallback((_) => _checkAdmin());
  }

  Future<void> _checkAdmin() async {
    var isAdmin = false;
    try {
      final ref = currentUserReference;
      if (ref != null) {
        final user = await UsersRecord.getDocumentOnce(ref);
        isAdmin = kContentAdminRoles.contains(user.role);
      }
    } catch (_) {
      isAdmin = false;
    }
    _model.isAdmin = isAdmin;
    if (isAdmin) {
      _recentStream = _notificationsRef
          .orderBy('created_at', descending: true)
          .limit(20)
          .snapshots();
      try {
        _pathways = (await queryPathwaysRecordOnce())
          ..sort((a, b) => a.order.compareTo(b.order));
      } catch (_) {
        _pathways = [];
      }
    }
    safeSetState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _snack(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 4000),
      ),
    );
  }

  String _pathwayName(String id) {
    for (final p in _pathways) {
      if (p.reference.id == id) {
        return p.title.en.isNotEmpty ? p.title.en : id;
      }
    }
    return id;
  }

  String _audienceSummary() {
    final parts = <String>[
      switch (_model.audience) {
        'iOS' => 'iPhone members',
        'Android' => 'Android members',
        _ => 'All members',
      },
      if (_model.language != null)
        'who use ${_kLanguages[_model.language]}',
      if (_model.pathwayId != null)
        'on ${_pathwayName(_model.pathwayId!)}',
    ];
    return parts.join(' ');
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _model.scheduledTime ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          _model.scheduledTime ?? now.add(const Duration(hours: 1))),
    );
    if (time == null) {
      return;
    }
    final picked =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    if (picked.isBefore(now)) {
      _snack('Choose a time in the future.');
      return;
    }
    _model.scheduledTime = picked;
    safeSetState(() {});
  }

  Future<void> _send() async {
    final title = _model.titleController.text.trim();
    final message = _model.messageController.text.trim();
    if (title.isEmpty || message.isEmpty) {
      _snack('Enter a title and a message.');
      return;
    }
    final scheduled = _model.scheduledTime;
    final when = scheduled == null
        ? 'now'
        : 'at ${dateTimeFormat('MMM d, h:mm a', scheduled)}';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Send notification?'),
        content: Text(
            '"$title"\n\nTo: ${_audienceSummary()}\nWhen: $when'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(scheduled == null ? 'Send' : 'Schedule'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    _model.sending = true;
    safeSetState(() {});
    try {
      await _notificationsRef.add({
        'notification_title': title,
        'notification_text': message,
        'target_audience': _model.audience,
        if (_model.language != null) 'target_language': _model.language,
        if (_model.pathwayId != null) 'target_pathway': _model.pathwayId,
        if (scheduled != null) 'scheduled_time': Timestamp.fromDate(scheduled),
        'initial_page_name': 'TodayPage',
        'parameter_data': '{}',
        'created_by': currentUserUid,
        'created_at': FieldValue.serverTimestamp(),
      });
      _model.titleController.clear();
      _model.messageController.clear();
      _model.scheduledTime = null;
      _snack(scheduled == null
          ? 'Notification is being sent.'
          : 'Notification scheduled.');
    } catch (err) {
      _snack('Could not send: $err');
    } finally {
      _model.sending = false;
      safeSetState(() {});
    }
  }

  Widget _sectionLabel(String text) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 6.0),
      child: Text(
        text,
        style: theme.labelLarge.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildForm() {
    final theme = FlutterFlowTheme.of(context);
    final hint = theme.labelSmall.override(
      font: GoogleFonts.inter(),
      color: theme.secondaryText,
      letterSpacing: 0.0,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _model.titleController,
          maxLength: 65,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _model.messageController,
          maxLength: 240,
          minLines: 3,
          maxLines: 6,
          decoration: const InputDecoration(
            labelText: 'Message',
            border: OutlineInputBorder(),
          ),
        ),
        _sectionLabel('Who receives it'),
        DropdownButtonFormField<String>(
          initialValue: _model.audience,
          decoration: const InputDecoration(
            labelText: 'Devices',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'All', child: Text('All devices')),
            DropdownMenuItem(value: 'iOS', child: Text('iPhone only')),
            DropdownMenuItem(value: 'Android', child: Text('Android only')),
          ],
          onChanged: (v) => safeSetState(() => _model.audience = v ?? 'All'),
        ),
        const SizedBox(height: 12.0),
        DropdownButtonFormField<String?>(
          initialValue: _model.language,
          decoration: const InputDecoration(
            labelText: 'Language',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('All languages')),
            for (final e in _kLanguages.entries)
              DropdownMenuItem(value: e.key, child: Text(e.value)),
          ],
          onChanged: (v) => safeSetState(() => _model.language = v),
        ),
        const SizedBox(height: 12.0),
        DropdownButtonFormField<String?>(
          initialValue: _model.pathwayId,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Pathway',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('All pathways')),
            for (final p in _pathways)
              DropdownMenuItem(
                value: p.reference.id,
                child: Text(
                  _pathwayName(p.reference.id),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (v) => safeSetState(() => _model.pathwayId = v),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Members receive the text exactly as written. Members in a pathway '
          'are those who started it or had it recommended.',
          style: hint,
        ),
        _sectionLabel('When'),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('Send now'),
              selected: _model.scheduledTime == null,
              onSelected: (_) =>
                  safeSetState(() => _model.scheduledTime = null),
            ),
            ChoiceChip(
              label: Text(_model.scheduledTime == null
                  ? 'Schedule…'
                  : dateTimeFormat('MMM d, h:mm a', _model.scheduledTime)),
              selected: _model.scheduledTime != null,
              onSelected: (_) => _pickTime(),
            ),
          ],
        ),
        if (_model.scheduledTime != null) ...[
          const SizedBox(height: 4.0),
          Text(
            'Scheduled notifications go out within about 5 minutes of the '
            'chosen time.',
            style: hint,
          ),
        ],
        const SizedBox(height: 20.0),
        FilledButton.icon(
          onPressed: _model.sending ? null : _send,
          icon: _model.sending
              ? const SizedBox(
                  width: 18.0,
                  height: 18.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                )
              : const Icon(Icons.send_rounded),
          label: Text(_model.scheduledTime == null
              ? 'Send notification'
              : 'Schedule notification'),
        ),
      ],
    );
  }

  Widget _buildRecent() {
    final theme = FlutterFlowTheme.of(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _recentStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Could not load recent notifications.',
              style: theme.bodySmall);
        }
        final docs = snapshot.data?.docs ?? const [];
        if (docs.isEmpty) {
          return Text('No notifications sent from this page yet.',
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(),
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ));
        }
        return Column(
          children: [
            for (final doc in docs) _recentTile(doc.data()),
          ],
        );
      },
    );
  }

  Widget _recentTile(Map<String, dynamic> data) {
    final theme = FlutterFlowTheme.of(context);
    final status = (data['status'] as String?) ?? '';
    final scheduled = (data['scheduled_time'] as Timestamp?)?.toDate();
    final created = (data['created_at'] as Timestamp?)?.toDate();
    final numSent = data['num_sent'];
    final String statusText;
    final Color statusColor;
    switch (status) {
      case 'succeeded':
        statusText = 'Sent to ${numSent ?? 0} device(s)';
        statusColor = theme.success;
      case 'failed':
        statusText = 'Failed: ${data['error'] ?? 'unknown error'}';
        statusColor = theme.error;
      case 'in_progress':
        statusText = 'Sending (${numSent ?? 0} so far)';
        statusColor = theme.warning;
      default:
        statusText = scheduled != null
            ? 'Scheduled for ${dateTimeFormat('MMM d, h:mm a', scheduled)}'
            : 'Sending…';
        statusColor = theme.secondaryText;
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: theme.secondaryBackground,
      elevation: 0.0,
      child: ListTile(
        title: Text((data['notification_title'] as String?) ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text((data['notification_text'] as String?) ?? '',
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4.0),
            Text(
              [
                statusText,
                if (created != null) dateTimeFormat('MMM d, h:mm a', created),
              ].join(' · '),
              style: theme.labelSmall.override(
                font: GoogleFonts.inter(),
                color: statusColor,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final Widget body;
    if (_model.isAdmin == null) {
      body = Center(child: CircularProgressIndicator(color: theme.primary));
    } else if (_model.isAdmin == false) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline_rounded,
                  size: 48.0, color: theme.secondaryText),
              const SizedBox(height: 12.0),
              Text('Not authorized', style: theme.titleMedium),
              const SizedBox(height: 6.0),
              Text(
                'Only admins can send notifications.',
                textAlign: TextAlign.center,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(),
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      body = ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildForm(),
          _sectionLabel('Recent notifications'),
          _buildRecent(),
        ],
      );
    }
    // Admin tooling is English-only, left-to-right.
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: theme.primaryBackground,
          appBar: AppBar(
            backgroundColor: theme.primaryBackground,
            automaticallyImplyLeading: true,
            title: Text(
              'Notifications',
              style: theme.titleLarge.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                fontSize: 22.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
          body: SafeArea(top: true, child: body),
        ),
      ),
    );
  }
}
