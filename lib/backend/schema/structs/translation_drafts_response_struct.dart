// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct TranslationDraftsResponse
class TranslationDraftsResponseStruct extends FFFirebaseStruct {
  TranslationDraftsResponseStruct({
    /// TranslationDraftsResponse.success
    bool? success,

    /// TranslationDraftsResponse.target
    String? target,

    /// TranslationDraftsResponse.updated
    int? updated,

    /// TranslationDraftsResponse.skipped
    int? skipped,

    /// TranslationDraftsResponse.note
    String? note,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _success = success,
        _target = target,
        _updated = updated,
        _skipped = skipped,
        _note = note,
        super(firestoreUtilData);

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "target" field.
  String? _target;
  String get target => _target ?? '';
  set target(String? val) => _target = val;

  bool hasTarget() => _target != null;

  // "updated" field.
  int? _updated;
  int get updated => _updated ?? 0;
  set updated(int? val) => _updated = val;

  void incrementUpdated(int amount) => updated = updated + amount;

  bool hasUpdated() => _updated != null;

  // "skipped" field.
  int? _skipped;
  int get skipped => _skipped ?? 0;
  set skipped(int? val) => _skipped = val;

  void incrementSkipped(int amount) => skipped = skipped + amount;

  bool hasSkipped() => _skipped != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  set note(String? val) => _note = val;

  bool hasNote() => _note != null;

  static TranslationDraftsResponseStruct fromMap(Map<String, dynamic> data) =>
      TranslationDraftsResponseStruct(
        success: data['success'] as bool?,
        target: data['target'] as String?,
        updated: castToType<int>(data['updated']),
        skipped: castToType<int>(data['skipped']),
        note: data['note'] as String?,
      );

  static TranslationDraftsResponseStruct? maybeFromMap(dynamic data) => data
          is Map
      ? TranslationDraftsResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'success': _success,
        'target': _target,
        'updated': _updated,
        'skipped': _skipped,
        'note': _note,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'target': serializeParam(
          _target,
          ParamType.String,
        ),
        'updated': serializeParam(
          _updated,
          ParamType.int,
        ),
        'skipped': serializeParam(
          _skipped,
          ParamType.int,
        ),
        'note': serializeParam(
          _note,
          ParamType.String,
        ),
      }.withoutNulls;

  static TranslationDraftsResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      TranslationDraftsResponseStruct(
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        target: deserializeParam(
          data['target'],
          ParamType.String,
          false,
        ),
        updated: deserializeParam(
          data['updated'],
          ParamType.int,
          false,
        ),
        skipped: deserializeParam(
          data['skipped'],
          ParamType.int,
          false,
        ),
        note: deserializeParam(
          data['note'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TranslationDraftsResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TranslationDraftsResponseStruct &&
        success == other.success &&
        target == other.target &&
        updated == other.updated &&
        skipped == other.skipped &&
        note == other.note;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([success, target, updated, skipped, note]);
}

TranslationDraftsResponseStruct createTranslationDraftsResponseStruct({
  bool? success,
  String? target,
  int? updated,
  int? skipped,
  String? note,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    TranslationDraftsResponseStruct(
      success: success,
      target: target,
      updated: updated,
      skipped: skipped,
      note: note,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

TranslationDraftsResponseStruct? updateTranslationDraftsResponseStruct(
  TranslationDraftsResponseStruct? translationDraftsResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    translationDraftsResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addTranslationDraftsResponseStructData(
  Map<String, dynamic> firestoreData,
  TranslationDraftsResponseStruct? translationDraftsResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (translationDraftsResponse == null) {
    return;
  }
  if (translationDraftsResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      translationDraftsResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final translationDraftsResponseData =
      getTranslationDraftsResponseFirestoreData(
          translationDraftsResponse, forFieldValue);
  final nestedData =
      translationDraftsResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      translationDraftsResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getTranslationDraftsResponseFirestoreData(
  TranslationDraftsResponseStruct? translationDraftsResponse, [
  bool forFieldValue = false,
]) {
  if (translationDraftsResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(translationDraftsResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(translationDraftsResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getTranslationDraftsResponseListFirestoreData(
  List<TranslationDraftsResponseStruct>? translationDraftsResponses,
) =>
    translationDraftsResponses
        ?.map((e) => getTranslationDraftsResponseFirestoreData(e, true))
        .toList() ??
    [];
