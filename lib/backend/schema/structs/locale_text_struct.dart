// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';
// Hand edit (keep after FlutterFlow sync): machine translation fallback.
import '/custom_code/languages/translation_service.dart';
import 'package:collection/collection.dart' show MapEquality;

/// DSL struct LocaleText
class LocaleTextStruct extends FFFirebaseStruct {
  LocaleTextStruct({
    /// LocaleText.en
    String? en,

    /// LocaleText.es
    String? es,

    /// LocaleText.ur
    String? ur,
    String? lg,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _en = en,
        _es = es,
        _ur = ur,
        _lg = lg,
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

  // "lg" field.
  String? _lg;
  String get lg => _lg ?? '';
  set lg(String? val) => _lg = val;

  bool hasLg() => _lg != null;

  // ---- Hand edits (keep after FlutterFlow sync) -------------------------
  // Languages added in the CMS (e.g. 'fr') are kept from the Firestore map
  // in [_extra], so new languages need no regenerated struct.
  Map<String, String> _extra = {};
  Map<String, String> get extraLanguages => Map.unmodifiable(_extra);
  void setLanguage(String code, String? text) {
    switch (code) {
      case 'en':
        _en = text;
      case 'es':
        _es = text;
      case 'ur':
        _ur = text;
      case 'lg':
        _lg = text;
      default:
        if (text == null || text.isEmpty) {
          _extra.remove(code);
        } else {
          _extra[code] = text;
        }
    }
  }

  static final _languageKey = RegExp(r'^[a-z]{2,3}([_-][A-Za-z]{2,4})?$');

  /// Text stored for [languageCode] in the content itself ('' if none).
  String storedText(String? languageCode) => switch (languageCode) {
        null || '' || 'en' => en,
        'es' => es,
        'ur' => ur,
        'lg' => lg,
        _ => _extra[languageCode] ?? '',
      };

  /// The text for [languageCode]: stored translation, else the cached
  /// (reviewed or machine) translation of the English text, else English,
  /// so the member never sees a blank. Kingdom Heirs-authored text only;
  /// use [scriptureForLanguage] for Scripture.
  String forLanguage(String? languageCode) {
    final text = storedText(languageCode);
    if (text.isNotEmpty) {
      return text;
    }
    return TranslationService.instance.translate(en, languageCode);
  }

  /// Scripture text: stored translation or English, never machine-translated.
  String scriptureForLanguage(String? languageCode) {
    final text = storedText(languageCode);
    return text.isNotEmpty ? text : en;
  }

  /// True when [forLanguage] shows unreviewed machine translation.
  bool isMachineTranslated(String? languageCode) =>
      storedText(languageCode).isEmpty &&
      en.isNotEmpty &&
      TranslationService.instance.isMachine(en, languageCode);

  /// True when [forLanguage] shows the English text for another language.
  bool isEnglishFallback(String? languageCode) =>
      (languageCode ?? 'en') != 'en' &&
      en.isNotEmpty &&
      forLanguage(languageCode) == en;
  // ---- End hand edits ---------------------------------------------------

  static LocaleTextStruct fromMap(Map<String, dynamic> data) =>
      LocaleTextStruct(
        en: data['en'] as String?,
        es: data['es'] as String?,
        ur: data['ur'] as String?,
        lg: data['lg'] as String?,
      ).._extra = _extraFrom(data);

  // Hand edit: keep every other language key from the map.
  static Map<String, String> _extraFrom(Map<String, dynamic> data) => {
        for (final e in data.entries)
          if (!const {'en', 'es', 'ur', 'lg'}.contains(e.key) &&
              _languageKey.hasMatch(e.key) &&
              e.value is String &&
              (e.value as String).isNotEmpty)
            e.key: e.value as String,
      };

  static LocaleTextStruct? maybeFromMap(dynamic data) => data is Map
      ? LocaleTextStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'en': _en,
        'es': _es,
        'ur': _ur,
        'lg': _lg,
        ..._extra, // Hand edit: CMS-added languages.
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
        'lg': serializeParam(
          _lg,
          ParamType.String,
        ),
        ..._extra, // Hand edit: CMS-added languages.
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
        lg: deserializeParam(
          data['lg'],
          ParamType.String,
          false,
        ),
      ).._extra = _extraFrom(data); // Hand edit: CMS-added languages.

  @override
  String toString() => 'LocaleTextStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LocaleTextStruct &&
        en == other.en &&
        es == other.es &&
        ur == other.ur &&
        lg == other.lg &&
        const MapEquality().equals(_extra, other._extra);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([en, es, ur, lg, const MapEquality().hash(_extra)]);
}

LocaleTextStruct createLocaleTextStruct({
  String? en,
  String? es,
  String? ur,
  String? lg,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    LocaleTextStruct(
      en: en,
      es: es,
      ur: ur,
      lg: lg,
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
