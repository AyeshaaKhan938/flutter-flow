// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct AnalyticsLogResponse
class AnalyticsLogResponseStruct extends FFFirebaseStruct {
  AnalyticsLogResponseStruct({
    /// AnalyticsLogResponse.success
    bool? success,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _success = success,
        super(firestoreUtilData);

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  static AnalyticsLogResponseStruct fromMap(Map<String, dynamic> data) =>
      AnalyticsLogResponseStruct(
        success: data['success'] as bool?,
      );

  static AnalyticsLogResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? AnalyticsLogResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'success': _success,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
      }.withoutNulls;

  static AnalyticsLogResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AnalyticsLogResponseStruct(
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'AnalyticsLogResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AnalyticsLogResponseStruct && success == other.success;
  }

  @override
  int get hashCode => const ListEquality().hash([success]);
}

AnalyticsLogResponseStruct createAnalyticsLogResponseStruct({
  bool? success,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AnalyticsLogResponseStruct(
      success: success,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AnalyticsLogResponseStruct? updateAnalyticsLogResponseStruct(
  AnalyticsLogResponseStruct? analyticsLogResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    analyticsLogResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAnalyticsLogResponseStructData(
  Map<String, dynamic> firestoreData,
  AnalyticsLogResponseStruct? analyticsLogResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (analyticsLogResponse == null) {
    return;
  }
  if (analyticsLogResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && analyticsLogResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final analyticsLogResponseData =
      getAnalyticsLogResponseFirestoreData(analyticsLogResponse, forFieldValue);
  final nestedData =
      analyticsLogResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      analyticsLogResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAnalyticsLogResponseFirestoreData(
  AnalyticsLogResponseStruct? analyticsLogResponse, [
  bool forFieldValue = false,
]) {
  if (analyticsLogResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(analyticsLogResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(analyticsLogResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAnalyticsLogResponseListFirestoreData(
  List<AnalyticsLogResponseStruct>? analyticsLogResponses,
) =>
    analyticsLogResponses
        ?.map((e) => getAnalyticsLogResponseFirestoreData(e, true))
        .toList() ??
    [];
