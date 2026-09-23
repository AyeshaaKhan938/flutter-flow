import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Data-driven Onboarding survey questions
class OnboardingQuestionsRecord extends FirestoreRecord {
  OnboardingQuestionsRecord._(
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

  void _initializeFields() {
    _stableId = snapshotData['stableId'] as String?;
    _order = castToType<int>(snapshotData['order']);
    _fieldKey = snapshotData['fieldKey'] as String?;
    _label = snapshotData['label'] is LocaleTextStruct
        ? snapshotData['label']
        : LocaleTextStruct.maybeFromMap(snapshotData['label']);
    _status = snapshotData['status'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('onboardingQuestions');

  static Stream<OnboardingQuestionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => OnboardingQuestionsRecord.fromSnapshot(s));

  static Future<OnboardingQuestionsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => OnboardingQuestionsRecord.fromSnapshot(s));

  static OnboardingQuestionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      OnboardingQuestionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static OnboardingQuestionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      OnboardingQuestionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'OnboardingQuestionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is OnboardingQuestionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createOnboardingQuestionsRecordData({
  String? stableId,
  int? order,
  String? fieldKey,
  LocaleTextStruct? label,
  String? status,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'stableId': stableId,
      'order': order,
      'fieldKey': fieldKey,
      'label': LocaleTextStruct().toMap(),
      'status': status,
    }.withoutNulls,
  );

  // Handle nested data for "label" field.
  addLocaleTextStructData(firestoreData, label, 'label');

  return firestoreData;
}

class OnboardingQuestionsRecordDocumentEquality
    implements Equality<OnboardingQuestionsRecord> {
  const OnboardingQuestionsRecordDocumentEquality();

  @override
  bool equals(OnboardingQuestionsRecord? e1, OnboardingQuestionsRecord? e2) {
    return e1?.stableId == e2?.stableId &&
        e1?.order == e2?.order &&
        e1?.fieldKey == e2?.fieldKey &&
        e1?.label == e2?.label &&
        e1?.status == e2?.status;
  }

  @override
  int hash(OnboardingQuestionsRecord? e) => const ListEquality()
      .hash([e?.stableId, e?.order, e?.fieldKey, e?.label, e?.status]);

  @override
  bool isValidKey(Object? o) => o is OnboardingQuestionsRecord;
}
