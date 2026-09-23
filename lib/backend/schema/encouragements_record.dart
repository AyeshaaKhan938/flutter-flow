import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// 365 daily encouragements
class EncouragementsRecord extends FirestoreRecord {
  EncouragementsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "date" field.
  String? _date;
  String get date => _date ?? '';
  bool hasDate() => _date != null;

  // "quote" field.
  LocaleTextStruct? _quote;
  LocaleTextStruct get quote => _quote ?? LocaleTextStruct();
  bool hasQuote() => _quote != null;

  // "attribution" field.
  String? _attribution;
  String get attribution => _attribution ?? '';
  bool hasAttribution() => _attribution != null;

  // "rightsCleared" field.
  bool? _rightsCleared;
  bool get rightsCleared => _rightsCleared ?? false;
  bool hasRightsCleared() => _rightsCleared != null;

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
    _quote = snapshotData['quote'] is LocaleTextStruct
        ? snapshotData['quote']
        : LocaleTextStruct.maybeFromMap(snapshotData['quote']);
    _attribution = snapshotData['attribution'] as String?;
    _rightsCleared = snapshotData['rightsCleared'] as bool?;
    _status = snapshotData['status'] as String?;
    _stableId = snapshotData['stableId'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('encouragements');

  static Stream<EncouragementsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EncouragementsRecord.fromSnapshot(s));

  static Future<EncouragementsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EncouragementsRecord.fromSnapshot(s));

  static EncouragementsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      EncouragementsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EncouragementsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EncouragementsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EncouragementsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EncouragementsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEncouragementsRecordData({
  String? date,
  LocaleTextStruct? quote,
  String? attribution,
  bool? rightsCleared,
  String? status,
  String? stableId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'date': date,
      'quote': LocaleTextStruct().toMap(),
      'attribution': attribution,
      'rightsCleared': rightsCleared,
      'status': status,
      'stableId': stableId,
    }.withoutNulls,
  );

  // Handle nested data for "quote" field.
  addLocaleTextStructData(firestoreData, quote, 'quote');

  return firestoreData;
}

class EncouragementsRecordDocumentEquality
    implements Equality<EncouragementsRecord> {
  const EncouragementsRecordDocumentEquality();

  @override
  bool equals(EncouragementsRecord? e1, EncouragementsRecord? e2) {
    return e1?.date == e2?.date &&
        e1?.quote == e2?.quote &&
        e1?.attribution == e2?.attribution &&
        e1?.rightsCleared == e2?.rightsCleared &&
        e1?.status == e2?.status &&
        e1?.stableId == e2?.stableId;
  }

  @override
  int hash(EncouragementsRecord? e) => const ListEquality().hash([
        e?.date,
        e?.quote,
        e?.attribution,
        e?.rightsCleared,
        e?.status,
        e?.stableId
      ]);

  @override
  bool isValidKey(Object? o) => o is EncouragementsRecord;
}
