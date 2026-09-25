import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      if (prefs.containsKey('ff_pendingOfflineWrites')) {
        try {
          _pendingOfflineWrites =
              jsonDecode(prefs.getString('ff_pendingOfflineWrites') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _offlineLessonTitle =
          prefs.getString('ff_offlineLessonTitle') ?? _offlineLessonTitle;
    });
    _safeInit(() {
      _offlineLessonScriptureRef =
          prefs.getString('ff_offlineLessonScriptureRef') ??
              _offlineLessonScriptureRef;
    });
    _safeInit(() {
      _offlineLessonScriptureText =
          prefs.getString('ff_offlineLessonScriptureText') ??
              _offlineLessonScriptureText;
    });
    _safeInit(() {
      _offlineLessonReflection =
          prefs.getString('ff_offlineLessonReflection') ??
              _offlineLessonReflection;
    });
    _safeInit(() {
      _offlineLessonId =
          prefs.getString('ff_offlineLessonId') ?? _offlineLessonId;
    });
    _safeInit(() {
      _localProgressCsv =
          prefs.getString('ff_localProgressCsv') ?? _localProgressCsv;
    });
    _safeInit(() {
      _localCompletedCount =
          prefs.getInt('ff_localCompletedCount') ?? _localCompletedCount;
    });
    _safeInit(() {
      _localTotalLessons =
          prefs.getInt('ff_localTotalLessons') ?? _localTotalLessons;
    });
    _safeInit(() {
      _localPathwayTitle =
          prefs.getString('ff_localPathwayTitle') ?? _localPathwayTitle;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  /// True when the device has no network connectivity.
  ///
  /// Drives the OfflineBanner and gates local write-queueing.
  bool _isOffline = false;
  bool get isOffline => _isOffline;
  set isOffline(bool value) {
    _isOffline = value;
  }

  /// Locally queued reflection/progress writes made while offline.
  ///
  /// Shape: { reflections: [{clientWriteId, lessonId, text, createdAt}],
  /// progress: [{pathwayId, currentDay, completedLessons, quizScores}] }.
  /// Drained by syncOfflineProgress once Firebase is connected (not wired yet).
  dynamic _pendingOfflineWrites =
      jsonDecode('{\"reflections\":[],\"progress\":[]}');
  dynamic get pendingOfflineWrites => _pendingOfflineWrites;
  set pendingOfflineWrites(dynamic value) {
    _pendingOfflineWrites = value;
    prefs.setString('ff_pendingOfflineWrites', jsonEncode(value));
  }

  /// DSL app state userProfileCache
  UserProfileEntryStruct _userProfileCache =
      UserProfileEntryStruct.fromSerializableMap(jsonDecode(
          '{\"id\":\"demo-user\",\"fullName\":\"Demo Member\",\"role\":\"admin\",\"preferredLanguage\":\"en\",\"surveyResponses\":\"{}\"}'));
  UserProfileEntryStruct get userProfileCache => _userProfileCache;
  set userProfileCache(UserProfileEntryStruct value) {
    _userProfileCache = value;
  }

  void updateUserProfileCacheStruct(Function(UserProfileEntryStruct) updateFn) {
    updateFn(_userProfileCache);
  }

  /// DSL app state offlineLessonTitle
  String _offlineLessonTitle = '';
  String get offlineLessonTitle => _offlineLessonTitle;
  set offlineLessonTitle(String value) {
    _offlineLessonTitle = value;
    prefs.setString('ff_offlineLessonTitle', value);
  }

  /// DSL app state offlineLessonScriptureRef
  String _offlineLessonScriptureRef = '';
  String get offlineLessonScriptureRef => _offlineLessonScriptureRef;
  set offlineLessonScriptureRef(String value) {
    _offlineLessonScriptureRef = value;
    prefs.setString('ff_offlineLessonScriptureRef', value);
  }

  /// DSL app state offlineLessonScriptureText
  String _offlineLessonScriptureText = '';
  String get offlineLessonScriptureText => _offlineLessonScriptureText;
  set offlineLessonScriptureText(String value) {
    _offlineLessonScriptureText = value;
    prefs.setString('ff_offlineLessonScriptureText', value);
  }

  /// DSL app state offlineLessonReflection
  String _offlineLessonReflection = '';
  String get offlineLessonReflection => _offlineLessonReflection;
  set offlineLessonReflection(String value) {
    _offlineLessonReflection = value;
    prefs.setString('ff_offlineLessonReflection', value);
  }

  /// DSL app state offlineLessonId
  String _offlineLessonId = '';
  String get offlineLessonId => _offlineLessonId;
  set offlineLessonId(String value) {
    _offlineLessonId = value;
    prefs.setString('ff_offlineLessonId', value);
  }

  /// DSL app state localProgressCsv
  String _localProgressCsv = '';
  String get localProgressCsv => _localProgressCsv;
  set localProgressCsv(String value) {
    _localProgressCsv = value;
    prefs.setString('ff_localProgressCsv', value);
  }

  /// DSL app state localCompletedCount
  int _localCompletedCount = 0;
  int get localCompletedCount => _localCompletedCount;
  set localCompletedCount(int value) {
    _localCompletedCount = value;
    prefs.setInt('ff_localCompletedCount', value);
  }

  /// DSL app state localTotalLessons
  int _localTotalLessons = 0;
  int get localTotalLessons => _localTotalLessons;
  set localTotalLessons(int value) {
    _localTotalLessons = value;
    prefs.setInt('ff_localTotalLessons', value);
  }

  /// DSL app state localPathwayTitle
  String _localPathwayTitle = '';
  String get localPathwayTitle => _localPathwayTitle;
  set localPathwayTitle(String value) {
    _localPathwayTitle = value;
    prefs.setString('ff_localPathwayTitle', value);
  }

  /// Value picked on the Sign Up country/city picker (not persisted).
  String _signupCountry = '';
  String get signupCountry => _signupCountry;
  set signupCountry(String value) {
    _signupCountry = value;
  }

  /// Value picked on the Sign Up country/city picker (not persisted).
  String _signupCity = '';
  String get signupCity => _signupCity;
  set signupCity(String value) {
    _signupCity = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
