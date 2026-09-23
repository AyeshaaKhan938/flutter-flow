// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct PathwayEntry
class PathwayEntryStruct extends FFFirebaseStruct {
  PathwayEntryStruct({
    /// PathwayEntry.id
    String? id,

    /// PathwayEntry.title
    LocaleTextStruct? title,

    /// PathwayEntry.description
    LocaleTextStruct? description,

    /// PathwayEntry.durationDays
    int? durationDays,

    /// PathwayEntry.status
    String? status,

    /// PathwayEntry.stableId
    String? stableId,

    /// PathwayEntry.order
    int? order,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _title = title,
        _description = description,
        _durationDays = durationDays,
        _status = status,
        _stableId = stableId,
        _order = order,
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

  // "description" field.
  LocaleTextStruct? _description;
  LocaleTextStruct get description => _description ?? LocaleTextStruct();
  set description(LocaleTextStruct? val) => _description = val;

  void updateDescription(Function(LocaleTextStruct) updateFn) {
    updateFn(_description ??= LocaleTextStruct());
  }

  bool hasDescription() => _description != null;

  // "durationDays" field.
  int? _durationDays;
  int get durationDays => _durationDays ?? 0;
  set durationDays(int? val) => _durationDays = val;

  void incrementDurationDays(int amount) =>
      durationDays = durationDays + amount;

  bool hasDurationDays() => _durationDays != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "stableId" field.
  String? _stableId;
  String get stableId => _stableId ?? '';
  set stableId(String? val) => _stableId = val;

  bool hasStableId() => _stableId != null;

  // "order" field.
  int? _order;
  int get order => _order ?? 0;
  set order(int? val) => _order = val;

  void incrementOrder(int amount) => order = order + amount;

  bool hasOrder() => _order != null;

  static PathwayEntryStruct fromMap(Map<String, dynamic> data) =>
      PathwayEntryStruct(
        id: data['id'] as String?,
        title: data['title'] is LocaleTextStruct
            ? data['title']
            : LocaleTextStruct.maybeFromMap(data['title']),
        description: data['description'] is LocaleTextStruct
            ? data['description']
            : LocaleTextStruct.maybeFromMap(data['description']),
        durationDays: castToType<int>(data['durationDays']),
        status: data['status'] as String?,
        stableId: data['stableId'] as String?,
        order: castToType<int>(data['order']),
      );

  static PathwayEntryStruct? maybeFromMap(dynamic data) => data is Map
      ? PathwayEntryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title?.toMap(),
        'description': _description?.toMap(),
        'durationDays': _durationDays,
        'status': _status,
        'stableId': _stableId,
        'order': _order,
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
        'description': serializeParam(
          _description,
          ParamType.DataStruct,
        ),
        'durationDays': serializeParam(
          _durationDays,
          ParamType.int,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'stableId': serializeParam(
          _stableId,
          ParamType.String,
        ),
        'order': serializeParam(
          _order,
          ParamType.int,
        ),
      }.withoutNulls;

  static PathwayEntryStruct fromSerializableMap(Map<String, dynamic> data) =>
      PathwayEntryStruct(
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
        description: deserializeStructParam(
          data['description'],
          ParamType.DataStruct,
          false,
          structBuilder: LocaleTextStruct.fromSerializableMap,
        ),
        durationDays: deserializeParam(
          data['durationDays'],
          ParamType.int,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        stableId: deserializeParam(
          data['stableId'],
          ParamType.String,
          false,
        ),
        order: deserializeParam(
          data['order'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PathwayEntryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PathwayEntryStruct &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        durationDays == other.durationDays &&
        status == other.status &&
        stableId == other.stableId &&
        order == other.order;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, title, description, durationDays, status, stableId, order]);
}

PathwayEntryStruct createPathwayEntryStruct({
  String? id,
  LocaleTextStruct? title,
  LocaleTextStruct? description,
  int? durationDays,
  String? status,
  String? stableId,
  int? order,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PathwayEntryStruct(
      id: id,
      title: title ?? (clearUnsetFields ? LocaleTextStruct() : null),
      description:
          description ?? (clearUnsetFields ? LocaleTextStruct() : null),
      durationDays: durationDays,
      status: status,
      stableId: stableId,
      order: order,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PathwayEntryStruct? updatePathwayEntryStruct(
  PathwayEntryStruct? pathwayEntry, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    pathwayEntry
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPathwayEntryStructData(
  Map<String, dynamic> firestoreData,
  PathwayEntryStruct? pathwayEntry,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (pathwayEntry == null) {
    return;
  }
  if (pathwayEntry.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && pathwayEntry.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final pathwayEntryData =
      getPathwayEntryFirestoreData(pathwayEntry, forFieldValue);
  final nestedData =
      pathwayEntryData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = pathwayEntry.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPathwayEntryFirestoreData(
  PathwayEntryStruct? pathwayEntry, [
  bool forFieldValue = false,
]) {
  if (pathwayEntry == null) {
    return {};
  }
  final firestoreData = mapToFirestore(pathwayEntry.toMap());

  // Handle nested data for "title" field.
  addLocaleTextStructData(
    firestoreData,
    pathwayEntry.hasTitle() ? pathwayEntry.title : null,
    'title',
    forFieldValue,
  );

  // Handle nested data for "description" field.
  addLocaleTextStructData(
    firestoreData,
    pathwayEntry.hasDescription() ? pathwayEntry.description : null,
    'description',
    forFieldValue,
  );

  // Add any Firestore field values
  mapToFirestore(pathwayEntry.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPathwayEntryListFirestoreData(
  List<PathwayEntryStruct>? pathwayEntrys,
) =>
    pathwayEntrys?.map((e) => getPathwayEntryFirestoreData(e, true)).toList() ??
    [];
