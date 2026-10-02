import 'dart:convert';

import '/admin_content_page/admin_content_page_model.dart'
    show kContentAdminRoles;
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_import_page_model.dart';
export 'admin_import_page_model.dart';

/// CMS CSV import: preview a file, import it as draft, and read the report.
///
/// Calls the `importContentCsv` Cloud Function
/// (firebase/functions/content_import.js), which validates the file, upserts
/// by stableId and writes every run to `importJobs`. Gated on
/// `users/{uid}.role` like the Admin Content page; the function and the
/// Firestore rules enforce the same check.
class AdminImportPageWidget extends StatefulWidget {
  const AdminImportPageWidget({super.key});

  static String routeName = 'AdminImportPage';
  static String routePath = '/admin/import';

  @override
  State<AdminImportPageWidget> createState() => _AdminImportPageWidgetState();
}

class _AdminImportPageWidgetState extends State<AdminImportPageWidget> {
  late AdminImportPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<QuerySnapshot<Map<String, dynamic>>>? _jobsStream;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminImportPageModel());
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
      _jobsStream = FirebaseFirestore.instance
          .collection('importJobs')
          .orderBy('importedAt', descending: true)
          .limit(20)
          .snapshots();
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

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        // Any file: some Android file managers hide .zip/.xlsx under a
        // custom-extension filter. The extension is checked after picking.
        type: FileType.any,
        withData: true,
      );
      final file = result?.files.single;
      final bytes = file?.bytes;
      if (file == null || bytes == null) {
        return;
      }
      final lower = file.name.toLowerCase();
      if (!(lower.endsWith('.csv') ||
          lower.endsWith('.xlsx') ||
          lower.endsWith('.zip'))) {
        _snack('Choose a .csv, .xlsx or .zip file (got ${file.name}).');
        return;
      }
      if (lower.endsWith('.xlsx') || lower.endsWith('.zip')) {
        // Original Excel master or the CSV handoff zip: read on the server.
        _model.csvText = null;
        _model.fileBase64 = base64Encode(bytes);
        // Pick the content type from the master's name when it is clear.
        if (lower.contains('encouragement')) {
          _model.contentType = 'encouragements';
        } else if (lower.contains('scripture')) {
          _model.contentType = 'daily_scripture';
        }
      } else {
        String text;
        try {
          text = utf8.decode(bytes);
        } on FormatException {
          _snack('${file.name} is not UTF-8. Save it as "CSV UTF-8" and try '
              'again.');
          return;
        }
        _model.csvText = text;
        _model.fileBase64 = null;
      }
      _model.fileName = file.name;
      _model.report = null;
      _model.callError = null;
      safeSetState(() {});
    } catch (err) {
      _snack('Could not open the file: $err');
    }
  }

  Future<void> _run(String mode) async {
    final csvText = _model.csvText;
    final fileBase64 = _model.fileBase64;
    if ((csvText == null && fileBase64 == null) ||
        _model.runningMode != null) {
      return;
    }
    if (mode == 'commit') {
      final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Import as draft?'),
          content: Text(
            'Import ${_model.fileName} into '
            '${kImportContentTypes[_model.contentType]}. New records are '
            'created as draft; existing records (same stableId) are updated. '
            'Nothing is written if the file has errors.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Import'),
            ),
          ],
        ),
      );
      if (ok != true) {
        return;
      }
    }
    _model.runningMode = mode;
    _model.callError = null;
    safeSetState(() {});
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable(
        'importContentCsv',
        options: HttpsCallableOptions(
          timeout: const Duration(seconds: 300),
        ),
      )
          .call({
        'type': _model.contentType,
        'fileName': _model.fileName ?? '',
        if (csvText != null) 'csvText': csvText,
        if (fileBase64 != null) 'fileBase64': fileBase64,
        'mode': mode,
      });
      _model.report = _jsonMap(result.data);
    } on FirebaseFunctionsException catch (err) {
      _model.callError = err.message ?? err.code;
    } catch (err) {
      _model.callError = '$err';
    } finally {
      _model.runningMode = null;
      safeSetState(() {});
    }
  }

  /// Deep-converts callable / Firestore data into JSON-safe maps.
  static Map<String, dynamic> _jsonMap(Object? data) {
    Object? convert(Object? v) {
      if (v is Map) {
        return {for (final e in v.entries) '${e.key}': convert(e.value)};
      }
      if (v is List) {
        return v.map(convert).toList();
      }
      if (v is Timestamp) {
        return v.toDate().toUtc().toIso8601String();
      }
      if (v == null || v is num || v is bool || v is String) {
        return v;
      }
      return '$v';
    }

    final out = convert(data);
    return out is Map<String, dynamic> ? out : <String, dynamic>{};
  }

  String _reportAsText(Map<String, dynamic> r) {
    final b = StringBuffer();
    final totals = _map(r['totals']);
    b.writeln('Kingdom Heirs content import report');
    b.writeln('Job: ${r['jobId'] ?? ''}');
    b.writeln('File: ${r['fileName'] ?? ''}');
    b.writeln('Content type: ${r['typeLabel'] ?? r['type'] ?? ''}');
    b.writeln('Mode: ${r['mode'] ?? ''}'
        '${r['committed'] == true ? ' (committed)' : ' (nothing written)'}');
    b.writeln('Date imported: ${_formatDate(r['importedAt'])}');
    if ((r['email'] ?? '').toString().isNotEmpty) {
      b.writeln('By: ${r['email']}');
    }
    b.writeln('');
    b.writeln(
        'Rows: ${totals['rows'] ?? 0}  Inserted: ${totals['inserted'] ?? 0}'
        '  Updated: ${totals['updated'] ?? 0}'
        '  Skipped (unchanged): ${totals['unchanged'] ?? 0}'
        '  Failed: ${totals['failed'] ?? 0}');
    final dup = _map(r['duplicateCheck']);
    final dupsInFile = _list(dup['duplicatesInFile']);
    b.writeln('Duplicate check: ${dupsInFile.length} duplicate(s) in file; '
        '${dup['existingMatchedByStableId'] ?? 0} existing record(s) matched '
        'by stableId');
    for (final d in dupsInFile) {
      final m = _map(d);
      b.writeln('  - ${m['kind']} ${m['value']} on rows '
          '${_list(m['rows']).join(', ')}');
    }
    b.writeln('Publication status: ${_mapLine(_map(r['publicationStatus']))}');
    b.writeln('Translation status (rows with text): '
        '${_mapLine(_map(r['translationStatus']))}');
    final errors = _list(r['errors']);
    b.writeln('');
    b.writeln('Errors (${errors.length}):');
    for (final e in errors) {
      final m = _map(e);
      b.writeln('  Row ${m['row']}  ${m['column']}: ${m['message']}');
    }
    final warnings = _list(r['warnings']);
    b.writeln('Warnings (${warnings.length}):');
    for (final w in warnings) {
      final m = _map(w);
      b.writeln('  Row ${m['row']}  ${m['column']}: ${m['message']}');
    }
    for (final n in _list(r['notes'])) {
      b.writeln('Note: $n');
    }
    return b.toString();
  }

  static Map<String, dynamic> _map(Object? v) =>
      v is Map<String, dynamic> ? v : <String, dynamic>{};

  static List<dynamic> _list(Object? v) => v is List ? v : const [];

  static String _mapLine(Map<String, dynamic> m) =>
      m.entries.map((e) => '${e.key} ${e.value}').join(', ');

  static String _formatDate(Object? iso) {
    final parsed = DateTime.tryParse('${iso ?? ''}');
    if (parsed == null) {
      return '${iso ?? ''}';
    }
    return DateFormat('yyyy-MM-dd HH:mm').format(parsed.toLocal());
  }

  Future<void> _copyReport(Map<String, dynamic> r, {bool json = false}) async {
    final text =
        json ? const JsonEncoder.withIndent('  ').convert(r) : _reportAsText(r);
    await Clipboard.setData(ClipboardData(text: text));
    _snack(json ? 'Report JSON copied.' : 'Report copied.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          'Import Content',
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
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    if (_model.isAdmin == null) {
      return Center(child: CircularProgressIndicator(color: theme.primary));
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
              Text('Not authorized', style: _strong(theme.titleMedium)),
              const SizedBox(height: 6.0),
              Text(
                'Only admins can import content.',
                textAlign: TextAlign.center,
                style: _muted(theme.bodyMedium),
              ),
            ],
          ),
        ),
      );
    }

    final report = _model.report;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 32.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPicker(context),
              if (_model.callError != null) ...[
                const SizedBox(height: 12.0),
                _card(
                  context,
                  child: Text(
                    _model.callError!,
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: theme.error,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ],
              if (report != null) ...[
                const SizedBox(height: 12.0),
                _buildReport(context, report),
              ],
              const SizedBox(height: 20.0),
              Text('Recent imports', style: _strong(theme.titleMedium)),
              const SizedBox(height: 8.0),
              _buildJobs(context),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _strong(TextStyle base) => base.override(
        font: GoogleFonts.inter(fontWeight: FontWeight.w600),
        letterSpacing: 0.0,
        fontWeight: FontWeight.w600,
      );

  TextStyle _muted(TextStyle base) => base.override(
        font: GoogleFonts.inter(),
        color: FlutterFlowTheme.of(context).secondaryText,
        letterSpacing: 0.0,
      );

  Widget _card(BuildContext context, {required Widget child}) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.alternate),
      ),
      child: child,
    );
  }

  Widget _buildPicker(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: theme.alternate, width: 1.0),
      borderRadius: BorderRadius.circular(8.0),
    );
    final running = _model.runningMode;
    final hasFile = _model.csvText != null || _model.fileBase64 != null;
    Widget spinner() => const SizedBox(
          width: 16.0,
          height: 16.0,
          child: CircularProgressIndicator(strokeWidth: 2.0),
        );
    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Upload a UTF-8 CSV in the template format (docs/import). '
            'Preview checks the file without writing anything. Import as '
            'Draft writes it only if every row is valid: new records are '
            'draft, existing records are matched and updated by stableId.',
            style: _muted(theme.bodySmall),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 240.0,
                child: DropdownButtonFormField<String>(
                  initialValue: _model.contentType,
                  decoration: InputDecoration(
                    labelText: 'Content type',
                    isDense: true,
                    filled: true,
                    fillColor: theme.primaryBackground,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: theme.primary, width: 1.0),
                    ),
                  ),
                  items: [
                    for (final e in kImportContentTypes.entries)
                      DropdownMenuItem(value: e.key, child: Text(e.value)),
                  ],
                  onChanged: running != null
                      ? null
                      : (v) {
                          _model.contentType = v ?? _model.contentType;
                          _model.report = null;
                          safeSetState(() {});
                        },
                ),
              ),
              OutlinedButton.icon(
                onPressed: running != null ? null : _pickFile,
                icon: const Icon(Icons.attach_file_rounded, size: 18.0),
                label: const Text('Choose file (CSV, Excel or ZIP)'),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            _model.fileName == null
                ? 'No file chosen.'
                : 'File: ${_model.fileName}',
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              letterSpacing: 0.0,
            ),
          ),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              OutlinedButton.icon(
                onPressed:
                    !hasFile || running != null ? null : () => _run('preview'),
                icon: running == 'preview'
                    ? spinner()
                    : const Icon(Icons.fact_check_outlined, size: 18.0),
                label: const Text('Preview'),
              ),
              FilledButton.icon(
                onPressed:
                    !hasFile || running != null ? null : () => _run('commit'),
                style: FilledButton.styleFrom(backgroundColor: theme.primary),
                icon: running == 'commit'
                    ? spinner()
                    : const Icon(Icons.upload_rounded, size: 18.0),
                label: const Text('Import as Draft'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReport(BuildContext context, Map<String, dynamic> r) {
    final theme = FlutterFlowTheme.of(context);
    final totals = _map(r['totals']);
    final dup = _map(r['duplicateCheck']);
    final dupsInFile = _list(dup['duplicatesInFile']);
    final errors = _list(r['errors']);
    final warnings = _list(r['warnings']);
    final committed = r['committed'] == true;
    final isPreview = r['mode'] == 'preview';
    final valid = r['valid'] == true;

    final String headline;
    final Color headlineColor;
    if (committed) {
      headline = 'Imported';
      headlineColor = theme.success;
    } else if (isPreview && valid) {
      headline = 'Preview: ready to import';
      headlineColor = theme.success;
    } else if (isPreview) {
      headline = 'Preview: fix the errors below';
      headlineColor = theme.error;
    } else {
      headline = 'Not imported: fix the errors and import again';
      headlineColor = theme.error;
    }

    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                valid ? Icons.check_circle_rounded : Icons.error_rounded,
                color: headlineColor,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  headline,
                  style:
                      _strong(theme.titleMedium).copyWith(color: headlineColor),
                ),
              ),
              IconButton(
                tooltip: 'Copy report',
                onPressed: () => _copyReport(r),
                icon: const Icon(Icons.copy_rounded),
              ),
              IconButton(
                tooltip: 'Copy report as JSON',
                onPressed: () => _copyReport(r, json: true),
                icon: const Icon(Icons.data_object_rounded),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          _kv(context, 'File', '${r['fileName'] ?? ''}'),
          if ((r['source'] ?? '') != '')
            _kv(context, 'Read from',
                '${r['source']} (${r['sourceFormat'] ?? ''})'),
          _kv(context, 'Content type', '${r['typeLabel'] ?? r['type'] ?? ''}'),
          _kv(context, 'Date imported', _formatDate(r['importedAt'])),
          _kv(
              context,
              'Mode',
              '${isPreview ? 'Preview' : 'Import as draft'}'
                  '${committed ? ' (written)' : ' (nothing written)'}'),
          if ((r['email'] ?? '').toString().isNotEmpty)
            _kv(context, 'By', '${r['email']}'),
          _kv(context, 'Job ID', '${r['jobId'] ?? ''}'),
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _countChip(context, 'Rows', totals['rows'], theme.secondaryText),
              _countChip(
                  context, 'Inserted', totals['inserted'], theme.success),
              _countChip(context, 'Updated', totals['updated'], theme.primary),
              _countChip(context, 'Skipped (unchanged)', totals['unchanged'],
                  theme.secondaryText),
              _countChip(context, 'Failed', totals['failed'], theme.error),
            ],
          ),
          const SizedBox(height: 14.0),
          _section(context, 'Duplicate check'),
          Text(
            '${dupsInFile.length} duplicate(s) within the file  ·  '
            '${dup['existingMatchedByStableId'] ?? 0} existing record(s) '
            'matched by stableId (updated, not duplicated)',
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(),
              letterSpacing: 0.0,
            ),
          ),
          for (final d in dupsInFile)
            Text(
              '• ${_map(d)['kind']} ${_map(d)['value']} on rows '
              '${_list(_map(d)['rows']).join(', ')}',
              style: _muted(theme.bodySmall),
            ),
          const SizedBox(height: 12.0),
          _section(
              context,
              committed
                  ? 'Publication status'
                  : 'Publication status after import'),
          _statWrap(context, _map(r['publicationStatus'])),
          const SizedBox(height: 12.0),
          _section(context, 'Translation status (rows with text)'),
          _statWrap(context, _map(r['translationStatus']),
              total: totals['rows']),
          for (final n in _list(r['notes'])) ...[
            const SizedBox(height: 8.0),
            Text('$n', style: _muted(theme.bodySmall)),
          ],
          const SizedBox(height: 12.0),
          _section(context, 'Errors (${errors.length})'),
          _issueList(context, errors, theme.error),
          if (r['errorsTruncated'] != null)
            Text('Showing the first ${errors.length} of '
                '${r['errorsTruncated']} errors.'),
          const SizedBox(height: 12.0),
          _section(context, 'Warnings (${warnings.length})'),
          _issueList(context, warnings, theme.warning),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String label, String value) {
    final theme = FlutterFlowTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.0,
            child: Text(label, style: _muted(theme.bodySmall)),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(),
                letterSpacing: 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Text(title,
            style: _strong(FlutterFlowTheme.of(context).titleSmall)),
      );

  Widget _countChip(
      BuildContext context, String label, Object? count, Color color) {
    final theme = FlutterFlowTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        '$label: ${count ?? 0}',
        style: theme.labelMedium.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
          color: color,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _statWrap(BuildContext context, Map<String, dynamic> stats,
      {Object? total}) {
    final theme = FlutterFlowTheme.of(context);
    if (stats.isEmpty) {
      return Text('None', style: _muted(theme.bodySmall));
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (final e in stats.entries)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: theme.primaryBackground,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: theme.alternate),
            ),
            child: Text(
              total == null
                  ? '${e.key}: ${e.value}'
                  : '${e.key}: ${e.value} / $total',
              style: theme.bodySmall.override(
                font: GoogleFonts.inter(),
                letterSpacing: 0.0,
              ),
            ),
          ),
      ],
    );
  }

  Widget _issueList(BuildContext context, List<dynamic> issues, Color color) {
    final theme = FlutterFlowTheme.of(context);
    if (issues.isEmpty) {
      return Text('None', style: _muted(theme.bodySmall));
    }
    return Container(
      constraints: const BoxConstraints(maxHeight: 320.0),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: theme.alternate),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        itemCount: issues.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1.0, color: theme.alternate),
        itemBuilder: (context, index) {
          final m = _map(issues[index]);
          final column = '${m['column'] ?? ''}';
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 64.0,
                  child: Text(
                    'Row ${m['row'] ?? ''}',
                    style: theme.bodySmall.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      color: color,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 130.0,
                  child: Text(
                    column.isEmpty ? '-' : column,
                    style: _muted(theme.bodySmall),
                  ),
                ),
                Expanded(
                  child: SelectableText(
                    '${m['message'] ?? ''}',
                    style: theme.bodySmall.override(
                      font: GoogleFonts.inter(),
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildJobs(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _jobsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Could not load recent imports: ${snapshot.error}',
            style: theme.bodySmall.override(
              font: GoogleFonts.inter(),
              color: theme.error,
              letterSpacing: 0.0,
            ),
          );
        }
        final docs = snapshot.data?.docs;
        if (docs == null) {
          return Center(child: CircularProgressIndicator(color: theme.primary));
        }
        if (docs.isEmpty) {
          return Text('No imports yet.', style: _muted(theme.bodySmall));
        }
        return Column(
          children: [
            for (final doc in docs) _buildJobRow(context, doc),
          ],
        );
      },
    );
  }

  Widget _buildJobRow(
      BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final theme = FlutterFlowTheme.of(context);
    final data = _jsonMap(doc.data());
    data['jobId'] ??= doc.id;
    final totals = _map(data['totals']);
    final committed = data['committed'] == true;
    final isPreview = data['mode'] == 'preview';
    final selected = _model.report?['jobId'] == doc.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: selected
            ? theme.primary.withValues(alpha: 0.08)
            : theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            _model.report = data;
            _model.callError = null;
            safeSetState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(
                  committed
                      ? Icons.cloud_done_outlined
                      : isPreview
                          ? Icons.fact_check_outlined
                          : Icons.cloud_off_outlined,
                  color: committed
                      ? theme.success
                      : isPreview
                          ? theme.secondaryText
                          : theme.error,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data['fileName'] ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _strong(theme.bodyMedium),
                      ),
                      Text(
                        '${data['typeLabel'] ?? data['type'] ?? ''}  ·  '
                        '${isPreview ? 'preview' : committed ? 'imported' : 'rejected'}  ·  '
                        '${_formatDate(data['importedAt'])}'
                        '${(data['email'] ?? '').toString().isEmpty ? '' : '  ·  ${data['email']}'}',
                        style: _muted(theme.bodySmall),
                      ),
                      Text(
                        '${totals['rows'] ?? 0} rows: '
                        '${totals['inserted'] ?? 0} inserted, '
                        '${totals['updated'] ?? 0} updated, '
                        '${totals['unchanged'] ?? 0} skipped, '
                        '${totals['failed'] ?? 0} failed',
                        style: _muted(theme.bodySmall),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: theme.secondaryText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
