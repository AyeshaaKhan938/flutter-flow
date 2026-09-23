import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Member lesson reflections
class ReflectionsRecord extends FirestoreRecord {
  ReflectionsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userId" field.
  String? _userId;
  String get userId => _userId ?? '';
  bool hasUserId() => _userId != null;

  // "lessonId" field.
  String? _lessonId;
  String get lessonId => _lessonId ?? '';
  bool hasLessonId() => _lessonId != null;

  // "text" field.
  String? _text;
  String get text => _text ?? '';
  bool hasText() => _text != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "clientWriteId" field.
  String? _clientWriteId;
  String get clientWriteId => _clientWriteId ?? '';
  bool hasClientWriteId() => _clientWriteId != null;

  void _initializeFields() {
    _userId = snapshotData['userId'] as String?;
    _lessonId = snapshotData['lessonId'] as String?;
    _text = snapshotData['text'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _clientWriteId = snapshotData['clientWriteId'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('reflections');

  static Stream<ReflectionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ReflectionsRecord.fromSnapshot(s));

  static Future<ReflectionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ReflectionsRecord.fromSnapshot(s));

  static ReflectionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ReflectionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ReflectionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReflectionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ReflectionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ReflectionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createReflectionsRecordData({
  String? userId,
  String? lessonId,
  String? text,
  DateTime? createdAt,
  String? clientWriteId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userId': userId,
      'lessonId': lessonId,
      'text': text,
      'createdAt': createdAt,
      'clientWriteId': clientWriteId,
    }.withoutNulls,
  );

  return firestoreData;
}

class ReflectionsRecordDocumentEquality implements Equality<ReflectionsRecord> {
  const ReflectionsRecordDocumentEquality();

  @override
  bool equals(ReflectionsRecord? e1, ReflectionsRecord? e2) {
    return e1?.userId == e2?.userId &&
        e1?.lessonId == e2?.lessonId &&
        e1?.text == e2?.text &&
        e1?.createdAt == e2?.createdAt &&
        e1?.clientWriteId == e2?.clientWriteId;
  }

  @override
  int hash(ReflectionsRecord? e) => const ListEquality()
      .hash([e?.userId, e?.lessonId, e?.text, e?.createdAt, e?.clientWriteId]);

  @override
  bool isValidKey(Object? o) => o is ReflectionsRecord;
}
