// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

/// DSL struct AssessmentQuestionsFlatResponse
class AssessmentQuestionsFlatResponseStruct extends FFFirebaseStruct {
  AssessmentQuestionsFlatResponseStruct({
    /// AssessmentQuestionsFlatResponse.q1Label
    String? q1Label,

    /// AssessmentQuestionsFlatResponse.q1A
    String? q1A,

    /// AssessmentQuestionsFlatResponse.q1B
    String? q1B,

    /// AssessmentQuestionsFlatResponse.q1C
    String? q1C,

    /// AssessmentQuestionsFlatResponse.q1D
    String? q1D,

    /// AssessmentQuestionsFlatResponse.q2Label
    String? q2Label,

    /// AssessmentQuestionsFlatResponse.q2A
    String? q2A,

    /// AssessmentQuestionsFlatResponse.q2B
    String? q2B,

    /// AssessmentQuestionsFlatResponse.q2C
    String? q2C,

    /// AssessmentQuestionsFlatResponse.q2D
    String? q2D,

    /// AssessmentQuestionsFlatResponse.q3Label
    String? q3Label,

    /// AssessmentQuestionsFlatResponse.q3A
    String? q3A,

    /// AssessmentQuestionsFlatResponse.q3B
    String? q3B,

    /// AssessmentQuestionsFlatResponse.q3C
    String? q3C,

    /// AssessmentQuestionsFlatResponse.q3D
    String? q3D,

    /// AssessmentQuestionsFlatResponse.q4Label
    String? q4Label,

    /// AssessmentQuestionsFlatResponse.q4A
    String? q4A,

    /// AssessmentQuestionsFlatResponse.q4B
    String? q4B,

    /// AssessmentQuestionsFlatResponse.q4C
    String? q4C,

    /// AssessmentQuestionsFlatResponse.q4D
    String? q4D,

    /// AssessmentQuestionsFlatResponse.q5Label
    String? q5Label,

    /// AssessmentQuestionsFlatResponse.q5A
    String? q5A,

    /// AssessmentQuestionsFlatResponse.q5B
    String? q5B,

    /// AssessmentQuestionsFlatResponse.q5C
    String? q5C,

    /// AssessmentQuestionsFlatResponse.q5D
    String? q5D,

    /// AssessmentQuestionsFlatResponse.q6Label
    String? q6Label,

    /// AssessmentQuestionsFlatResponse.q6A
    String? q6A,

    /// AssessmentQuestionsFlatResponse.q6B
    String? q6B,

    /// AssessmentQuestionsFlatResponse.q6C
    String? q6C,

    /// AssessmentQuestionsFlatResponse.q6D
    String? q6D,

    /// AssessmentQuestionsFlatResponse.q7Label
    String? q7Label,

    /// AssessmentQuestionsFlatResponse.q7A
    String? q7A,

    /// AssessmentQuestionsFlatResponse.q7B
    String? q7B,

    /// AssessmentQuestionsFlatResponse.q7C
    String? q7C,

    /// AssessmentQuestionsFlatResponse.q7D
    String? q7D,

    /// AssessmentQuestionsFlatResponse.q8Label
    String? q8Label,

    /// AssessmentQuestionsFlatResponse.q8A
    String? q8A,

    /// AssessmentQuestionsFlatResponse.q8B
    String? q8B,

    /// AssessmentQuestionsFlatResponse.q8C
    String? q8C,

    /// AssessmentQuestionsFlatResponse.q8D
    String? q8D,

    /// AssessmentQuestionsFlatResponse.q9Label
    String? q9Label,

    /// AssessmentQuestionsFlatResponse.q9A
    String? q9A,

    /// AssessmentQuestionsFlatResponse.q9B
    String? q9B,

    /// AssessmentQuestionsFlatResponse.q9C
    String? q9C,

    /// AssessmentQuestionsFlatResponse.q9D
    String? q9D,

    /// AssessmentQuestionsFlatResponse.q10Label
    String? q10Label,

    /// AssessmentQuestionsFlatResponse.q10A
    String? q10A,

    /// AssessmentQuestionsFlatResponse.q10B
    String? q10B,

    /// AssessmentQuestionsFlatResponse.q10C
    String? q10C,

    /// AssessmentQuestionsFlatResponse.q10D
    String? q10D,

    /// AssessmentQuestionsFlatResponse.count
    int? count,

    /// AssessmentQuestionsFlatResponse.locale
    String? locale,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _q1Label = q1Label,
        _q1A = q1A,
        _q1B = q1B,
        _q1C = q1C,
        _q1D = q1D,
        _q2Label = q2Label,
        _q2A = q2A,
        _q2B = q2B,
        _q2C = q2C,
        _q2D = q2D,
        _q3Label = q3Label,
        _q3A = q3A,
        _q3B = q3B,
        _q3C = q3C,
        _q3D = q3D,
        _q4Label = q4Label,
        _q4A = q4A,
        _q4B = q4B,
        _q4C = q4C,
        _q4D = q4D,
        _q5Label = q5Label,
        _q5A = q5A,
        _q5B = q5B,
        _q5C = q5C,
        _q5D = q5D,
        _q6Label = q6Label,
        _q6A = q6A,
        _q6B = q6B,
        _q6C = q6C,
        _q6D = q6D,
        _q7Label = q7Label,
        _q7A = q7A,
        _q7B = q7B,
        _q7C = q7C,
        _q7D = q7D,
        _q8Label = q8Label,
        _q8A = q8A,
        _q8B = q8B,
        _q8C = q8C,
        _q8D = q8D,
        _q9Label = q9Label,
        _q9A = q9A,
        _q9B = q9B,
        _q9C = q9C,
        _q9D = q9D,
        _q10Label = q10Label,
        _q10A = q10A,
        _q10B = q10B,
        _q10C = q10C,
        _q10D = q10D,
        _count = count,
        _locale = locale,
        super(firestoreUtilData);

  // "q1Label" field.
  String? _q1Label;
  String get q1Label => _q1Label ?? '';
  set q1Label(String? val) => _q1Label = val;

  bool hasQ1Label() => _q1Label != null;

  // "q1A" field.
  String? _q1A;
  String get q1A => _q1A ?? '';
  set q1A(String? val) => _q1A = val;

  bool hasQ1A() => _q1A != null;

  // "q1B" field.
  String? _q1B;
  String get q1B => _q1B ?? '';
  set q1B(String? val) => _q1B = val;

  bool hasQ1B() => _q1B != null;

  // "q1C" field.
  String? _q1C;
  String get q1C => _q1C ?? '';
  set q1C(String? val) => _q1C = val;

  bool hasQ1C() => _q1C != null;

  // "q1D" field.
  String? _q1D;
  String get q1D => _q1D ?? '';
  set q1D(String? val) => _q1D = val;

  bool hasQ1D() => _q1D != null;

  // "q2Label" field.
  String? _q2Label;
  String get q2Label => _q2Label ?? '';
  set q2Label(String? val) => _q2Label = val;

  bool hasQ2Label() => _q2Label != null;

  // "q2A" field.
  String? _q2A;
  String get q2A => _q2A ?? '';
  set q2A(String? val) => _q2A = val;

  bool hasQ2A() => _q2A != null;

  // "q2B" field.
  String? _q2B;
  String get q2B => _q2B ?? '';
  set q2B(String? val) => _q2B = val;

  bool hasQ2B() => _q2B != null;

  // "q2C" field.
  String? _q2C;
  String get q2C => _q2C ?? '';
  set q2C(String? val) => _q2C = val;

  bool hasQ2C() => _q2C != null;

  // "q2D" field.
  String? _q2D;
  String get q2D => _q2D ?? '';
  set q2D(String? val) => _q2D = val;

  bool hasQ2D() => _q2D != null;

  // "q3Label" field.
  String? _q3Label;
  String get q3Label => _q3Label ?? '';
  set q3Label(String? val) => _q3Label = val;

  bool hasQ3Label() => _q3Label != null;

  // "q3A" field.
  String? _q3A;
  String get q3A => _q3A ?? '';
  set q3A(String? val) => _q3A = val;

  bool hasQ3A() => _q3A != null;

  // "q3B" field.
  String? _q3B;
  String get q3B => _q3B ?? '';
  set q3B(String? val) => _q3B = val;

  bool hasQ3B() => _q3B != null;

  // "q3C" field.
  String? _q3C;
  String get q3C => _q3C ?? '';
  set q3C(String? val) => _q3C = val;

  bool hasQ3C() => _q3C != null;

  // "q3D" field.
  String? _q3D;
  String get q3D => _q3D ?? '';
  set q3D(String? val) => _q3D = val;

  bool hasQ3D() => _q3D != null;

  // "q4Label" field.
  String? _q4Label;
  String get q4Label => _q4Label ?? '';
  set q4Label(String? val) => _q4Label = val;

  bool hasQ4Label() => _q4Label != null;

  // "q4A" field.
  String? _q4A;
  String get q4A => _q4A ?? '';
  set q4A(String? val) => _q4A = val;

  bool hasQ4A() => _q4A != null;

  // "q4B" field.
  String? _q4B;
  String get q4B => _q4B ?? '';
  set q4B(String? val) => _q4B = val;

  bool hasQ4B() => _q4B != null;

  // "q4C" field.
  String? _q4C;
  String get q4C => _q4C ?? '';
  set q4C(String? val) => _q4C = val;

  bool hasQ4C() => _q4C != null;

  // "q4D" field.
  String? _q4D;
  String get q4D => _q4D ?? '';
  set q4D(String? val) => _q4D = val;

  bool hasQ4D() => _q4D != null;

  // "q5Label" field.
  String? _q5Label;
  String get q5Label => _q5Label ?? '';
  set q5Label(String? val) => _q5Label = val;

  bool hasQ5Label() => _q5Label != null;

  // "q5A" field.
  String? _q5A;
  String get q5A => _q5A ?? '';
  set q5A(String? val) => _q5A = val;

  bool hasQ5A() => _q5A != null;

  // "q5B" field.
  String? _q5B;
  String get q5B => _q5B ?? '';
  set q5B(String? val) => _q5B = val;

  bool hasQ5B() => _q5B != null;

  // "q5C" field.
  String? _q5C;
  String get q5C => _q5C ?? '';
  set q5C(String? val) => _q5C = val;

  bool hasQ5C() => _q5C != null;

  // "q5D" field.
  String? _q5D;
  String get q5D => _q5D ?? '';
  set q5D(String? val) => _q5D = val;

  bool hasQ5D() => _q5D != null;

  // "q6Label" field.
  String? _q6Label;
  String get q6Label => _q6Label ?? '';
  set q6Label(String? val) => _q6Label = val;

  bool hasQ6Label() => _q6Label != null;

  // "q6A" field.
  String? _q6A;
  String get q6A => _q6A ?? '';
  set q6A(String? val) => _q6A = val;

  bool hasQ6A() => _q6A != null;

  // "q6B" field.
  String? _q6B;
  String get q6B => _q6B ?? '';
  set q6B(String? val) => _q6B = val;

  bool hasQ6B() => _q6B != null;

  // "q6C" field.
  String? _q6C;
  String get q6C => _q6C ?? '';
  set q6C(String? val) => _q6C = val;

  bool hasQ6C() => _q6C != null;

  // "q6D" field.
  String? _q6D;
  String get q6D => _q6D ?? '';
  set q6D(String? val) => _q6D = val;

  bool hasQ6D() => _q6D != null;

  // "q7Label" field.
  String? _q7Label;
  String get q7Label => _q7Label ?? '';
  set q7Label(String? val) => _q7Label = val;

  bool hasQ7Label() => _q7Label != null;

  // "q7A" field.
  String? _q7A;
  String get q7A => _q7A ?? '';
  set q7A(String? val) => _q7A = val;

  bool hasQ7A() => _q7A != null;

  // "q7B" field.
  String? _q7B;
  String get q7B => _q7B ?? '';
  set q7B(String? val) => _q7B = val;

  bool hasQ7B() => _q7B != null;

  // "q7C" field.
  String? _q7C;
  String get q7C => _q7C ?? '';
  set q7C(String? val) => _q7C = val;

  bool hasQ7C() => _q7C != null;

  // "q7D" field.
  String? _q7D;
  String get q7D => _q7D ?? '';
  set q7D(String? val) => _q7D = val;

  bool hasQ7D() => _q7D != null;

  // "q8Label" field.
  String? _q8Label;
  String get q8Label => _q8Label ?? '';
  set q8Label(String? val) => _q8Label = val;

  bool hasQ8Label() => _q8Label != null;

  // "q8A" field.
  String? _q8A;
  String get q8A => _q8A ?? '';
  set q8A(String? val) => _q8A = val;

  bool hasQ8A() => _q8A != null;

  // "q8B" field.
  String? _q8B;
  String get q8B => _q8B ?? '';
  set q8B(String? val) => _q8B = val;

  bool hasQ8B() => _q8B != null;

  // "q8C" field.
  String? _q8C;
  String get q8C => _q8C ?? '';
  set q8C(String? val) => _q8C = val;

  bool hasQ8C() => _q8C != null;

  // "q8D" field.
  String? _q8D;
  String get q8D => _q8D ?? '';
  set q8D(String? val) => _q8D = val;

  bool hasQ8D() => _q8D != null;

  // "q9Label" field.
  String? _q9Label;
  String get q9Label => _q9Label ?? '';
  set q9Label(String? val) => _q9Label = val;

  bool hasQ9Label() => _q9Label != null;

  // "q9A" field.
  String? _q9A;
  String get q9A => _q9A ?? '';
  set q9A(String? val) => _q9A = val;

  bool hasQ9A() => _q9A != null;

  // "q9B" field.
  String? _q9B;
  String get q9B => _q9B ?? '';
  set q9B(String? val) => _q9B = val;

  bool hasQ9B() => _q9B != null;

  // "q9C" field.
  String? _q9C;
  String get q9C => _q9C ?? '';
  set q9C(String? val) => _q9C = val;

  bool hasQ9C() => _q9C != null;

  // "q9D" field.
  String? _q9D;
  String get q9D => _q9D ?? '';
  set q9D(String? val) => _q9D = val;

  bool hasQ9D() => _q9D != null;

  // "q10Label" field.
  String? _q10Label;
  String get q10Label => _q10Label ?? '';
  set q10Label(String? val) => _q10Label = val;

  bool hasQ10Label() => _q10Label != null;

  // "q10A" field.
  String? _q10A;
  String get q10A => _q10A ?? '';
  set q10A(String? val) => _q10A = val;

  bool hasQ10A() => _q10A != null;

  // "q10B" field.
  String? _q10B;
  String get q10B => _q10B ?? '';
  set q10B(String? val) => _q10B = val;

  bool hasQ10B() => _q10B != null;

  // "q10C" field.
  String? _q10C;
  String get q10C => _q10C ?? '';
  set q10C(String? val) => _q10C = val;

  bool hasQ10C() => _q10C != null;

  // "q10D" field.
  String? _q10D;
  String get q10D => _q10D ?? '';
  set q10D(String? val) => _q10D = val;

  bool hasQ10D() => _q10D != null;

  // "count" field.
  int? _count;
  int get count => _count ?? 0;
  set count(int? val) => _count = val;

  void incrementCount(int amount) => count = count + amount;

  bool hasCount() => _count != null;

  // "locale" field.
  String? _locale;
  String get locale => _locale ?? '';
  set locale(String? val) => _locale = val;

  bool hasLocale() => _locale != null;

  static AssessmentQuestionsFlatResponseStruct fromMap(
          Map<String, dynamic> data) =>
      AssessmentQuestionsFlatResponseStruct(
        q1Label: data['q1Label'] as String?,
        q1A: data['q1A'] as String?,
        q1B: data['q1B'] as String?,
        q1C: data['q1C'] as String?,
        q1D: data['q1D'] as String?,
        q2Label: data['q2Label'] as String?,
        q2A: data['q2A'] as String?,
        q2B: data['q2B'] as String?,
        q2C: data['q2C'] as String?,
        q2D: data['q2D'] as String?,
        q3Label: data['q3Label'] as String?,
        q3A: data['q3A'] as String?,
        q3B: data['q3B'] as String?,
        q3C: data['q3C'] as String?,
        q3D: data['q3D'] as String?,
        q4Label: data['q4Label'] as String?,
        q4A: data['q4A'] as String?,
        q4B: data['q4B'] as String?,
        q4C: data['q4C'] as String?,
        q4D: data['q4D'] as String?,
        q5Label: data['q5Label'] as String?,
        q5A: data['q5A'] as String?,
        q5B: data['q5B'] as String?,
        q5C: data['q5C'] as String?,
        q5D: data['q5D'] as String?,
        q6Label: data['q6Label'] as String?,
        q6A: data['q6A'] as String?,
        q6B: data['q6B'] as String?,
        q6C: data['q6C'] as String?,
        q6D: data['q6D'] as String?,
        q7Label: data['q7Label'] as String?,
        q7A: data['q7A'] as String?,
        q7B: data['q7B'] as String?,
        q7C: data['q7C'] as String?,
        q7D: data['q7D'] as String?,
        q8Label: data['q8Label'] as String?,
        q8A: data['q8A'] as String?,
        q8B: data['q8B'] as String?,
        q8C: data['q8C'] as String?,
        q8D: data['q8D'] as String?,
        q9Label: data['q9Label'] as String?,
        q9A: data['q9A'] as String?,
        q9B: data['q9B'] as String?,
        q9C: data['q9C'] as String?,
        q9D: data['q9D'] as String?,
        q10Label: data['q10Label'] as String?,
        q10A: data['q10A'] as String?,
        q10B: data['q10B'] as String?,
        q10C: data['q10C'] as String?,
        q10D: data['q10D'] as String?,
        count: castToType<int>(data['count']),
        locale: data['locale'] as String?,
      );

  static AssessmentQuestionsFlatResponseStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? AssessmentQuestionsFlatResponseStruct.fromMap(
              data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'q1Label': _q1Label,
        'q1A': _q1A,
        'q1B': _q1B,
        'q1C': _q1C,
        'q1D': _q1D,
        'q2Label': _q2Label,
        'q2A': _q2A,
        'q2B': _q2B,
        'q2C': _q2C,
        'q2D': _q2D,
        'q3Label': _q3Label,
        'q3A': _q3A,
        'q3B': _q3B,
        'q3C': _q3C,
        'q3D': _q3D,
        'q4Label': _q4Label,
        'q4A': _q4A,
        'q4B': _q4B,
        'q4C': _q4C,
        'q4D': _q4D,
        'q5Label': _q5Label,
        'q5A': _q5A,
        'q5B': _q5B,
        'q5C': _q5C,
        'q5D': _q5D,
        'q6Label': _q6Label,
        'q6A': _q6A,
        'q6B': _q6B,
        'q6C': _q6C,
        'q6D': _q6D,
        'q7Label': _q7Label,
        'q7A': _q7A,
        'q7B': _q7B,
        'q7C': _q7C,
        'q7D': _q7D,
        'q8Label': _q8Label,
        'q8A': _q8A,
        'q8B': _q8B,
        'q8C': _q8C,
        'q8D': _q8D,
        'q9Label': _q9Label,
        'q9A': _q9A,
        'q9B': _q9B,
        'q9C': _q9C,
        'q9D': _q9D,
        'q10Label': _q10Label,
        'q10A': _q10A,
        'q10B': _q10B,
        'q10C': _q10C,
        'q10D': _q10D,
        'count': _count,
        'locale': _locale,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'q1Label': serializeParam(
          _q1Label,
          ParamType.String,
        ),
        'q1A': serializeParam(
          _q1A,
          ParamType.String,
        ),
        'q1B': serializeParam(
          _q1B,
          ParamType.String,
        ),
        'q1C': serializeParam(
          _q1C,
          ParamType.String,
        ),
        'q1D': serializeParam(
          _q1D,
          ParamType.String,
        ),
        'q2Label': serializeParam(
          _q2Label,
          ParamType.String,
        ),
        'q2A': serializeParam(
          _q2A,
          ParamType.String,
        ),
        'q2B': serializeParam(
          _q2B,
          ParamType.String,
        ),
        'q2C': serializeParam(
          _q2C,
          ParamType.String,
        ),
        'q2D': serializeParam(
          _q2D,
          ParamType.String,
        ),
        'q3Label': serializeParam(
          _q3Label,
          ParamType.String,
        ),
        'q3A': serializeParam(
          _q3A,
          ParamType.String,
        ),
        'q3B': serializeParam(
          _q3B,
          ParamType.String,
        ),
        'q3C': serializeParam(
          _q3C,
          ParamType.String,
        ),
        'q3D': serializeParam(
          _q3D,
          ParamType.String,
        ),
        'q4Label': serializeParam(
          _q4Label,
          ParamType.String,
        ),
        'q4A': serializeParam(
          _q4A,
          ParamType.String,
        ),
        'q4B': serializeParam(
          _q4B,
          ParamType.String,
        ),
        'q4C': serializeParam(
          _q4C,
          ParamType.String,
        ),
        'q4D': serializeParam(
          _q4D,
          ParamType.String,
        ),
        'q5Label': serializeParam(
          _q5Label,
          ParamType.String,
        ),
        'q5A': serializeParam(
          _q5A,
          ParamType.String,
        ),
        'q5B': serializeParam(
          _q5B,
          ParamType.String,
        ),
        'q5C': serializeParam(
          _q5C,
          ParamType.String,
        ),
        'q5D': serializeParam(
          _q5D,
          ParamType.String,
        ),
        'q6Label': serializeParam(
          _q6Label,
          ParamType.String,
        ),
        'q6A': serializeParam(
          _q6A,
          ParamType.String,
        ),
        'q6B': serializeParam(
          _q6B,
          ParamType.String,
        ),
        'q6C': serializeParam(
          _q6C,
          ParamType.String,
        ),
        'q6D': serializeParam(
          _q6D,
          ParamType.String,
        ),
        'q7Label': serializeParam(
          _q7Label,
          ParamType.String,
        ),
        'q7A': serializeParam(
          _q7A,
          ParamType.String,
        ),
        'q7B': serializeParam(
          _q7B,
          ParamType.String,
        ),
        'q7C': serializeParam(
          _q7C,
          ParamType.String,
        ),
        'q7D': serializeParam(
          _q7D,
          ParamType.String,
        ),
        'q8Label': serializeParam(
          _q8Label,
          ParamType.String,
        ),
        'q8A': serializeParam(
          _q8A,
          ParamType.String,
        ),
        'q8B': serializeParam(
          _q8B,
          ParamType.String,
        ),
        'q8C': serializeParam(
          _q8C,
          ParamType.String,
        ),
        'q8D': serializeParam(
          _q8D,
          ParamType.String,
        ),
        'q9Label': serializeParam(
          _q9Label,
          ParamType.String,
        ),
        'q9A': serializeParam(
          _q9A,
          ParamType.String,
        ),
        'q9B': serializeParam(
          _q9B,
          ParamType.String,
        ),
        'q9C': serializeParam(
          _q9C,
          ParamType.String,
        ),
        'q9D': serializeParam(
          _q9D,
          ParamType.String,
        ),
        'q10Label': serializeParam(
          _q10Label,
          ParamType.String,
        ),
        'q10A': serializeParam(
          _q10A,
          ParamType.String,
        ),
        'q10B': serializeParam(
          _q10B,
          ParamType.String,
        ),
        'q10C': serializeParam(
          _q10C,
          ParamType.String,
        ),
        'q10D': serializeParam(
          _q10D,
          ParamType.String,
        ),
        'count': serializeParam(
          _count,
          ParamType.int,
        ),
        'locale': serializeParam(
          _locale,
          ParamType.String,
        ),
      }.withoutNulls;

  static AssessmentQuestionsFlatResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AssessmentQuestionsFlatResponseStruct(
        q1Label: deserializeParam(
          data['q1Label'],
          ParamType.String,
          false,
        ),
        q1A: deserializeParam(
          data['q1A'],
          ParamType.String,
          false,
        ),
        q1B: deserializeParam(
          data['q1B'],
          ParamType.String,
          false,
        ),
        q1C: deserializeParam(
          data['q1C'],
          ParamType.String,
          false,
        ),
        q1D: deserializeParam(
          data['q1D'],
          ParamType.String,
          false,
        ),
        q2Label: deserializeParam(
          data['q2Label'],
          ParamType.String,
          false,
        ),
        q2A: deserializeParam(
          data['q2A'],
          ParamType.String,
          false,
        ),
        q2B: deserializeParam(
          data['q2B'],
          ParamType.String,
          false,
        ),
        q2C: deserializeParam(
          data['q2C'],
          ParamType.String,
          false,
        ),
        q2D: deserializeParam(
          data['q2D'],
          ParamType.String,
          false,
        ),
        q3Label: deserializeParam(
          data['q3Label'],
          ParamType.String,
          false,
        ),
        q3A: deserializeParam(
          data['q3A'],
          ParamType.String,
          false,
        ),
        q3B: deserializeParam(
          data['q3B'],
          ParamType.String,
          false,
        ),
        q3C: deserializeParam(
          data['q3C'],
          ParamType.String,
          false,
        ),
        q3D: deserializeParam(
          data['q3D'],
          ParamType.String,
          false,
        ),
        q4Label: deserializeParam(
          data['q4Label'],
          ParamType.String,
          false,
        ),
        q4A: deserializeParam(
          data['q4A'],
          ParamType.String,
          false,
        ),
        q4B: deserializeParam(
          data['q4B'],
          ParamType.String,
          false,
        ),
        q4C: deserializeParam(
          data['q4C'],
          ParamType.String,
          false,
        ),
        q4D: deserializeParam(
          data['q4D'],
          ParamType.String,
          false,
        ),
        q5Label: deserializeParam(
          data['q5Label'],
          ParamType.String,
          false,
        ),
        q5A: deserializeParam(
          data['q5A'],
          ParamType.String,
          false,
        ),
        q5B: deserializeParam(
          data['q5B'],
          ParamType.String,
          false,
        ),
        q5C: deserializeParam(
          data['q5C'],
          ParamType.String,
          false,
        ),
        q5D: deserializeParam(
          data['q5D'],
          ParamType.String,
          false,
        ),
        q6Label: deserializeParam(
          data['q6Label'],
          ParamType.String,
          false,
        ),
        q6A: deserializeParam(
          data['q6A'],
          ParamType.String,
          false,
        ),
        q6B: deserializeParam(
          data['q6B'],
          ParamType.String,
          false,
        ),
        q6C: deserializeParam(
          data['q6C'],
          ParamType.String,
          false,
        ),
        q6D: deserializeParam(
          data['q6D'],
          ParamType.String,
          false,
        ),
        q7Label: deserializeParam(
          data['q7Label'],
          ParamType.String,
          false,
        ),
        q7A: deserializeParam(
          data['q7A'],
          ParamType.String,
          false,
        ),
        q7B: deserializeParam(
          data['q7B'],
          ParamType.String,
          false,
        ),
        q7C: deserializeParam(
          data['q7C'],
          ParamType.String,
          false,
        ),
        q7D: deserializeParam(
          data['q7D'],
          ParamType.String,
          false,
        ),
        q8Label: deserializeParam(
          data['q8Label'],
          ParamType.String,
          false,
        ),
        q8A: deserializeParam(
          data['q8A'],
          ParamType.String,
          false,
        ),
        q8B: deserializeParam(
          data['q8B'],
          ParamType.String,
          false,
        ),
        q8C: deserializeParam(
          data['q8C'],
          ParamType.String,
          false,
        ),
        q8D: deserializeParam(
          data['q8D'],
          ParamType.String,
          false,
        ),
        q9Label: deserializeParam(
          data['q9Label'],
          ParamType.String,
          false,
        ),
        q9A: deserializeParam(
          data['q9A'],
          ParamType.String,
          false,
        ),
        q9B: deserializeParam(
          data['q9B'],
          ParamType.String,
          false,
        ),
        q9C: deserializeParam(
          data['q9C'],
          ParamType.String,
          false,
        ),
        q9D: deserializeParam(
          data['q9D'],
          ParamType.String,
          false,
        ),
        q10Label: deserializeParam(
          data['q10Label'],
          ParamType.String,
          false,
        ),
        q10A: deserializeParam(
          data['q10A'],
          ParamType.String,
          false,
        ),
        q10B: deserializeParam(
          data['q10B'],
          ParamType.String,
          false,
        ),
        q10C: deserializeParam(
          data['q10C'],
          ParamType.String,
          false,
        ),
        q10D: deserializeParam(
          data['q10D'],
          ParamType.String,
          false,
        ),
        count: deserializeParam(
          data['count'],
          ParamType.int,
          false,
        ),
        locale: deserializeParam(
          data['locale'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AssessmentQuestionsFlatResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AssessmentQuestionsFlatResponseStruct &&
        q1Label == other.q1Label &&
        q1A == other.q1A &&
        q1B == other.q1B &&
        q1C == other.q1C &&
        q1D == other.q1D &&
        q2Label == other.q2Label &&
        q2A == other.q2A &&
        q2B == other.q2B &&
        q2C == other.q2C &&
        q2D == other.q2D &&
        q3Label == other.q3Label &&
        q3A == other.q3A &&
        q3B == other.q3B &&
        q3C == other.q3C &&
        q3D == other.q3D &&
        q4Label == other.q4Label &&
        q4A == other.q4A &&
        q4B == other.q4B &&
        q4C == other.q4C &&
        q4D == other.q4D &&
        q5Label == other.q5Label &&
        q5A == other.q5A &&
        q5B == other.q5B &&
        q5C == other.q5C &&
        q5D == other.q5D &&
        q6Label == other.q6Label &&
        q6A == other.q6A &&
        q6B == other.q6B &&
        q6C == other.q6C &&
        q6D == other.q6D &&
        q7Label == other.q7Label &&
        q7A == other.q7A &&
        q7B == other.q7B &&
        q7C == other.q7C &&
        q7D == other.q7D &&
        q8Label == other.q8Label &&
        q8A == other.q8A &&
        q8B == other.q8B &&
        q8C == other.q8C &&
        q8D == other.q8D &&
        q9Label == other.q9Label &&
        q9A == other.q9A &&
        q9B == other.q9B &&
        q9C == other.q9C &&
        q9D == other.q9D &&
        q10Label == other.q10Label &&
        q10A == other.q10A &&
        q10B == other.q10B &&
        q10C == other.q10C &&
        q10D == other.q10D &&
        count == other.count &&
        locale == other.locale;
  }

  @override
  int get hashCode => const ListEquality().hash([
        q1Label,
        q1A,
        q1B,
        q1C,
        q1D,
        q2Label,
        q2A,
        q2B,
        q2C,
        q2D,
        q3Label,
        q3A,
        q3B,
        q3C,
        q3D,
        q4Label,
        q4A,
        q4B,
        q4C,
        q4D,
        q5Label,
        q5A,
        q5B,
        q5C,
        q5D,
        q6Label,
        q6A,
        q6B,
        q6C,
        q6D,
        q7Label,
        q7A,
        q7B,
        q7C,
        q7D,
        q8Label,
        q8A,
        q8B,
        q8C,
        q8D,
        q9Label,
        q9A,
        q9B,
        q9C,
        q9D,
        q10Label,
        q10A,
        q10B,
        q10C,
        q10D,
        count,
        locale
      ]);
}

AssessmentQuestionsFlatResponseStruct
    createAssessmentQuestionsFlatResponseStruct({
  String? q1Label,
  String? q1A,
  String? q1B,
  String? q1C,
  String? q1D,
  String? q2Label,
  String? q2A,
  String? q2B,
  String? q2C,
  String? q2D,
  String? q3Label,
  String? q3A,
  String? q3B,
  String? q3C,
  String? q3D,
  String? q4Label,
  String? q4A,
  String? q4B,
  String? q4C,
  String? q4D,
  String? q5Label,
  String? q5A,
  String? q5B,
  String? q5C,
  String? q5D,
  String? q6Label,
  String? q6A,
  String? q6B,
  String? q6C,
  String? q6D,
  String? q7Label,
  String? q7A,
  String? q7B,
  String? q7C,
  String? q7D,
  String? q8Label,
  String? q8A,
  String? q8B,
  String? q8C,
  String? q8D,
  String? q9Label,
  String? q9A,
  String? q9B,
  String? q9C,
  String? q9D,
  String? q10Label,
  String? q10A,
  String? q10B,
  String? q10C,
  String? q10D,
  int? count,
  String? locale,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
        AssessmentQuestionsFlatResponseStruct(
          q1Label: q1Label,
          q1A: q1A,
          q1B: q1B,
          q1C: q1C,
          q1D: q1D,
          q2Label: q2Label,
          q2A: q2A,
          q2B: q2B,
          q2C: q2C,
          q2D: q2D,
          q3Label: q3Label,
          q3A: q3A,
          q3B: q3B,
          q3C: q3C,
          q3D: q3D,
          q4Label: q4Label,
          q4A: q4A,
          q4B: q4B,
          q4C: q4C,
          q4D: q4D,
          q5Label: q5Label,
          q5A: q5A,
          q5B: q5B,
          q5C: q5C,
          q5D: q5D,
          q6Label: q6Label,
          q6A: q6A,
          q6B: q6B,
          q6C: q6C,
          q6D: q6D,
          q7Label: q7Label,
          q7A: q7A,
          q7B: q7B,
          q7C: q7C,
          q7D: q7D,
          q8Label: q8Label,
          q8A: q8A,
          q8B: q8B,
          q8C: q8C,
          q8D: q8D,
          q9Label: q9Label,
          q9A: q9A,
          q9B: q9B,
          q9C: q9C,
          q9D: q9D,
          q10Label: q10Label,
          q10A: q10A,
          q10B: q10B,
          q10C: q10C,
          q10D: q10D,
          count: count,
          locale: locale,
          firestoreUtilData: FirestoreUtilData(
            clearUnsetFields: clearUnsetFields,
            create: create,
            delete: delete,
            fieldValues: fieldValues,
          ),
        );

AssessmentQuestionsFlatResponseStruct?
    updateAssessmentQuestionsFlatResponseStruct(
  AssessmentQuestionsFlatResponseStruct? assessmentQuestionsFlatResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
        assessmentQuestionsFlatResponse
          ?..firestoreUtilData = FirestoreUtilData(
            clearUnsetFields: clearUnsetFields,
            create: create,
          );

void addAssessmentQuestionsFlatResponseStructData(
  Map<String, dynamic> firestoreData,
  AssessmentQuestionsFlatResponseStruct? assessmentQuestionsFlatResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (assessmentQuestionsFlatResponse == null) {
    return;
  }
  if (assessmentQuestionsFlatResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      assessmentQuestionsFlatResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final assessmentQuestionsFlatResponseData =
      getAssessmentQuestionsFlatResponseFirestoreData(
          assessmentQuestionsFlatResponse, forFieldValue);
  final nestedData = assessmentQuestionsFlatResponseData
      .map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      assessmentQuestionsFlatResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAssessmentQuestionsFlatResponseFirestoreData(
  AssessmentQuestionsFlatResponseStruct? assessmentQuestionsFlatResponse, [
  bool forFieldValue = false,
]) {
  if (assessmentQuestionsFlatResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(assessmentQuestionsFlatResponse.toMap());

  // Add any Firestore field values
  mapToFirestore(assessmentQuestionsFlatResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAssessmentQuestionsFlatResponseListFirestoreData(
  List<AssessmentQuestionsFlatResponseStruct>? assessmentQuestionsFlatResponses,
) =>
    assessmentQuestionsFlatResponses
        ?.map((e) => getAssessmentQuestionsFlatResponseFirestoreData(e, true))
        .toList() ??
    [];
