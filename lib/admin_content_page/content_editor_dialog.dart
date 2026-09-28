import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui' as ui show TextDirection;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_content_page_model.dart';

const _kLanguages = [
  ('en', 'English'),
  ('es', 'Spanish'),
  ('ur', 'Urdu'),
  ('lg', 'Luganda'),
];

/// Create / edit form for one Daily Scripture or Encouragement record.
///
/// Pass [scripture] or [encouragement] to edit; pass neither to create a new
/// record of [kind]. [takenDates] maps each scheduled date to the record path
/// already using it, so we can warn about double-booking a day.
class ContentEditorDialog extends StatefulWidget {
  const ContentEditorDialog({
    super.key,
    required this.kind,
    this.scripture,
    this.encouragement,
    this.takenDates = const {},
  });

  final AdminContentKind kind;
  final DailyScriptureRecord? scripture;
  final EncouragementsRecord? encouragement;
  final Map<String, String> takenDates;

  @override
  State<ContentEditorDialog> createState() => _ContentEditorDialogState();
}

class _ContentEditorDialogState extends State<ContentEditorDialog> {
  final _formKey = GlobalKey<FormState>();

  late String _date;
  late String _status;
  late bool _rightsCleared;
  late final TextEditingController _stableIdController;
  // verseRef (scripture) or attribution (encouragement).
  late final TextEditingController _referenceController;
  late final Map<String, TextEditingController> _textControllers;

  bool _saving = false;

  bool get _isScripture => widget.kind == AdminContentKind.scripture;
  bool get _isNew => widget.scripture == null && widget.encouragement == null;
  DocumentReference? get _existingRef =>
      widget.scripture?.reference ?? widget.encouragement?.reference;

  @override
  void initState() {
    super.initState();
    final s = widget.scripture;
    final e = widget.encouragement;
    final LocaleTextStruct text = _isScripture
        ? (s?.text ?? LocaleTextStruct())
        : (e?.quote ?? LocaleTextStruct());

    _date = (s?.date ?? e?.date ?? '').isNotEmpty
        ? (s?.date ?? e?.date)!
        : DateFormat(kContentDateFormat).format(DateTime.now());
    final status = s?.status ?? e?.status ?? '';
    _status = kContentStatuses.contains(status) ? status : 'draft';
    _rightsCleared = e?.rightsCleared ?? false;
    _stableIdController =
        TextEditingController(text: s?.stableId ?? e?.stableId ?? '');
    _referenceController =
        TextEditingController(text: s?.verseRef ?? e?.attribution ?? '');
    _textControllers = {
      'en': TextEditingController(text: text.en),
      'es': TextEditingController(text: text.es),
      'ur': TextEditingController(text: text.ur),
      'lg': TextEditingController(text: text.lg),
    };
  }

  @override
  void dispose() {
    _stableIdController.dispose();
    _referenceController.dispose();
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String? get _dateConflictWarning {
    final takenBy = widget.takenDates[_date];
    if (takenBy == null || takenBy == _existingRef?.path) {
      return null;
    }
    return 'Another record is already scheduled for $_date.';
  }

  Future<void> _pickDate() async {
    final initial = parseContentDate(_date) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = DateFormat(kContentDateFormat).format(picked));
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _saving = true);

    final localeText = createLocaleTextStruct(
      en: _textControllers['en']!.text.trim(),
      es: _textControllers['es']!.text.trim(),
      ur: _textControllers['ur']!.text.trim(),
      lg: _textControllers['lg']!.text.trim(),
    );
    final stableId = _stableIdController.text.trim().isNotEmpty
        ? _stableIdController.text.trim()
        : '${_isScripture ? 'scripture' : 'encouragement'}-$_date';

    final data = _isScripture
        // The imported records carry the reference twice; keep both equal.
        ? (createDailyScriptureRecordData(
            date: _date,
            verseRef: _referenceController.text.trim(),
            text: localeText,
            status: _status,
            stableId: stableId,
          )..['reference'] = _referenceController.text.trim())
        : createEncouragementsRecordData(
            date: _date,
            quote: localeText,
            attribution: _referenceController.text.trim(),
            rightsCleared: _rightsCleared,
            status: _status,
            stableId: stableId,
          );

    try {
      final ref = _existingRef;
      if (ref != null) {
        await ref.update(data);
      } else {
        final collection = _isScripture
            ? DailyScriptureRecord.collection
            : EncouragementsRecord.collection;
        await collection.doc().set(data);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (err) {
      if (!mounted) {
        return;
      }
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save: $err'),
          duration: const Duration(milliseconds: 5000),
        ),
      );
    }
  }

  InputDecoration _decoration(String label, {String? hint}) {
    final theme = FlutterFlowTheme.of(context);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: theme.secondaryBackground,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.alternate, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primary, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final textLabel = _isScripture ? 'Scripture text' : 'Encouragement';
    final kindLabel = _isScripture ? 'Daily Scripture' : 'Encouragement';
    final warning = _dateConflictWarning;

    return AlertDialog(
      backgroundColor: theme.primaryBackground,
      title: Text(
        '${_isNew ? 'New' : 'Edit'} $kindLabel',
        style: theme.titleLarge.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SizedBox(
        width: 560.0,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Schedule date.
                InkWell(
                  onTap: _saving ? null : _pickDate,
                  child: InputDecorator(
                    decoration: _decoration('Scheduled date'),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _date,
                            style: theme.bodyMedium.override(
                              font: GoogleFonts.inter(),
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        Icon(Icons.calendar_today_rounded,
                            size: 18.0, color: theme.secondaryText),
                      ],
                    ),
                  ),
                ),
                if (warning != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      warning,
                      style: theme.bodySmall.override(
                        font: GoogleFonts.inter(),
                        color: theme.warning,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                const SizedBox(height: 12.0),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  decoration: _decoration('Status'),
                  items: kContentStatuses
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: _saving
                      ? null
                      : (v) => setState(() => _status = v ?? _status),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _referenceController,
                  enabled: !_saving,
                  decoration: _decoration(
                    _isScripture ? 'Verse reference' : 'Attribution',
                    hint: _isScripture ? 'e.g. John 3:16' : 'e.g. Psalm 118:24',
                  ),
                  validator: _isScripture
                      ? (v) => (v ?? '').trim().isEmpty
                          ? 'Verse reference is required'
                          : null
                      : null,
                ),
                const SizedBox(height: 12.0),
                for (final (code, name) in _kLanguages) ...[
                  TextFormField(
                    controller: _textControllers[code],
                    enabled: !_saving,
                    minLines: 2,
                    maxLines: 6,
                    textDirection: code == 'ur'
                        ? ui.TextDirection.rtl
                        : ui.TextDirection.ltr,
                    decoration: _decoration(
                      '$textLabel ($name)',
                      hint: code == 'en'
                          ? 'Required'
                          : 'Optional - falls back to English',
                    ),
                    validator: code == 'en'
                        ? (v) => (v ?? '').trim().isEmpty
                            ? 'English text is required'
                            : null
                        : null,
                  ),
                  const SizedBox(height: 12.0),
                ],
                if (!_isScripture)
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _rightsCleared,
                    onChanged: _saving
                        ? null
                        : (v) => setState(() => _rightsCleared = v),
                    title: Text(
                      'Rights cleared',
                      style: theme.bodyMedium.override(
                        font: GoogleFonts.inter(),
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
                TextFormField(
                  controller: _stableIdController,
                  enabled: !_saving,
                  decoration: _decoration(
                    'Stable ID',
                    hint: 'Auto-generated from the date if left blank',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: theme.primary),
          child: _saving
              ? const SizedBox(
                  width: 18.0,
                  height: 18.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Colors.white,
                  ),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
