// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct RagHttpResponse
class RagHttpResponseStruct extends FFFirebaseStruct {
  RagHttpResponseStruct({
    /// RagHttpResponse.answer
    String? answer,

    /// RagHttpResponse.citations
    String? citations,

    /// RagHttpResponse.fallbackTriggered
    bool? fallbackTriggered,

    /// RagHttpResponse.fallbackMessage
    String? fallbackMessage,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _answer = answer,
        _citations = citations,
        _fallbackTriggered = fallbackTriggered,
        _fallbackMessage = fallbackMessage,
        super(firestoreUtilData);

  // "answer" field.
  String? _answer;
  String get answer => _answer ?? '';
  set answer(String? val) => _answer = val;

  bool hasAnswer() => _answer != null;

  // "citations" field.
  String? _citations;
  String get citations => _citations ?? '';
  set citations(String? val) => _citations = val;

  bool hasCitations() => _citations != null;

  // "fallbackTriggered" field.
  bool? _fallbackTriggered;
  bool get fallbackTriggered => _fallbackTriggered ?? false;
  set fallbackTriggered(bool? val) => _fallbackTriggered = val;

  bool hasFallbackTriggered() => _fallbackTriggered != null;

  // "fallbackMessage" field.
  String? _fallbackMessage;
  String get fallbackMessage => _fallbackMessage ?? '';
  set fallbackMessage(String? val) => _fallbackMessage = val;

  bool hasFallbackMessage() => _fallbackMessage != null;

  static RagHttpResponseStruct fromMap(Map<String, dynamic> data) =>
      RagHttpResponseStruct(
        answer: data['answer'] as String?,
        citations: data['citations'] as String?,
        fallbackTriggered: data['fallbackTriggered'] as bool?,
        fallbackMessage: data['fallbackMessage'] as String?,
      );

  static RagHttpResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? RagHttpResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'answer': _answer,
        'citations': _citations,
        'fallbackTriggered': _fallbackTriggered,
        'fallbackMessage': _fallbackMessage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'answer': serializeParam(
          _answer,
          ParamType.String,
        ),
        'citations': serializeParam(
          _citations,
          ParamType.String,
        ),
        'fallbackTriggered': serializeParam(
          _fallbackTriggered,
          ParamType.bool,
        ),
        'fallbackMessage': serializeParam(
          _fallbackMessage,
          ParamType.String,
        ),
      }.withoutNulls;

  static RagHttpResponseStruct fromSerializableMap(Map<String, dynamic> data) =>
      RagHttpResponseStruct(
        answer: deserializeParam(
          data['answer'],
          ParamType.String,
          false,
        ),
        citations: deserializeParam(
          data['citations'],
          ParamType.String,
          false,
        ),
        fallbackTriggered: deserializeParam(
          data['fallbackTriggered'],
          ParamType.bool,
          false,
        ),
        fallbackMessage: deserializeParam(
          data['fallbackMessage'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RagHttpResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RagHttpResponseStruct &&
        answer == other.answer &&
        citations == other.citations &&
        fallbackTriggered == other.fallbackTriggered &&
        fallbackMessage == other.fallbackMessage;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([answer, citations, fallbackTriggered, fallbackMessage]);
}

RagHttpResponseStruct createRagHttpResponseStruct({
  String? answer,
  String? citations,
  bool? fallbackTriggered,
  String? fallbackMessage,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RagHttpResponseStruct(
      answer: answer,
      citations: citations,
      fallbackTriggered: fallbackTriggered,
      fallbackMessage: fallbackMessage,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RagHttpResponseStruct? updateRagHttpResponseStruct(
  RagHttpResponseStruct? ragHttpResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    ragHttpResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRagHttpResponseStructData(
  Map<String, dynamic> firestoreData,
  RagHttpResponseStruct? ragHttpResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (ragHttpResponse == null) {
    return;
  }
  if (ragHttpResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && ragHttpResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final ragHttpResponseData =
      getRagHttpResponseFirestoreData(ragHttpResponse, forFieldValue);
  final nestedData =
      ragHttpResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = ragHttpResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRagHttpResponseFirestoreData(
  RagHttpResponseStruct? ragHttpResponse, [
  bool forFieldValue = false,
]) {
  if (ragHttpResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(ragHttpResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(ragHttpResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRagHttpResponseListFirestoreData(
  List<RagHttpResponseStruct>? ragHttpResponses,
) =>
    ragHttpResponses
        ?.map((e) => getRagHttpResponseFirestoreData(e, true))
        .toList() ??
    [];
