import '/flutter_flow/flutter_flow_util.dart';
import 'admin_content_page_widget.dart' show AdminContentPageWidget;
import 'package:flutter/material.dart';

/// Which collection the CMS page is currently showing.
enum AdminContentKind { scripture, encouragement }

/// Roles allowed to manage content. Mirrors the gate on ProfilePage and the
/// `isContentAdmin()` helper in firebase/firestore.rules.
const kContentAdminRoles = ['admin', 'ministry_reviewer'];

/// Status values the CMS can set. Only 'published' is shown to members.
const kContentStatuses = ['published', 'draft', 'unpublished'];

class AdminContentPageModel extends FlutterFlowModel<AdminContentPageWidget> {
  ///  Local state fields for this page.

  /// null while the role lookup is in flight.
  bool? isAdmin;

  AdminContentKind kind = AdminContentKind.scripture;

  /// 'yyyy-MM' month filter, or null for all months.
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
