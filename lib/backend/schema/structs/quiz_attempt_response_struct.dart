// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct QuizAttemptResponse
class QuizAttemptResponseStruct extends FFFirebaseStruct {
  QuizAttemptResponseStruct({
    /// QuizAttemptResponse.hasAttempt
    bool? hasAttempt,

    /// QuizAttemptResponse.percentage
    int? percentage,

    /// QuizAttemptResponse.passed
    bool? passed,

    /// QuizAttemptResponse.passingScore
    int? passingScore,

    /// QuizAttemptResponse.attemptCount
    int? attemptCount,

    /// QuizAttemptResponse.correctCount
    int? correctCount,

    /// QuizAttemptResponse.total
    int? total,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _hasAttempt = hasAttempt,
        _percentage = percentage,
        _passed = passed,
        _passingScore = passingScore,
        _attemptCount = attemptCount,
        _correctCount = correctCount,
        _total = total,
        super(firestoreUtilData);

  // "hasAttempt" field.
  bool? _hasAttempt;
  bool get hasAttempt => _hasAttempt ?? false;
  set hasAttempt(bool? val) => _hasAttempt = val;

  bool hasHasAttempt() => _hasAttempt != null;

  // "percentage" field.
  int? _percentage;
  int get percentage => _percentage ?? 0;
  set percentage(int? val) => _percentage = val;

  void incrementPercentage(int amount) => percentage = percentage + amount;

  bool hasPercentage() => _percentage != null;

  // "passed" field.
  bool? _passed;
  bool get passed => _passed ?? false;
  set passed(bool? val) => _passed = val;

  bool hasPassed() => _passed != null;

  // "passingScore" field.
  int? _passingScore;
  int get passingScore => _passingScore ?? 0;
  set passingScore(int? val) => _passingScore = val;

  void incrementPassingScore(int amount) =>
      passingScore = passingScore + amount;

  bool hasPassingScore() => _passingScore != null;

  // "attemptCount" field.
  int? _attemptCount;
  int get attemptCount => _attemptCount ?? 0;
  set attemptCount(int? val) => _attemptCount = val;

  void incrementAttemptCount(int amount) =>
      attemptCount = attemptCount + amount;

  bool hasAttemptCount() => _attemptCount != null;

  // "correctCount" field.
  int? _correctCount;
  int get correctCount => _correctCount ?? 0;
  set correctCount(int? val) => _correctCount = val;

  void incrementCorrectCount(int amount) =>
      correctCount = correctCount + amount;

  bool hasCorrectCount() => _correctCount != null;

  // "total" field.
  int? _total;
  int get total => _total ?? 0;
  set total(int? val) => _total = val;

  void incrementTotal(int amount) => total = total + amount;

  bool hasTotal() => _total != null;

  static QuizAttemptResponseStruct fromMap(Map<String, dynamic> data) =>
      QuizAttemptResponseStruct(
        hasAttempt: data['hasAttempt'] as bool?,
        percentage: castToType<int>(data['percentage']),
        passed: data['passed'] as bool?,
        passingScore: castToType<int>(data['passingScore']),
        attemptCount: castToType<int>(data['attemptCount']),
        correctCount: castToType<int>(data['correctCount']),
        total: castToType<int>(data['total']),
      );

  static QuizAttemptResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? QuizAttemptResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'hasAttempt': _hasAttempt,
        'percentage': _percentage,
        'passed': _passed,
        'passingScore': _passingScore,
        'attemptCount': _attemptCount,
        'correctCount': _correctCount,
        'total': _total,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'hasAttempt': serializeParam(
          _hasAttempt,
          ParamType.bool,
        ),
        'percentage': serializeParam(
          _percentage,
          ParamType.int,
        ),
        'passed': serializeParam(
          _passed,
          ParamType.bool,
        ),
        'passingScore': serializeParam(
          _passingScore,
          ParamType.int,
        ),
        'attemptCount': serializeParam(
          _attemptCount,
          ParamType.int,
        ),
        'correctCount': serializeParam(
          _correctCount,
          ParamType.int,
        ),
        'total': serializeParam(
          _total,
          ParamType.int,
        ),
      }.withoutNulls;

  static QuizAttemptResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      QuizAttemptResponseStruct(
        hasAttempt: deserializeParam(
          data['hasAttempt'],
          ParamType.bool,
          false,
        ),
        percentage: deserializeParam(
          data['percentage'],
          ParamType.int,
          false,
        ),
        passed: deserializeParam(
          data['passed'],
          ParamType.bool,
          false,
        ),
        passingScore: deserializeParam(
          data['passingScore'],
          ParamType.int,
          false,
        ),
        attemptCount: deserializeParam(
          data['attemptCount'],
          ParamType.int,
          false,
        ),
        correctCount: deserializeParam(
          data['correctCount'],
          ParamType.int,
          false,
        ),
        total: deserializeParam(
          data['total'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'QuizAttemptResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is QuizAttemptResponseStruct &&
        hasAttempt == other.hasAttempt &&
        percentage == other.percentage &&
        passed == other.passed &&
        passingScore == other.passingScore &&
        attemptCount == other.attemptCount &&
        correctCount == other.correctCount &&
        total == other.total;
  }

  @override
  int get hashCode => const ListEquality().hash([
        hasAttempt,
        percentage,
        passed,
        passingScore,
        attemptCount,
        correctCount,
        total
      ]);
}

QuizAttemptResponseStruct createQuizAttemptResponseStruct({
  bool? hasAttempt,
  int? percentage,
  bool? passed,
  int? passingScore,
  int? attemptCount,
  int? correctCount,
  int? total,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    QuizAttemptResponseStruct(
      hasAttempt: hasAttempt,
      percentage: percentage,
      passed: passed,
      passingScore: passingScore,
      attemptCount: attemptCount,
      correctCount: correctCount,
      total: total,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

QuizAttemptResponseStruct? updateQuizAttemptResponseStruct(
  QuizAttemptResponseStruct? quizAttemptResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    quizAttemptResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addQuizAttemptResponseStructData(
  Map<String, dynamic> firestoreData,
  QuizAttemptResponseStruct? quizAttemptResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (quizAttemptResponse == null) {
    return;
  }
  if (quizAttemptResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && quizAttemptResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final quizAttemptResponseData =
      getQuizAttemptResponseFirestoreData(quizAttemptResponse, forFieldValue);
  final nestedData =
      quizAttemptResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      quizAttemptResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getQuizAttemptResponseFirestoreData(
  QuizAttemptResponseStruct? quizAttemptResponse, [
  bool forFieldValue = false,
]) {
  if (quizAttemptResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(quizAttemptResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(quizAttemptResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getQuizAttemptResponseListFirestoreData(
  List<QuizAttemptResponseStruct>? quizAttemptResponses,
) =>
    quizAttemptResponses
        ?.map((e) => getQuizAttemptResponseFirestoreData(e, true))
        .toList() ??
    [];
