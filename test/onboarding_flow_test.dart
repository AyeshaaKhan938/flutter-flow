import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_heirs_discipleship_app/custom_code/onboarding_flow.dart';
import 'package:kingdom_heirs_discipleship_app/custom_code/pathway_progression.dart';

void main() {
  group('Automatic time zone', () {
    test('accepts IANA names', () {
      expect(validTimezone('Africa/Kampala'), 'Africa/Kampala');
      expect(validTimezone('America/Argentina/Buenos_Aires'),
          'America/Argentina/Buenos_Aires');
      expect(validTimezone(' Asia/Karachi '), 'Asia/Karachi');
      expect(validTimezone('UTC'), 'UTC');
      expect(validTimezone('Etc/GMT+5'), 'Etc/GMT+5');
    });

    test('rejects anything else', () {
      expect(validTimezone(''), '');
      expect(validTimezone(null), '');
      expect(validTimezone('GMT+5'), '');
      expect(validTimezone('Kampala'), '');
      expect(validTimezone('Africa/Kampala; drop'), '');
    });
  });

  group('Language pre-selected after sign-up', () {
    bool offered(String c) => ['en', 'es', 'ur', 'lg'].contains(c);

    test('keeps a language already chosen on this phone', () {
      expect(initialLanguage(stored: 'ur', device: 'es', isOffered: offered),
          'ur');
    });

    test("uses the phone's language when offered", () {
      expect(initialLanguage(stored: null, device: 'es', isOffered: offered),
          'es');
    });

    test('falls back to English', () {
      expect(initialLanguage(stored: '', device: 'de', isOffered: offered),
          'en');
      expect(initialLanguage(stored: null, device: null, isOffered: offered),
          'en');
    });
  });

  group('Assessment invitation on Home', () {
    final now = DateTime(2026, 11, 16, 9);

    bool show({
      bool? done = false,
      bool dismissed = false,
      int lessons = 0,
      DateTime? created,
    }) =>
        shouldShowAssessmentInvite(
          onboardingCompleted: done,
          dismissed: dismissed,
          lessonsCompleted: lessons,
          accountCreated: created,
          now: now,
        );

    test('not on the first day before any lesson', () {
      expect(show(created: now.subtract(const Duration(hours: 2))), isFalse);
    });

    test('after the first lesson', () {
      expect(
          show(lessons: 1, created: now.subtract(const Duration(hours: 2))),
          isTrue);
    });

    test('from the second day', () {
      expect(show(created: now.subtract(const Duration(days: 1))), isTrue);
    });

    test('never after the assessment or once dismissed', () {
      expect(show(done: true, lessons: 3), isFalse);
      expect(show(dismissed: true, lessons: 3), isFalse);
    });
  });

  group('Approved wording', () {
    test('certificate title and invitation match', () {
      expect(kCoreCertificateTitle,
          'Kingdom Heirs School of Ministry Commissioning Certificate');
      expect(kCertificateInvitation, contains(kCoreCertificateTitle));
    });

    test('information pages', () {
      expect(kSchoolClubsInfo, startsWith('Kingdom Heirs School Clubs will meet'));
      expect(kSchoolClubsInfo, contains('about 35 weekly lessons'));
      expect(kSportsTournamentsInfo,
          startsWith('Young people will be able to register'));
      expect(kSchoolClubsInfo, endsWith('Coming soon.'));
      expect(kSportsTournamentsInfo, endsWith('Coming soon.'));
    });
  });
}
