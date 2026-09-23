// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct AdminReportResponse
class AdminReportResponseStruct extends FFFirebaseStruct {
  AdminReportResponseStruct({
    /// AdminReportResponse.pathwayCount
    int? pathwayCount,

    /// AdminReportResponse.lessonCount
    int? lessonCount,

    /// AdminReportResponse.quizCount
    int? quizCount,

    /// AdminReportResponse.memberCount
    int? memberCount,

    /// AdminReportResponse.lastImportSummary
    String? lastImportSummary,

    /// AdminReportResponse.lastRagQuestion
    String? lastRagQuestion,

    /// AdminReportResponse.note
    String? note,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _pathwayCount = pathwayCount,
        _lessonCount = lessonCount,
        _quizCount = quizCount,
        _memberCount = memberCount,
        _lastImportSummary = lastImportSummary,
        _lastRagQuestion = lastRagQuestion,
        _note = note,
        super(firestoreUtilData);

  // "pathwayCount" field.
  int? _pathwayCount;
  int get pathwayCount => _pathwayCount ?? 0;
  set pathwayCount(int? val) => _pathwayCount = val;

  void incrementPathwayCount(int amount) =>
      pathwayCount = pathwayCount + amount;

  bool hasPathwayCount() => _pathwayCount != null;

  // "lessonCount" field.
  int? _lessonCount;
  int get lessonCount => _lessonCount ?? 0;
  set lessonCount(int? val) => _lessonCount = val;

  void incrementLessonCount(int amount) => lessonCount = lessonCount + amount;

  bool hasLessonCount() => _lessonCount != null;

  // "quizCount" field.
  int? _quizCount;
  int get quizCount => _quizCount ?? 0;
  set quizCount(int? val) => _quizCount = val;

  void incrementQuizCount(int amount) => quizCount = quizCount + amount;

  bool hasQuizCount() => _quizCount != null;

  // "memberCount" field.
  int? _memberCount;
  int get memberCount => _memberCount ?? 0;
  set memberCount(int? val) => _memberCount = val;

  void incrementMemberCount(int amount) => memberCount = memberCount + amount;

  bool hasMemberCount() => _memberCount != null;

  // "lastImportSummary" field.
  String? _lastImportSummary;
  String get lastImportSummary => _lastImportSummary ?? '';
  set lastImportSummary(String? val) => _lastImportSummary = val;

  bool hasLastImportSummary() => _lastImportSummary != null;

  // "lastRagQuestion" field.
  String? _lastRagQuestion;
  String get lastRagQuestion => _lastRagQuestion ?? '';
  set lastRagQuestion(String? val) => _lastRagQuestion = val;

  bool hasLastRagQuestion() => _lastRagQuestion != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  set note(String? val) => _note = val;

  bool hasNote() => _note != null;

  static AdminReportResponseStruct fromMap(Map<String, dynamic> data) =>
      AdminReportResponseStruct(
        pathwayCount: castToType<int>(data['pathwayCount']),
        lessonCount: castToType<int>(data['lessonCount']),
        quizCount: castToType<int>(data['quizCount']),
        memberCount: castToType<int>(data['memberCount']),
        lastImportSummary: data['lastImportSummary'] as String?,
        lastRagQuestion: data['lastRagQuestion'] as String?,
        note: data['note'] as String?,
      );

  static AdminReportResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? AdminReportResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'pathwayCount': _pathwayCount,
        'lessonCount': _lessonCount,
        'quizCount': _quizCount,
        'memberCount': _memberCount,
        'lastImportSummary': _lastImportSummary,
        'lastRagQuestion': _lastRagQuestion,
        'note': _note,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'pathwayCount': serializeParam(
          _pathwayCount,
          ParamType.int,
        ),
        'lessonCount': serializeParam(
          _lessonCount,
          ParamType.int,
        ),
        'quizCount': serializeParam(
          _quizCount,
          ParamType.int,
        ),
        'memberCount': serializeParam(
          _memberCount,
          ParamType.int,
        ),
        'lastImportSummary': serializeParam(
          _lastImportSummary,
          ParamType.String,
        ),
        'lastRagQuestion': serializeParam(
          _lastRagQuestion,
          ParamType.String,
        ),
        'note': serializeParam(
          _note,
          ParamType.String,
        ),
      }.withoutNulls;

  static AdminReportResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AdminReportResponseStruct(
        pathwayCount: deserializeParam(
          data['pathwayCount'],
          ParamType.int,
          false,
        ),
        lessonCount: deserializeParam(
          data['lessonCount'],
          ParamType.int,
          false,
        ),
        quizCount: deserializeParam(
          data['quizCount'],
          ParamType.int,
          false,
        ),
        memberCount: deserializeParam(
          data['memberCount'],
          ParamType.int,
          false,
        ),
        lastImportSummary: deserializeParam(
          data['lastImportSummary'],
          ParamType.String,
          false,
        ),
        lastRagQuestion: deserializeParam(
          data['lastRagQuestion'],
          ParamType.String,
          false,
        ),
        note: deserializeParam(
          data['note'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AdminReportResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AdminReportResponseStruct &&
        pathwayCount == other.pathwayCount &&
        lessonCount == other.lessonCount &&
        quizCount == other.quizCount &&
        memberCount == other.memberCount &&
        lastImportSummary == other.lastImportSummary &&
        lastRagQuestion == other.lastRagQuestion &&
        note == other.note;
  }

  @override
  int get hashCode => const ListEquality().hash([
        pathwayCount,
        lessonCount,
        quizCount,
        memberCount,
        lastImportSummary,
        lastRagQuestion,
        note
      ]);
}

AdminReportResponseStruct createAdminReportResponseStruct({
  int? pathwayCount,
  int? lessonCount,
  int? quizCount,
  int? memberCount,
  String? lastImportSummary,
  String? lastRagQuestion,
  String? note,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AdminReportResponseStruct(
      pathwayCount: pathwayCount,
      lessonCount: lessonCount,
      quizCount: quizCount,
      memberCount: memberCount,
      lastImportSummary: lastImportSummary,
      lastRagQuestion: lastRagQuestion,
      note: note,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AdminReportResponseStruct? updateAdminReportResponseStruct(
  AdminReportResponseStruct? adminReportResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    adminReportResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAdminReportResponseStructData(
  Map<String, dynamic> firestoreData,
  AdminReportResponseStruct? adminReportResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (adminReportResponse == null) {
    return;
  }
  if (adminReportResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && adminReportResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final adminReportResponseData =
      getAdminReportResponseFirestoreData(adminReportResponse, forFieldValue);
  final nestedData =
      adminReportResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      adminReportResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAdminReportResponseFirestoreData(
  AdminReportResponseStruct? adminReportResponse, [
  bool forFieldValue = false,
]) {
  if (adminReportResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(adminReportResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(adminReportResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAdminReportResponseListFirestoreData(
  List<AdminReportResponseStruct>? adminReportResponses,
) =>
    adminReportResponses
        ?.map((e) => getAdminReportResponseFirestoreData(e, true))
        .toList() ??
    [];
