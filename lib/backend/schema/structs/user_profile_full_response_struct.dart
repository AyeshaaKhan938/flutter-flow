// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct UserProfileFullResponse
class UserProfileFullResponseStruct extends FFFirebaseStruct {
  UserProfileFullResponseStruct({
    /// UserProfileFullResponse.onboardingCompleted
    bool? onboardingCompleted,

    /// UserProfileFullResponse.preferredLanguage
    String? preferredLanguage,

    /// UserProfileFullResponse.recommendedPathwayId
    String? recommendedPathwayId,

    /// UserProfileFullResponse.recommendationReason
    String? recommendationReason,

    /// UserProfileFullResponse.additionalPathwayIds
    String? additionalPathwayIds,

    /// UserProfileFullResponse.companionPathwayId
    String? companionPathwayId,

    /// UserProfileFullResponse.latestAssessmentScore
    int? latestAssessmentScore,

    /// UserProfileFullResponse.role
    String? role,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _onboardingCompleted = onboardingCompleted,
        _preferredLanguage = preferredLanguage,
        _recommendedPathwayId = recommendedPathwayId,
        _recommendationReason = recommendationReason,
        _additionalPathwayIds = additionalPathwayIds,
        _companionPathwayId = companionPathwayId,
        _latestAssessmentScore = latestAssessmentScore,
        _role = role,
        super(firestoreUtilData);

  // "onboardingCompleted" field.
  bool? _onboardingCompleted;
  bool get onboardingCompleted => _onboardingCompleted ?? false;
  set onboardingCompleted(bool? val) => _onboardingCompleted = val;

  bool hasOnboardingCompleted() => _onboardingCompleted != null;

  // "preferredLanguage" field.
  String? _preferredLanguage;
  String get preferredLanguage => _preferredLanguage ?? '';
  set preferredLanguage(String? val) => _preferredLanguage = val;

  bool hasPreferredLanguage() => _preferredLanguage != null;

  // "recommendedPathwayId" field.
  String? _recommendedPathwayId;
  String get recommendedPathwayId => _recommendedPathwayId ?? '';
  set recommendedPathwayId(String? val) => _recommendedPathwayId = val;

  bool hasRecommendedPathwayId() => _recommendedPathwayId != null;

  // "recommendationReason" field.
  String? _recommendationReason;
  String get recommendationReason => _recommendationReason ?? '';
  set recommendationReason(String? val) => _recommendationReason = val;

  bool hasRecommendationReason() => _recommendationReason != null;

  // "additionalPathwayIds" field.
  String? _additionalPathwayIds;
  String get additionalPathwayIds => _additionalPathwayIds ?? '';
  set additionalPathwayIds(String? val) => _additionalPathwayIds = val;

  bool hasAdditionalPathwayIds() => _additionalPathwayIds != null;

  // "companionPathwayId" field.
  String? _companionPathwayId;
  String get companionPathwayId => _companionPathwayId ?? '';
  set companionPathwayId(String? val) => _companionPathwayId = val;

  bool hasCompanionPathwayId() => _companionPathwayId != null;

  // "latestAssessmentScore" field.
  int? _latestAssessmentScore;
  int get latestAssessmentScore => _latestAssessmentScore ?? 0;
  set latestAssessmentScore(int? val) => _latestAssessmentScore = val;

  void incrementLatestAssessmentScore(int amount) =>
      latestAssessmentScore = latestAssessmentScore + amount;

  bool hasLatestAssessmentScore() => _latestAssessmentScore != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  static UserProfileFullResponseStruct fromMap(Map<String, dynamic> data) =>
      UserProfileFullResponseStruct(
        onboardingCompleted: data['onboardingCompleted'] as bool?,
        preferredLanguage: data['preferredLanguage'] as String?,
        recommendedPathwayId: data['recommendedPathwayId'] as String?,
        recommendationReason: data['recommendationReason'] as String?,
        additionalPathwayIds: data['additionalPathwayIds'] as String?,
        companionPathwayId: data['companionPathwayId'] as String?,
        latestAssessmentScore: castToType<int>(data['latestAssessmentScore']),
        role: data['role'] as String?,
      );

  static UserProfileFullResponseStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? UserProfileFullResponseStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'onboardingCompleted': _onboardingCompleted,
        'preferredLanguage': _preferredLanguage,
        'recommendedPathwayId': _recommendedPathwayId,
        'recommendationReason': _recommendationReason,
        'additionalPathwayIds': _additionalPathwayIds,
        'companionPathwayId': _companionPathwayId,
        'latestAssessmentScore': _latestAssessmentScore,
        'role': _role,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'onboardingCompleted': serializeParam(
          _onboardingCompleted,
          ParamType.bool,
        ),
        'preferredLanguage': serializeParam(
          _preferredLanguage,
          ParamType.String,
        ),
        'recommendedPathwayId': serializeParam(
          _recommendedPathwayId,
          ParamType.String,
        ),
        'recommendationReason': serializeParam(
          _recommendationReason,
          ParamType.String,
        ),
        'additionalPathwayIds': serializeParam(
          _additionalPathwayIds,
          ParamType.String,
        ),
        'companionPathwayId': serializeParam(
          _companionPathwayId,
          ParamType.String,
        ),
        'latestAssessmentScore': serializeParam(
          _latestAssessmentScore,
          ParamType.int,
        ),
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
      }.withoutNulls;

  static UserProfileFullResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      UserProfileFullResponseStruct(
        onboardingCompleted: deserializeParam(
          data['onboardingCompleted'],
          ParamType.bool,
          false,
        ),
        preferredLanguage: deserializeParam(
          data['preferredLanguage'],
          ParamType.String,
          false,
        ),
        recommendedPathwayId: deserializeParam(
          data['recommendedPathwayId'],
          ParamType.String,
          false,
        ),
        recommendationReason: deserializeParam(
          data['recommendationReason'],
          ParamType.String,
          false,
        ),
        additionalPathwayIds: deserializeParam(
          data['additionalPathwayIds'],
          ParamType.String,
          false,
        ),
        companionPathwayId: deserializeParam(
          data['companionPathwayId'],
          ParamType.String,
          false,
        ),
        latestAssessmentScore: deserializeParam(
          data['latestAssessmentScore'],
          ParamType.int,
          false,
        ),
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UserProfileFullResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserProfileFullResponseStruct &&
        onboardingCompleted == other.onboardingCompleted &&
        preferredLanguage == other.preferredLanguage &&
        recommendedPathwayId == other.recommendedPathwayId &&
        recommendationReason == other.recommendationReason &&
        additionalPathwayIds == other.additionalPathwayIds &&
        companionPathwayId == other.companionPathwayId &&
        latestAssessmentScore == other.latestAssessmentScore &&
        role == other.role;
  }

  @override
  int get hashCode => const ListEquality().hash([
        onboardingCompleted,
        preferredLanguage,
        recommendedPathwayId,
        recommendationReason,
        additionalPathwayIds,
        companionPathwayId,
        latestAssessmentScore,
        role
      ]);
}

UserProfileFullResponseStruct createUserProfileFullResponseStruct({
  bool? onboardingCompleted,
  String? preferredLanguage,
  String? recommendedPathwayId,
  String? recommendationReason,
  String? additionalPathwayIds,
  String? companionPathwayId,
  int? latestAssessmentScore,
  String? role,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    UserProfileFullResponseStruct(
      onboardingCompleted: onboardingCompleted,
      preferredLanguage: preferredLanguage,
      recommendedPathwayId: recommendedPathwayId,
      recommendationReason: recommendationReason,
      additionalPathwayIds: additionalPathwayIds,
      companionPathwayId: companionPathwayId,
      latestAssessmentScore: latestAssessmentScore,
      role: role,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

UserProfileFullResponseStruct? updateUserProfileFullResponseStruct(
  UserProfileFullResponseStruct? userProfileFullResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    userProfileFullResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addUserProfileFullResponseStructData(
  Map<String, dynamic> firestoreData,
  UserProfileFullResponseStruct? userProfileFullResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (userProfileFullResponse == null) {
    return;
  }
  if (userProfileFullResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      userProfileFullResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final userProfileFullResponseData = getUserProfileFullResponseFirestoreData(
      userProfileFullResponse, forFieldValue);
  final nestedData =
      userProfileFullResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      userProfileFullResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getUserProfileFullResponseFirestoreData(
  UserProfileFullResponseStruct? userProfileFullResponse, [
  bool forFieldValue = false,
]) {
  if (userProfileFullResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(userProfileFullResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(userProfileFullResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getUserProfileFullResponseListFirestoreData(
  List<UserProfileFullResponseStruct>? userProfileFullResponses,
) =>
    userProfileFullResponses
        ?.map((e) => getUserProfileFullResponseFirestoreData(e, true))
        .toList() ??
    [];
