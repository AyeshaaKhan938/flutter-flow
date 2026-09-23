// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// Response shape for importCurriculum
class ImportSummaryResponseStruct extends FFFirebaseStruct {
  ImportSummaryResponseStruct({
    /// Rows that will create/created a new document
    int? created,

    /// Rows that will update/updated an existing document
    int? updated,

    /// Rows matching an existing document with no changes
    int? unchanged,

    /// Number of validation errors
    int? errorCount,

    /// First validation error, if any
    String? firstErrorMessage,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _created = created,
        _updated = updated,
        _unchanged = unchanged,
        _errorCount = errorCount,
        _firstErrorMessage = firstErrorMessage,
        super(firestoreUtilData);

  // "created" field.
  int? _created;
  int get created => _created ?? 0;
  set created(int? val) => _created = val;

  void incrementCreated(int amount) => created = created + amount;

  bool hasCreated() => _created != null;

  // "updated" field.
  int? _updated;
  int get updated => _updated ?? 0;
  set updated(int? val) => _updated = val;

  void incrementUpdated(int amount) => updated = updated + amount;

  bool hasUpdated() => _updated != null;

  // "unchanged" field.
  int? _unchanged;
  int get unchanged => _unchanged ?? 0;
  set unchanged(int? val) => _unchanged = val;

  void incrementUnchanged(int amount) => unchanged = unchanged + amount;

  bool hasUnchanged() => _unchanged != null;

  // "errorCount" field.
  int? _errorCount;
  int get errorCount => _errorCount ?? 0;
  set errorCount(int? val) => _errorCount = val;

  void incrementErrorCount(int amount) => errorCount = errorCount + amount;

  bool hasErrorCount() => _errorCount != null;

  // "firstErrorMessage" field.
  String? _firstErrorMessage;
  String get firstErrorMessage => _firstErrorMessage ?? '';
  set firstErrorMessage(String? val) => _firstErrorMessage = val;

  bool hasFirstErrorMessage() => _firstErrorMessage != null;

  static ImportSummaryResponseStruct fromMap(Map<String, dynamic> data) =>
      ImportSummaryResponseStruct(
        created: castToType<int>(data['created']),
        updated: castToType<int>(data['updated']),
        unchanged: castToType<int>(data['unchanged']),
        errorCount: castToType<int>(data['errorCount']),
        firstErrorMessage: data['firstErrorMessage'] as String?,
      );

  static ImportSummaryResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? ImportSummaryResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'created': _created,
        'updated': _updated,
        'unchanged': _unchanged,
        'errorCount': _errorCount,
        'firstErrorMessage': _firstErrorMessage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'created': serializeParam(
          _created,
          ParamType.int,
        ),
        'updated': serializeParam(
          _updated,
          ParamType.int,
        ),
        'unchanged': serializeParam(
          _unchanged,
          ParamType.int,
        ),
        'errorCount': serializeParam(
          _errorCount,
          ParamType.int,
        ),
        'firstErrorMessage': serializeParam(
          _firstErrorMessage,
          ParamType.String,
        ),
      }.withoutNulls;

  static ImportSummaryResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ImportSummaryResponseStruct(
        created: deserializeParam(
          data['created'],
          ParamType.int,
          false,
        ),
        updated: deserializeParam(
          data['updated'],
          ParamType.int,
          false,
        ),
        unchanged: deserializeParam(
          data['unchanged'],
          ParamType.int,
          false,
        ),
        errorCount: deserializeParam(
          data['errorCount'],
          ParamType.int,
          false,
        ),
        firstErrorMessage: deserializeParam(
          data['firstErrorMessage'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ImportSummaryResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ImportSummaryResponseStruct &&
        created == other.created &&
        updated == other.updated &&
        unchanged == other.unchanged &&
        errorCount == other.errorCount &&
        firstErrorMessage == other.firstErrorMessage;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([created, updated, unchanged, errorCount, firstErrorMessage]);
}

ImportSummaryResponseStruct createImportSummaryResponseStruct({
  int? created,
  int? updated,
  int? unchanged,
  int? errorCount,
  String? firstErrorMessage,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ImportSummaryResponseStruct(
      created: created,
      updated: updated,
      unchanged: unchanged,
      errorCount: errorCount,
      firstErrorMessage: firstErrorMessage,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ImportSummaryResponseStruct? updateImportSummaryResponseStruct(
  ImportSummaryResponseStruct? importSummaryResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    importSummaryResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addImportSummaryResponseStructData(
  Map<String, dynamic> firestoreData,
  ImportSummaryResponseStruct? importSummaryResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (importSummaryResponse == null) {
    return;
  }
  if (importSummaryResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      importSummaryResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final importSummaryResponseData = getImportSummaryResponseFirestoreData(
      importSummaryResponse, forFieldValue);
  final nestedData =
      importSummaryResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      importSummaryResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getImportSummaryResponseFirestoreData(
  ImportSummaryResponseStruct? importSummaryResponse, [
  bool forFieldValue = false,
]) {
  if (importSummaryResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(importSummaryResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(importSummaryResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getImportSummaryResponseListFirestoreData(
  List<ImportSummaryResponseStruct>? importSummaryResponses,
) =>
    importSummaryResponses
        ?.map((e) => getImportSummaryResponseFirestoreData(e, true))
        .toList() ??
    [];
