import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';
import '/custom_code/pathway_progression.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';

/// Formats [date] for [lang], falling back to English when the locale has
/// no date data.
String formatCertificateDate(DateTime date, String lang) {
  try {
    return DateFormat.yMMMMd(lang).format(date);
  } catch (_) {
    return DateFormat.yMMMMd('en').format(date);
  }
}

/// A completion certificate for one pathway, or the Kingdom Heirs Core
/// Discipleship Certificate (`pathwayId` = [kCoreCertificateId]).
///
/// The certificate is stored once in users/{uid}/certificates/{pathwayId}
/// the first time it is earned; later views show the stored record.
class CertificatePageWidget extends StatefulWidget {
  const CertificatePageWidget({super.key, this.pathwayId});

  final String? pathwayId;

  static String routeName = 'CertificatePage';
  static String routePath = '/certificate';

  @override
  State<CertificatePageWidget> createState() => _CertificatePageWidgetState();
}

class _CertificatePageWidgetState extends State<CertificatePageWidget> {
  final _boundaryKey = GlobalKey();

  bool _loading = true;
  bool _earned = false;
  bool _sharing = false;
  String _memberName = '';
  String _certificateNumber = '';
  DateTime? _issuedAt;
  PathwaysRecord? _pathway;

  String get _lang => LanguageRegistry.contentLanguage;
  String get _id => widget.pathwayId ?? '';
  bool get _isCore => _id == kCoreCertificateId;

  String _t(String english, [Map<String, String> args = const {}]) =>
      progressionText(english, _lang, args);

  String get _title => _isCore
      ? _t(kCoreCertificateTitle)
      : (_pathway?.title.forLanguage(_lang) ?? _id);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = currentUserUid;
    if (!_isCore && _id.isNotEmpty) {
      try {
        final found = await queryPathwaysRecordOnce(
          queryBuilder: (q) => q.where('stableId', isEqualTo: _id),
          singleRecord: true,
        );
        _pathway = found.firstOrNull;
      } catch (_) {}
    }

    Map<String, dynamic>? data;
    if (uid.isNotEmpty && _id.isNotEmpty) {
      try {
        final snap =
            await PathwayProgressionService.certificatesOf(uid).doc(_id).get();
        if (snap.exists) {
          data = snap.data();
        }
      } catch (_) {}
      if (data == null) {
        final progression =
            await PathwayProgressionService.instance.refresh();
        if (progression.hasEarned(_id)) {
          data = await PathwayProgressionService.instance.issueCertificate(
            _id,
            _isCore ? kCoreCertificateTitle : (_pathway?.title.en ?? _id),
          );
        }
      }
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
      _earned = data != null;
      if (data != null) {
        final name = (data['memberName'] as String? ?? '').trim();
        _memberName =
            name.isNotEmpty ? name : PathwayProgressionService.memberDisplayName();
        _certificateNumber = (data['certificateId'] as String? ?? '').isNotEmpty
            ? data['certificateId'] as String
            : PathwayProgressionService.certificateNumber(uid, _id);
        final issued = data['issuedAt'];
        _issuedAt = issued is Timestamp ? issued.toDate() : DateTime.now();
      }
    });
  }

  Future<void> _share() async {
    if (_sharing) {
      return;
    }
    setState(() => _sharing = true);
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        throw StateError('Certificate not rendered');
      }
      final image = await boundary.toImage(pixelRatio: 3.0);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) {
        throw StateError('No image data');
      }
      final fileName = 'kingdom-heirs-certificate-$_id.png';
      await SharePlus.instance.share(ShareParams(
        files: [
          XFile.fromData(
            bytes.buffer.asUint8List(),
            mimeType: 'image/png',
            name: fileName,
          ),
        ],
        fileNameOverrides: [fileName],
        text: _title,
        subject: _title,
      ));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_t('Could not share the certificate.'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return ListenableBuilder(
      listenable: TranslationService.instance,
      builder: (context, _) => Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.primaryBackground,
          automaticallyImplyLeading: true,
          title: Text(
            _t('Certificate'),
            style: theme.titleLarge.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 22.0,
              letterSpacing: 0.0,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: _loading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: theme.primary),
                      const SizedBox(height: 12.0),
                      Text(_t('Loading…'), style: theme.bodyMedium),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560.0),
                      child: _earned
                          ? _buildEarned(theme)
                          : _buildNotEarned(theme),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildNotEarned(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24.0),
        Icon(Icons.workspace_premium_outlined,
            size: 56.0, color: theme.secondaryText),
        const SizedBox(height: 12.0),
        Text(
          _title,
          textAlign: TextAlign.center,
          style: theme.titleMedium,
        ),
        const SizedBox(height: 8.0),
        Text(
          _t('Not earned yet'),
          textAlign: TextAlign.center,
          style: theme.titleLarge.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            letterSpacing: 0.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          _isCore
              ? _t('Complete all seven core pathways to earn this certificate.')
              : _t(
                  'Finish every lesson and pass every quiz with 80% or higher to earn this certificate.'),
          textAlign: TextAlign.center,
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(),
            color: theme.secondaryText,
            letterSpacing: 0.0,
          ),
        ),
        const SizedBox(height: 20.0),
        FFButtonWidget(
          onPressed: () => context.pushNamed(PathwayListPageWidget.routeName),
          text: _t('Explore pathways'),
          options: FFButtonOptions(
            width: double.infinity,
            height: 48.0,
            color: theme.secondary,
            textStyle: TextStyle(color: theme.primaryText),
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildEarned(FlutterFlowTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RepaintBoundary(
          key: _boundaryKey,
          child: _CertificateCard(
            heading: _isCore
                ? _t(kCoreCertificateTitle)
                : _t('Certificate of Completion'),
            certifies: _t('This certifies that'),
            memberName: _memberName,
            hasCompleted: _t('has completed'),
            achievement: _isCore
                ? _t(
                    'all seven core pathways of the Kingdom Heirs discipleship journey')
                : _title,
            dateLine: _t('Completed on {date}', {
              'date': formatCertificateDate(_issuedAt ?? DateTime.now(), _lang),
            }),
            idLine: _t('Certificate ID: {id}', {'id': _certificateNumber}),
            notice: _t(kCertificateNotice),
            rtl: _lang == 'ur',
          ),
        ),
        const SizedBox(height: 20.0),
        FFButtonWidget(
          onPressed: _sharing ? null : _share,
          text: _t('Share / Save'),
          icon: const Icon(Icons.ios_share, size: 18.0),
          options: FFButtonOptions(
            width: double.infinity,
            height: 48.0,
            color: theme.secondary,
            textStyle: TextStyle(color: theme.primaryText),
            iconColor: theme.primaryText,
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        const SizedBox(height: 8.0),
        FFButtonWidget(
          onPressed: () => context.pushNamed(PathwayListPageWidget.routeName),
          text: _t('Explore pathways'),
          options: FFButtonOptions(
            width: double.infinity,
            height: 48.0,
            color: Colors.transparent,
            textStyle: TextStyle(color: theme.primaryText),
            elevation: 0.0,
            borderSide: BorderSide(color: theme.tertiary, width: 1.0),
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ],
    );
  }
}

/// The printable certificate itself. Fixed light colours so it looks the
/// same (and prints well) in dark mode.
class _CertificateCard extends StatelessWidget {
  const _CertificateCard({
    required this.heading,
    required this.certifies,
    required this.memberName,
    required this.hasCompleted,
    required this.achievement,
    required this.dateLine,
    required this.idLine,
    required this.notice,
    required this.rtl,
  });

  final String heading;
  final String certifies;
  final String memberName;
  final String hasCompleted;
  final String achievement;
  final String dateLine;
  final String idLine;
  final String notice;
  final bool rtl;

  static const _paper = Color(0xFFFFFBF2);
  static const _gold = Color(0xFFB8892B);
  static const _ink = Color(0xFF1E2A5A);
  static const _muted = Color(0xFF5B6275);

  @override
  Widget build(BuildContext context) {
    TextStyle serif(double size,
            {FontWeight weight = FontWeight.w400,
            Color color = _ink,
            FontStyle style = FontStyle.normal}) =>
        GoogleFonts.playfairDisplay(
          fontSize: size,
          fontWeight: weight,
          color: color,
          fontStyle: style,
          height: 1.25,
        );
    TextStyle sans(double size,
            {FontWeight weight = FontWeight.w400,
            Color color = _muted,
            double spacing = 0.0}) =>
        GoogleFonts.inter(
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: spacing,
        );

    return Directionality(
      textDirection: rtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Container(
        color: _paper,
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: _gold, width: 3.0),
          ),
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: _gold, width: 1.0),
            ),
            padding: const EdgeInsets.fromLTRB(20.0, 28.0, 20.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.workspace_premium, color: _gold, size: 44.0),
                const SizedBox(height: 6.0),
                Text(
                  'KINGDOM HEIRS',
                  textAlign: TextAlign.center,
                  style: sans(12.0,
                      weight: FontWeight.w700, color: _gold, spacing: 3.0),
                ),
                const SizedBox(height: 14.0),
                Text(heading,
                    textAlign: TextAlign.center,
                    style: serif(24.0, weight: FontWeight.w700)),
                const SizedBox(height: 18.0),
                Text(certifies, textAlign: TextAlign.center, style: sans(13.0)),
                const SizedBox(height: 8.0),
                Text(
                  memberName,
                  textAlign: TextAlign.center,
                  style: serif(26.0,
                      weight: FontWeight.w600, style: FontStyle.italic),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  height: 1.0,
                  color: _gold,
                ),
                Text(hasCompleted,
                    textAlign: TextAlign.center, style: sans(13.0)),
                const SizedBox(height: 8.0),
                Text(achievement,
                    textAlign: TextAlign.center,
                    style: serif(20.0, weight: FontWeight.w700)),
                const SizedBox(height: 16.0),
                Text(dateLine,
                    textAlign: TextAlign.center,
                    style: sans(13.0, color: _ink)),
                const SizedBox(height: 26.0),
                Container(width: 180.0, height: 1.0, color: _ink),
                const SizedBox(height: 6.0),
                Text(
                  'Kingdom Heirs Foundation',
                  textAlign: TextAlign.center,
                  style: serif(15.0, weight: FontWeight.w600),
                ),
                const SizedBox(height: 18.0),
                Text(idLine,
                    textAlign: TextAlign.center,
                    style: sans(10.0, spacing: 0.5)),
                const SizedBox(height: 10.0),
                Text(notice,
                    textAlign: TextAlign.center,
                    style: sans(9.0, color: _ink)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
