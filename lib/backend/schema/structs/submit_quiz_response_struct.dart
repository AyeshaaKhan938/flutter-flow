// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// Response shape for submitQuizAttempt
class SubmitQuizResponseStruct extends FFFirebaseStruct {
  SubmitQuizResponseStruct({
    /// Number of correct answers
    int? correctCount,

    /// Total question count
    int? total,

    /// Score percentage
    int? percentage,

    /// Whether the member passed
    bool? passed,

    /// Passing score threshold
    int? passingScore,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _correctCount = correctCount,
        _total = total,
        _percentage = percentage,
        _passed = passed,
        _passingScore = passingScore,
        super(firestoreUtilData);

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

  static SubmitQuizResponseStruct fromMap(Map<String, dynamic> data) =>
      SubmitQuizResponseStruct(
        correctCount: castToType<int>(data['correctCount']),
        total: castToType<int>(data['total']),
        percentage: castToType<int>(data['percentage']),
        passed: data['passed'] as bool?,
        passingScore: castToType<int>(data['passingScore']),
      );

  static SubmitQuizResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? SubmitQuizResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'correctCount': _correctCount,
        'total': _total,
        'percentage': _percentage,
        'passed': _passed,
        'passingScore': _passingScore,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'correctCount': serializeParam(
          _correctCount,
          ParamType.int,
        ),
        'total': serializeParam(
          _total,
          ParamType.int,
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
      }.withoutNulls;

  static SubmitQuizResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      SubmitQuizResponseStruct(
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
      );

  @override
  String toString() => 'SubmitQuizResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SubmitQuizResponseStruct &&
        correctCount == other.correctCount &&
        total == other.total &&
        percentage == other.percentage &&
        passed == other.passed &&
        passingScore == other.passingScore;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([correctCount, total, percentage, passed, passingScore]);
}

SubmitQuizResponseStruct createSubmitQuizResponseStruct({
  int? correctCount,
  int? total,
  int? percentage,
  bool? passed,
  int? passingScore,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SubmitQuizResponseStruct(
      correctCount: correctCount,
      total: total,
      percentage: percentage,
      passed: passed,
      passingScore: passingScore,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SubmitQuizResponseStruct? updateSubmitQuizResponseStruct(
  SubmitQuizResponseStruct? submitQuizResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    submitQuizResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSubmitQuizResponseStructData(
  Map<String, dynamic> firestoreData,
  SubmitQuizResponseStruct? submitQuizResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (submitQuizResponse == null) {
    return;
  }
  if (submitQuizResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && submitQuizResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final submitQuizResponseData =
      getSubmitQuizResponseFirestoreData(submitQuizResponse, forFieldValue);
  final nestedData =
      submitQuizResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      submitQuizResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSubmitQuizResponseFirestoreData(
  SubmitQuizResponseStruct? submitQuizResponse, [
  bool forFieldValue = false,
]) {
  if (submitQuizResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(submitQuizResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(submitQuizResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSubmitQuizResponseListFirestoreData(
  List<SubmitQuizResponseStruct>? submitQuizResponses,
) =>
    submitQuizResponses
        ?.map((e) => getSubmitQuizResponseFirestoreData(e, true))
        .toList() ??
    [];
