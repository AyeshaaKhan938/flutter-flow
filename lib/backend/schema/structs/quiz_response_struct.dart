// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// Flattened response shape for getQuiz
class QuizResponseStruct extends FFFirebaseStruct {
  QuizResponseStruct({
    /// Quiz title
    String? quizTitle,

    /// Passing score percentage
    int? passingScore,

    /// Question 1 text
    String? q1Text,

    /// Question 1 option A
    String? q1A,

    /// Question 1 option B
    String? q1B,

    /// Question 1 option C
    String? q1C,

    /// Question 1 option D
    String? q1D,

    /// Question 2 text
    String? q2Text,

    /// Question 2 option A
    String? q2A,

    /// Question 2 option B
    String? q2B,

    /// Question 2 option C
    String? q2C,

    /// Question 2 option D
    String? q2D,

    /// Question 3 text
    String? q3Text,

    /// Question 3 option A
    String? q3A,

    /// Question 3 option B
    String? q3B,

    /// Question 3 option C
    String? q3C,

    /// Question 3 option D
    String? q3D,

    /// Question 4 text
    String? q4Text,

    /// Question 4 option A
    String? q4A,

    /// Question 4 option B
    String? q4B,

    /// Question 4 option C
    String? q4C,

    /// Question 4 option D
    String? q4D,

    /// Question 5 text
    String? q5Text,

    /// Question 5 option A
    String? q5A,

    /// Question 5 option B
    String? q5B,

    /// Question 5 option C
    String? q5C,

    /// Question 5 option D
    String? q5D,

    /// Question 6 text
    String? q6Text,

    /// Question 6 option A
    String? q6A,

    /// Question 6 option B
    String? q6B,

    /// Question 6 option C
    String? q6C,

    /// Question 6 option D
    String? q6D,

    /// Question 7 text
    String? q7Text,

    /// Question 7 option A
    String? q7A,

    /// Question 7 option B
    String? q7B,

    /// Question 7 option C
    String? q7C,

    /// Question 7 option D
    String? q7D,

    /// Question 8 text
    String? q8Text,

    /// Question 8 option A
    String? q8A,

    /// Question 8 option B
    String? q8B,

    /// Question 8 option C
    String? q8C,

    /// Question 8 option D
    String? q8D,

    /// Question 9 text
    String? q9Text,

    /// Question 9 option A
    String? q9A,

    /// Question 9 option B
    String? q9B,

    /// Question 9 option C
    String? q9C,

    /// Question 9 option D
    String? q9D,

    /// Question 10 text
    String? q10Text,

    /// Question 10 option A
    String? q10A,

    /// Question 10 option B
    String? q10B,

    /// Question 10 option C
    String? q10C,

    /// Question 10 option D
    String? q10D,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _quizTitle = quizTitle,
        _passingScore = passingScore,
        _q1Text = q1Text,
        _q1A = q1A,
        _q1B = q1B,
        _q1C = q1C,
        _q1D = q1D,
        _q2Text = q2Text,
        _q2A = q2A,
        _q2B = q2B,
        _q2C = q2C,
        _q2D = q2D,
        _q3Text = q3Text,
        _q3A = q3A,
        _q3B = q3B,
        _q3C = q3C,
        _q3D = q3D,
        _q4Text = q4Text,
        _q4A = q4A,
        _q4B = q4B,
        _q4C = q4C,
        _q4D = q4D,
        _q5Text = q5Text,
        _q5A = q5A,
        _q5B = q5B,
        _q5C = q5C,
        _q5D = q5D,
        _q6Text = q6Text,
        _q6A = q6A,
        _q6B = q6B,
        _q6C = q6C,
        _q6D = q6D,
        _q7Text = q7Text,
        _q7A = q7A,
        _q7B = q7B,
        _q7C = q7C,
        _q7D = q7D,
        _q8Text = q8Text,
        _q8A = q8A,
        _q8B = q8B,
        _q8C = q8C,
        _q8D = q8D,
        _q9Text = q9Text,
        _q9A = q9A,
        _q9B = q9B,
        _q9C = q9C,
        _q9D = q9D,
        _q10Text = q10Text,
        _q10A = q10A,
        _q10B = q10B,
        _q10C = q10C,
        _q10D = q10D,
        super(firestoreUtilData);

  // "quizTitle" field.
  String? _quizTitle;
  String get quizTitle => _quizTitle ?? '';
  set quizTitle(String? val) => _quizTitle = val;

  bool hasQuizTitle() => _quizTitle != null;

  // "passingScore" field.
  int? _passingScore;
  int get passingScore => _passingScore ?? 0;
  set passingScore(int? val) => _passingScore = val;

  void incrementPassingScore(int amount) =>
      passingScore = passingScore + amount;

  bool hasPassingScore() => _passingScore != null;

  // "q1Text" field.
  String? _q1Text;
  String get q1Text => _q1Text ?? '';
  set q1Text(String? val) => _q1Text = val;

  bool hasQ1Text() => _q1Text != null;

  // "q1A" field.
  String? _q1A;
  String get q1A => _q1A ?? '';
  set q1A(String? val) => _q1A = val;

  bool hasQ1A() => _q1A != null;

  // "q1B" field.
  String? _q1B;
  String get q1B => _q1B ?? '';
  set q1B(String? val) => _q1B = val;

  bool hasQ1B() => _q1B != null;

  // "q1C" field.
  String? _q1C;
  String get q1C => _q1C ?? '';
  set q1C(String? val) => _q1C = val;

  bool hasQ1C() => _q1C != null;

  // "q1D" field.
  String? _q1D;
  String get q1D => _q1D ?? '';
  set q1D(String? val) => _q1D = val;

  bool hasQ1D() => _q1D != null;

  // "q2Text" field.
  String? _q2Text;
  String get q2Text => _q2Text ?? '';
  set q2Text(String? val) => _q2Text = val;

  bool hasQ2Text() => _q2Text != null;

  // "q2A" field.
  String? _q2A;
  String get q2A => _q2A ?? '';
  set q2A(String? val) => _q2A = val;

  bool hasQ2A() => _q2A != null;

  // "q2B" field.
  String? _q2B;
  String get q2B => _q2B ?? '';
  set q2B(String? val) => _q2B = val;

  bool hasQ2B() => _q2B != null;

  // "q2C" field.
  String? _q2C;
  String get q2C => _q2C ?? '';
  set q2C(String? val) => _q2C = val;

  bool hasQ2C() => _q2C != null;

  // "q2D" field.
  String? _q2D;
  String get q2D => _q2D ?? '';
  set q2D(String? val) => _q2D = val;

  bool hasQ2D() => _q2D != null;

  // "q3Text" field.
  String? _q3Text;
  String get q3Text => _q3Text ?? '';
  set q3Text(String? val) => _q3Text = val;

  bool hasQ3Text() => _q3Text != null;

  // "q3A" field.
  String? _q3A;
  String get q3A => _q3A ?? '';
  set q3A(String? val) => _q3A = val;

  bool hasQ3A() => _q3A != null;

  // "q3B" field.
  String? _q3B;
  String get q3B => _q3B ?? '';
  set q3B(String? val) => _q3B = val;

  bool hasQ3B() => _q3B != null;

  // "q3C" field.
  String? _q3C;
  String get q3C => _q3C ?? '';
  set q3C(String? val) => _q3C = val;

  bool hasQ3C() => _q3C != null;

  // "q3D" field.
  String? _q3D;
  String get q3D => _q3D ?? '';
  set q3D(String? val) => _q3D = val;

  bool hasQ3D() => _q3D != null;

  // "q4Text" field.
  String? _q4Text;
  String get q4Text => _q4Text ?? '';
  set q4Text(String? val) => _q4Text = val;

  bool hasQ4Text() => _q4Text != null;

  // "q4A" field.
  String? _q4A;
  String get q4A => _q4A ?? '';
  set q4A(String? val) => _q4A = val;

  bool hasQ4A() => _q4A != null;

  // "q4B" field.
  String? _q4B;
  String get q4B => _q4B ?? '';
  set q4B(String? val) => _q4B = val;

  bool hasQ4B() => _q4B != null;

  // "q4C" field.
  String? _q4C;
  String get q4C => _q4C ?? '';
  set q4C(String? val) => _q4C = val;

  bool hasQ4C() => _q4C != null;

  // "q4D" field.
  String? _q4D;
  String get q4D => _q4D ?? '';
  set q4D(String? val) => _q4D = val;

  bool hasQ4D() => _q4D != null;

  // "q5Text" field.
  String? _q5Text;
  String get q5Text => _q5Text ?? '';
  set q5Text(String? val) => _q5Text = val;

  bool hasQ5Text() => _q5Text != null;

  // "q5A" field.
  String? _q5A;
  String get q5A => _q5A ?? '';
  set q5A(String? val) => _q5A = val;

  bool hasQ5A() => _q5A != null;

  // "q5B" field.
  String? _q5B;
  String get q5B => _q5B ?? '';
  set q5B(String? val) => _q5B = val;

  bool hasQ5B() => _q5B != null;

  // "q5C" field.
  String? _q5C;
  String get q5C => _q5C ?? '';
  set q5C(String? val) => _q5C = val;

  bool hasQ5C() => _q5C != null;

  // "q5D" field.
  String? _q5D;
  String get q5D => _q5D ?? '';
  set q5D(String? val) => _q5D = val;

  bool hasQ5D() => _q5D != null;

  // "q6Text" field.
  String? _q6Text;
  String get q6Text => _q6Text ?? '';
  set q6Text(String? val) => _q6Text = val;

  bool hasQ6Text() => _q6Text != null;

  // "q6A" field.
  String? _q6A;
  String get q6A => _q6A ?? '';
  set q6A(String? val) => _q6A = val;

  bool hasQ6A() => _q6A != null;

  // "q6B" field.
  String? _q6B;
  String get q6B => _q6B ?? '';
  set q6B(String? val) => _q6B = val;

  bool hasQ6B() => _q6B != null;

  // "q6C" field.
  String? _q6C;
  String get q6C => _q6C ?? '';
  set q6C(String? val) => _q6C = val;

  bool hasQ6C() => _q6C != null;

  // "q6D" field.
  String? _q6D;
  String get q6D => _q6D ?? '';
  set q6D(String? val) => _q6D = val;

  bool hasQ6D() => _q6D != null;

  // "q7Text" field.
  String? _q7Text;
  String get q7Text => _q7Text ?? '';
  set q7Text(String? val) => _q7Text = val;

  bool hasQ7Text() => _q7Text != null;

  // "q7A" field.
  String? _q7A;
  String get q7A => _q7A ?? '';
  set q7A(String? val) => _q7A = val;

  bool hasQ7A() => _q7A != null;

  // "q7B" field.
  String? _q7B;
  String get q7B => _q7B ?? '';
  set q7B(String? val) => _q7B = val;

  bool hasQ7B() => _q7B != null;

  // "q7C" field.
  String? _q7C;
  String get q7C => _q7C ?? '';
  set q7C(String? val) => _q7C = val;

  bool hasQ7C() => _q7C != null;

  // "q7D" field.
  String? _q7D;
  String get q7D => _q7D ?? '';
  set q7D(String? val) => _q7D = val;

  bool hasQ7D() => _q7D != null;

  // "q8Text" field.
  String? _q8Text;
  String get q8Text => _q8Text ?? '';
  set q8Text(String? val) => _q8Text = val;

  bool hasQ8Text() => _q8Text != null;

  // "q8A" field.
  String? _q8A;
  String get q8A => _q8A ?? '';
  set q8A(String? val) => _q8A = val;

  bool hasQ8A() => _q8A != null;

  // "q8B" field.
  String? _q8B;
  String get q8B => _q8B ?? '';
  set q8B(String? val) => _q8B = val;

  bool hasQ8B() => _q8B != null;

  // "q8C" field.
  String? _q8C;
  String get q8C => _q8C ?? '';
  set q8C(String? val) => _q8C = val;

  bool hasQ8C() => _q8C != null;

  // "q8D" field.
  String? _q8D;
  String get q8D => _q8D ?? '';
  set q8D(String? val) => _q8D = val;

  bool hasQ8D() => _q8D != null;

  // "q9Text" field.
  String? _q9Text;
  String get q9Text => _q9Text ?? '';
  set q9Text(String? val) => _q9Text = val;

  bool hasQ9Text() => _q9Text != null;

  // "q9A" field.
  String? _q9A;
  String get q9A => _q9A ?? '';
  set q9A(String? val) => _q9A = val;

  bool hasQ9A() => _q9A != null;

  // "q9B" field.
  String? _q9B;
  String get q9B => _q9B ?? '';
  set q9B(String? val) => _q9B = val;

  bool hasQ9B() => _q9B != null;

  // "q9C" field.
  String? _q9C;
  String get q9C => _q9C ?? '';
  set q9C(String? val) => _q9C = val;

  bool hasQ9C() => _q9C != null;

  // "q9D" field.
  String? _q9D;
  String get q9D => _q9D ?? '';
  set q9D(String? val) => _q9D = val;

  bool hasQ9D() => _q9D != null;

  // "q10Text" field.
  String? _q10Text;
  String get q10Text => _q10Text ?? '';
  set q10Text(String? val) => _q10Text = val;

  bool hasQ10Text() => _q10Text != null;

  // "q10A" field.
  String? _q10A;
  String get q10A => _q10A ?? '';
  set q10A(String? val) => _q10A = val;

  bool hasQ10A() => _q10A != null;

  // "q10B" field.
  String? _q10B;
  String get q10B => _q10B ?? '';
  set q10B(String? val) => _q10B = val;

  bool hasQ10B() => _q10B != null;

  // "q10C" field.
  String? _q10C;
  String get q10C => _q10C ?? '';
  set q10C(String? val) => _q10C = val;

  bool hasQ10C() => _q10C != null;

  // "q10D" field.
  String? _q10D;
  String get q10D => _q10D ?? '';
  set q10D(String? val) => _q10D = val;

  bool hasQ10D() => _q10D != null;

  static QuizResponseStruct fromMap(Map<String, dynamic> data) =>
      QuizResponseStruct(
        quizTitle: data['quizTitle'] as String?,
        passingScore: castToType<int>(data['passingScore']),
        q1Text: data['q1Text'] as String?,
        q1A: data['q1A'] as String?,
        q1B: data['q1B'] as String?,
        q1C: data['q1C'] as String?,
        q1D: data['q1D'] as String?,
        q2Text: data['q2Text'] as String?,
        q2A: data['q2A'] as String?,
        q2B: data['q2B'] as String?,
        q2C: data['q2C'] as String?,
        q2D: data['q2D'] as String?,
        q3Text: data['q3Text'] as String?,
        q3A: data['q3A'] as String?,
        q3B: data['q3B'] as String?,
        q3C: data['q3C'] as String?,
        q3D: data['q3D'] as String?,
        q4Text: data['q4Text'] as String?,
        q4A: data['q4A'] as String?,
        q4B: data['q4B'] as String?,
        q4C: data['q4C'] as String?,
        q4D: data['q4D'] as String?,
        q5Text: data['q5Text'] as String?,
        q5A: data['q5A'] as String?,
        q5B: data['q5B'] as String?,
        q5C: data['q5C'] as String?,
        q5D: data['q5D'] as String?,
        q6Text: data['q6Text'] as String?,
        q6A: data['q6A'] as String?,
        q6B: data['q6B'] as String?,
        q6C: data['q6C'] as String?,
        q6D: data['q6D'] as String?,
        q7Text: data['q7Text'] as String?,
        q7A: data['q7A'] as String?,
        q7B: data['q7B'] as String?,
        q7C: data['q7C'] as String?,
        q7D: data['q7D'] as String?,
        q8Text: data['q8Text'] as String?,
        q8A: data['q8A'] as String?,
        q8B: data['q8B'] as String?,
        q8C: data['q8C'] as String?,
        q8D: data['q8D'] as String?,
        q9Text: data['q9Text'] as String?,
        q9A: data['q9A'] as String?,
        q9B: data['q9B'] as String?,
        q9C: data['q9C'] as String?,
        q9D: data['q9D'] as String?,
        q10Text: data['q10Text'] as String?,
        q10A: data['q10A'] as String?,
        q10B: data['q10B'] as String?,
        q10C: data['q10C'] as String?,
        q10D: data['q10D'] as String?,
      );

  static QuizResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? QuizResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'quizTitle': _quizTitle,
        'passingScore': _passingScore,
        'q1Text': _q1Text,
        'q1A': _q1A,
        'q1B': _q1B,
        'q1C': _q1C,
        'q1D': _q1D,
        'q2Text': _q2Text,
        'q2A': _q2A,
        'q2B': _q2B,
        'q2C': _q2C,
        'q2D': _q2D,
        'q3Text': _q3Text,
        'q3A': _q3A,
        'q3B': _q3B,
        'q3C': _q3C,
        'q3D': _q3D,
        'q4Text': _q4Text,
        'q4A': _q4A,
        'q4B': _q4B,
        'q4C': _q4C,
        'q4D': _q4D,
        'q5Text': _q5Text,
        'q5A': _q5A,
        'q5B': _q5B,
        'q5C': _q5C,
        'q5D': _q5D,
        'q6Text': _q6Text,
        'q6A': _q6A,
        'q6B': _q6B,
        'q6C': _q6C,
        'q6D': _q6D,
        'q7Text': _q7Text,
        'q7A': _q7A,
        'q7B': _q7B,
        'q7C': _q7C,
        'q7D': _q7D,
        'q8Text': _q8Text,
        'q8A': _q8A,
        'q8B': _q8B,
        'q8C': _q8C,
        'q8D': _q8D,
        'q9Text': _q9Text,
        'q9A': _q9A,
        'q9B': _q9B,
        'q9C': _q9C,
        'q9D': _q9D,
        'q10Text': _q10Text,
        'q10A': _q10A,
        'q10B': _q10B,
        'q10C': _q10C,
        'q10D': _q10D,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'quizTitle': serializeParam(
          _quizTitle,
          ParamType.String,
        ),
        'passingScore': serializeParam(
          _passingScore,
          ParamType.int,
        ),
        'q1Text': serializeParam(
          _q1Text,
          ParamType.String,
        ),
        'q1A': serializeParam(
          _q1A,
          ParamType.String,
        ),
        'q1B': serializeParam(
          _q1B,
          ParamType.String,
        ),
        'q1C': serializeParam(
          _q1C,
          ParamType.String,
        ),
        'q1D': serializeParam(
          _q1D,
          ParamType.String,
        ),
        'q2Text': serializeParam(
          _q2Text,
          ParamType.String,
        ),
        'q2A': serializeParam(
          _q2A,
          ParamType.String,
        ),
        'q2B': serializeParam(
          _q2B,
          ParamType.String,
        ),
        'q2C': serializeParam(
          _q2C,
          ParamType.String,
        ),
        'q2D': serializeParam(
          _q2D,
          ParamType.String,
        ),
        'q3Text': serializeParam(
          _q3Text,
          ParamType.String,
        ),
        'q3A': serializeParam(
          _q3A,
          ParamType.String,
        ),
        'q3B': serializeParam(
          _q3B,
          ParamType.String,
        ),
        'q3C': serializeParam(
          _q3C,
          ParamType.String,
        ),
        'q3D': serializeParam(
          _q3D,
          ParamType.String,
        ),
        'q4Text': serializeParam(
          _q4Text,
          ParamType.String,
        ),
        'q4A': serializeParam(
          _q4A,
          ParamType.String,
        ),
        'q4B': serializeParam(
          _q4B,
          ParamType.String,
        ),
        'q4C': serializeParam(
          _q4C,
          ParamType.String,
        ),
        'q4D': serializeParam(
          _q4D,
          ParamType.String,
        ),
        'q5Text': serializeParam(
          _q5Text,
          ParamType.String,
        ),
        'q5A': serializeParam(
          _q5A,
          ParamType.String,
        ),
        'q5B': serializeParam(
          _q5B,
          ParamType.String,
        ),
        'q5C': serializeParam(
          _q5C,
          ParamType.String,
        ),
        'q5D': serializeParam(
          _q5D,
          ParamType.String,
        ),
        'q6Text': serializeParam(
          _q6Text,
          ParamType.String,
        ),
        'q6A': serializeParam(
          _q6A,
          ParamType.String,
        ),
        'q6B': serializeParam(
          _q6B,
          ParamType.String,
        ),
        'q6C': serializeParam(
          _q6C,
          ParamType.String,
        ),
        'q6D': serializeParam(
          _q6D,
          ParamType.String,
        ),
        'q7Text': serializeParam(
          _q7Text,
          ParamType.String,
        ),
        'q7A': serializeParam(
          _q7A,
          ParamType.String,
        ),
        'q7B': serializeParam(
          _q7B,
          ParamType.String,
        ),
        'q7C': serializeParam(
          _q7C,
          ParamType.String,
        ),
        'q7D': serializeParam(
          _q7D,
          ParamType.String,
        ),
        'q8Text': serializeParam(
          _q8Text,
          ParamType.String,
        ),
        'q8A': serializeParam(
          _q8A,
          ParamType.String,
        ),
        'q8B': serializeParam(
          _q8B,
          ParamType.String,
        ),
        'q8C': serializeParam(
          _q8C,
          ParamType.String,
        ),
        'q8D': serializeParam(
          _q8D,
          ParamType.String,
        ),
        'q9Text': serializeParam(
          _q9Text,
          ParamType.String,
        ),
        'q9A': serializeParam(
          _q9A,
          ParamType.String,
        ),
        'q9B': serializeParam(
          _q9B,
          ParamType.String,
        ),
        'q9C': serializeParam(
          _q9C,
          ParamType.String,
        ),
        'q9D': serializeParam(
          _q9D,
          ParamType.String,
        ),
        'q10Text': serializeParam(
          _q10Text,
          ParamType.String,
        ),
        'q10A': serializeParam(
          _q10A,
          ParamType.String,
        ),
        'q10B': serializeParam(
          _q10B,
          ParamType.String,
        ),
        'q10C': serializeParam(
          _q10C,
          ParamType.String,
        ),
        'q10D': serializeParam(
          _q10D,
          ParamType.String,
        ),
      }.withoutNulls;

  static QuizResponseStruct fromSerializableMap(Map<String, dynamic> data) =>
      QuizResponseStruct(
        quizTitle: deserializeParam(
          data['quizTitle'],
          ParamType.String,
          false,
        ),
        passingScore: deserializeParam(
          data['passingScore'],
          ParamType.int,
          false,
        ),
        q1Text: deserializeParam(
          data['q1Text'],
          ParamType.String,
          false,
        ),
        q1A: deserializeParam(
          data['q1A'],
          ParamType.String,
          false,
        ),
        q1B: deserializeParam(
          data['q1B'],
          ParamType.String,
          false,
        ),
        q1C: deserializeParam(
          data['q1C'],
          ParamType.String,
          false,
        ),
        q1D: deserializeParam(
          data['q1D'],
          ParamType.String,
          false,
        ),
        q2Text: deserializeParam(
          data['q2Text'],
          ParamType.String,
          false,
        ),
        q2A: deserializeParam(
          data['q2A'],
          ParamType.String,
          false,
        ),
        q2B: deserializeParam(
          data['q2B'],
          ParamType.String,
          false,
        ),
        q2C: deserializeParam(
          data['q2C'],
          ParamType.String,
          false,
        ),
        q2D: deserializeParam(
          data['q2D'],
          ParamType.String,
          false,
        ),
        q3Text: deserializeParam(
          data['q3Text'],
          ParamType.String,
          false,
        ),
        q3A: deserializeParam(
          data['q3A'],
          ParamType.String,
          false,
        ),
        q3B: deserializeParam(
          data['q3B'],
          ParamType.String,
          false,
        ),
        q3C: deserializeParam(
          data['q3C'],
          ParamType.String,
          false,
        ),
        q3D: deserializeParam(
          data['q3D'],
          ParamType.String,
          false,
        ),
        q4Text: deserializeParam(
          data['q4Text'],
          ParamType.String,
          false,
        ),
        q4A: deserializeParam(
          data['q4A'],
          ParamType.String,
          false,
        ),
        q4B: deserializeParam(
          data['q4B'],
          ParamType.String,
          false,
        ),
        q4C: deserializeParam(
          data['q4C'],
          ParamType.String,
          false,
        ),
        q4D: deserializeParam(
          data['q4D'],
          ParamType.String,
          false,
        ),
        q5Text: deserializeParam(
          data['q5Text'],
          ParamType.String,
          false,
        ),
        q5A: deserializeParam(
          data['q5A'],
          ParamType.String,
          false,
        ),
        q5B: deserializeParam(
          data['q5B'],
          ParamType.String,
          false,
        ),
        q5C: deserializeParam(
          data['q5C'],
          ParamType.String,
          false,
        ),
        q5D: deserializeParam(
          data['q5D'],
          ParamType.String,
          false,
        ),
        q6Text: deserializeParam(
          data['q6Text'],
          ParamType.String,
          false,
        ),
        q6A: deserializeParam(
          data['q6A'],
          ParamType.String,
          false,
        ),
        q6B: deserializeParam(
          data['q6B'],
          ParamType.String,
          false,
        ),
        q6C: deserializeParam(
          data['q6C'],
          ParamType.String,
          false,
        ),
        q6D: deserializeParam(
          data['q6D'],
          ParamType.String,
          false,
        ),
        q7Text: deserializeParam(
          data['q7Text'],
          ParamType.String,
          false,
        ),
        q7A: deserializeParam(
          data['q7A'],
          ParamType.String,
          false,
        ),
        q7B: deserializeParam(
          data['q7B'],
          ParamType.String,
          false,
        ),
        q7C: deserializeParam(
          data['q7C'],
          ParamType.String,
          false,
        ),
        q7D: deserializeParam(
          data['q7D'],
          ParamType.String,
          false,
        ),
        q8Text: deserializeParam(
          data['q8Text'],
          ParamType.String,
          false,
        ),
        q8A: deserializeParam(
          data['q8A'],
          ParamType.String,
          false,
        ),
        q8B: deserializeParam(
          data['q8B'],
          ParamType.String,
          false,
        ),
        q8C: deserializeParam(
          data['q8C'],
          ParamType.String,
          false,
        ),
        q8D: deserializeParam(
          data['q8D'],
          ParamType.String,
          false,
        ),
        q9Text: deserializeParam(
          data['q9Text'],
          ParamType.String,
          false,
        ),
        q9A: deserializeParam(
          data['q9A'],
          ParamType.String,
          false,
        ),
        q9B: deserializeParam(
          data['q9B'],
          ParamType.String,
          false,
        ),
        q9C: deserializeParam(
          data['q9C'],
          ParamType.String,
          false,
        ),
        q9D: deserializeParam(
          data['q9D'],
          ParamType.String,
          false,
        ),
        q10Text: deserializeParam(
          data['q10Text'],
          ParamType.String,
          false,
        ),
        q10A: deserializeParam(
          data['q10A'],
          ParamType.String,
          false,
        ),
        q10B: deserializeParam(
          data['q10B'],
          ParamType.String,
          false,
        ),
        q10C: deserializeParam(
          data['q10C'],
          ParamType.String,
          false,
        ),
        q10D: deserializeParam(
          data['q10D'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'QuizResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is QuizResponseStruct &&
        quizTitle == other.quizTitle &&
        passingScore == other.passingScore &&
        q1Text == other.q1Text &&
        q1A == other.q1A &&
        q1B == other.q1B &&
        q1C == other.q1C &&
        q1D == other.q1D &&
        q2Text == other.q2Text &&
        q2A == other.q2A &&
        q2B == other.q2B &&
        q2C == other.q2C &&
        q2D == other.q2D &&
        q3Text == other.q3Text &&
        q3A == other.q3A &&
        q3B == other.q3B &&
        q3C == other.q3C &&
        q3D == other.q3D &&
        q4Text == other.q4Text &&
        q4A == other.q4A &&
        q4B == other.q4B &&
        q4C == other.q4C &&
        q4D == other.q4D &&
        q5Text == other.q5Text &&
        q5A == other.q5A &&
        q5B == other.q5B &&
        q5C == other.q5C &&
        q5D == other.q5D &&
        q6Text == other.q6Text &&
        q6A == other.q6A &&
        q6B == other.q6B &&
        q6C == other.q6C &&
        q6D == other.q6D &&
        q7Text == other.q7Text &&
        q7A == other.q7A &&
        q7B == other.q7B &&
        q7C == other.q7C &&
        q7D == other.q7D &&
        q8Text == other.q8Text &&
        q8A == other.q8A &&
        q8B == other.q8B &&
        q8C == other.q8C &&
        q8D == other.q8D &&
        q9Text == other.q9Text &&
        q9A == other.q9A &&
        q9B == other.q9B &&
        q9C == other.q9C &&
        q9D == other.q9D &&
        q10Text == other.q10Text &&
        q10A == other.q10A &&
        q10B == other.q10B &&
        q10C == other.q10C &&
        q10D == other.q10D;
  }

  @override
  int get hashCode => const ListEquality().hash([
        quizTitle,
        passingScore,
        q1Text,
        q1A,
        q1B,
        q1C,
        q1D,
        q2Text,
        q2A,
        q2B,
        q2C,
        q2D,
        q3Text,
        q3A,
        q3B,
        q3C,
        q3D,
        q4Text,
        q4A,
        q4B,
        q4C,
        q4D,
        q5Text,
        q5A,
        q5B,
        q5C,
        q5D,
        q6Text,
        q6A,
        q6B,
        q6C,
        q6D,
        q7Text,
        q7A,
        q7B,
        q7C,
        q7D,
        q8Text,
        q8A,
        q8B,
        q8C,
        q8D,
        q9Text,
        q9A,
        q9B,
        q9C,
        q9D,
        q10Text,
        q10A,
        q10B,
        q10C,
        q10D
      ]);
}

QuizResponseStruct createQuizResponseStruct({
  String? quizTitle,
  int? passingScore,
  String? q1Text,
  String? q1A,
  String? q1B,
  String? q1C,
  String? q1D,
  String? q2Text,
  String? q2A,
  String? q2B,
  String? q2C,
  String? q2D,
  String? q3Text,
  String? q3A,
  String? q3B,
  String? q3C,
  String? q3D,
  String? q4Text,
  String? q4A,
  String? q4B,
  String? q4C,
  String? q4D,
  String? q5Text,
  String? q5A,
  String? q5B,
  String? q5C,
  String? q5D,
  String? q6Text,
  String? q6A,
  String? q6B,
  String? q6C,
  String? q6D,
  String? q7Text,
  String? q7A,
  String? q7B,
  String? q7C,
  String? q7D,
  String? q8Text,
  String? q8A,
  String? q8B,
  String? q8C,
  String? q8D,
  String? q9Text,
  String? q9A,
  String? q9B,
  String? q9C,
  String? q9D,
  String? q10Text,
  String? q10A,
  String? q10B,
  String? q10C,
  String? q10D,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    QuizResponseStruct(
      quizTitle: quizTitle,
      passingScore: passingScore,
      q1Text: q1Text,
      q1A: q1A,
      q1B: q1B,
      q1C: q1C,
      q1D: q1D,
      q2Text: q2Text,
      q2A: q2A,
      q2B: q2B,
      q2C: q2C,
      q2D: q2D,
      q3Text: q3Text,
      q3A: q3A,
      q3B: q3B,
      q3C: q3C,
      q3D: q3D,
      q4Text: q4Text,
      q4A: q4A,
      q4B: q4B,
      q4C: q4C,
      q4D: q4D,
      q5Text: q5Text,
      q5A: q5A,
      q5B: q5B,
      q5C: q5C,
      q5D: q5D,
      q6Text: q6Text,
      q6A: q6A,
      q6B: q6B,
      q6C: q6C,
      q6D: q6D,
      q7Text: q7Text,
      q7A: q7A,
      q7B: q7B,
      q7C: q7C,
      q7D: q7D,
      q8Text: q8Text,
      q8A: q8A,
      q8B: q8B,
      q8C: q8C,
      q8D: q8D,
      q9Text: q9Text,
      q9A: q9A,
      q9B: q9B,
      q9C: q9C,
      q9D: q9D,
      q10Text: q10Text,
      q10A: q10A,
      q10B: q10B,
      q10C: q10C,
      q10D: q10D,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

QuizResponseStruct? updateQuizResponseStruct(
  QuizResponseStruct? quizResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    quizResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addQuizResponseStructData(
  Map<String, dynamic> firestoreData,
  QuizResponseStruct? quizResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (quizResponse == null) {
    return;
  }
  if (quizResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && quizResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final quizResponseData =
      getQuizResponseFirestoreData(quizResponse, forFieldValue);
  final nestedData =
      quizResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = quizResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getQuizResponseFirestoreData(
  QuizResponseStruct? quizResponse, [
  bool forFieldValue = false,
]) {
  if (quizResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(quizResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(quizResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getQuizResponseListFirestoreData(
  List<QuizResponseStruct>? quizResponses,
) =>
    quizResponses?.map((e) => getQuizResponseFirestoreData(e, true)).toList() ??
    [];
