import '/flutter_flow/flutter_flow_util.dart';
import 'admin_content_page_widget.dart' show AdminContentPageWidget;
import 'package:flutter/material.dart';

/// Which collection the CMS page is currently showing.
enum AdminContentKind { scripture, encouragement }

/// Roles allowed to manage content. Mirrors the gate on ProfilePage and the
/// `isContentAdmin()` helper in firebase/firestore.rules.
const kContentAdminRoles = ['admin', 'ministry_reviewer'];

/// Status values the CMS can set. Only 'published' is shown to members.
/// Workflow: draft -> review (awaiting Kingdom Heirs approval) -> published;
/// 'unpublished' hides a record again until it is republished.
const kContentStatuses = ['draft', 'review', 'published', 'unpublished'];

class AdminContentPageModel extends FlutterFlowModel<AdminContentPageWidget> {
  ///  Local state fields for this page.

  /// null while the role lookup is in flight.
  bool? isAdmin;

  AdminContentKind kind = AdminContentKind.scripture;

  /// 'MM' month filter, or null for all months.
  String? monthFilter;

  /// Status filter, or null for all statuses.
  String? statusFilter;

  /// Record references with a status change in flight (disables the toggle).
  final Set<String> busyPaths = {};

  ///  State fields for stateful widgets in this page.

  // State field(s) for SearchField widget.
  FocusNode? searchFieldFocusNode;
  TextEditingController? searchFieldTextController;

  String get searchText => searchFieldTextController?.text.trim() ?? '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchFieldFocusNode?.dispose();
    searchFieldTextController?.dispose();
  }
}

/// Daily Scripture and Encouragement records repeat every year, so their
/// `date` is month-day ("01-31"), as in the imported content.
const kContentDateFormat = 'MM-dd';

/// Parses a month-day content date (a leap year, so 02-29 is valid).
DateTime? parseContentDate(String date) {
  final parts = date.split('-');
  if (parts.length != 2) {
    return null;
  }
  final month = int.tryParse(parts[0]);
  final day = int.tryParse(parts[1]);
  if (month == null || day == null) {
    return null;
  }
  return DateTime(2024, month, day);
}
