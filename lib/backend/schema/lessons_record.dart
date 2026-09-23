import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Pathway lessons (subcollection)
class LessonsRecord extends FirestoreRecord {
  LessonsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "dayNumber" field.
  int? _dayNumber;
  int get dayNumber => _dayNumber ?? 0;
  bool hasDayNumber() => _dayNumber != null;

  // "title" field.
  LocaleTextStruct? _title;
  LocaleTextStruct get title => _title ?? LocaleTextStruct();
  bool hasTitle() => _title != null;

  // "scriptureRef" field.
  String? _scriptureRef;
  String get scriptureRef => _scriptureRef ?? '';
  bool hasScriptureRef() => _scriptureRef != null;

  // "scriptureText" field.
  LocaleTextStruct? _scriptureText;
  LocaleTextStruct get scriptureText => _scriptureText ?? LocaleTextStruct();
  bool hasScriptureText() => _scriptureText != null;

  // "reflectionPrompt" field.
  LocaleTextStruct? _reflectionPrompt;
  LocaleTextStruct get reflectionPrompt =>
      _reflectionPrompt ?? LocaleTextStruct();
  bool hasReflectionPrompt() => _reflectionPrompt != null;

  // "mediaUrl" field.
  String? _mediaUrl;
  String get mediaUrl => _mediaUrl ?? '';
  bool hasMediaUrl() => _mediaUrl != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  bool hasStatus() => _status != null;

  // "stableId" field.
  String? _stableId;
  String get stableId => _stableId ?? '';
  bool hasStableId() => _stableId != null;

  // "pathwayId" field.
  String? _pathwayId;
  String get pathwayId => _pathwayId ?? '';
  bool hasPathwayId() => _pathwayId != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _dayNumber = castToType<int>(snapshotData['dayNumber']);
    _title = snapshotData['title'] is LocaleTextStruct
        ? snapshotData['title']
        : LocaleTextStruct.maybeFromMap(snapshotData['title']);
    _scriptureRef = snapshotData['scriptureRef'] as String?;
    _scriptureText = snapshotData['scriptureText'] is LocaleTextStruct
        ? snapshotData['scriptureText']
        : LocaleTextStruct.maybeFromMap(snapshotData['scriptureText']);
    _reflectionPrompt = snapshotData['reflectionPrompt'] is LocaleTextStruct
        ? snapshotData['reflectionPrompt']
        : LocaleTextStruct.maybeFromMap(snapshotData['reflectionPrompt']);
    _mediaUrl = snapshotData['mediaUrl'] as String?;
    _status = snapshotData['status'] as String?;
    _stableId = snapshotData['stableId'] as String?;
    _pathwayId = snapshotData['pathwayId'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('lessons')
          : FirebaseFirestore.instance.collectionGroup('lessons');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('lessons').doc(id);

  static Stream<LessonsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => LessonsRecord.fromSnapshot(s));

  static Future<LessonsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => LessonsRecord.fromSnapshot(s));

  static LessonsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      LessonsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static LessonsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      LessonsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'LessonsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is LessonsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createLessonsRecordData({
  int? dayNumber,
  LocaleTextStruct? title,
  String? scriptureRef,
  LocaleTextStruct? scriptureText,
  LocaleTextStruct? reflectionPrompt,
  String? mediaUrl,
  String? status,
  String? stableId,
  String? pathwayId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'dayNumber': dayNumber,
      'title': LocaleTextStruct().toMap(),
      'scriptureRef': scriptureRef,
      'scriptureText': LocaleTextStruct().toMap(),
      'reflectionPrompt': LocaleTextStruct().toMap(),
      'mediaUrl': mediaUrl,
      'status': status,
      'stableId': stableId,
      'pathwayId': pathwayId,
    }.withoutNulls,
  );

  // Handle nested data for "title" field.
  addLocaleTextStructData(firestoreData, title, 'title');

  // Handle nested data for "scriptureText" field.
  addLocaleTextStructData(firestoreData, scriptureText, 'scriptureText');

  // Handle nested data for "reflectionPrompt" field.
  addLocaleTextStructData(firestoreData, reflectionPrompt, 'reflectionPrompt');

  return firestoreData;
}

class LessonsRecordDocumentEquality implements Equality<LessonsRecord> {
  const LessonsRecordDocumentEquality();

  @override
  bool equals(LessonsRecord? e1, LessonsRecord? e2) {
    return e1?.dayNumber == e2?.dayNumber &&
        e1?.title == e2?.title &&
        e1?.scriptureRef == e2?.scriptureRef &&
        e1?.scriptureText == e2?.scriptureText &&
        e1?.reflectionPrompt == e2?.reflectionPrompt &&
        e1?.mediaUrl == e2?.mediaUrl &&
        e1?.status == e2?.status &&
        e1?.stableId == e2?.stableId &&
        e1?.pathwayId == e2?.pathwayId;
  }

  @override
  int hash(LessonsRecord? e) => const ListEquality().hash([
        e?.dayNumber,
        e?.title,
        e?.scriptureRef,
        e?.scriptureText,
        e?.reflectionPrompt,
        e?.mediaUrl,
        e?.status,
        e?.stableId,
        e?.pathwayId
      ]);

  @override
  bool isValidKey(Object? o) => o is LessonsRecord;
}
