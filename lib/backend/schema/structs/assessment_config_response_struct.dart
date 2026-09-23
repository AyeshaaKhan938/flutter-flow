// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct AssessmentConfigResponse
class AssessmentConfigResponseStruct extends FFFirebaseStruct {
  AssessmentConfigResponseStruct({
    /// AssessmentConfigResponse.assessmentVersion
    String? assessmentVersion,

    /// AssessmentConfigResponse.active
    bool? active,

    /// AssessmentConfigResponse.scoreBandsJson
    String? scoreBandsJson,

    /// AssessmentConfigResponse.overridesJson
    String? overridesJson,

    /// AssessmentConfigResponse.explanationsJson
    String? explanationsJson,

    /// AssessmentConfigResponse.pointMapJson
    String? pointMapJson,

    /// AssessmentConfigResponse.note
    String? note,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _assessmentVersion = assessmentVersion,
        _active = active,
        _scoreBandsJson = scoreBandsJson,
        _overridesJson = overridesJson,
        _explanationsJson = explanationsJson,
        _pointMapJson = pointMapJson,
        _note = note,
        super(firestoreUtilData);

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

  // "scoreBandsJson" field.
  String? _scoreBandsJson;
  String get scoreBandsJson => _scoreBandsJson ?? '';
  set scoreBandsJson(String? val) => _scoreBandsJson = val;

  bool hasScoreBandsJson() => _scoreBandsJson != null;

  // "overridesJson" field.
  String? _overridesJson;
  String get overridesJson => _overridesJson ?? '';
  set overridesJson(String? val) => _overridesJson = val;

  bool hasOverridesJson() => _overridesJson != null;

  // "explanationsJson" field.
  String? _explanationsJson;
  String get explanationsJson => _explanationsJson ?? '';
  set explanationsJson(String? val) => _explanationsJson = val;

  bool hasExplanationsJson() => _explanationsJson != null;

  // "pointMapJson" field.
  String? _pointMapJson;
  String get pointMapJson => _pointMapJson ?? '';
  set pointMapJson(String? val) => _pointMapJson = val;

  bool hasPointMapJson() => _pointMapJson != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  set note(String? val) => _note = val;

  bool hasNote() => _note != null;

  static AssessmentConfigResponseStruct fromMap(Map<String, dynamic> data) =>
      AssessmentConfigResponseStruct(
        assessmentVersion: data['assessmentVersion'] as String?,
        active: data['active'] as bool?,
        scoreBandsJson: data['scoreBandsJson'] as String?,
        overridesJson: data['overridesJson'] as String?,
        explanationsJson: data['explanationsJson'] as String?,
        pointMapJson: data['pointMapJson'] as String?,
        note: data['note'] as String?,
      );

  static AssessmentConfigResponseStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? AssessmentConfigResponseStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'assessmentVersion': _assessmentVersion,
        'active': _active,
        'scoreBandsJson': _scoreBandsJson,
        'overridesJson': _overridesJson,
        'explanationsJson': _explanationsJson,
        'pointMapJson': _pointMapJson,
        'note': _note,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'assessmentVersion': serializeParam(
          _assessmentVersion,
          ParamType.String,
        ),
        'active': serializeParam(
          _active,
          ParamType.bool,
        ),
        'scoreBandsJson': serializeParam(
          _scoreBandsJson,
          ParamType.String,
        ),
        'overridesJson': serializeParam(
          _overridesJson,
          ParamType.String,
        ),
        'explanationsJson': serializeParam(
          _explanationsJson,
          ParamType.String,
        ),
        'pointMapJson': serializeParam(
          _pointMapJson,
          ParamType.String,
        ),
        'note': serializeParam(
          _note,
          ParamType.String,
        ),
      }.withoutNulls;

  static AssessmentConfigResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AssessmentConfigResponseStruct(
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
        scoreBandsJson: deserializeParam(
          data['scoreBandsJson'],
          ParamType.String,
          false,
        ),
        overridesJson: deserializeParam(
          data['overridesJson'],
          ParamType.String,
          false,
        ),
        explanationsJson: deserializeParam(
          data['explanationsJson'],
          ParamType.String,
          false,
        ),
        pointMapJson: deserializeParam(
          data['pointMapJson'],
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
  String toString() => 'AssessmentConfigResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AssessmentConfigResponseStruct &&
        assessmentVersion == other.assessmentVersion &&
        active == other.active &&
        scoreBandsJson == other.scoreBandsJson &&
        overridesJson == other.overridesJson &&
        explanationsJson == other.explanationsJson &&
        pointMapJson == other.pointMapJson &&
        note == other.note;
  }

  @override
  int get hashCode => const ListEquality().hash([
        assessmentVersion,
        active,
        scoreBandsJson,
        overridesJson,
        explanationsJson,
        pointMapJson,
        note
      ]);
}

AssessmentConfigResponseStruct createAssessmentConfigResponseStruct({
  String? assessmentVersion,
  bool? active,
  String? scoreBandsJson,
  String? overridesJson,
  String? explanationsJson,
  String? pointMapJson,
  String? note,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AssessmentConfigResponseStruct(
      assessmentVersion: assessmentVersion,
      active: active,
      scoreBandsJson: scoreBandsJson,
      overridesJson: overridesJson,
      explanationsJson: explanationsJson,
      pointMapJson: pointMapJson,
      note: note,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AssessmentConfigResponseStruct? updateAssessmentConfigResponseStruct(
  AssessmentConfigResponseStruct? assessmentConfigResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    assessmentConfigResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAssessmentConfigResponseStructData(
  Map<String, dynamic> firestoreData,
  AssessmentConfigResponseStruct? assessmentConfigResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (assessmentConfigResponse == null) {
    return;
  }
  if (assessmentConfigResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      assessmentConfigResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final assessmentConfigResponseData = getAssessmentConfigResponseFirestoreData(
      assessmentConfigResponse, forFieldValue);
  final nestedData =
      assessmentConfigResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      assessmentConfigResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAssessmentConfigResponseFirestoreData(
  AssessmentConfigResponseStruct? assessmentConfigResponse, [
  bool forFieldValue = false,
]) {
  if (assessmentConfigResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(assessmentConfigResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(assessmentConfigResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAssessmentConfigResponseListFirestoreData(
  List<AssessmentConfigResponseStruct>? assessmentConfigResponses,
) =>
    assessmentConfigResponses
        ?.map((e) => getAssessmentConfigResponseFirestoreData(e, true))
        .toList() ??
    [];
