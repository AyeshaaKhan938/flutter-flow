import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Ministry announcements
class AnnouncementsRecord extends FirestoreRecord {
  AnnouncementsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  LocaleTextStruct? _title;
  LocaleTextStruct get title => _title ?? LocaleTextStruct();
  bool hasTitle() => _title != null;

  // "body" field.
  LocaleTextStruct? _body;
  LocaleTextStruct get body => _body ?? LocaleTextStruct();
  bool hasBody() => _body != null;

  // "publishedAt" field.
  DateTime? _publishedAt;
  DateTime? get publishedAt => _publishedAt;
  bool hasPublishedAt() => _publishedAt != null;

  // "audience" field.
  String? _audience;
  String get audience => _audience ?? '';
  bool hasAudience() => _audience != null;

  void _initializeFields() {
    _title = snapshotData['title'] is LocaleTextStruct
        ? snapshotData['title']
        : LocaleTextStruct.maybeFromMap(snapshotData['title']);
    _body = snapshotData['body'] is LocaleTextStruct
        ? snapshotData['body']
        : LocaleTextStruct.maybeFromMap(snapshotData['body']);
    _publishedAt = snapshotData['publishedAt'] as DateTime?;
    _audience = snapshotData['audience'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('announcements');

  static Stream<AnnouncementsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AnnouncementsRecord.fromSnapshot(s));

  static Future<AnnouncementsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AnnouncementsRecord.fromSnapshot(s));

  static AnnouncementsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AnnouncementsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AnnouncementsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AnnouncementsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AnnouncementsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AnnouncementsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAnnouncementsRecordData({
  LocaleTextStruct? title,
  LocaleTextStruct? body,
  DateTime? publishedAt,
  String? audience,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': LocaleTextStruct().toMap(),
      'body': LocaleTextStruct().toMap(),
      'publishedAt': publishedAt,
      'audience': audience,
    }.withoutNulls,
  );

  // Handle nested data for "title" field.
  addLocaleTextStructData(firestoreData, title, 'title');

  // Handle nested data for "body" field.
  addLocaleTextStructData(firestoreData, body, 'body');

  return firestoreData;
}

class AnnouncementsRecordDocumentEquality
    implements Equality<AnnouncementsRecord> {
  const AnnouncementsRecordDocumentEquality();

  @override
  bool equals(AnnouncementsRecord? e1, AnnouncementsRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.body == e2?.body &&
        e1?.publishedAt == e2?.publishedAt &&
        e1?.audience == e2?.audience;
  }

  @override
  int hash(AnnouncementsRecord? e) => const ListEquality()
      .hash([e?.title, e?.body, e?.publishedAt, e?.audience]);

  @override
  bool isValidKey(Object? o) => o is AnnouncementsRecord;
}
