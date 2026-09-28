import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_content_page_model.dart';
import 'content_editor_dialog.dart';
export 'admin_content_page_model.dart';

/// CMS page for the 365-day Daily Scripture and Encouragement records.
///
/// Admins can schedule (set the date), edit all four languages, and
/// publish / unpublish / republish each record. Gated on `users/{uid}.role`
/// being one of [kContentAdminRoles]; Firestore rules enforce the same check
/// on writes, so the gate here is only for UX.
class AdminContentPageWidget extends StatefulWidget {
  const AdminContentPageWidget({super.key});

  static String routeName = 'AdminContentPage';
  static String routePath = '/admin/content';

  @override
  State<AdminContentPageWidget> createState() => _AdminContentPageWidgetState();
}

/// One list row, independent of which collection it came from.
class _ContentRow {
  _ContentRow({
    required this.reference,
    required this.date,
    required this.status,
    required this.preview,
    required this.refLabel,
    this.scripture,
    this.encouragement,
  });

  factory _ContentRow.fromScripture(DailyScriptureRecord r) => _ContentRow(
        reference: r.reference,
        date: r.date,
        status: r.status,
        preview: r.text.en,
        refLabel: r.verseRef,
        scripture: r,
      );

  factory _ContentRow.fromEncouragement(EncouragementsRecord r) => _ContentRow(
        reference: r.reference,
        date: r.date,
        status: r.status,
        preview: r.quote.en,
        refLabel: r.attribution,
        encouragement: r,
      );

  final DocumentReference reference;
  final String date;
  final String status;
  final String preview;

  /// Verse reference or attribution.
  final String refLabel;
  final DailyScriptureRecord? scripture;
  final EncouragementsRecord? encouragement;

  bool get isPublished => status == 'published';
}

class _AdminContentPageWidgetState extends State<AdminContentPageWidget> {
  late AdminContentPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late final Stream<List<DailyScriptureRecord>> _scriptureStream;
  late final Stream<List<EncouragementsRecord>> _encouragementStream;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminContentPageModel());

    _model.searchFieldTextController ??= TextEditingController();
    _model.searchFieldFocusNode ??= FocusNode();

    _scriptureStream = queryDailyScriptureRecord();
    _encouragementStream = queryEncouragementsRecord();

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
    safeSetState(() {});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  List<_ContentRow> _filter(List<_ContentRow> rows) {
    final search = _model.searchText.toLowerCase();
    final filtered = rows.where((r) {
      if (_model.monthFilter != null &&
          !r.date.startsWith(_model.monthFilter!)) {
        return false;
      }
      if (_model.statusFilter != null) {
        final status = r.status.isEmpty ? 'draft' : r.status;
        if (status != _model.statusFilter) {
          return false;
        }
      }
      if (search.isNotEmpty &&
          !r.date.contains(search) &&
          !r.preview.toLowerCase().contains(search) &&
          !r.refLabel.toLowerCase().contains(search)) {
        return false;
      }
      return true;
    }).toList();
    filtered.sort((a, b) => a.date.compareTo(b.date));
    return filtered;
  }

  Future<void> _openEditor(List<_ContentRow> allRows,
      {_ContentRow? row}) async {
    final takenDates = <String, String>{
      for (final r in allRows)
        if (r.date.isNotEmpty) r.date: r.reference.path,
    };
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ContentEditorDialog(
        kind: _model.kind,
        scripture: row?.scripture,
        encouragement: row?.encouragement,
        takenDates: takenDates,
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved.'),
          duration: Duration(milliseconds: 2500),
        ),
      );
    }
  }

  Future<void> _togglePublished(_ContentRow row) async {
    final newStatus = row.isPublished ? 'unpublished' : 'published';
    final data = row.scripture != null
        ? createDailyScriptureRecordData(status: newStatus)
        : createEncouragementsRecordData(status: newStatus);
    _model.busyPaths.add(row.reference.path);
    safeSetState(() {});
    try {
      await row.reference.update(data);
    } catch (err) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not change status: $err'),
            duration: const Duration(milliseconds: 5000),
          ),
        );
      }
    } finally {
      _model.busyPaths.remove(row.reference.path);
      safeSetState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.primaryBackground,
          automaticallyImplyLeading: true,
          title: Text(
            'Daily Content',
            style: theme.titleLarge.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontStyle: theme.titleLarge.fontStyle,
              ),
              fontSize: 22.0,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              fontStyle: theme.titleLarge.fontStyle,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (_model.isAdmin == null) {
      return Center(
        child: CircularProgressIndicator(color: theme.primary),
      );
    }
    if (_model.isAdmin == false) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline_rounded,
                  size: 48.0, color: theme.secondaryText),
              const SizedBox(height: 12.0),
              Text(
                'Not authorized',
                style: theme.titleMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                'Only admins can manage Daily Scripture and Encouragements.',
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
    }

    final isScripture = _model.kind == AdminContentKind.scripture;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<AdminContentKind>(
            segments: const [
              ButtonSegment(
                value: AdminContentKind.scripture,
                label: Text('Daily Scripture'),
                icon: Icon(Icons.menu_book_rounded),
              ),
              ButtonSegment(
                value: AdminContentKind.encouragement,
                label: Text('Encouragements'),
                icon: Icon(Icons.favorite_border_rounded),
              ),
            ],
            selected: {_model.kind},
            onSelectionChanged: (s) {
              _model.kind = s.first;
              safeSetState(() {});
            },
          ),
          const SizedBox(height: 12.0),
          Expanded(
            child: isScripture
                ? StreamBuilder<List<DailyScriptureRecord>>(
                    stream: _scriptureStream,
                    builder: (context, snapshot) => _buildList(
                      context,
                      snapshot,
                      snapshot.data?.map(_ContentRow.fromScripture).toList(),
                    ),
                  )
                : StreamBuilder<List<EncouragementsRecord>>(
                    stream: _encouragementStream,
                    builder: (context, snapshot) => _buildList(
                      context,
                      snapshot,
                      snapshot.data
                          ?.map(_ContentRow.fromEncouragement)
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    AsyncSnapshot snapshot,
    List<_ContentRow>? allRows,
  ) {
    final theme = FlutterFlowTheme.of(context);
    if (snapshot.hasError) {
      return Center(
        child: Text(
          'Could not load records: ${snapshot.error}',
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            color: theme.error,
            letterSpacing: 0.0,
          ),
        ),
      );
    }
    if (allRows == null) {
      return Center(child: CircularProgressIndicator(color: theme.primary));
    }

    final months = allRows
        .map((r) => r.date.length >= 7 ? r.date.substring(0, 7) : '')
        .where((m) => m.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    if (_model.monthFilter != null && !months.contains(_model.monthFilter)) {
      months.add(_model.monthFilter!);
      months.sort();
    }
    final rows = _filter(allRows);
    final publishedCount = allRows.where((r) => r.isPublished).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFilters(context, months),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Text(
                '${rows.length} shown  ·  $publishedCount of ${allRows.length} published',
                style: theme.bodySmall.override(
                  font: GoogleFonts.inter(),
                  color: theme.secondaryText,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () => _openEditor(allRows),
              style: FilledButton.styleFrom(backgroundColor: theme.primary),
              icon: const Icon(Icons.add_rounded, size: 18.0),
              label: const Text('New record'),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: rows.isEmpty
              ? Center(
                  child: Text(
                    'No records match.',
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: theme.secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  itemCount: rows.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                  itemBuilder: (context, index) =>
                      _buildRow(context, rows[index], allRows),
                ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context, List<String> months) {
    final theme = FlutterFlowTheme.of(context);
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: theme.alternate, width: 1.0),
      borderRadius: BorderRadius.circular(8.0),
    );
    InputDecoration decoration(String label) => InputDecoration(
          labelText: label,
          isDense: true,
          filled: true,
          fillColor: theme.secondaryBackground,
          enabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(color: theme.primary, width: 1.0),
          ),
        );

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        SizedBox(
          width: 240.0,
          child: TextField(
            controller: _model.searchFieldTextController,
            focusNode: _model.searchFieldFocusNode,
            onChanged: (_) => safeSetState(() {}),
            decoration: decoration('Search date or text').copyWith(
              hintText: 'e.g. 2026-03-14',
              prefixIcon: const Icon(Icons.search_rounded, size: 20.0),
            ),
          ),
        ),
        SizedBox(
          width: 170.0,
          child: DropdownButtonFormField<String?>(
            initialValue: _model.monthFilter,
            decoration: decoration('Month'),
            items: [
              const DropdownMenuItem<String?>(
                  value: null, child: Text('All months')),
              for (final m in months)
                DropdownMenuItem<String?>(
                  value: m,
                  child: Text(_monthLabel(m)),
                ),
            ],
            onChanged: (v) {
              _model.monthFilter = v;
              safeSetState(() {});
            },
          ),
        ),
        SizedBox(
          width: 170.0,
          child: DropdownButtonFormField<String?>(
            initialValue: _model.statusFilter,
            decoration: decoration('Status'),
            items: [
              const DropdownMenuItem<String?>(
                  value: null, child: Text('All statuses')),
              for (final s in kContentStatuses)
                DropdownMenuItem<String?>(value: s, child: Text(s)),
            ],
            onChanged: (v) {
              _model.statusFilter = v;
              safeSetState(() {});
            },
          ),
        ),
      ],
    );
  }

  String _monthLabel(String yyyyMm) {
    final parsed = DateTime.tryParse('$yyyyMm-01');
    return parsed == null ? yyyyMm : DateFormat('MMM yyyy').format(parsed);
  }

  Widget _buildRow(
      BuildContext context, _ContentRow row, List<_ContentRow> allRows) {
    final theme = FlutterFlowTheme.of(context);
    final busy = _model.busyPaths.contains(row.reference.path);
    return Material(
      color: theme.secondaryBackground,
      borderRadius: BorderRadius.circular(12.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () => _openEditor(allRows, row: row),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 10.0, 8.0, 10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          row.date.isEmpty ? '(no date)' : row.date,
                          style: theme.titleSmall.override(
                            font:
                                GoogleFonts.inter(fontWeight: FontWeight.w600),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        _StatusChip(status: row.status),
                        if (row.refLabel.isNotEmpty) ...[
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Text(
                              row.refLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.bodySmall.override(
                                font: GoogleFonts.inter(),
                                color: theme.secondaryText,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      row.preview.isEmpty ? '(no English text)' : row.preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              busy
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      ),
                    )
                  : TextButton(
                      onPressed: () => _togglePublished(row),
                      child: Text(row.isPublished ? 'Unpublish' : 'Publish'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final label = status.isEmpty ? 'draft' : status;
    final color = switch (label) {
      'published' => theme.success,
      'unpublished' => theme.error,
      _ => theme.warning,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        label,
        style: theme.labelSmall.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
          color: color,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
