// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// Response shape for getUserProfile
class UserProfileResponseStruct extends FFFirebaseStruct {
  UserProfileResponseStruct({
    /// Has this member finished onboarding+assessment+recommendation
    bool? onboardingCompleted,

    /// Chosen display language
    String? preferredLanguage,

    /// Recommended pathway stable ID
    String? recommendedPathwayId,

    /// The member's role (member/ministry_reviewer/admin)
    String? role,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _onboardingCompleted = onboardingCompleted,
        _preferredLanguage = preferredLanguage,
        _recommendedPathwayId = recommendedPathwayId,
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

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  static UserProfileResponseStruct fromMap(Map<String, dynamic> data) =>
      UserProfileResponseStruct(
        onboardingCompleted: data['onboardingCompleted'] as bool?,
        preferredLanguage: data['preferredLanguage'] as String?,
        recommendedPathwayId: data['recommendedPathwayId'] as String?,
        role: data['role'] as String?,
      );

  static UserProfileResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? UserProfileResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'onboardingCompleted': _onboardingCompleted,
        'preferredLanguage': _preferredLanguage,
        'recommendedPathwayId': _recommendedPathwayId,
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
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
      }.withoutNulls;

  static UserProfileResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      UserProfileResponseStruct(
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
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UserProfileResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserProfileResponseStruct &&
        onboardingCompleted == other.onboardingCompleted &&
        preferredLanguage == other.preferredLanguage &&
        recommendedPathwayId == other.recommendedPathwayId &&
        role == other.role;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [onboardingCompleted, preferredLanguage, recommendedPathwayId, role]);
}

UserProfileResponseStruct createUserProfileResponseStruct({
  bool? onboardingCompleted,
  String? preferredLanguage,
  String? recommendedPathwayId,
  String? role,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    UserProfileResponseStruct(
      onboardingCompleted: onboardingCompleted,
      preferredLanguage: preferredLanguage,
      recommendedPathwayId: recommendedPathwayId,
      role: role,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

UserProfileResponseStruct? updateUserProfileResponseStruct(
  UserProfileResponseStruct? userProfileResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    userProfileResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addUserProfileResponseStructData(
  Map<String, dynamic> firestoreData,
  UserProfileResponseStruct? userProfileResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (userProfileResponse == null) {
    return;
  }
  if (userProfileResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && userProfileResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final userProfileResponseData =
      getUserProfileResponseFirestoreData(userProfileResponse, forFieldValue);
  final nestedData =
      userProfileResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      userProfileResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getUserProfileResponseFirestoreData(
  UserProfileResponseStruct? userProfileResponse, [
  bool forFieldValue = false,
]) {
  if (userProfileResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(userProfileResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(userProfileResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getUserProfileResponseListFirestoreData(
  List<UserProfileResponseStruct>? userProfileResponses,
) =>
    userProfileResponses
        ?.map((e) => getUserProfileResponseFirestoreData(e, true))
        .toList() ??
    [];
