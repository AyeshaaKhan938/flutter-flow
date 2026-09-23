// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct AnnouncementEntry
class AnnouncementEntryStruct extends FFFirebaseStruct {
  AnnouncementEntryStruct({
    /// AnnouncementEntry.id
    String? id,

    /// AnnouncementEntry.title
    LocaleTextStruct? title,

    /// AnnouncementEntry.body
    LocaleTextStruct? body,

    /// AnnouncementEntry.audience
    String? audience,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _title = title,
        _body = body,
        _audience = audience,
        super(firestoreUtilData);

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "title" field.
  LocaleTextStruct? _title;
  LocaleTextStruct get title => _title ?? LocaleTextStruct();
  set title(LocaleTextStruct? val) => _title = val;

  void updateTitle(Function(LocaleTextStruct) updateFn) {
    updateFn(_title ??= LocaleTextStruct());
  }

  bool hasTitle() => _title != null;

  // "body" field.
  LocaleTextStruct? _body;
  LocaleTextStruct get body => _body ?? LocaleTextStruct();
  set body(LocaleTextStruct? val) => _body = val;

  void updateBody(Function(LocaleTextStruct) updateFn) {
    updateFn(_body ??= LocaleTextStruct());
  }

  bool hasBody() => _body != null;

  // "audience" field.
  String? _audience;
  String get audience => _audience ?? '';
  set audience(String? val) => _audience = val;

  bool hasAudience() => _audience != null;

  static AnnouncementEntryStruct fromMap(Map<String, dynamic> data) =>
      AnnouncementEntryStruct(
        id: data['id'] as String?,
        title: data['title'] is LocaleTextStruct
            ? data['title']
            : LocaleTextStruct.maybeFromMap(data['title']),
        body: data['body'] is LocaleTextStruct
            ? data['body']
            : LocaleTextStruct.maybeFromMap(data['body']),
        audience: data['audience'] as String?,
      );

  static AnnouncementEntryStruct? maybeFromMap(dynamic data) => data is Map
      ? AnnouncementEntryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title?.toMap(),
        'body': _body?.toMap(),
        'audience': _audience,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.DataStruct,
        ),
        'body': serializeParam(
          _body,
          ParamType.DataStruct,
        ),
        'audience': serializeParam(
          _audience,
          ParamType.String,
        ),
      }.withoutNulls;

  static AnnouncementEntryStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AnnouncementEntryStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        title: deserializeStructParam(
          data['title'],
          ParamType.DataStruct,
          false,
          structBuilder: LocaleTextStruct.fromSerializableMap,
        ),
        body: deserializeStructParam(
          data['body'],
          ParamType.DataStruct,
          false,
          structBuilder: LocaleTextStruct.fromSerializableMap,
        ),
        audience: deserializeParam(
          data['audience'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AnnouncementEntryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AnnouncementEntryStruct &&
        id == other.id &&
        title == other.title &&
        body == other.body &&
        audience == other.audience;
  }

  @override
  int get hashCode => const ListEquality().hash([id, title, body, audience]);
}

AnnouncementEntryStruct createAnnouncementEntryStruct({
  String? id,
  LocaleTextStruct? title,
  LocaleTextStruct? body,
  String? audience,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AnnouncementEntryStruct(
      id: id,
      title: title ?? (clearUnsetFields ? LocaleTextStruct() : null),
      body: body ?? (clearUnsetFields ? LocaleTextStruct() : null),
      audience: audience,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AnnouncementEntryStruct? updateAnnouncementEntryStruct(
  AnnouncementEntryStruct? announcementEntry, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    announcementEntry
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAnnouncementEntryStructData(
  Map<String, dynamic> firestoreData,
  AnnouncementEntryStruct? announcementEntry,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (announcementEntry == null) {
    return;
  }
  if (announcementEntry.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && announcementEntry.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final announcementEntryData =
      getAnnouncementEntryFirestoreData(announcementEntry, forFieldValue);
  final nestedData =
      announcementEntryData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = announcementEntry.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAnnouncementEntryFirestoreData(
  AnnouncementEntryStruct? announcementEntry, [
  bool forFieldValue = false,
]) {
  if (announcementEntry == null) {
    return {};
  }
  final firestoreData = mapToFirestore(announcementEntry.toMap());

  // Handle nested data for "title" field.
  addLocaleTextStructData(
    firestoreData,
    announcementEntry.hasTitle() ? announcementEntry.title : null,
    'title',
    forFieldValue,
  );

  // Handle nested data for "body" field.
  addLocaleTextStructData(
    firestoreData,
    announcementEntry.hasBody() ? announcementEntry.body : null,
    'body',
    forFieldValue,
  );

  // Add any Firestore field values
  mapToFirestore(announcementEntry.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAnnouncementEntryListFirestoreData(
  List<AnnouncementEntryStruct>? announcementEntrys,
) =>
    announcementEntrys
        ?.map((e) => getAnnouncementEntryFirestoreData(e, true))
        .toList() ??
    [];
