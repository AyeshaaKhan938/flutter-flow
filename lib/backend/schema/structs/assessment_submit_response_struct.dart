// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct AssessmentSubmitResponse
class AssessmentSubmitResponseStruct extends FFFirebaseStruct {
  AssessmentSubmitResponseStruct({
    /// AssessmentSubmitResponse.success
    bool? success,

    /// AssessmentSubmitResponse.assessmentId
    String? assessmentId,

    /// AssessmentSubmitResponse.assessmentVersion
    String? assessmentVersion,

    /// AssessmentSubmitResponse.totalScore
    int? totalScore,

    /// AssessmentSubmitResponse.primaryPathwayId
    String? primaryPathwayId,

    /// AssessmentSubmitResponse.additionalPathwayIds
    String? additionalPathwayIds,

    /// AssessmentSubmitResponse.reasonCodes
    String? reasonCodes,

    /// AssessmentSubmitResponse.explanationTextKey
    String? explanationTextKey,

    /// AssessmentSubmitResponse.explanationText
    String? explanationText,

    /// AssessmentSubmitResponse.companionExplanationText
    String? companionExplanationText,

    /// AssessmentSubmitResponse.companionPathwayId
    String? companionPathwayId,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _success = success,
        _assessmentId = assessmentId,
        _assessmentVersion = assessmentVersion,
        _totalScore = totalScore,
        _primaryPathwayId = primaryPathwayId,
        _additionalPathwayIds = additionalPathwayIds,
        _reasonCodes = reasonCodes,
        _explanationTextKey = explanationTextKey,
        _explanationText = explanationText,
        _companionExplanationText = companionExplanationText,
        _companionPathwayId = companionPathwayId,
        super(firestoreUtilData);

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "assessmentId" field.
  String? _assessmentId;
  String get assessmentId => _assessmentId ?? '';
  set assessmentId(String? val) => _assessmentId = val;

  bool hasAssessmentId() => _assessmentId != null;

  // "assessmentVersion" field.
  String? _assessmentVersion;
  String get assessmentVersion => _assessmentVersion ?? '';
  set assessmentVersion(String? val) => _assessmentVersion = val;

  bool hasAssessmentVersion() => _assessmentVersion != null;

  // "totalScore" field.
  int? _totalScore;
  int get totalScore => _totalScore ?? 0;
  set totalScore(int? val) => _totalScore = val;

  void incrementTotalScore(int amount) => totalScore = totalScore + amount;

  bool hasTotalScore() => _totalScore != null;

  // "primaryPathwayId" field.
  String? _primaryPathwayId;
  String get primaryPathwayId => _primaryPathwayId ?? '';
  set primaryPathwayId(String? val) => _primaryPathwayId = val;

  bool hasPrimaryPathwayId() => _primaryPathwayId != null;

  // "additionalPathwayIds" field.
  String? _additionalPathwayIds;
  String get additionalPathwayIds => _additionalPathwayIds ?? '';
  set additionalPathwayIds(String? val) => _additionalPathwayIds = val;

  bool hasAdditionalPathwayIds() => _additionalPathwayIds != null;

  // "reasonCodes" field.
  String? _reasonCodes;
  String get reasonCodes => _reasonCodes ?? '';
  set reasonCodes(String? val) => _reasonCodes = val;

  bool hasReasonCodes() => _reasonCodes != null;

  // "explanationTextKey" field.
  String? _explanationTextKey;
  String get explanationTextKey => _explanationTextKey ?? '';
  set explanationTextKey(String? val) => _explanationTextKey = val;

  bool hasExplanationTextKey() => _explanationTextKey != null;

  // "explanationText" field.
  String? _explanationText;
  String get explanationText => _explanationText ?? '';
  set explanationText(String? val) => _explanationText = val;

  bool hasExplanationText() => _explanationText != null;

  // "companionExplanationText" field.
  String? _companionExplanationText;
  String get companionExplanationText => _companionExplanationText ?? '';
  set companionExplanationText(String? val) => _companionExplanationText = val;

  bool hasCompanionExplanationText() => _companionExplanationText != null;

  // "companionPathwayId" field.
  String? _companionPathwayId;
  String get companionPathwayId => _companionPathwayId ?? '';
  set companionPathwayId(String? val) => _companionPathwayId = val;

  bool hasCompanionPathwayId() => _companionPathwayId != null;

  static AssessmentSubmitResponseStruct fromMap(Map<String, dynamic> data) =>
      AssessmentSubmitResponseStruct(
        success: data['success'] as bool?,
        assessmentId: data['assessmentId'] as String?,
        assessmentVersion: data['assessmentVersion'] as String?,
        totalScore: castToType<int>(data['totalScore']),
        primaryPathwayId: data['primaryPathwayId'] as String?,
        additionalPathwayIds: data['additionalPathwayIds'] as String?,
        reasonCodes: data['reasonCodes'] as String?,
        explanationTextKey: data['explanationTextKey'] as String?,
        explanationText: data['explanationText'] as String?,
        companionExplanationText: data['companionExplanationText'] as String?,
        companionPathwayId: data['companionPathwayId'] as String?,
      );

  static AssessmentSubmitResponseStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? AssessmentSubmitResponseStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'success': _success,
        'assessmentId': _assessmentId,
        'assessmentVersion': _assessmentVersion,
        'totalScore': _totalScore,
        'primaryPathwayId': _primaryPathwayId,
        'additionalPathwayIds': _additionalPathwayIds,
        'reasonCodes': _reasonCodes,
        'explanationTextKey': _explanationTextKey,
        'explanationText': _explanationText,
        'companionExplanationText': _companionExplanationText,
        'companionPathwayId': _companionPathwayId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'assessmentId': serializeParam(
          _assessmentId,
          ParamType.String,
        ),
        'assessmentVersion': serializeParam(
          _assessmentVersion,
          ParamType.String,
        ),
        'totalScore': serializeParam(
          _totalScore,
          ParamType.int,
        ),
        'primaryPathwayId': serializeParam(
          _primaryPathwayId,
          ParamType.String,
        ),
        'additionalPathwayIds': serializeParam(
          _additionalPathwayIds,
          ParamType.String,
        ),
        'reasonCodes': serializeParam(
          _reasonCodes,
          ParamType.String,
        ),
        'explanationTextKey': serializeParam(
          _explanationTextKey,
          ParamType.String,
        ),
        'explanationText': serializeParam(
          _explanationText,
          ParamType.String,
        ),
        'companionExplanationText': serializeParam(
          _companionExplanationText,
          ParamType.String,
        ),
        'companionPathwayId': serializeParam(
          _companionPathwayId,
          ParamType.String,
        ),
      }.withoutNulls;

  static AssessmentSubmitResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AssessmentSubmitResponseStruct(
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        assessmentId: deserializeParam(
          data['assessmentId'],
          ParamType.String,
          false,
        ),
        assessmentVersion: deserializeParam(
          data['assessmentVersion'],
          ParamType.String,
          false,
        ),
        totalScore: deserializeParam(
          data['totalScore'],
          ParamType.int,
          false,
        ),
        primaryPathwayId: deserializeParam(
          data['primaryPathwayId'],
          ParamType.String,
          false,
        ),
        additionalPathwayIds: deserializeParam(
          data['additionalPathwayIds'],
          ParamType.String,
          false,
        ),
        reasonCodes: deserializeParam(
          data['reasonCodes'],
          ParamType.String,
          false,
        ),
        explanationTextKey: deserializeParam(
          data['explanationTextKey'],
          ParamType.String,
          false,
        ),
        explanationText: deserializeParam(
          data['explanationText'],
          ParamType.String,
          false,
        ),
        companionExplanationText: deserializeParam(
          data['companionExplanationText'],
          ParamType.String,
          false,
        ),
        companionPathwayId: deserializeParam(
          data['companionPathwayId'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AssessmentSubmitResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AssessmentSubmitResponseStruct &&
        success == other.success &&
        assessmentId == other.assessmentId &&
        assessmentVersion == other.assessmentVersion &&
        totalScore == other.totalScore &&
        primaryPathwayId == other.primaryPathwayId &&
        additionalPathwayIds == other.additionalPathwayIds &&
        reasonCodes == other.reasonCodes &&
        explanationTextKey == other.explanationTextKey &&
        explanationText == other.explanationText &&
        companionExplanationText == other.companionExplanationText &&
        companionPathwayId == other.companionPathwayId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        success,
        assessmentId,
        assessmentVersion,
        totalScore,
        primaryPathwayId,
        additionalPathwayIds,
        reasonCodes,
        explanationTextKey,
        explanationText,
        companionExplanationText,
        companionPathwayId
      ]);
}

AssessmentSubmitResponseStruct createAssessmentSubmitResponseStruct({
  bool? success,
  String? assessmentId,
  String? assessmentVersion,
  int? totalScore,
  String? primaryPathwayId,
  String? additionalPathwayIds,
  String? reasonCodes,
  String? explanationTextKey,
  String? explanationText,
  String? companionExplanationText,
  String? companionPathwayId,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AssessmentSubmitResponseStruct(
      success: success,
      assessmentId: assessmentId,
      assessmentVersion: assessmentVersion,
      totalScore: totalScore,
      primaryPathwayId: primaryPathwayId,
      additionalPathwayIds: additionalPathwayIds,
      reasonCodes: reasonCodes,
      explanationTextKey: explanationTextKey,
      explanationText: explanationText,
      companionExplanationText: companionExplanationText,
      companionPathwayId: companionPathwayId,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AssessmentSubmitResponseStruct? updateAssessmentSubmitResponseStruct(
  AssessmentSubmitResponseStruct? assessmentSubmitResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    assessmentSubmitResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAssessmentSubmitResponseStructData(
  Map<String, dynamic> firestoreData,
  AssessmentSubmitResponseStruct? assessmentSubmitResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (assessmentSubmitResponse == null) {
    return;
  }
  if (assessmentSubmitResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      assessmentSubmitResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final assessmentSubmitResponseData = getAssessmentSubmitResponseFirestoreData(
      assessmentSubmitResponse, forFieldValue);
  final nestedData =
      assessmentSubmitResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      assessmentSubmitResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAssessmentSubmitResponseFirestoreData(
  AssessmentSubmitResponseStruct? assessmentSubmitResponse, [
  bool forFieldValue = false,
]) {
  if (assessmentSubmitResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(assessmentSubmitResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(assessmentSubmitResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAssessmentSubmitResponseListFirestoreData(
  List<AssessmentSubmitResponseStruct>? assessmentSubmitResponses,
) =>
    assessmentSubmitResponses
        ?.map((e) => getAssessmentSubmitResponseFirestoreData(e, true))
        .toList() ??
    [];
