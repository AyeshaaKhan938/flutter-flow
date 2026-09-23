import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Data-driven Assessment questions
class AssessmentQuestionsRecord extends FirestoreRecord {
  AssessmentQuestionsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "stableId" field.
  String? _stableId;
  String get stableId => _stableId ?? '';
  bool hasStableId() => _stableId != null;

  // "order" field.
  int? _order;
  int get order => _order ?? 0;
  bool hasOrder() => _order != null;

  // "fieldKey" field.
  String? _fieldKey;
  String get fieldKey => _fieldKey ?? '';
  bool hasFieldKey() => _fieldKey != null;

  // "label" field.
  LocaleTextStruct? _label;
  LocaleTextStruct get label => _label ?? LocaleTextStruct();
  bool hasLabel() => _label != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "optionA" field.
  LocaleTextStruct? _optionA;
  LocaleTextStruct get optionA => _optionA ?? LocaleTextStruct();
  bool hasOptionA() => _optionA != null;

  // "optionB" field.
  LocaleTextStruct? _optionB;
  LocaleTextStruct get optionB => _optionB ?? LocaleTextStruct();
  bool hasOptionB() => _optionB != null;

  // "optionC" field.
  LocaleTextStruct? _optionC;
  LocaleTextStruct get optionC => _optionC ?? LocaleTextStruct();
  bool hasOptionC() => _optionC != null;

  // "optionD" field.
  LocaleTextStruct? _optionD;
  LocaleTextStruct get optionD => _optionD ?? LocaleTextStruct();
  bool hasOptionD() => _optionD != null;

  // "questionId" field.
  String? _questionId;
  String get questionId => _questionId ?? '';
  bool hasQuestionId() => _questionId != null;

  void _initializeFields() {
    _stableId = snapshotData['stableId'] as String?;
    _order = castToType<int>(snapshotData['order']);
    _fieldKey = snapshotData['fieldKey'] as String?;
    _label = snapshotData['label'] is LocaleTextStruct
        ? snapshotData['label']
        : LocaleTextStruct.maybeFromMap(snapshotData['label']);
    _status = snapshotData['status'] as String?;
    _optionA = snapshotData['optionA'] is LocaleTextStruct
        ? snapshotData['optionA']
        : LocaleTextStruct.maybeFromMap(snapshotData['optionA']);
    _optionB = snapshotData['optionB'] is LocaleTextStruct
        ? snapshotData['optionB']
        : LocaleTextStruct.maybeFromMap(snapshotData['optionB']);
    _optionC = snapshotData['optionC'] is LocaleTextStruct
        ? snapshotData['optionC']
        : LocaleTextStruct.maybeFromMap(snapshotData['optionC']);
    _optionD = snapshotData['optionD'] is LocaleTextStruct
        ? snapshotData['optionD']
        : LocaleTextStruct.maybeFromMap(snapshotData['optionD']);
    _questionId = snapshotData['questionId'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('assessmentQuestions');

  static Stream<AssessmentQuestionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AssessmentQuestionsRecord.fromSnapshot(s));

  static Future<AssessmentQuestionsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => AssessmentQuestionsRecord.fromSnapshot(s));

  static AssessmentQuestionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AssessmentQuestionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AssessmentQuestionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AssessmentQuestionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AssessmentQuestionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AssessmentQuestionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAssessmentQuestionsRecordData({
  String? stableId,
  int? order,
  String? fieldKey,
  LocaleTextStruct? label,
  String? status,
  LocaleTextStruct? optionA,
  LocaleTextStruct? optionB,
  LocaleTextStruct? optionC,
  LocaleTextStruct? optionD,
  String? questionId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'stableId': stableId,
      'order': order,
      'fieldKey': fieldKey,
      'label': LocaleTextStruct().toMap(),
      'status': status,
      'optionA': LocaleTextStruct().toMap(),
      'optionB': LocaleTextStruct().toMap(),
      'optionC': LocaleTextStruct().toMap(),
      'optionD': LocaleTextStruct().toMap(),
      'questionId': questionId,
    }.withoutNulls,
  );

  // Handle nested data for "label" field.
  addLocaleTextStructData(firestoreData, label, 'label');

  // Handle nested data for "optionA" field.
  addLocaleTextStructData(firestoreData, optionA, 'optionA');

  // Handle nested data for "optionB" field.
  addLocaleTextStructData(firestoreData, optionB, 'optionB');

  // Handle nested data for "optionC" field.
  addLocaleTextStructData(firestoreData, optionC, 'optionC');

  // Handle nested data for "optionD" field.
  addLocaleTextStructData(firestoreData, optionD, 'optionD');

  return firestoreData;
}

class AssessmentQuestionsRecordDocumentEquality
    implements Equality<AssessmentQuestionsRecord> {
  const AssessmentQuestionsRecordDocumentEquality();

  @override
  bool equals(AssessmentQuestionsRecord? e1, AssessmentQuestionsRecord? e2) {
    return e1?.stableId == e2?.stableId &&
        e1?.order == e2?.order &&
        e1?.fieldKey == e2?.fieldKey &&
        e1?.label == e2?.label &&
        e1?.status == e2?.status &&
        e1?.optionA == e2?.optionA &&
        e1?.optionB == e2?.optionB &&
        e1?.optionC == e2?.optionC &&
        e1?.optionD == e2?.optionD &&
        e1?.questionId == e2?.questionId;
  }

  @override
  int hash(AssessmentQuestionsRecord? e) => const ListEquality().hash([
        e?.stableId,
        e?.order,
        e?.fieldKey,
        e?.label,
        e?.status,
        e?.optionA,
        e?.optionB,
        e?.optionC,
        e?.optionD,
        e?.questionId
      ]);

  @override
  bool isValidKey(Object? o) => o is AssessmentQuestionsRecord;
}
