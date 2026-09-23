import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Pathway quizzes (subcollection)
class QuizzesRecord extends FirestoreRecord {
  QuizzesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "lessonId" field.
  String? _lessonId;
  String get lessonId => _lessonId ?? '';
  bool hasLessonId() => _lessonId != null;

  // "questions" field.
  dynamic _questions;
  dynamic get questions => _questions;
  bool hasQuestions() => _questions != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "stableId" field.
  String? _stableId;
  String get stableId => _stableId ?? '';
  bool hasStableId() => _stableId != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _lessonId = snapshotData['lessonId'] as String?;
    _questions = snapshotData['questions'] as dynamic;
    _status = snapshotData['status'] as String?;
    _stableId = snapshotData['stableId'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('quizzes')
          : FirebaseFirestore.instance.collectionGroup('quizzes');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('quizzes').doc(id);

  static Stream<QuizzesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => QuizzesRecord.fromSnapshot(s));

  static Future<QuizzesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => QuizzesRecord.fromSnapshot(s));

  static QuizzesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      QuizzesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static QuizzesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      QuizzesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'QuizzesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is QuizzesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createQuizzesRecordData({
  String? lessonId,
  dynamic questions,
  String? status,
  String? stableId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'lessonId': lessonId,
      'questions': questions,
      'status': status,
      'stableId': stableId,
    }.withoutNulls,
  );

  return firestoreData;
}

class QuizzesRecordDocumentEquality implements Equality<QuizzesRecord> {
  const QuizzesRecordDocumentEquality();

  @override
  bool equals(QuizzesRecord? e1, QuizzesRecord? e2) {
    return e1?.lessonId == e2?.lessonId &&
        e1?.questions == e2?.questions &&
        e1?.status == e2?.status &&
        e1?.stableId == e2?.stableId;
  }

  @override
  int hash(QuizzesRecord? e) => const ListEquality()
      .hash([e?.lessonId, e?.questions, e?.status, e?.stableId]);

  @override
  bool isValidKey(Object? o) => o is QuizzesRecord;
}
