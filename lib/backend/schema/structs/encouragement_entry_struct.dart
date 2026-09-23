// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct EncouragementEntry
class EncouragementEntryStruct extends FFFirebaseStruct {
  EncouragementEntryStruct({
    /// EncouragementEntry.id
    String? id,

    /// EncouragementEntry.date
    String? date,

    /// EncouragementEntry.quote
    LocaleTextStruct? quote,

    /// EncouragementEntry.attribution
    String? attribution,

    /// EncouragementEntry.status
    String? status,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _date = date,
        _quote = quote,
        _attribution = attribution,
        _status = status,
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

  // "quote" field.
  LocaleTextStruct? _quote;
  LocaleTextStruct get quote => _quote ?? LocaleTextStruct();
  set quote(LocaleTextStruct? val) => _quote = val;

  void updateQuote(Function(LocaleTextStruct) updateFn) {
    updateFn(_quote ??= LocaleTextStruct());
  }

  bool hasQuote() => _quote != null;

  // "attribution" field.
  String? _attribution;
  String get attribution => _attribution ?? '';
  set attribution(String? val) => _attribution = val;

  bool hasAttribution() => _attribution != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  static EncouragementEntryStruct fromMap(Map<String, dynamic> data) =>
      EncouragementEntryStruct(
        id: data['id'] as String?,
        date: data['date'] as String?,
        quote: data['quote'] is LocaleTextStruct
            ? data['quote']
            : LocaleTextStruct.maybeFromMap(data['quote']),
        attribution: data['attribution'] as String?,
        status: data['status'] as String?,
      );

  static EncouragementEntryStruct? maybeFromMap(dynamic data) => data is Map
      ? EncouragementEntryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'date': _date,
        'quote': _quote?.toMap(),
        'attribution': _attribution,
        'status': _status,
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
        'quote': serializeParam(
          _quote,
          ParamType.DataStruct,
        ),
        'attribution': serializeParam(
          _attribution,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
      }.withoutNulls;

  static EncouragementEntryStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      EncouragementEntryStruct(
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
        quote: deserializeStructParam(
          data['quote'],
          ParamType.DataStruct,
          false,
          structBuilder: LocaleTextStruct.fromSerializableMap,
        ),
        attribution: deserializeParam(
          data['attribution'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'EncouragementEntryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EncouragementEntryStruct &&
        id == other.id &&
        date == other.date &&
        quote == other.quote &&
        attribution == other.attribution &&
        status == other.status;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, date, quote, attribution, status]);
}

EncouragementEntryStruct createEncouragementEntryStruct({
  String? id,
  String? date,
  LocaleTextStruct? quote,
  String? attribution,
  String? status,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EncouragementEntryStruct(
      id: id,
      date: date,
      quote: quote ?? (clearUnsetFields ? LocaleTextStruct() : null),
      attribution: attribution,
      status: status,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EncouragementEntryStruct? updateEncouragementEntryStruct(
  EncouragementEntryStruct? encouragementEntry, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    encouragementEntry
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEncouragementEntryStructData(
  Map<String, dynamic> firestoreData,
  EncouragementEntryStruct? encouragementEntry,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (encouragementEntry == null) {
    return;
  }
  if (encouragementEntry.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && encouragementEntry.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final encouragementEntryData =
      getEncouragementEntryFirestoreData(encouragementEntry, forFieldValue);
  final nestedData =
      encouragementEntryData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      encouragementEntry.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEncouragementEntryFirestoreData(
  EncouragementEntryStruct? encouragementEntry, [
  bool forFieldValue = false,
]) {
  if (encouragementEntry == null) {
    return {};
  }
  final firestoreData = mapToFirestore(encouragementEntry.toMap());

  // Handle nested data for "quote" field.
  addLocaleTextStructData(
    firestoreData,
    encouragementEntry.hasQuote() ? encouragementEntry.quote : null,
    'quote',
    forFieldValue,
  );

  // Add any Firestore field values
  mapToFirestore(encouragementEntry.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEncouragementEntryListFirestoreData(
  List<EncouragementEntryStruct>? encouragementEntrys,
) =>
    encouragementEntrys
        ?.map((e) => getEncouragementEntryFirestoreData(e, true))
        .toList() ??
    [];
