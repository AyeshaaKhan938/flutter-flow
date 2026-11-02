import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_heirs_discipleship_app/custom_code/pathway_progression.dart';

void main() {
  group('80% quiz requirement', () {
    test('8 of 10 passes, 7 of 10 does not', () {
      expect(const QuizScore(8, 10).passes(80), isTrue);
      expect(const QuizScore(7, 10).passes(80), isFalse);
    });
    test('no rounding up: 79.9% does not pass', () {
      expect(const QuizScore(799, 1000).passes(80), isFalse);
      expect(const QuizScore(4, 5).passes(80), isTrue);
      expect(const QuizScore(3, 5).passes(80), isFalse);
    });
    test('a quiz with no questions never passes', () {
      expect(const QuizScore(0, 0).passes(80), isFalse);
    });
  });

  group('quiz retakes keep the best attempt', () {
    test('a better retake replaces a failed attempt', () {
      final best = QuizScore.best(const QuizScore(6, 10), const QuizScore(9, 10))!;
      expect(best.correct, 9);
      expect(best.passes(80), isTrue);
    });
    test('a worse retake never lowers the score', () {
      final best = QuizScore.best(const QuizScore(9, 10), const QuizScore(5, 10))!;
      expect(best.correct, 9);
    });
  });

  group('pathway completion', () {
    final scores = {
      'q1': const QuizScore(8, 10),
      'q2': const QuizScore(10, 10),
    };
    test('all lessons and all quizzes at 80%+ completes the pathway', () {
      expect(
          isPathwayComplete(
              lessonsTotal: 14,
              lessonsDone: 14,
              quizIds: ['q1', 'q2'],
              bestScores: scores,
              passingScore: 80),
          isTrue);
    });
    test('one unfinished lesson keeps it incomplete', () {
      expect(
          isPathwayComplete(
              lessonsTotal: 14,
              lessonsDone: 13,
              quizIds: ['q1', 'q2'],
              bestScores: scores,
              passingScore: 80),
          isFalse);
    });
    test('one quiz below 80% keeps it incomplete', () {
      expect(
          isPathwayComplete(
              lessonsTotal: 14,
              lessonsDone: 14,
              quizIds: ['q1', 'q2'],
              bestScores: {...scores, 'q1': const QuizScore(7, 10)},
              passingScore: 80),
          isFalse);
    });
    test('an untaken quiz keeps it incomplete', () {
      expect(
          isPathwayComplete(
              lessonsTotal: 14,
              lessonsDone: 14,
              quizIds: ['q1', 'q2', 'q3'],
              bestScores: scores,
              passingScore: 80),
          isFalse);
    });
    test('an issued certificate stays complete', () {
      expect(
          isPathwayComplete(
              lessonsTotal: 20,
              lessonsDone: 3,
              quizIds: ['q1'],
              bestScores: const {},
              passingScore: 80,
              certificateIssued: true),
          isTrue);
    });
  });

  group('required order and locking', () {
    test('Come & See is always open; the next opens only after it', () {
      expect(coreUnlocks([false, false, false, false, false, false, false]),
          [true, false, false, false, false, false, false]);
    });
    test('completing pathways in order opens the next one', () {
      expect(coreUnlocks([true, true, false, false, false, false, false]),
          [true, true, true, false, false, false, false]);
    });
    test('a later pathway stays locked if an earlier one is incomplete', () {
      expect(coreUnlocks([true, false, true, true, false, false, false]),
          [true, true, false, false, false, false, false]);
    });
    test('the required order has seven pathways, starting with Come & See',
        () {
      expect(kCorePathwayIds.length, 7);
      expect(kCorePathwayIds.first, 'come-and-see');
      expect(kCorePathwayIds.last, 'counterfeit-gospels');
    });
  });

  group('certificate grade', () {
    test('total correct over total questions, best attempt per quiz', () {
      final g = CertificateGrade.of(
          [const QuizScore(9, 10), const QuizScore(4, 5)]);
      expect(g.correct, 13);
      expect(g.total, 15);
      expect(g.percent, 87);
    });
    test('commissioning wording carries the member name', () {
      expect(commissioningStatementFor('Joel'),
          contains('certifies that Joel is commissioned'));
    });
  });
}
