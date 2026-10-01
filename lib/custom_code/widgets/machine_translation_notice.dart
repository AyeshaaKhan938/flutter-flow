// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:google_fonts/google_fonts.dart';
import '/custom_code/languages/translation_service.dart';

/// Small banner identifying unreviewed machine-generated translation (or,
/// with [message], another language note such as the English Bible notice).
/// The text itself is shown in the member's language (English source).
class MachineTranslationNotice extends StatelessWidget {
  const MachineTranslationNotice({
    super.key,
    required this.language,
    this.message = kMachineTranslationNotice,
    this.icon = Icons.translate,
    this.compact = false,
  });

  final String? language;
  final String message;
  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return ListenableBuilder(
      listenable: TranslationService.instance,
      builder: (context, _) {
        final text = TranslationService.instance.translate(message, language);
        final style = theme.labelSmall.override(
          font: GoogleFonts.inter(),
          color: theme.secondaryText,
          letterSpacing: 0.0,
        );
        final row = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16.0, color: theme.secondaryText),
            const SizedBox(width: 6.0),
            Expanded(child: Text(text, style: style)),
          ],
        );
        if (compact) {
          return row;
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: theme.alternate,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: row,
        );
      },
    );
  }
}
