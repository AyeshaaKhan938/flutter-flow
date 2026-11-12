// Helpers for showing quiz choices and the review after a quiz is submitted.
// Pure functions, so they can be unit tested.

const kQuizOptionLetters = ['A', 'B', 'C', 'D'];

/// Leading labels such as "A.", "A)", "(A)", "A:" or "A -" for [letter],
/// repeated any number of times ("A. A. text"). The mark must be followed by
/// a space, so text such as "A.D. 70" is kept.
RegExp _leadingLabels(String letter) => RegExp(
      '^(?:\\s*\\(?$letter(?:[.):](?=\\s|\$)|\\s+-(?=\\s))\\s*)+',
      caseSensitive: false,
    );

/// The choice text with exactly one letter in front: "A. text".
///
/// Some imported choices already start with their letter, and the quiz
/// service adds it again, which showed "A. A. text". Any number of leading
/// labels for this letter are removed and one is added back.
String optionWithSingleLabel(String letter, String? text) {
  final raw = (text ?? '').trim();
  if (raw.isEmpty) return '';
  final body = raw.replaceFirst(_leadingLabels(letter), '').trim();
  return body.isEmpty ? '$letter.' : '$letter. $body';
}

/// Number of answers that match the correct letters (case-insensitive).
int countCorrect(List<String> answers, List<String> correct) {
  var n = 0;
  for (var i = 0; i < answers.length && i < correct.length; i++) {
    final a = answers[i].trim().toUpperCase();
    if (a.isNotEmpty && a == correct[i].trim().toUpperCase()) n++;
  }
  return n;
}

/// Whether the correct answers read from the quiz record can be shown.
///
/// They are shown only when every answered question has a correct letter
/// and the number they mark correct equals the score the server gave. If
/// the server scored from different data, the review shows the member's
/// answers and explanations without marking them right or wrong.
bool canShowCorrectAnswers({
  required List<String> answers,
  required List<String> correct,
  required int? serverCorrectCount,
}) {
  if (serverCorrectCount == null) return false;
  for (var i = 0; i < answers.length; i++) {
    if (answers[i].trim().isEmpty) continue;
    if (i >= correct.length ||
        !kQuizOptionLetters.contains(correct[i].trim().toUpperCase())) {
      return false;
    }
  }
  return countCorrect(answers, correct) == serverCorrectCount;
}
