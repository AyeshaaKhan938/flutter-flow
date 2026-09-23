// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct LocaleText
class LocaleTextStruct extends FFFirebaseStruct {
  LocaleTextStruct({
    /// LocaleText.en
    String? en,

    /// LocaleText.es
    String? es,

    /// LocaleText.ur
    String? ur,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _en = en,
        _es = es,
        _ur = ur,
        super(firestoreUtilData);

  // "en" field.
  String? _en;
  String get en => _en ?? '';
  set en(String? val) => _en = val;

  bool hasEn() => _en != null;

  // "es" field.
  String? _es;
  String get es => _es ?? '';
  set es(String? val) => _es = val;

  bool hasEs() => _es != null;

  // "ur" field.
  String? _ur;
  String get ur => _ur ?? '';
  set ur(String? val) => _ur = val;

  bool hasUr() => _ur != null;

  static LocaleTextStruct fromMap(Map<String, dynamic> data) =>
      LocaleTextStruct(
        en: data['en'] as String?,
        es: data['es'] as String?,
        ur: data['ur'] as String?,
      );

  static LocaleTextStruct? maybeFromMap(dynamic data) => data is Map
      ? LocaleTextStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'en': _en,
        'es': _es,
        'ur': _ur,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'en': serializeParam(
          _en,
          ParamType.String,
        ),
        'es': serializeParam(
          _es,
          ParamType.String,
        ),
        'ur': serializeParam(
          _ur,
          ParamType.String,
        ),
      }.withoutNulls;

  static LocaleTextStruct fromSerializableMap(Map<String, dynamic> data) =>
      LocaleTextStruct(
        en: deserializeParam(
          data['en'],
          ParamType.String,
          false,
        ),
        es: deserializeParam(
          data['es'],
          ParamType.String,
          false,
        ),
        ur: deserializeParam(
          data['ur'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'LocaleTextStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LocaleTextStruct &&
        en == other.en &&
        es == other.es &&
        ur == other.ur;
  }

  @override
  int get hashCode => const ListEquality().hash([en, es, ur]);
}

LocaleTextStruct createLocaleTextStruct({
  String? en,
  String? es,
  String? ur,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LocaleTextStruct(
      en: en,
      es: es,
      ur: ur,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

LocaleTextStruct? updateLocaleTextStruct(
  LocaleTextStruct? localeText, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    localeText
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addLocaleTextStructData(
  Map<String, dynamic> firestoreData,
  LocaleTextStruct? localeText,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (localeText == null) {
    return;
  }
  if (localeText.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && localeText.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final localeTextData = getLocaleTextFirestoreData(localeText, forFieldValue);
  final nestedData = localeTextData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = localeText.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getLocaleTextFirestoreData(
  LocaleTextStruct? localeText, [
  bool forFieldValue = false,
]) {
  if (localeText == null) {
    return {};
  }
  final firestoreData = mapToFirestore(localeText.toMap());

  // Add any Firestore field values
  mapToFirestore(localeText.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getLocaleTextListFirestoreData(
  List<LocaleTextStruct>? localeTexts,
) =>
    localeTexts?.map((e) => getLocaleTextFirestoreData(e, true)).toList() ?? [];
