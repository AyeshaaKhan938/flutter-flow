import 'dart:typed_data';
import 'dart:ui' show Rect;

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// The two official Kingdom Heirs certificate designs.
enum CertificateKind { pathway, commissioning }

/// Shown on Pathway Certificates (no commissioning language).
const kPathwayCertificateNotice =
    'This certificate recognizes completion of a Kingdom Heirs discipleship '
    'pathway. It is not an accredited degree, professional credential, '
    'ordination or ministry license. Any ministry or leadership role '
    'requires a separate Kingdom Heirs approval process.';

/// Printed on the Commissioning Certificate (the template has no such line).
const kCommissioningDisclaimer =
    'This is a Kingdom Heirs ministry commissioning and recognition '
    'certificate. It is not an accredited academic degree, professional '
    'license, or ordination credential.';

/// The values printed on a certificate. They come from the issued record in
/// users/{uid}/certificates, never from user input.
class CertificateData {
  const CertificateData({
    required this.kind,
    required this.memberName,
    required this.completedAt,
    required this.certificateNumber,
    this.pathwayName = '',
    this.gradePercent,
  });

  final CertificateKind kind;
  final String memberName;
  final String pathwayName;
  final DateTime completedAt;
  final String certificateNumber;

  /// Whole percent; null when the pathway has no quizzes.
  final int? gradePercent;

  String get gradeText => gradePercent == null ? 'N/A' : '$gradePercent%';
  String get dateText => DateFormat.yMMMMd('en_US').format(completedAt);
  String get idText => 'Certificate ID: $certificateNumber';
}

enum CertificateFont { serif, sans, sansBold }

enum CertificateAlign { left, center, right }

/// One line of text drawn on the template, in PDF points (top-left origin)
/// on the 792 x 612 pt landscape page.
class CertificateTextBox {
  const CertificateTextBox(
    this.rect,
    this.text, {
    required this.size,
    this.font = CertificateFont.serif,
    this.color = CertificateTemplate.navy,
    this.align = CertificateAlign.center,
    this.wrap = false,
  });

  final Rect rect;
  final String text;
  final double size;
  final CertificateFont font;
  final int color;
  final CertificateAlign align;

  /// Wraps over several lines instead of shrinking to one line.
  final bool wrap;
}

/// Layout of the client's fillable templates
/// (assets/pdfs/Kingdom_Heirs_Official_*_Certificate_Fillable.pdf).
///
/// The form fields are filled by drawing text at the AcroForm widget
/// rectangles over a 300 dpi rendering of the template (fields removed),
/// so the result has no form fields left: it is flattened and cannot be
/// edited. The logo, signature, "Evangelist James Maddalone / Founder,
/// Kingdom Heirs Foundation" and the commissioning wording and Scripture
/// references are part of the template image.
class CertificateTemplate {
  static const pageWidth = 792.0;
  static const pageHeight = 612.0;

  /// Field text colour from the templates' /DA (.0235 .1059 .2431 rg).
  static const navy = 0xFF061B3E;
  static const brown = 0xFF514B42;

  static String backgroundAsset(CertificateKind kind) =>
      kind == CertificateKind.commissioning
          ? 'assets/images/certificate_template_commissioning.jpg'
          : 'assets/images/certificate_template_pathway.jpg';

  static List<CertificateTextBox> boxes(CertificateData d) {
    if (d.kind == CertificateKind.commissioning) {
      return [
        // AcroForm field "recipient_name".
        CertificateTextBox(
            const Rect.fromLTRB(145, 293, 647, 327), d.memberName,
            size: 24),
        // AcroForm field "overall_program_grade".
        CertificateTextBox(const Rect.fromLTRB(330, 515, 420, 538), d.gradeText,
            size: 13),
        // AcroForm field "completion_date".
        CertificateTextBox(const Rect.fromLTRB(510, 515, 620, 538), d.dateText,
            size: 12),
        CertificateTextBox(const Rect.fromLTRB(305, 546, 645, 556), d.idText,
            size: 7.5, font: CertificateFont.sansBold),
        const CertificateTextBox(
            Rect.fromLTRB(305, 558, 645, 584), kCommissioningDisclaimer,
            size: 6.3, font: CertificateFont.sans, color: brown, wrap: true),
      ];
    }
    return [
      // AcroForm field "recipient_name".
      CertificateTextBox(const Rect.fromLTRB(155, 274, 637, 308), d.memberName,
          size: 23),
      // AcroForm field "pathway_name".
      CertificateTextBox(const Rect.fromLTRB(120, 353, 672, 387), d.pathwayName,
          size: 20),
      // AcroForm field "pathway_grade".
      CertificateTextBox(const Rect.fromLTRB(241, 483, 321, 507), d.gradeText,
          size: 14),
      // AcroForm field "completion_date".
      CertificateTextBox(const Rect.fromLTRB(456, 483, 576, 507), d.dateText,
          size: 13),
      const CertificateTextBox(
          Rect.fromLTRB(62, 545, 282, 584), kPathwayCertificateNotice,
          size: 6.0,
          font: CertificateFont.sans,
          color: brown,
          align: CertificateAlign.left,
          wrap: true),
      CertificateTextBox(const Rect.fromLTRB(530, 566, 730, 576), d.idText,
          size: 7.5,
          font: CertificateFont.sansBold,
          align: CertificateAlign.right),
    ];
  }
}

/// Builds the completed, flattened certificate PDF (one landscape page).
Future<Uint8List> buildCertificatePdf(CertificateData data) async {
  final background = pw.MemoryImage(
    (await rootBundle.load(CertificateTemplate.backgroundAsset(data.kind)))
        .buffer
        .asUint8List(),
  );
  final serif =
      pw.Font.ttf(await rootBundle.load('assets/fonts/Lora-Regular.ttf'));
  final fonts = {
    CertificateFont.serif: serif,
    CertificateFont.sans: pw.Font.helvetica(),
    CertificateFont.sansBold: pw.Font.helveticaBold(),
  };

  final doc = pw.Document(
    title: data.kind == CertificateKind.commissioning
        ? 'Kingdom Heirs Commissioning Certificate'
        : 'Pathway Certificate of Completion',
    author: 'Kingdom Heirs Foundation',
    creator: 'Kingdom Heirs',
  );

  pw.Widget box(CertificateTextBox b) {
    final style = pw.TextStyle(
      font: fonts[b.font],
      fontSize: b.size,
      color: PdfColor.fromInt(b.color),
      lineSpacing: b.wrap ? 1.0 : 0.0,
    );
    final align = switch (b.align) {
      CertificateAlign.left => pw.TextAlign.left,
      CertificateAlign.right => pw.TextAlign.right,
      CertificateAlign.center => pw.TextAlign.center,
    };
    final alignment = switch (b.align) {
      CertificateAlign.left => pw.Alignment.centerLeft,
      CertificateAlign.right => pw.Alignment.centerRight,
      CertificateAlign.center => pw.Alignment.center,
    };
    return pw.Positioned(
      left: b.rect.left,
      top: b.rect.top,
      child: pw.SizedBox(
        width: b.rect.width,
        height: b.rect.height,
        child: b.wrap
            ? pw.Text(b.text, style: style, textAlign: align)
            : pw.FittedBox(
                fit: pw.BoxFit.scaleDown,
                alignment: alignment,
                child: pw.Text(b.text, style: style, textAlign: align),
              ),
      ),
    );
  }

  doc.addPage(pw.Page(
    pageFormat: const PdfPageFormat(
      CertificateTemplate.pageWidth,
      CertificateTemplate.pageHeight,
    ),
    margin: pw.EdgeInsets.zero,
    build: (context) => pw.Stack(
      children: [
        pw.Positioned.fill(
          child: pw.Image(background, fit: pw.BoxFit.fill),
        ),
        ...CertificateTemplate.boxes(data).map(box),
      ],
    ),
  ));
  return doc.save();
}
