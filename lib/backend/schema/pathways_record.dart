import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Discipleship pathways
class PathwaysRecord extends FirestoreRecord {
  PathwaysRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  LocaleTextStruct? _title;
  LocaleTextStruct get title => _title ?? LocaleTextStruct();
  bool hasTitle() => _title != null;

  // "description" field.
  LocaleTextStruct? _description;
  LocaleTextStruct get description => _description ?? LocaleTextStruct();
  bool hasDescription() => _description != null;

  // "durationDays" field.
  int? _durationDays;
  int get durationDays => _durationDays ?? 0;
  bool hasDurationDays() => _durationDays != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "stableId" field.
  String? _stableId;
  String get stableId => _stableId ?? '';
  bool hasStableId() => _stableId != null;

  // "order" field.
  int? _order;
  int get order => _order ?? 0;
  bool hasOrder() => _order != null;

  void _initializeFields() {
    _title = snapshotData['title'] is LocaleTextStruct
        ? snapshotData['title']
        : LocaleTextStruct.maybeFromMap(snapshotData['title']);
    _description = snapshotData['description'] is LocaleTextStruct
        ? snapshotData['description']
        : LocaleTextStruct.maybeFromMap(snapshotData['description']);
    _durationDays = castToType<int>(snapshotData['durationDays']);
    _status = snapshotData['status'] as String?;
    _stableId = snapshotData['stableId'] as String?;
    _order = castToType<int>(snapshotData['order']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('pathways');

  static Stream<PathwaysRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PathwaysRecord.fromSnapshot(s));

  static Future<PathwaysRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PathwaysRecord.fromSnapshot(s));

  static PathwaysRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PathwaysRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PathwaysRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PathwaysRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PathwaysRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PathwaysRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPathwaysRecordData({
  LocaleTextStruct? title,
  LocaleTextStruct? description,
  int? durationDays,
  String? status,
  String? stableId,
  int? order,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': LocaleTextStruct().toMap(),
      'description': LocaleTextStruct().toMap(),
      'durationDays': durationDays,
      'status': status,
      'stableId': stableId,
      'order': order,
    }.withoutNulls,
  );

  // Handle nested data for "title" field.
  addLocaleTextStructData(firestoreData, title, 'title');

  // Handle nested data for "description" field.
  addLocaleTextStructData(firestoreData, description, 'description');

  return firestoreData;
}

class PathwaysRecordDocumentEquality implements Equality<PathwaysRecord> {
  const PathwaysRecordDocumentEquality();

  @override
  bool equals(PathwaysRecord? e1, PathwaysRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.description == e2?.description &&
        e1?.durationDays == e2?.durationDays &&
        e1?.status == e2?.status &&
        e1?.stableId == e2?.stableId &&
        e1?.order == e2?.order;
  }

  @override
  int hash(PathwaysRecord? e) => const ListEquality().hash([
        e?.title,
        e?.description,
        e?.durationDays,
        e?.status,
        e?.stableId,
        e?.order
      ]);

  @override
  bool isValidKey(Object? o) => o is PathwaysRecord;
}
