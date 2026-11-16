import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kingdom_heirs_discipleship_app/backend/schema/structs/locale_text_struct.dart';
import 'package:kingdom_heirs_discipleship_app/custom_code/languages/language_registry.dart';
import 'package:kingdom_heirs_discipleship_app/custom_code/languages/translation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  final service = TranslationService.instance;

  tearDown(() {
    service.previewMachine = false;
    LanguageRegistry.instance.showTesterLanguages = false;
  });

  group('Long texts are translated in whole paragraphs', () {
    test('short text is one part', () {
      final parts = TranslationService.splitForTranslation('Hello', 50);
      expect(parts.single.text, 'Hello');
    });

    test('parts rebuild the original exactly, headings and lists kept', () {
      final text = [
        'Application for Today',
        '1. Pray.\n2. Read John 15.\n3. Share with a friend.',
        'A' * 30,
        'B' * 30,
      ].join('\n\n');
      final parts = TranslationService.splitForTranslation(text, 60);
      expect(parts.length, greaterThan(1));
      expect(parts.map((p) => p.text + p.separator).join(), text);
      for (final p in parts) {
        expect(p.text.length, lessThanOrEqualTo(60));
      }
      // A numbered list is never split between parts.
      expect(parts.any((p) => p.text.contains('1. Pray.\n2. Read John 15.')),
          isTrue);
    });

    test('a paragraph longer than the limit splits at line breaks', () {
      final text = List.generate(6, (i) => 'Line $i ${'x' * 20}').join('\n');
      final parts = TranslationService.splitForTranslation(text, 70);
      expect(parts.map((p) => p.text + p.separator).join(), text);
      expect(parts.every((p) => p.text.length <= 70), isTrue);
    });
  });

  group('Unreviewed translations: internal testers only', () {
    const en = 'Come and see the One who changes everything.';
    const machine = 'Ven y ve al que lo cambia todo.';

    setUp(() => service.debugPut('es', en, machine));

    test('general members see English', () {
      final t = LocaleTextStruct(en: en);
      expect(t.forLanguage('es'), en);
      expect(t.isMachineTranslated('es'), isFalse);
      expect(t.isEnglishFallback('es'), isTrue);
    });

    test('internal testers see the machine text, labelled', () {
      service.previewMachine = true;
      final t = LocaleTextStruct(en: en);
      expect(t.forLanguage('es'), machine);
      expect(t.isMachineTranslated('es'), isTrue);
    });

    test('approved text is shown to everyone without a label', () {
      service.debugPut('es', en, 'Ven y ve (revisado).', approved: true);
      final t = LocaleTextStruct(en: en);
      expect(t.forLanguage('es'), 'Ven y ve (revisado).');
      expect(t.isMachineTranslated('es'), isFalse);
      service.debugPut('es', en, machine); // restore
    });

    test('a stored draft of an unapproved language: testers only', () {
      const other = 'A sentence with no cached translation.';
      final t = LocaleTextStruct(en: other, ur: 'اردو مسودہ');
      expect(t.forLanguage('ur'), other);
      service.previewMachine = true;
      expect(t.forLanguage('ur'), 'اردو مسودہ');
      expect(t.isMachineTranslated('ur'), isTrue);
    });

    test('the warning is fixed text in each tested language', () {
      expect(kMachineTranslationNotice,
          'Machine-translated, not yet reviewed by Kingdom Heirs.');
      expect(kMachineTranslationNoticeByLanguage.keys,
          containsAll(['es', 'ur', 'lg']));
    });
  });

  group('Languages hidden from general members', () {
    test('a testers-only language is offered to testers only', () {
      final lang = AppLanguage.fromMap(
          {'code': 'fr', 'name': 'Français', 'testersOnly': true})!;
      expect(lang.testersOnly, isTrue);
      expect(AppLanguage.fromMap({'code': 'fr'})!.testersOnly, isFalse);
      expect(lang.toMap()['testersOnly'], isTrue);
    });
  });
}
