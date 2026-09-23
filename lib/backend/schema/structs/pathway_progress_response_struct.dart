// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// Response shape for getPathwayProgress
class PathwayProgressResponseStruct extends FFFirebaseStruct {
  PathwayProgressResponseStruct({
    /// Highest day number reached
    int? currentDay,

    /// Comma-separated completed lesson stableIds
    String? completedLessonsCsv,

    /// Count of completed lessons
    int? completedCount,

    /// Total lesson count for this pathway
    int? totalLessons,

    /// Pathway display title
    String? pathwayTitle,

    /// Member preferred language (en/es/ur)
    String? preferredLanguage,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _currentDay = currentDay,
        _completedLessonsCsv = completedLessonsCsv,
        _completedCount = completedCount,
        _totalLessons = totalLessons,
        _pathwayTitle = pathwayTitle,
        _preferredLanguage = preferredLanguage,
        super(firestoreUtilData);

  // "currentDay" field.
  int? _currentDay;
  int get currentDay => _currentDay ?? 0;
  set currentDay(int? val) => _currentDay = val;

  void incrementCurrentDay(int amount) => currentDay = currentDay + amount;

  bool hasCurrentDay() => _currentDay != null;

  // "completedLessonsCsv" field.
  String? _completedLessonsCsv;
  String get completedLessonsCsv => _completedLessonsCsv ?? '';
  set completedLessonsCsv(String? val) => _completedLessonsCsv = val;

  bool hasCompletedLessonsCsv() => _completedLessonsCsv != null;

  // "completedCount" field.
  int? _completedCount;
  int get completedCount => _completedCount ?? 0;
  set completedCount(int? val) => _completedCount = val;

  void incrementCompletedCount(int amount) =>
      completedCount = completedCount + amount;

  bool hasCompletedCount() => _completedCount != null;

  // "totalLessons" field.
  int? _totalLessons;
  int get totalLessons => _totalLessons ?? 0;
  set totalLessons(int? val) => _totalLessons = val;

  void incrementTotalLessons(int amount) =>
      totalLessons = totalLessons + amount;

  bool hasTotalLessons() => _totalLessons != null;

  // "pathwayTitle" field.
  String? _pathwayTitle;
  String get pathwayTitle => _pathwayTitle ?? '';
  set pathwayTitle(String? val) => _pathwayTitle = val;

  bool hasPathwayTitle() => _pathwayTitle != null;

  // "preferredLanguage" field.
  String? _preferredLanguage;
  String get preferredLanguage => _preferredLanguage ?? '';
  set preferredLanguage(String? val) => _preferredLanguage = val;

  bool hasPreferredLanguage() => _preferredLanguage != null;

  static PathwayProgressResponseStruct fromMap(Map<String, dynamic> data) =>
      PathwayProgressResponseStruct(
        currentDay: castToType<int>(data['currentDay']),
        completedLessonsCsv: data['completedLessonsCsv'] as String?,
        completedCount: castToType<int>(data['completedCount']),
        totalLessons: castToType<int>(data['totalLessons']),
        pathwayTitle: data['pathwayTitle'] as String?,
        preferredLanguage: data['preferredLanguage'] as String?,
      );

  static PathwayProgressResponseStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? PathwayProgressResponseStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'currentDay': _currentDay,
        'completedLessonsCsv': _completedLessonsCsv,
        'completedCount': _completedCount,
        'totalLessons': _totalLessons,
        'pathwayTitle': _pathwayTitle,
        'preferredLanguage': _preferredLanguage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'currentDay': serializeParam(
          _currentDay,
          ParamType.int,
        ),
        'completedLessonsCsv': serializeParam(
          _completedLessonsCsv,
          ParamType.String,
        ),
        'completedCount': serializeParam(
          _completedCount,
          ParamType.int,
        ),
        'totalLessons': serializeParam(
          _totalLessons,
          ParamType.int,
        ),
        'pathwayTitle': serializeParam(
          _pathwayTitle,
          ParamType.String,
        ),
        'preferredLanguage': serializeParam(
          _preferredLanguage,
          ParamType.String,
        ),
      }.withoutNulls;

  static PathwayProgressResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PathwayProgressResponseStruct(
        currentDay: deserializeParam(
          data['currentDay'],
          ParamType.int,
          false,
        ),
        completedLessonsCsv: deserializeParam(
          data['completedLessonsCsv'],
          ParamType.String,
          false,
        ),
        completedCount: deserializeParam(
          data['completedCount'],
          ParamType.int,
          false,
        ),
        totalLessons: deserializeParam(
          data['totalLessons'],
          ParamType.int,
          false,
        ),
        pathwayTitle: deserializeParam(
          data['pathwayTitle'],
          ParamType.String,
          false,
        ),
        preferredLanguage: deserializeParam(
          data['preferredLanguage'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PathwayProgressResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PathwayProgressResponseStruct &&
        currentDay == other.currentDay &&
        completedLessonsCsv == other.completedLessonsCsv &&
        completedCount == other.completedCount &&
        totalLessons == other.totalLessons &&
        pathwayTitle == other.pathwayTitle &&
        preferredLanguage == other.preferredLanguage;
  }

  @override
  int get hashCode => const ListEquality().hash([
        currentDay,
        completedLessonsCsv,
        completedCount,
        totalLessons,
        pathwayTitle,
        preferredLanguage
      ]);
}

PathwayProgressResponseStruct createPathwayProgressResponseStruct({
  int? currentDay,
  String? completedLessonsCsv,
  int? completedCount,
  int? totalLessons,
  String? pathwayTitle,
  String? preferredLanguage,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PathwayProgressResponseStruct(
      currentDay: currentDay,
      completedLessonsCsv: completedLessonsCsv,
      completedCount: completedCount,
      totalLessons: totalLessons,
      pathwayTitle: pathwayTitle,
      preferredLanguage: preferredLanguage,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PathwayProgressResponseStruct? updatePathwayProgressResponseStruct(
  PathwayProgressResponseStruct? pathwayProgressResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    pathwayProgressResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPathwayProgressResponseStructData(
  Map<String, dynamic> firestoreData,
  PathwayProgressResponseStruct? pathwayProgressResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (pathwayProgressResponse == null) {
    return;
  }
  if (pathwayProgressResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      pathwayProgressResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final pathwayProgressResponseData = getPathwayProgressResponseFirestoreData(
      pathwayProgressResponse, forFieldValue);
  final nestedData =
      pathwayProgressResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      pathwayProgressResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPathwayProgressResponseFirestoreData(
  PathwayProgressResponseStruct? pathwayProgressResponse, [
  bool forFieldValue = false,
]) {
  if (pathwayProgressResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(pathwayProgressResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(pathwayProgressResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPathwayProgressResponseListFirestoreData(
  List<PathwayProgressResponseStruct>? pathwayProgressResponses,
) =>
    pathwayProgressResponses
        ?.map((e) => getPathwayProgressResponseFirestoreData(e, true))
        .toList() ??
    [];
