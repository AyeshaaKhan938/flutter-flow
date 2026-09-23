// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct DailyScriptureEntry
class DailyScriptureEntryStruct extends FFFirebaseStruct {
  DailyScriptureEntryStruct({
    /// DailyScriptureEntry.id
    String? id,

    /// DailyScriptureEntry.date
    String? date,

    /// DailyScriptureEntry.verseRef
    String? verseRef,

    /// DailyScriptureEntry.text
    String? text,

    /// DailyScriptureEntry.status
    String? status,
    String? encouragementAuthor,
    String? encouragementText,
    String? announcementTitle,
    String? announcementBody,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _date = date,
        _verseRef = verseRef,
        _text = text,
        _status = status,
        _encouragementAuthor = encouragementAuthor,
        _encouragementText = encouragementText,
        _announcementTitle = announcementTitle,
        _announcementBody = announcementBody,
        super(firestoreUtilData);

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  set date(String? val) => _date = val;

  bool hasDate() => _date != null;

  // "verseRef" field.
  String? _verseRef;
  String get verseRef => _verseRef ?? '';
  set verseRef(String? val) => _verseRef = val;

  bool hasVerseRef() => _verseRef != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  set text(String? val) => _text = val;

  bool hasText() => _text != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "encouragementAuthor" field.
  String? _encouragementAuthor;
  String get encouragementAuthor => _encouragementAuthor ?? '';
  set encouragementAuthor(String? val) => _encouragementAuthor = val;

  bool hasEncouragementAuthor() => _encouragementAuthor != null;

  // "encouragementText" field.
  String? _encouragementText;
  String get encouragementText => _encouragementText ?? '';
  set encouragementText(String? val) => _encouragementText = val;

  bool hasEncouragementText() => _encouragementText != null;

  // "announcementTitle" field.
  String? _announcementTitle;
  String get announcementTitle => _announcementTitle ?? '';
  set announcementTitle(String? val) => _announcementTitle = val;

  bool hasAnnouncementTitle() => _announcementTitle != null;

  // "announcementBody" field.
  String? _announcementBody;
  String get announcementBody => _announcementBody ?? '';
  set announcementBody(String? val) => _announcementBody = val;

  bool hasAnnouncementBody() => _announcementBody != null;

  static DailyScriptureEntryStruct fromMap(Map<String, dynamic> data) =>
      DailyScriptureEntryStruct(
        id: data['id'] as String?,
        date: data['date'] as String?,
        verseRef: data['verseRef'] as String?,
        text: data['text'] as String?,
        status: data['status'] as String?,
        encouragementAuthor: data['encouragementAuthor'] as String?,
        encouragementText: data['encouragementText'] as String?,
        announcementTitle: data['announcementTitle'] as String?,
        announcementBody: data['announcementBody'] as String?,
      );

  static DailyScriptureEntryStruct? maybeFromMap(dynamic data) => data is Map
      ? DailyScriptureEntryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'date': _date,
        'verseRef': _verseRef,
        'text': _text,
        'status': _status,
        'encouragementAuthor': _encouragementAuthor,
        'encouragementText': _encouragementText,
        'announcementTitle': _announcementTitle,
        'announcementBody': _announcementBody,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'date': serializeParam(
          _date,
          ParamType.String,
        ),
        'verseRef': serializeParam(
          _verseRef,
          ParamType.String,
        ),
        'text': serializeParam(
          _text,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'encouragementAuthor': serializeParam(
          _encouragementAuthor,
          ParamType.String,
        ),
        'encouragementText': serializeParam(
          _encouragementText,
          ParamType.String,
        ),
        'announcementTitle': serializeParam(
          _announcementTitle,
          ParamType.String,
        ),
        'announcementBody': serializeParam(
          _announcementBody,
          ParamType.String,
        ),
      }.withoutNulls;

  static DailyScriptureEntryStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      DailyScriptureEntryStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        date: deserializeParam(
          data['date'],
          ParamType.String,
          false,
        ),
        verseRef: deserializeParam(
          data['verseRef'],
          ParamType.String,
          false,
        ),
        text: deserializeParam(
          data['text'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        encouragementAuthor: deserializeParam(
          data['encouragementAuthor'],
          ParamType.String,
          false,
        ),
        encouragementText: deserializeParam(
          data['encouragementText'],
          ParamType.String,
          false,
        ),
        announcementTitle: deserializeParam(
          data['announcementTitle'],
          ParamType.String,
          false,
        ),
        announcementBody: deserializeParam(
          data['announcementBody'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DailyScriptureEntryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DailyScriptureEntryStruct &&
        id == other.id &&
        date == other.date &&
        verseRef == other.verseRef &&
        text == other.text &&
        status == other.status &&
        encouragementAuthor == other.encouragementAuthor &&
        encouragementText == other.encouragementText &&
        announcementTitle == other.announcementTitle &&
        announcementBody == other.announcementBody;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        date,
        verseRef,
        text,
        status,
        encouragementAuthor,
        encouragementText,
        announcementTitle,
        announcementBody
      ]);
}

DailyScriptureEntryStruct createDailyScriptureEntryStruct({
  String? id,
  String? date,
  String? verseRef,
  String? text,
  String? status,
  String? encouragementAuthor,
  String? encouragementText,
  String? announcementTitle,
  String? announcementBody,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DailyScriptureEntryStruct(
      id: id,
      date: date,
      verseRef: verseRef,
      text: text,
      status: status,
      encouragementAuthor: encouragementAuthor,
      encouragementText: encouragementText,
      announcementTitle: announcementTitle,
      announcementBody: announcementBody,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DailyScriptureEntryStruct? updateDailyScriptureEntryStruct(
  DailyScriptureEntryStruct? dailyScriptureEntry, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dailyScriptureEntry
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDailyScriptureEntryStructData(
  Map<String, dynamic> firestoreData,
  DailyScriptureEntryStruct? dailyScriptureEntry,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dailyScriptureEntry == null) {
    return;
  }
  if (dailyScriptureEntry.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && dailyScriptureEntry.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final dailyScriptureEntryData =
      getDailyScriptureEntryFirestoreData(dailyScriptureEntry, forFieldValue);
  final nestedData =
      dailyScriptureEntryData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      dailyScriptureEntry.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDailyScriptureEntryFirestoreData(
  DailyScriptureEntryStruct? dailyScriptureEntry, [
  bool forFieldValue = false,
]) {
  if (dailyScriptureEntry == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dailyScriptureEntry.toMap());

  // Add any Firestore field values
  mapToFirestore(dailyScriptureEntry.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDailyScriptureEntryListFirestoreData(
  List<DailyScriptureEntryStruct>? dailyScriptureEntrys,
) =>
    dailyScriptureEntrys
        ?.map((e) => getDailyScriptureEntryFirestoreData(e, true))
        .toList() ??
    [];
