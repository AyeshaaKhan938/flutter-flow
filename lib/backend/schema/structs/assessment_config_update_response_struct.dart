// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct AssessmentConfigUpdateResponse
class AssessmentConfigUpdateResponseStruct extends FFFirebaseStruct {
  AssessmentConfigUpdateResponseStruct({
    /// AssessmentConfigUpdateResponse.success
    bool? success,

    /// AssessmentConfigUpdateResponse.docId
    String? docId,

    /// AssessmentConfigUpdateResponse.assessmentVersion
    String? assessmentVersion,

    /// AssessmentConfigUpdateResponse.active
    bool? active,

    /// AssessmentConfigUpdateResponse.note
    String? note,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _success = success,
        _docId = docId,
        _assessmentVersion = assessmentVersion,
        _active = active,
        _note = note,
        super(firestoreUtilData);

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "docId" field.
  String? _docId;
  String get docId => _docId ?? '';
  set docId(String? val) => _docId = val;

  bool hasDocId() => _docId != null;

  // "assessmentVersion" field.
  String? _assessmentVersion;
  String get assessmentVersion => _assessmentVersion ?? '';
  set assessmentVersion(String? val) => _assessmentVersion = val;

  bool hasAssessmentVersion() => _assessmentVersion != null;

  // "active" field.
  bool? _active;
  bool get active => _active ?? false;
  set active(bool? val) => _active = val;

  bool hasActive() => _active != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  set note(String? val) => _note = val;

  bool hasNote() => _note != null;

  static AssessmentConfigUpdateResponseStruct fromMap(
          Map<String, dynamic> data) =>
      AssessmentConfigUpdateResponseStruct(
        success: data['success'] as bool?,
        docId: data['docId'] as String?,
        assessmentVersion: data['assessmentVersion'] as String?,
        active: data['active'] as bool?,
        note: data['note'] as String?,
      );

  static AssessmentConfigUpdateResponseStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? AssessmentConfigUpdateResponseStruct.fromMap(
              data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'success': _success,
        'docId': _docId,
        'assessmentVersion': _assessmentVersion,
        'active': _active,
        'note': _note,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'docId': serializeParam(
          _docId,
          ParamType.String,
        ),
        'assessmentVersion': serializeParam(
          _assessmentVersion,
          ParamType.String,
        ),
        'active': serializeParam(
          _active,
          ParamType.bool,
        ),
        'note': serializeParam(
          _note,
          ParamType.String,
        ),
      }.withoutNulls;

  static AssessmentConfigUpdateResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AssessmentConfigUpdateResponseStruct(
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        docId: deserializeParam(
          data['docId'],
          ParamType.String,
          false,
        ),
        assessmentVersion: deserializeParam(
          data['assessmentVersion'],
          ParamType.String,
          false,
        ),
        active: deserializeParam(
          data['active'],
          ParamType.bool,
          false,
        ),
        note: deserializeParam(
          data['note'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AssessmentConfigUpdateResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AssessmentConfigUpdateResponseStruct &&
        success == other.success &&
        docId == other.docId &&
        assessmentVersion == other.assessmentVersion &&
        active == other.active &&
        note == other.note;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([success, docId, assessmentVersion, active, note]);
}

AssessmentConfigUpdateResponseStruct
    createAssessmentConfigUpdateResponseStruct({
  bool? success,
  String? docId,
  String? assessmentVersion,
  bool? active,
  String? note,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
        AssessmentConfigUpdateResponseStruct(
          success: success,
          docId: docId,
          assessmentVersion: assessmentVersion,
          active: active,
          note: note,
          firestoreUtilData: FirestoreUtilData(
            clearUnsetFields: clearUnsetFields,
            create: create,
            delete: delete,
            fieldValues: fieldValues,
          ),
        );

AssessmentConfigUpdateResponseStruct?
    updateAssessmentConfigUpdateResponseStruct(
  AssessmentConfigUpdateResponseStruct? assessmentConfigUpdateResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
        assessmentConfigUpdateResponse
          ?..firestoreUtilData = FirestoreUtilData(
            clearUnsetFields: clearUnsetFields,
            create: create,
          );

void addAssessmentConfigUpdateResponseStructData(
  Map<String, dynamic> firestoreData,
  AssessmentConfigUpdateResponseStruct? assessmentConfigUpdateResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (assessmentConfigUpdateResponse == null) {
    return;
  }
  if (assessmentConfigUpdateResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      assessmentConfigUpdateResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final assessmentConfigUpdateResponseData =
      getAssessmentConfigUpdateResponseFirestoreData(
          assessmentConfigUpdateResponse, forFieldValue);
  final nestedData = assessmentConfigUpdateResponseData
      .map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      assessmentConfigUpdateResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAssessmentConfigUpdateResponseFirestoreData(
  AssessmentConfigUpdateResponseStruct? assessmentConfigUpdateResponse, [
  bool forFieldValue = false,
]) {
  if (assessmentConfigUpdateResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(assessmentConfigUpdateResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(assessmentConfigUpdateResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAssessmentConfigUpdateResponseListFirestoreData(
  List<AssessmentConfigUpdateResponseStruct>? assessmentConfigUpdateResponses,
) =>
    assessmentConfigUpdateResponses
        ?.map((e) => getAssessmentConfigUpdateResponseFirestoreData(e, true))
        .toList() ??
    [];
