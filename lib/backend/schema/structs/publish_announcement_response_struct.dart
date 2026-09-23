// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct PublishAnnouncementResponse
class PublishAnnouncementResponseStruct extends FFFirebaseStruct {
  PublishAnnouncementResponseStruct({
    /// PublishAnnouncementResponse.success
    bool? success,

    /// PublishAnnouncementResponse.announcementId
    String? announcementId,

    /// PublishAnnouncementResponse.pushSent
    int? pushSent,

    /// PublishAnnouncementResponse.pushFailed
    int? pushFailed,

    /// PublishAnnouncementResponse.note
    String? note,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _success = success,
        _announcementId = announcementId,
        _pushSent = pushSent,
        _pushFailed = pushFailed,
        _note = note,
        super(firestoreUtilData);

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "announcementId" field.
  String? _announcementId;
  String get announcementId => _announcementId ?? '';
  set announcementId(String? val) => _announcementId = val;

  bool hasAnnouncementId() => _announcementId != null;

  // "pushSent" field.
  int? _pushSent;
  int get pushSent => _pushSent ?? 0;
  set pushSent(int? val) => _pushSent = val;

  void incrementPushSent(int amount) => pushSent = pushSent + amount;

  bool hasPushSent() => _pushSent != null;

  // "pushFailed" field.
  int? _pushFailed;
  int get pushFailed => _pushFailed ?? 0;
  set pushFailed(int? val) => _pushFailed = val;

  void incrementPushFailed(int amount) => pushFailed = pushFailed + amount;

  bool hasPushFailed() => _pushFailed != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  set note(String? val) => _note = val;

  bool hasNote() => _note != null;

  static PublishAnnouncementResponseStruct fromMap(Map<String, dynamic> data) =>
      PublishAnnouncementResponseStruct(
        success: data['success'] as bool?,
        announcementId: data['announcementId'] as String?,
        pushSent: castToType<int>(data['pushSent']),
        pushFailed: castToType<int>(data['pushFailed']),
        note: data['note'] as String?,
      );

  static PublishAnnouncementResponseStruct? maybeFromMap(dynamic data) => data
          is Map
      ? PublishAnnouncementResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'success': _success,
        'announcementId': _announcementId,
        'pushSent': _pushSent,
        'pushFailed': _pushFailed,
        'note': _note,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'announcementId': serializeParam(
          _announcementId,
          ParamType.String,
        ),
        'pushSent': serializeParam(
          _pushSent,
          ParamType.int,
        ),
        'pushFailed': serializeParam(
          _pushFailed,
          ParamType.int,
        ),
        'note': serializeParam(
          _note,
          ParamType.String,
        ),
      }.withoutNulls;

  static PublishAnnouncementResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PublishAnnouncementResponseStruct(
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        announcementId: deserializeParam(
          data['announcementId'],
          ParamType.String,
          false,
        ),
        pushSent: deserializeParam(
          data['pushSent'],
          ParamType.int,
          false,
        ),
        pushFailed: deserializeParam(
          data['pushFailed'],
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
  String toString() => 'PublishAnnouncementResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PublishAnnouncementResponseStruct &&
        success == other.success &&
        announcementId == other.announcementId &&
        pushSent == other.pushSent &&
        pushFailed == other.pushFailed &&
        note == other.note;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([success, announcementId, pushSent, pushFailed, note]);
}

PublishAnnouncementResponseStruct createPublishAnnouncementResponseStruct({
  bool? success,
  String? announcementId,
  int? pushSent,
  int? pushFailed,
  String? note,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PublishAnnouncementResponseStruct(
      success: success,
      announcementId: announcementId,
      pushSent: pushSent,
      pushFailed: pushFailed,
      note: note,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PublishAnnouncementResponseStruct? updatePublishAnnouncementResponseStruct(
  PublishAnnouncementResponseStruct? publishAnnouncementResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    publishAnnouncementResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPublishAnnouncementResponseStructData(
  Map<String, dynamic> firestoreData,
  PublishAnnouncementResponseStruct? publishAnnouncementResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (publishAnnouncementResponse == null) {
    return;
  }
  if (publishAnnouncementResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      publishAnnouncementResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final publishAnnouncementResponseData =
      getPublishAnnouncementResponseFirestoreData(
          publishAnnouncementResponse, forFieldValue);
  final nestedData = publishAnnouncementResponseData
      .map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      publishAnnouncementResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPublishAnnouncementResponseFirestoreData(
  PublishAnnouncementResponseStruct? publishAnnouncementResponse, [
  bool forFieldValue = false,
]) {
  if (publishAnnouncementResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(publishAnnouncementResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(publishAnnouncementResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPublishAnnouncementResponseListFirestoreData(
  List<PublishAnnouncementResponseStruct>? publishAnnouncementResponses,
) =>
    publishAnnouncementResponses
        ?.map((e) => getPublishAnnouncementResponseFirestoreData(e, true))
        .toList() ??
    [];
