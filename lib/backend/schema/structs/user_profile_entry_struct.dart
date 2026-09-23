// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct UserProfileEntry
class UserProfileEntryStruct extends FFFirebaseStruct {
  UserProfileEntryStruct({
    /// UserProfileEntry.id
    String? id,

    /// UserProfileEntry.fullName
    String? fullName,

    /// UserProfileEntry.role
    String? role,

    /// UserProfileEntry.preferredLanguage
    String? preferredLanguage,

    /// UserProfileEntry.surveyResponses
    dynamic surveyResponses,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _fullName = fullName,
        _role = role,
        _preferredLanguage = preferredLanguage,
        _surveyResponses = surveyResponses,
        super(firestoreUtilData);

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "fullName" field.
  String? _fullName;
  String get fullName => _fullName ?? '';
  set fullName(String? val) => _fullName = val;

  bool hasFullName() => _fullName != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  // "preferredLanguage" field.
  String? _preferredLanguage;
  String get preferredLanguage => _preferredLanguage ?? '';
  set preferredLanguage(String? val) => _preferredLanguage = val;

  bool hasPreferredLanguage() => _preferredLanguage != null;

  // "surveyResponses" field.
  dynamic _surveyResponses;
  dynamic get surveyResponses => _surveyResponses;
  set surveyResponses(dynamic val) => _surveyResponses = val;

  bool hasSurveyResponses() => _surveyResponses != null;

  static UserProfileEntryStruct fromMap(Map<String, dynamic> data) =>
      UserProfileEntryStruct(
        id: data['id'] as String?,
        fullName: data['fullName'] as String?,
        role: data['role'] as String?,
        preferredLanguage: data['preferredLanguage'] as String?,
        surveyResponses: data['surveyResponses'] as dynamic,
      );

  static UserProfileEntryStruct? maybeFromMap(dynamic data) => data is Map
      ? UserProfileEntryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'fullName': _fullName,
        'role': _role,
        'preferredLanguage': _preferredLanguage,
        'surveyResponses': _surveyResponses,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'fullName': serializeParam(
          _fullName,
          ParamType.String,
        ),
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
        'preferredLanguage': serializeParam(
          _preferredLanguage,
          ParamType.String,
        ),
        'surveyResponses': serializeParam(
          _surveyResponses,
          ParamType.JSON,
        ),
      }.withoutNulls;

  static UserProfileEntryStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      UserProfileEntryStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        fullName: deserializeParam(
          data['fullName'],
          ParamType.String,
          false,
        ),
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
        preferredLanguage: deserializeParam(
          data['preferredLanguage'],
          ParamType.String,
          false,
        ),
        surveyResponses: deserializeParam(
          data['surveyResponses'],
          ParamType.JSON,
          false,
        ),
      );

  @override
  String toString() => 'UserProfileEntryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserProfileEntryStruct &&
        id == other.id &&
        fullName == other.fullName &&
        role == other.role &&
        preferredLanguage == other.preferredLanguage &&
        surveyResponses == other.surveyResponses;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, fullName, role, preferredLanguage, surveyResponses]);
}

UserProfileEntryStruct createUserProfileEntryStruct({
  String? id,
  String? fullName,
  String? role,
  String? preferredLanguage,
  dynamic surveyResponses,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    UserProfileEntryStruct(
      id: id,
      fullName: fullName,
      role: role,
      preferredLanguage: preferredLanguage,
      surveyResponses: surveyResponses,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

UserProfileEntryStruct? updateUserProfileEntryStruct(
  UserProfileEntryStruct? userProfileEntry, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    userProfileEntry
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addUserProfileEntryStructData(
  Map<String, dynamic> firestoreData,
  UserProfileEntryStruct? userProfileEntry,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (userProfileEntry == null) {
    return;
  }
  if (userProfileEntry.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && userProfileEntry.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final userProfileEntryData =
      getUserProfileEntryFirestoreData(userProfileEntry, forFieldValue);
  final nestedData =
      userProfileEntryData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = userProfileEntry.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getUserProfileEntryFirestoreData(
  UserProfileEntryStruct? userProfileEntry, [
  bool forFieldValue = false,
]) {
  if (userProfileEntry == null) {
    return {};
  }
  final firestoreData = mapToFirestore(userProfileEntry.toMap());

  // Add any Firestore field values
  mapToFirestore(userProfileEntry.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getUserProfileEntryListFirestoreData(
  List<UserProfileEntryStruct>? userProfileEntrys,
) =>
    userProfileEntrys
        ?.map((e) => getUserProfileEntryFirestoreData(e, true))
        .toList() ??
    [];
