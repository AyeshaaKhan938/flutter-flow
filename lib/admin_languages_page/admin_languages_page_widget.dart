import 'dart:ui' as ui;
import 'package:cloud_functions/cloud_functions.dart';

import '/admin_content_page/admin_content_page_model.dart'
    show kContentAdminRoles;
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/internationalization.dart' show kTranslationsMap;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_languages_page_model.dart';
export 'admin_languages_page_model.dart';

/// Admin page for CMS-managed languages and translation review.
///
/// - Languages: add / edit / activate languages (tier approved or machine,
///   RTL, order, API.Bible id). Members see changes without an app update.
/// - Translation review: correct and approve (or reject) machine
///   translations in `machineTranslations`; approved text is shown to
///   members without the machine-translation notice.
///
/// Gated on `users/{uid}.role` in [kContentAdminRoles]; Firestore rules
/// enforce the same check on writes.
class AdminLanguagesPageWidget extends StatefulWidget {
  const AdminLanguagesPageWidget({super.key});

  static String routeName = 'AdminLanguagesPage';
  static String routePath = '/admin/languages';

  @override
  State<AdminLanguagesPageWidget> createState() =>
      _AdminLanguagesPageWidgetState();
}

class _AdminLanguagesPageWidgetState extends State<AdminLanguagesPageWidget> {
  late AdminLanguagesPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CollectionReference<Map<String, dynamic>> get _languagesRef =>
      FirebaseFirestore.instance.collection('languages');
  CollectionReference<Map<String, dynamic>> get _translationsRef =>
      FirebaseFirestore.instance.collection('machineTranslations');

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _languagesStream;

  // Review query stream, recreated only when its filters change.
  Stream<QuerySnapshot<Map<String, dynamic>>>? _reviewStream;
  String? _reviewStreamKey;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminLanguagesPageModel());
    _languagesStream = _languagesRef.snapshots();
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

  List<AppLanguage> _parse(QuerySnapshot<Map<String, dynamic>>? snap) {
    final list = (snap?.docs ?? const [])
        .map((d) => AppLanguage.fromMap(d.data(), d.id))
        .whereType<AppLanguage>()
        .toList()
      ..sort((a, b) => a.order != b.order
          ? a.order.compareTo(b.order)
          : a.englishName.compareTo(b.englishName));
    return list;
  }

  // ---------------------------------------------------------------- Languages

  Future<void> _seedDefaults() async {
    try {
      var created = 0;
      for (final lang in kDefaultLanguages) {
        final ref = _languagesRef.doc(lang.code);
        final existing = await ref.get();
        if (existing.exists) {
          continue; // Never overwrite an administrator's settings.
        }
        await ref.set({
          ...lang.toMap(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        created++;
      }
      await LanguageRegistry.instance.refresh();
      _snack(created == 0
          ? 'Default languages already exist.'
          : 'Added $created default language(s).');
    } catch (err) {
      _snack('Could not seed languages: $err');
    }
  }

  Future<void> _editLanguage(AppLanguage? lang) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _LanguageEditorDialog(language: lang),
    );
    if (saved == true) {
      await LanguageRegistry.instance.refresh();
      _snack('Language saved.');
    }
  }

  Widget _buildLanguagesTab() {
    final theme = FlutterFlowTheme.of(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _languagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Could not load languages.'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: theme.primary));
        }
        final languages = _parse(snapshot.data);
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                FilledButton.icon(
                  onPressed: () => _editLanguage(null),
                  icon: const Icon(Icons.add),
                  label: const Text('Add language'),
                ),
                OutlinedButton.icon(
                  onPressed: _seedDefaults,
                  icon: const Icon(Icons.playlist_add),
                  label: const Text('Seed default languages'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Active languages appear in the member language picker '
              'immediately: "approved" under Approved languages, "machine" '
              'under More languages with a machine-translation notice. '
              'English is the master source.',
              style: theme.labelSmall.override(
                font: GoogleFonts.inter(),
                color: theme.secondaryText,
                letterSpacing: 0.0,
              ),
            ),
            const SizedBox(height: 12.0),
            if (languages.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'No languages in the CMS yet. The app is using the built-in '
                  'English, Spanish, Urdu and Luganda. Tap "Seed default '
                  'languages" to manage them here.',
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium,
                ),
              ),
            ...languages.map((l) => Card(
                  child: ListTile(
                    title: Text(
                      l.name == l.englishName
                          ? '${l.name} (${l.code})'
                          : '${l.name} · ${l.englishName} (${l.code})',
                    ),
                    subtitle: Text([
                      l.isApproved ? 'Approved' : 'Machine-translated',
                      l.active ? 'active' : 'inactive',
                      if (l.rtl) 'RTL',
                      'order ${l.order}',
                      l.bibleId.isEmpty
                          ? 'Bible: English (no approved Bible)'
                          : 'Bible: ${l.bibleName.isEmpty ? l.bibleId : l.bibleName}',
                    ].join(' · ')),
                    leading: Icon(
                      l.active ? Icons.check_circle : Icons.pause_circle,
                      color: l.active ? theme.success : theme.secondaryText,
                    ),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () => _editLanguage(l),
                  ),
                )),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------- Translation review

  TextEditingController _editorFor(String id, String initial) =>
      _model.editors.putIfAbsent(id, () => TextEditingController(text: initial));

  Future<void> _approve(DocumentSnapshot<Map<String, dynamic>> doc) async {
    final text = _model.editors[doc.id]?.text.trim() ?? '';
    if (text.isEmpty) {
      _snack('Enter the corrected translation first.');
      return;
    }
    _model.busy.add(doc.id);
    safeSetState(() {});
    try {
      await doc.reference.update({
        'status': 'approved',
        'approvedText': text,
        'reviewedBy': currentUserUid,
        'reviewedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (err) {
      _snack('Could not approve: $err');
    } finally {
      _model.busy.remove(doc.id);
      safeSetState(() {});
    }
  }

  Future<void> _reject(DocumentSnapshot<Map<String, dynamic>> doc) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reject translation?'),
        content: const Text(
            'The cached translation is deleted. Members see English (or a '
            'fresh machine translation the next time it is requested).'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
    if (ok != true) {
      return;
    }
    _model.busy.add(doc.id);
    safeSetState(() {});
    try {
      await doc.reference.delete();
      _model.editors.remove(doc.id)?.dispose();
    } catch (err) {
      _snack('Could not reject: $err');
    } finally {
      _model.busy.remove(doc.id);
      safeSetState(() {});
    }
  }

  /// English source texts of all published Kingdom Heirs content without a
  /// stored translation in [lang], plus UI labels. Never Scripture.
  Future<List<String>> _collectSourceTexts(String lang) async {
    final texts = <String>{kMachineTranslationNotice, kEnglishBibleNotice};
    void add(LocaleTextStruct t) {
      if (t.en.isNotEmpty && t.storedText(lang).isEmpty) {
        texts.add(t.en);
      }
    }

    final lessons = await queryLessonsRecordOnce(
      queryBuilder: (q) => q.where('status', isEqualTo: 'published'),
    );
    for (final l in lessons) {
      add(l.title);
      add(l.reflectionPrompt);
      add(l.application);
      add(l.prayer);
    }
    final pathways = await queryPathwaysRecordOnce(
      queryBuilder: (q) => q.where('status', isEqualTo: 'published'),
    );
    for (final p in pathways) {
      add(p.title);
      add(p.description);
    }
    final encouragements = await queryEncouragementsRecordOnce(
      queryBuilder: (q) => q.where('status', isEqualTo: 'published'),
    );
    for (final e in encouragements) {
      add(e.quote);
    }
    final daily = await queryDailyScriptureRecordOnce(
      queryBuilder: (q) => q.where('status', isEqualTo: 'published'),
    );
    for (final d in daily) {
      add(d.text); // Daily Truth commentary (the verse comes from API.Bible).
    }
    final announcements = await queryAnnouncementsRecordOnce();
    for (final a in announcements) {
      add(a.title);
      add(a.body);
    }
    if (!kCompiledLanguages.contains(lang)) {
      for (final entry in kTranslationsMap.values) {
        final en = entry['en'] ?? '';
        if (en.isNotEmpty) {
          texts.add(en);
        }
      }
    }
    return texts.where((t) => t.trim().isNotEmpty && t.length <= 5000).toList();
  }

  Future<void> _generateAll(String lang) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Generate translations for ${LanguageRegistry.instance.labelFor(lang)}?'),
        content: const Text(
            'Sends the English text of all published lessons, pathways, '
            'Daily Truth commentary, encouragements, announcements and app '
            'labels to Google Cloud Translation. Texts already translated '
            'are answered from the cache at no cost; new texts are billed '
            'per character. Scripture is never sent.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Generate'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    _model.generateProgress = 'Collecting content…';
    safeSetState(() {});
    try {
      final texts = await _collectSourceTexts(lang);
      final callable = FirebaseFunctions.instance.httpsCallable(
        'translateTexts',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 120)),
      );
      for (var i = 0; i < texts.length; i += 100) {
        final end = i + 100 > texts.length ? texts.length : i + 100;
        _model.generateProgress = 'Translating $end of ${texts.length}…';
        safeSetState(() {});
        await callable.call({
          'targetLanguage': lang,
          'texts': texts.sublist(i, end),
        });
      }
      _snack('Translations ready for ${texts.length} texts.');
    } catch (err) {
      _snack('Translation stopped: $err');
    } finally {
      _model.generateProgress = null;
      safeSetState(() {});
    }
  }

  Widget _buildReviewTab() {
    final theme = FlutterFlowTheme.of(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _languagesStream,
      builder: (context, langSnap) {
        final languages = _parse(langSnap.data).where((l) => l.code != 'en');
        final fallback = LanguageRegistry.instance.active
            .where((l) => l.code != 'en')
            .toList();
        final options = languages.isNotEmpty ? languages.toList() : fallback;
        if (options.isEmpty) {
          return const Center(child: Text('Add a language first.'));
        }
        final lang = options.any((l) => l.code == _model.reviewLanguage)
            ? _model.reviewLanguage!
            : options.first.code;

        Query<Map<String, dynamic>> query =
            _translationsRef.where('targetLanguage', isEqualTo: lang);
        if (_model.reviewStatus != null) {
          query = query.where('status', isEqualTo: _model.reviewStatus);
        }
        query = query.limit(500);
        final streamKey = '$lang|${_model.reviewStatus}';
        if (_reviewStreamKey != streamKey) {
          _reviewStreamKey = streamKey;
          _reviewStream = query.snapshots();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
              child: Wrap(
                spacing: 12.0,
                runSpacing: 8.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: lang,
                    items: options
                        .map((l) => DropdownMenuItem(
                              value: l.code,
                              child: Text('${l.englishName} (${l.code})'),
                            ))
                        .toList(),
                    onChanged: (v) =>
                        safeSetState(() => _model.reviewLanguage = v),
                  ),
                  DropdownButton<String?>(
                    value: _model.reviewStatus,
                    items: const [
                      DropdownMenuItem(
                          value: 'machine', child: Text('Awaiting review')),
                      DropdownMenuItem(
                          value: 'approved', child: Text('Approved')),
                      DropdownMenuItem(value: null, child: Text('All')),
                    ],
                    onChanged: (v) =>
                        safeSetState(() => _model.reviewStatus = v),
                  ),
                  SizedBox(
                    width: 220.0,
                    child: TextField(
                      decoration: const InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Filter text',
                      ),
                      onChanged: (v) => safeSetState(
                          () => _model.reviewSearch = v.trim().toLowerCase()),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _model.generateProgress != null
                        ? null
                        : () => _generateAll(lang),
                    icon: const Icon(Icons.auto_awesome),
                    label: Text(_model.generateProgress ??
                        'Generate translations for all published content'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                key: ValueKey(streamKey),
                stream: _reviewStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Could not load translations: '
                            '${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(color: theme.primary));
                  }
                  final search = _model.reviewSearch;
                  final docs = snapshot.data!.docs.where((d) {
                    if (search.isEmpty) {
                      return true;
                    }
                    final m = d.data();
                    return '${m['sourceText']} ${m['translatedText']} ${m['approvedText'] ?? ''}'
                        .toLowerCase()
                        .contains(search);
                  }).toList()
                    ..sort((a, b) => '${a.data()['sourceText']}'
                        .compareTo('${b.data()['sourceText']}'));
                  if (docs.isEmpty) {
                    return const Center(child: Text('Nothing to review.'));
                  }
                  final rtl = LanguageRegistry.instance.isRtl(lang);
                  return ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8.0),
                    itemBuilder: (context, i) =>
                        _buildReviewCard(docs[i], rtl),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReviewCard(
      QueryDocumentSnapshot<Map<String, dynamic>> doc, bool rtl) {
    final theme = FlutterFlowTheme.of(context);
    final m = doc.data();
    final approved = m['status'] == 'approved';
    final machineText = '${m['translatedText'] ?? ''}';
    final editor = _editorFor(
        doc.id, '${m['approvedText'] ?? m['translatedText'] ?? ''}');
    final busy = _model.busy.contains(doc.id);
    final labelStyle = theme.labelSmall.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
      color: theme.secondaryText,
      letterSpacing: 0.0,
      fontWeight: FontWeight.w600,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text('English (source)', style: labelStyle)),
                Chip(
                  label: Text(approved ? 'Approved' : 'Machine'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            SelectableText('${m['sourceText'] ?? ''}'),
            const SizedBox(height: 8.0),
            Text('Machine translation', style: labelStyle),
            Directionality(
              textDirection: rtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              child: SelectableText(machineText),
            ),
            const SizedBox(height: 8.0),
            Directionality(
              textDirection: rtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              child: TextField(
                controller: editor,
                minLines: 1,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Corrected translation',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: busy ? null : () => _reject(doc),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Reject'),
                ),
                const SizedBox(width: 8.0),
                FilledButton.icon(
                  onPressed: busy ? null : () => _approve(doc),
                  icon: const Icon(Icons.check),
                  label: Text(approved ? 'Save approved' : 'Approve'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------- Page

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
                'Only admins can manage languages and translations.',
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
      body = TabBarView(
        children: [_buildLanguagesTab(), _buildReviewTab()],
      );
    }
    // Admin tooling is English-only, left-to-right.
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: DefaultTabController(
        length: 2,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: theme.primaryBackground,
            appBar: AppBar(
              backgroundColor: theme.primaryBackground,
              automaticallyImplyLeading: true,
              title: Text(
                'Languages',
                style: theme.titleLarge.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              bottom: _model.isAdmin == true
                  ? TabBar(
                      labelColor: theme.primary,
                      unselectedLabelColor: theme.secondaryText,
                      indicatorColor: theme.primary,
                      tabs: const [
                        Tab(text: 'Languages'),
                        Tab(text: 'Translation review'),
                      ],
                    )
                  : null,
            ),
            body: SafeArea(top: true, child: body),
          ),
        ),
      ),
    );
  }
}

/// Add / edit one `languages/{code}` document.
class _LanguageEditorDialog extends StatefulWidget {
  const _LanguageEditorDialog({this.language});
  final AppLanguage? language;

  @override
  State<_LanguageEditorDialog> createState() => _LanguageEditorDialogState();
}

class _LanguageEditorDialogState extends State<_LanguageEditorDialog> {
  late final TextEditingController _code;
  late final TextEditingController _name;
  late final TextEditingController _englishName;
  late final TextEditingController _order;
  late final TextEditingController _bibleId;
  late final TextEditingController _bibleName;
  late final TextEditingController _googleCode;
  late bool _rtl;
  late bool _active;
  late String _tier;
  bool _saving = false;
  String? _error;

  bool get _isNew => widget.language == null;

  @override
  void initState() {
    super.initState();
    final l = widget.language;
    _code = TextEditingController(text: l?.code ?? '');
    _name = TextEditingController(text: l?.name ?? '');
    _englishName = TextEditingController(text: l?.englishName ?? '');
    _order = TextEditingController(text: '${l?.order ?? 100}');
    _bibleId = TextEditingController(text: l?.bibleId ?? '');
    _bibleName = TextEditingController(text: l?.bibleName ?? '');
    _googleCode = TextEditingController(text: l?.googleCode ?? '');
    _rtl = l?.rtl ?? false;
    _active = l?.active ?? true;
    _tier = l?.tier ?? 'machine';
  }

  @override
  void dispose() {
    for (final c in [
      _code,
      _name,
      _englishName,
      _order,
      _bibleId,
      _bibleName,
      _googleCode
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final code = _code.text.trim().toLowerCase();
    if (!RegExp(r'^[a-z]{2,3}([_-][a-z0-9]{2,4})?$').hasMatch(code)) {
      setState(() => _error =
          'Use an ISO 639 language code, e.g. "fr", "sw", "ar" or "zh_hant".');
      return;
    }
    if (_name.text.trim().isEmpty || _englishName.text.trim().isEmpty) {
      setState(() => _error = 'Enter the native and English names.');
      return;
    }
    if (code == 'en' && (!_active || _tier != 'approved')) {
      setState(() => _error = 'English is the master source and must stay '
          'active and approved.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final ref = FirebaseFirestore.instance.collection('languages').doc(code);
      if (_isNew && (await ref.get()).exists) {
        setState(() {
          _saving = false;
          _error = 'A language with code "$code" already exists.';
        });
        return;
      }
      await ref.set({
        'code': code,
        'name': _name.text.trim(),
        'englishName': _englishName.text.trim(),
        'rtl': _rtl,
        'tier': _tier,
        'active': _active,
        'order': int.tryParse(_order.text.trim()) ?? 100,
        'bibleId': _bibleId.text.trim(),
        'bibleName': _bibleName.text.trim(),
        'googleCode': _googleCode.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (err) {
      setState(() {
        _saving = false;
        _error = 'Could not save: $err';
      });
    }
  }

  Widget _field(TextEditingController c, String label,
          {String? helper, bool enabled = true, TextInputType? keyboard}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: TextField(
          controller: c,
          enabled: enabled,
          keyboardType: keyboard,
          decoration: InputDecoration(
            labelText: label,
            helperText: helper,
            helperMaxLines: 3,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isNew ? 'Add language' : 'Edit language'),
      content: SizedBox(
        width: 460.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field(_code, 'Code',
                  helper: 'ISO 639-1 code, e.g. fr, sw, ar.', enabled: _isNew),
              _field(_name, 'Native name', helper: 'e.g. Français'),
              _field(_englishName, 'English name', helper: 'e.g. French'),
              DropdownButtonFormField<String>(
                initialValue: _tier,
                decoration: const InputDecoration(
                  labelText: 'Tier',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'approved',
                      child: Text('Approved (reviewed by Kingdom Heirs)')),
                  DropdownMenuItem(
                      value: 'machine',
                      child: Text('More languages (machine-translated)')),
                ],
                onChanged: (v) => setState(() => _tier = v ?? 'machine'),
              ),
              const SizedBox(height: 10.0),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active (offered to members)'),
                value: _active,
                onChanged: (v) => setState(() => _active = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Right-to-left script'),
                value: _rtl,
                onChanged: (v) => setState(() => _rtl = v),
              ),
              _field(_order, 'Order in the picker',
                  keyboard: TextInputType.number),
              _field(_bibleId, 'API.Bible id',
                  helper: 'Bible for Scripture in this language. Leave empty '
                      'to show the English Bible with a note. Scripture is '
                      'never machine-translated.'),
              _field(_bibleName, 'Bible abbreviation', helper: 'e.g. LSG'),
              _field(_googleCode, 'Google Translate code (optional)',
                  helper: 'Only if Google uses a different code, e.g. '
                      '"zh-TW" for zh_hant.'),
              if (_error != null)
                Text(_error!,
                    style: TextStyle(
                        color: FlutterFlowTheme.of(context).error)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Save'),
        ),
      ],
    );
  }
}
