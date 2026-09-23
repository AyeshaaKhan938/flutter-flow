import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// 365 daily Scripture entries
class DailyScriptureRecord extends FirestoreRecord {
  DailyScriptureRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  bool hasDate() => _date != null;

  // "verseRef" field.
  String? _verseRef;
  String get verseRef => _verseRef ?? '';
  bool hasVerseRef() => _verseRef != null;

  // "text" field.
  LocaleTextStruct? _text;
  LocaleTextStruct get text => _text ?? LocaleTextStruct();
  bool hasText() => _text != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "stableId" field.
  String? _stableId;
  String get stableId => _stableId ?? '';
  bool hasStableId() => _stableId != null;

  void _initializeFields() {
    _date = snapshotData['date'] as String?;
    _verseRef = snapshotData['verseRef'] as String?;
    _text = snapshotData['text'] is LocaleTextStruct
        ? snapshotData['text']
        : LocaleTextStruct.maybeFromMap(snapshotData['text']);
    _status = snapshotData['status'] as String?;
    _stableId = snapshotData['stableId'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('dailyScripture');

  static Stream<DailyScriptureRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DailyScriptureRecord.fromSnapshot(s));

  static Future<DailyScriptureRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DailyScriptureRecord.fromSnapshot(s));

  static DailyScriptureRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DailyScriptureRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static DailyScriptureRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DailyScriptureRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'DailyScriptureRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DailyScriptureRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createDailyScriptureRecordData({
  String? date,
  String? verseRef,
  LocaleTextStruct? text,
  String? status,
  String? stableId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'date': date,
      'verseRef': verseRef,
      'text': LocaleTextStruct().toMap(),
      'status': status,
      'stableId': stableId,
    }.withoutNulls,
  );

  // Handle nested data for "text" field.
  addLocaleTextStructData(firestoreData, text, 'text');

  return firestoreData;
}

class DailyScriptureRecordDocumentEquality
    implements Equality<DailyScriptureRecord> {
  const DailyScriptureRecordDocumentEquality();

  @override
  bool equals(DailyScriptureRecord? e1, DailyScriptureRecord? e2) {
    return e1?.date == e2?.date &&
        e1?.verseRef == e2?.verseRef &&
        e1?.text == e2?.text &&
        e1?.status == e2?.status &&
        e1?.stableId == e2?.stableId;
  }

  @override
  int hash(DailyScriptureRecord? e) => const ListEquality()
      .hash([e?.date, e?.verseRef, e?.text, e?.status, e?.stableId]);

  @override
  bool isValidKey(Object? o) => o is DailyScriptureRecord;
}
