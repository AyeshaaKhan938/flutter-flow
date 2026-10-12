import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/custom_code/certificate_pdf.dart';
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

/// A Pathway Certificate of Completion, or the Kingdom Heirs Commissioning
/// Certificate (`pathwayId` = [kCoreCertificateId]).
///
/// The certificate is stored once in users/{uid}/certificates/{pathwayId}
/// the first time it is earned; later views show the stored record (name,
/// completion date and certificate ID never change; the grade is raised
/// when the member improves a quiz score). The PDF is generated from that
/// record on the client's official template.
class CertificatePageWidget extends StatefulWidget {
  const CertificatePageWidget({super.key, this.pathwayId});

  final String? pathwayId;

  static String routeName = 'CertificatePage';
  static String routePath = '/certificate';

  @override
  State<CertificatePageWidget> createState() => _CertificatePageWidgetState();
}

class _CertificatePageWidgetState extends State<CertificatePageWidget> {
  bool _loading = true;
  bool _sharing = false;
  CertificateData? _certificate;
  PathwaysRecord? _pathway;
  int _passingScore = kDefaultPassingScore;

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
    int? previousGrade;
    if (uid.isNotEmpty && _id.isNotEmpty) {
      final service = PathwayProgressionService.instance;
      final progression = await service.refresh();
      _passingScore =
          progression.statusFor(_id)?.passingScore ?? kDefaultPassingScore;
      final stored = progression.issuedCertificates[_id];
      final storedGrade = stored?['grade'];
      previousGrade = storedGrade is num ? storedGrade.toInt() : null;
      // Issues the certificate when first earned, or raises its grade.
      data = await service.syncCertificate(progression, _id);
      if (data == null) {
        try {
          final snap =
              await PathwayProgressionService.certificatesOf(uid).doc(_id).get();
          data = snap.exists ? snap.data() : null;
        } catch (_) {}
      }
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
      if (data != null) {
        final name = (data['memberName'] as String? ?? '').trim();
        final number = (data['certificateId'] as String? ?? '').trim();
        final grade = data['grade'];
        _certificate = CertificateData(
          kind: _isCore
              ? CertificateKind.commissioning
              : CertificateKind.pathway,
          memberName: name.isNotEmpty
              ? name
              : PathwayProgressionService.memberDisplayName(),
          // The official template is English.
          pathwayName: _pathway?.title.en ?? (data['title'] as String? ?? _id),
          completedAt: PathwayProgressionService.completedAtOf(data),
          certificateNumber: number.isNotEmpty
              ? number
              : PathwayProgressionService.certificateNumber(uid, _id),
          gradePercent: grade is num ? grade.toInt() : null,
        );
      }
    });
    final newGrade = _certificate?.gradePercent;
    if (previousGrade != null && newGrade != null && newGrade > previousGrade) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_t(
          'Your grade was updated to {grade}. Your certificate ID and completion date stay the same.',
          {'grade': '$newGrade%'},
        )),
      ));
    }
  }

  Future<void> _downloadPdf() async {
    final certificate = _certificate;
    if (_sharing || certificate == null) {
      return;
    }
    setState(() => _sharing = true);
    try {
      final bytes = await buildCertificatePdf(certificate);
      final fileName = _isCore
          ? 'kingdom-heirs-commissioning-certificate.pdf'
          : 'kingdom-heirs-certificate-$_id.pdf';
      await SharePlus.instance.share(ShareParams(
        files: [
          XFile.fromData(bytes, mimeType: 'application/pdf', name: fileName),
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
                      constraints: const BoxConstraints(maxWidth: 720.0),
                      child: _certificate != null
                          ? _buildEarned(theme, _certificate!)
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
              ? _t(
                  'Complete all seven required pathways in order, passing every quiz with 80% or higher, to earn this certificate.')
              : _t(
                  'Finish every lesson and pass every quiz with {n}% or higher to earn this certificate.',
                  {'n': '$_passingScore'}),
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

  Widget _buildEarned(FlutterFlowTheme theme, CertificateData certificate) {
    final body = theme.bodyMedium.override(
      font: GoogleFonts.inter(),
      color: theme.secondaryText,
      letterSpacing: 0.0,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CertificatePreview(data: certificate),
        const SizedBox(height: 16.0),
        Text(
          _isCore ? _t(kCoreCertificateTitle) : _t(kPathwayCertificateTitle),
          textAlign: TextAlign.center,
          style: theme.titleMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            letterSpacing: 0.0,
          ),
        ),
        if (!_isCore) ...[
          const SizedBox(height: 4.0),
          Text(_title, textAlign: TextAlign.center, style: theme.titleSmall),
        ],
        const SizedBox(height: 8.0),
        Text(
          [
            _t('Completed on {date}', {
              'date': formatCertificateDate(certificate.completedAt, _lang),
            }),
            _t('Grade {grade}', {'grade': certificate.gradeText}),
            _t('Certificate ID: {id}', {'id': certificate.certificateNumber}),
          ].join('\n'),
          textAlign: TextAlign.center,
          style: body,
        ),
        if (_isCore) ...[
          const SizedBox(height: 12.0),
          Text(_t(kCommissioningStatement),
              textAlign: TextAlign.center,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                letterSpacing: 0.0,
              )),
          const SizedBox(height: 6.0),
          Text(_t(kCommissioningReferences),
              textAlign: TextAlign.center, style: body),
        ],
        const SizedBox(height: 12.0),
        Text(
          _t(_isCore ? kCommissioningDisclaimer : kCertificateNotice),
          textAlign: TextAlign.center,
          style: theme.labelSmall.override(
            font: GoogleFonts.inter(),
            color: theme.secondaryText,
            letterSpacing: 0.0,
          ),
        ),
        if (_lang != 'en') ...[
          const SizedBox(height: 6.0),
          Text(_t('The official certificate is issued in English.'),
              textAlign: TextAlign.center,
              style: theme.labelSmall.override(
                font: GoogleFonts.inter(),
                color: theme.secondaryText,
                letterSpacing: 0.0,
              )),
        ],
        const SizedBox(height: 20.0),
        FFButtonWidget(
          onPressed: _sharing ? null : _downloadPdf,
          text: _t('Download PDF'),
          icon: const Icon(Icons.picture_as_pdf_outlined, size: 18.0),
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

/// On-screen preview of the certificate: the official template with the
/// same text boxes the PDF uses ([CertificateTemplate.boxes]).
class CertificatePreview extends StatelessWidget {
  const CertificatePreview({super.key, required this.data});

  final CertificateData data;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: CertificateTemplate.pageWidth / CertificateTemplate.pageHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        final scale = constraints.maxWidth / CertificateTemplate.pageWidth;
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                CertificateTemplate.backgroundAsset(data.kind),
                fit: BoxFit.fill,
              ),
            ),
            for (final box in CertificateTemplate.boxes(data))
              Positioned(
                left: box.rect.left * scale,
                top: box.rect.top * scale,
                width: box.rect.width * scale,
                height: box.rect.height * scale,
                child: _boxText(box, scale),
              ),
          ],
        );
      }),
    );
  }

  Widget _boxText(CertificateTextBox box, double scale) {
    final size = box.size * scale;
    final color = Color(box.color);
    final style = switch (box.font) {
      CertificateFont.serif =>
        GoogleFonts.lora(fontSize: size, color: color, height: 1.2),
      CertificateFont.sans =>
        GoogleFonts.inter(fontSize: size, color: color, height: 1.2),
      CertificateFont.sansBold => GoogleFonts.inter(
          fontSize: size,
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.2),
    };
    final align = switch (box.align) {
      CertificateAlign.left => TextAlign.left,
      CertificateAlign.right => TextAlign.right,
      CertificateAlign.center => TextAlign.center,
    };
    final alignment = switch (box.align) {
      CertificateAlign.left => Alignment.centerLeft,
      CertificateAlign.right => Alignment.centerRight,
      CertificateAlign.center => Alignment.center,
    };
    final text = Text(
      box.text,
      textAlign: align,
      textDirection: ui.TextDirection.ltr,
      style: style,
    );
    if (box.wrap) {
      return text;
    }
    return FittedBox(fit: BoxFit.scaleDown, alignment: alignment, child: text);
  }
}
