// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';

/// Language picker driven by the CMS `languages` collection: "Approved
/// languages" (reviewed by Kingdom Heirs) first, then "More languages" whose
/// content is machine-translated. New languages appear as soon as an
/// administrator activates them; no app update is needed.
class LanguageSelector extends StatefulWidget {
  const LanguageSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  /// Currently chosen language code (may be null while loading).
  final String? selected;
  final Future<void> Function(String code) onSelected;

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  bool _showMore = false;

  @override
  void initState() {
    super.initState();
    final registry = LanguageRegistry.instance;
    _showMore = registry.machine.any((l) => l.code == widget.selected);
    registry.refresh();
  }

  String _t(String english) => TranslationService.instance
      .translate(english, LanguageRegistry.contentLanguage);

  Widget _chip(AppLanguage lang) {
    final theme = FlutterFlowTheme.of(context);
    final selected = lang.code == (widget.selected ?? '');
    return ChoiceChip(
      label: Text(
        lang.name == lang.englishName
            ? lang.name
            : '${lang.name} · ${lang.englishName}',
        textDirection: lang.rtl ? ui.TextDirection.rtl : null,
      ),
      selected: selected,
      showCheckmark: true,
      selectedColor: theme.primary,
      checkmarkColor: theme.primaryBackground,
      backgroundColor: Colors.transparent,
      side: BorderSide(color: theme.primary),
      labelStyle: TextStyle(
        color: selected ? theme.primaryBackground : theme.primary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      onSelected: (_) => widget.onSelected(lang.code),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge(
          [LanguageRegistry.instance, TranslationService.instance]),
      builder: (context, _) {
        final registry = LanguageRegistry.instance;
        final approved = registry.approved;
        final machine = registry.machine;
        final labelStyle = theme.labelMedium.override(
          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
          color: theme.secondaryText,
          letterSpacing: 0.0,
          fontWeight: FontWeight.w600,
        );
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_t('Approved languages'), style: labelStyle),
            const SizedBox(height: 6.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: approved.map(_chip).toList(),
            ),
            if (machine.isNotEmpty) ...[
              const SizedBox(height: 10.0),
              InkWell(
                onTap: () => setState(() => _showMore = !_showMore),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _t('More languages (machine-translated)'),
                          style: labelStyle,
                        ),
                      ),
                      Icon(
                        _showMore ? Icons.expand_less : Icons.expand_more,
                        color: theme.secondaryText,
                      ),
                    ],
                  ),
                ),
              ),
              if (_showMore) ...[
                Text(
                  _t('These languages use Google machine translation that '
                      'Kingdom Heirs has not yet reviewed. Scripture is '
                      'never machine-translated.'),
                  style: theme.labelSmall.override(
                    font: GoogleFonts.inter(),
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 6.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: machine.map(_chip).toList(),
                ),
              ],
            ],
          ],
        );
      },
    );
  }
}
