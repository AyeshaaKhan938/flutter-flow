// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct TodayContentResponse
class TodayContentResponseStruct extends FFFirebaseStruct {
  TodayContentResponseStruct({
    /// TodayContentResponse.date
    String? date,

    /// TodayContentResponse.language
    String? language,

    /// TodayContentResponse.scriptureRef
    String? scriptureRef,

    /// TodayContentResponse.scriptureTheme
    String? scriptureTheme,

    /// TodayContentResponse.scriptureText
    String? scriptureText,

    /// TodayContentResponse.encouragementText
    String? encouragementText,

    /// TodayContentResponse.encouragementRef
    String? encouragementRef,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _date = date,
        _language = language,
        _scriptureRef = scriptureRef,
        _scriptureTheme = scriptureTheme,
        _scriptureText = scriptureText,
        _encouragementText = encouragementText,
        _encouragementRef = encouragementRef,
        super(firestoreUtilData);

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  set date(String? val) => _date = val;

  bool hasDate() => _date != null;

  // "language" field.
  String? _language;
  String get language => _language ?? '';
  set language(String? val) => _language = val;

  bool hasLanguage() => _language != null;

  // "scriptureRef" field.
  String? _scriptureRef;
  String get scriptureRef => _scriptureRef ?? '';
  set scriptureRef(String? val) => _scriptureRef = val;

  bool hasScriptureRef() => _scriptureRef != null;

  // "scriptureTheme" field.
  String? _scriptureTheme;
  String get scriptureTheme => _scriptureTheme ?? '';
  set scriptureTheme(String? val) => _scriptureTheme = val;

  bool hasScriptureTheme() => _scriptureTheme != null;

  // "scriptureText" field.
  String? _scriptureText;
  String get scriptureText => _scriptureText ?? '';
  set scriptureText(String? val) => _scriptureText = val;

  bool hasScriptureText() => _scriptureText != null;

  // "encouragementText" field.
  String? _encouragementText;
  String get encouragementText => _encouragementText ?? '';
  set encouragementText(String? val) => _encouragementText = val;

  bool hasEncouragementText() => _encouragementText != null;

  // "encouragementRef" field.
  String? _encouragementRef;
  String get encouragementRef => _encouragementRef ?? '';
  set encouragementRef(String? val) => _encouragementRef = val;

  bool hasEncouragementRef() => _encouragementRef != null;

  static TodayContentResponseStruct fromMap(Map<String, dynamic> data) =>
      TodayContentResponseStruct(
        date: data['date'] as String?,
        language: data['language'] as String?,
        scriptureRef: data['scriptureRef'] as String?,
        scriptureTheme: data['scriptureTheme'] as String?,
        scriptureText: data['scriptureText'] as String?,
        encouragementText: data['encouragementText'] as String?,
        encouragementRef: data['encouragementRef'] as String?,
      );

  static TodayContentResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? TodayContentResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'date': _date,
        'language': _language,
        'scriptureRef': _scriptureRef,
        'scriptureTheme': _scriptureTheme,
        'scriptureText': _scriptureText,
        'encouragementText': _encouragementText,
        'encouragementRef': _encouragementRef,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'date': serializeParam(
          _date,
          ParamType.String,
        ),
        'language': serializeParam(
          _language,
          ParamType.String,
        ),
        'scriptureRef': serializeParam(
          _scriptureRef,
          ParamType.String,
        ),
        'scriptureTheme': serializeParam(
          _scriptureTheme,
          ParamType.String,
        ),
        'scriptureText': serializeParam(
          _scriptureText,
          ParamType.String,
        ),
        'encouragementText': serializeParam(
          _encouragementText,
          ParamType.String,
        ),
        'encouragementRef': serializeParam(
          _encouragementRef,
          ParamType.String,
        ),
      }.withoutNulls;

  static TodayContentResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      TodayContentResponseStruct(
        date: deserializeParam(
          data['date'],
          ParamType.String,
          false,
        ),
        language: deserializeParam(
          data['language'],
          ParamType.String,
          false,
        ),
        scriptureRef: deserializeParam(
          data['scriptureRef'],
          ParamType.String,
          false,
        ),
        scriptureTheme: deserializeParam(
          data['scriptureTheme'],
          ParamType.String,
          false,
        ),
        scriptureText: deserializeParam(
          data['scriptureText'],
          ParamType.String,
          false,
        ),
        encouragementText: deserializeParam(
          data['encouragementText'],
          ParamType.String,
          false,
        ),
        encouragementRef: deserializeParam(
          data['encouragementRef'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TodayContentResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TodayContentResponseStruct &&
        date == other.date &&
        language == other.language &&
        scriptureRef == other.scriptureRef &&
        scriptureTheme == other.scriptureTheme &&
        scriptureText == other.scriptureText &&
        encouragementText == other.encouragementText &&
        encouragementRef == other.encouragementRef;
  }

  @override
  int get hashCode => const ListEquality().hash([
        date,
        language,
        scriptureRef,
        scriptureTheme,
        scriptureText,
        encouragementText,
        encouragementRef
      ]);
}

TodayContentResponseStruct createTodayContentResponseStruct({
  String? date,
  String? language,
  String? scriptureRef,
  String? scriptureTheme,
  String? scriptureText,
  String? encouragementText,
  String? encouragementRef,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TodayContentResponseStruct(
      date: date,
      language: language,
      scriptureRef: scriptureRef,
      scriptureTheme: scriptureTheme,
      scriptureText: scriptureText,
      encouragementText: encouragementText,
      encouragementRef: encouragementRef,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TodayContentResponseStruct? updateTodayContentResponseStruct(
  TodayContentResponseStruct? todayContentResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    todayContentResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTodayContentResponseStructData(
  Map<String, dynamic> firestoreData,
  TodayContentResponseStruct? todayContentResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (todayContentResponse == null) {
    return;
  }
  if (todayContentResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && todayContentResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final todayContentResponseData =
      getTodayContentResponseFirestoreData(todayContentResponse, forFieldValue);
  final nestedData =
      todayContentResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      todayContentResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTodayContentResponseFirestoreData(
  TodayContentResponseStruct? todayContentResponse, [
  bool forFieldValue = false,
]) {
  if (todayContentResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(todayContentResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(todayContentResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTodayContentResponseListFirestoreData(
  List<TodayContentResponseStruct>? todayContentResponses,
) =>
    todayContentResponses
        ?.map((e) => getTodayContentResponseFirestoreData(e, true))
        .toList() ??
    [];
