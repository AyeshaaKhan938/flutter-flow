import 'package:flutter_test/flutter_test.dart';
import 'package:kingdom_heirs_discipleship_app/custom_code/quiz_review.dart';

void main() {
  group('optionWithSingleLabel', () {
    test('adds one letter to plain text', () {
      expect(optionWithSingleLabel('A', 'Grace'), 'A. Grace');
    });
    test('keeps a single existing letter', () {
      expect(optionWithSingleLabel('B', 'B. Faith'), 'B. Faith');
    });
    test('removes a duplicated letter', () {
      expect(optionWithSingleLabel('A', 'A. A. Grace'), 'A. Grace');
      expect(optionWithSingleLabel('C', 'C) C. Hope'), 'C. Hope');
      expect(optionWithSingleLabel('D', '(D) D: Love'), 'D. Love');
    });
    test('keeps text that only starts like a label', () {
      expect(optionWithSingleLabel('A', 'A.D. 70'), 'A. A.D. 70');
      expect(optionWithSingleLabel('A', 'A man of God'), 'A. A man of God');
      expect(optionWithSingleLabel('B', 'A. text'), 'B. A. text');
    });
    test('empty stays empty', () {
      expect(optionWithSingleLabel('A', null), '');
      expect(optionWithSingleLabel('A', '  '), '');
    });
  });

  group('correct answers in the review', () {
    final correct = ['A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'A', 'B'];
    test('counts matching answers', () {
      expect(countCorrect(['A', 'b', 'D', '', 'A'], correct), 3);
    });
    test('shown when they agree with the server score', () {
      final answers = ['A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'B', 'A'];
      expect(
          canShowCorrectAnswers(
              answers: answers, correct: correct, serverCorrectCount: 8),
          isTrue);
    });
    test('hidden when they disagree with the server score', () {
      final answers = ['A', 'B', 'C', 'D', 'A', 'B', 'C', 'D', 'B', 'A'];
      expect(
          canShowCorrectAnswers(
              answers: answers, correct: correct, serverCorrectCount: 7),
          isFalse);
    });
    test('hidden without a server score or a correct letter', () {
      expect(
          canShowCorrectAnswers(
              answers: ['A'], correct: ['A'], serverCorrectCount: null),
          isFalse);
      expect(
          canShowCorrectAnswers(
              answers: ['A', 'B'], correct: ['A', ''], serverCorrectCount: 1),
          isFalse);
    });
  });
}
