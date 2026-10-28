import 'dart:convert';

import '/backend/mock/adapters/mock_api_adapter.dart';
import '/backend/mock/ff_data_source.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class ListPathwaysCall {
  static Future<ApiCallResponse> call({
    int? limit,
  }) async {
    if (FFDataSource.isMock) {
      return MockApiAdapter.listPathwaysCall(
        limit: limit,
      );
    }
    return ApiManager.instance.makeApiCall(
      callName: 'ListPathways',
      apiUrl: 'https://mock.kingdomheirs.app/pathways',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListDailyScriptureCall {
  static Future<ApiCallResponse> call({
    int? limit,
  }) async {
    if (FFDataSource.isMock) {
      return MockApiAdapter.listDailyScriptureCall(
        limit: limit,
      );
    }
    return ApiManager.instance.makeApiCall(
      callName: 'ListDailyScripture',
      apiUrl: 'https://mock.kingdomheirs.app/dailyScripture',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListEncouragementsCall {
  static Future<ApiCallResponse> call({
    int? limit,
  }) async {
    if (FFDataSource.isMock) {
      return MockApiAdapter.listEncouragementsCall(
        limit: limit,
      );
    }
    return ApiManager.instance.makeApiCall(
      callName: 'ListEncouragements',
      apiUrl: 'https://mock.kingdomheirs.app/encouragements',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListAnnouncementsCall {
  static Future<ApiCallResponse> call({
    int? limit,
  }) async {
    if (FFDataSource.isMock) {
      return MockApiAdapter.listAnnouncementsCall(
        limit: limit,
      );
    }
    return ApiManager.instance.makeApiCall(
      callName: 'ListAnnouncements',
      apiUrl: 'https://mock.kingdomheirs.app/announcements',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserProfileCall {
  static Future<ApiCallResponse> call({
    String? id = '',
  }) async {
    if (FFDataSource.isMock) {
      return MockApiAdapter.getUserProfileCall(
        id: id,
      );
    }
    return ApiManager.instance.makeApiCall(
      callName: 'GetUserProfile',
      apiUrl: 'https://mock.kingdomheirs.app/users/${id}',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateUserProfileCall {
  static Future<ApiCallResponse> call({
    String? fullName = '',
    String? preferredLanguage = '',
  }) async {
    final ffApiRequestBody = '''
{"fullName":${fullName == null ? 'null' : '"${fullName}"'},"preferredLanguage":${preferredLanguage == null ? 'null' : '"${preferredLanguage}"'},"role":"member","surveyResponses":{}}''';
    if (FFDataSource.isMock) {
      return MockApiAdapter.createUserProfileCall(
        fullName: fullName,
        preferredLanguage: preferredLanguage,
        ffApiRequestBody: ffApiRequestBody,
      );
    }
    return ApiManager.instance.makeApiCall(
      callName: 'CreateUserProfile',
      apiUrl: 'https://mock.kingdomheirs.app/users',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateUserProfileCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? preferredLanguage = '',
    String? surveyResponses = '',
  }) async {
    final ffApiRequestBody = '''
{"preferredLanguage":${preferredLanguage == null ? 'null' : '"${preferredLanguage}"'},"surveyResponses":${surveyResponses == null ? 'null' : '"${surveyResponses}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateUserProfile',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer <authToken>',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateUserProfileFullCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? preferredLanguage = '',
    String? surveyResponses = '',
    String? recommendedPathwayId = '',
    String? recommendationReason = '',
    String? assessmentBibleConfidence = '',
    String? assessmentNeeds = '',
    String? assessmentHabits = '',
    String? assessmentGoals = '',
  }) async {
    final ffApiRequestBody = '''
{"preferredLanguage":${preferredLanguage == null ? 'null' : '"${preferredLanguage}"'},"surveyResponses":${surveyResponses == null ? 'null' : '"${surveyResponses}"'},"recommendedPathwayId":${recommendedPathwayId == null ? 'null' : '"${recommendedPathwayId}"'},"recommendationReason":${recommendationReason == null ? 'null' : '"${recommendationReason}"'},"assessmentBibleConfidence":${assessmentBibleConfidence == null ? 'null' : '"${assessmentBibleConfidence}"'},"assessmentNeeds":${assessmentNeeds == null ? 'null' : '"${assessmentNeeds}"'},"assessmentHabits":${assessmentHabits == null ? 'null' : '"${assessmentHabits}"'},"assessmentGoals":${assessmentGoals == null ? 'null' : '"${assessmentGoals}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateUserProfileFull',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer <authToken>',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateUserProfileV2Call {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? preferredLanguage = '',
    String? surveyResponses = '',
    String? recommendedPathwayId = '',
    String? recommendationReason = '',
    String? assessmentBibleConfidence = '',
    String? assessmentNeeds = '',
    String? assessmentHabits = '',
    String? assessmentGoals = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"preferredLanguage":${preferredLanguage == null ? 'null' : '"${preferredLanguage}"'},"surveyResponses":${surveyResponses == null ? 'null' : '"${surveyResponses}"'},"recommendedPathwayId":${recommendedPathwayId == null ? 'null' : '"${recommendedPathwayId}"'},"recommendationReason":${recommendationReason == null ? 'null' : '"${recommendationReason}"'},"assessmentBibleConfidence":${assessmentBibleConfidence == null ? 'null' : '"${assessmentBibleConfidence}"'},"assessmentNeeds":${assessmentNeeds == null ? 'null' : '"${assessmentNeeds}"'},"assessmentHabits":${assessmentHabits == null ? 'null' : '"${assessmentHabits}"'},"assessmentGoals":${assessmentGoals == null ? 'null' : '"${assessmentGoals}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateUserProfileV2',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserProfileV2Call {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetUserProfileV2',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserProfileV3Call {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetUserProfileV3',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPathwayProgressCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? pathwayId = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"pathwayId":${pathwayId == null ? 'null' : '"${pathwayId}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetPathwayProgress',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getPathwayProgress',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SaveLessonProgressCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? pathwayId = '',
    String? lessonId = '',
    String? dayNumber = '',
    String? reflectionText = '',
    String? clientWriteId = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"pathwayId":${pathwayId == null ? 'null' : '"${pathwayId}"'},"lessonId":${lessonId == null ? 'null' : '"${lessonId}"'},"dayNumber":${dayNumber == null ? 'null' : '"${dayNumber}"'},"reflectionText":${reflectionText == null ? 'null' : '"${reflectionText}"'},"clientWriteId":${clientWriteId == null ? 'null' : '"${clientWriteId}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SaveLessonProgress',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/saveLessonProgress',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetQuizCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? quizId = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"quizId":${quizId == null ? 'null' : '"${quizId}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetQuiz',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getQuiz',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SubmitQuizAttemptCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? quizId = '',
    String? q1 = '',
    String? q2 = '',
    String? q3 = '',
    String? q4 = '',
    String? q5 = '',
    String? q6 = '',
    String? q7 = '',
    String? q8 = '',
    String? q9 = '',
    String? q10 = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"quizId":${quizId == null ? 'null' : '"${quizId}"'},"q1":${q1 == null ? 'null' : '"${q1}"'},"q2":${q2 == null ? 'null' : '"${q2}"'},"q3":${q3 == null ? 'null' : '"${q3}"'},"q4":${q4 == null ? 'null' : '"${q4}"'},"q5":${q5 == null ? 'null' : '"${q5}"'},"q6":${q6 == null ? 'null' : '"${q6}"'},"q7":${q7 == null ? 'null' : '"${q7}"'},"q8":${q8 == null ? 'null' : '"${q8}"'},"q9":${q9 == null ? 'null' : '"${q9}"'},"q10":${q10 == null ? 'null' : '"${q10}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SubmitQuizAttempt',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/submitQuizAttempt',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ImportCurriculumCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? collection = '',
    String? csvText = '',
    String? previewOnly = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"collection":${collection == null ? 'null' : '"${collection}"'},"csvText":${csvText == null ? 'null' : '"${csvText}"'},"previewOnly":${previewOnly == null ? 'null' : '"${previewOnly}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ImportCurriculum',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/importCurriculum',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetQuizV2Call {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? quizId = '',
    String? locale = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"quizId":${quizId == null ? 'null' : '"${quizId}"'},"locale":${locale == null ? 'null' : '"${locale}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetQuizV2',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getQuiz',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetQuizAttemptCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? quizId = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"quizId":${quizId == null ? 'null' : '"${quizId}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetQuizAttempt',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getQuizAttempt',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SubmitQuizAttemptV2Call {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? quizId = '',
    String? pathwayId = '',
    String? q1 = '',
    String? q2 = '',
    String? q3 = '',
    String? q4 = '',
    String? q5 = '',
    String? q6 = '',
    String? q7 = '',
    String? q8 = '',
    String? q9 = '',
    String? q10 = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"quizId":${quizId == null ? 'null' : '"${quizId}"'},"pathwayId":${pathwayId == null ? 'null' : '"${pathwayId}"'},"q1":${q1 == null ? 'null' : '"${q1}"'},"q2":${q2 == null ? 'null' : '"${q2}"'},"q3":${q3 == null ? 'null' : '"${q3}"'},"q4":${q4 == null ? 'null' : '"${q4}"'},"q5":${q5 == null ? 'null' : '"${q5}"'},"q6":${q6 == null ? 'null' : '"${q6}"'},"q7":${q7 == null ? 'null' : '"${q7}"'},"q8":${q8 == null ? 'null' : '"${q8}"'},"q9":${q9 == null ? 'null' : '"${q9}"'},"q10":${q10 == null ? 'null' : '"${q10}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SubmitQuizAttemptV2',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/submitQuizAttempt',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserProfileV4Call {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetUserProfileV4',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SubmitAssessmentCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? q1 = '',
    String? q2 = '',
    String? q3 = '',
    String? q4 = '',
    String? q5 = '',
    String? q6 = '',
    String? q7 = '',
    String? q8 = '',
    String? q9 = '',
    String? q10 = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"q1":${q1 == null ? 'null' : '"${q1}"'},"q2":${q2 == null ? 'null' : '"${q2}"'},"q3":${q3 == null ? 'null' : '"${q3}"'},"q4":${q4 == null ? 'null' : '"${q4}"'},"q5":${q5 == null ? 'null' : '"${q5}"'},"q6":${q6 == null ? 'null' : '"${q6}"'},"q7":${q7 == null ? 'null' : '"${q7}"'},"q8":${q8 == null ? 'null' : '"${q8}"'},"q9":${q9 == null ? 'null' : '"${q9}"'},"q10":${q10 == null ? 'null' : '"${q10}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SubmitAssessment',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/submitAssessment',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RagQueryHttpCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? question = '',
    String? locale = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"question":${question == null ? 'null' : '"${question}"'},"locale":${locale == null ? 'null' : '"${locale}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'RagQueryHttp',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/ragQueryHttp',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAdminReportCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetAdminReport',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getAdminReport',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAssessmentConfigCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetAssessmentConfig',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getAssessmentConfig',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateAssessmentConfigCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? assessmentVersion = '',
    String? scoreBandsJson = '',
    String? overridesJson = '',
    String? explanationsJson = '',
    String? pointMapJson = '',
    String? activate = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"assessmentVersion":${assessmentVersion == null ? 'null' : '"${assessmentVersion}"'},"scoreBandsJson":${scoreBandsJson == null ? 'null' : '"${scoreBandsJson}"'},"overridesJson":${overridesJson == null ? 'null' : '"${overridesJson}"'},"explanationsJson":${explanationsJson == null ? 'null' : '"${explanationsJson}"'},"pointMapJson":${pointMapJson == null ? 'null' : '"${pointMapJson}"'},"activate":${activate == null ? 'null' : '"${activate}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateAssessmentConfig',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateAssessmentConfig',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAssessmentQuestionsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? locale = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"locale":${locale == null ? 'null' : '"${locale}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetAssessmentQuestions',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getAssessmentQuestions',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserProfileV5Call {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetUserProfileV5',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SubmitAssessmentV2Call {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? q1 = '',
    String? q2 = '',
    String? q3 = '',
    String? q4 = '',
    String? q5 = '',
    String? q6 = '',
    String? q7 = '',
    String? q8 = '',
    String? q9 = '',
    String? q10 = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"q1":${q1 == null ? 'null' : '"${q1}"'},"q2":${q2 == null ? 'null' : '"${q2}"'},"q3":${q3 == null ? 'null' : '"${q3}"'},"q4":${q4 == null ? 'null' : '"${q4}"'},"q5":${q5 == null ? 'null' : '"${q5}"'},"q6":${q6 == null ? 'null' : '"${q6}"'},"q7":${q7 == null ? 'null' : '"${q7}"'},"q8":${q8 == null ? 'null' : '"${q8}"'},"q9":${q9 == null ? 'null' : '"${q9}"'},"q10":${q10 == null ? 'null' : '"${q10}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SubmitAssessmentV2',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/submitAssessment',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class PublishAnnouncementCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? titleEn = '',
    String? titleEs = '',
    String? titleUr = '',
    String? bodyEn = '',
    String? bodyEs = '',
    String? bodyUr = '',
    String? audience = '',
    String? sendPush = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"titleEn":${titleEn == null ? 'null' : '"${titleEn}"'},"titleEs":${titleEs == null ? 'null' : '"${titleEs}"'},"titleUr":${titleUr == null ? 'null' : '"${titleUr}"'},"bodyEn":${bodyEn == null ? 'null' : '"${bodyEn}"'},"bodyEs":${bodyEs == null ? 'null' : '"${bodyEs}"'},"bodyUr":${bodyUr == null ? 'null' : '"${bodyUr}"'},"audience":${audience == null ? 'null' : '"${audience}"'},"sendPush":${sendPush == null ? 'null' : '"${sendPush}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'PublishAnnouncement',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/publishAnnouncement',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GenerateTranslationDraftsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? target = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"target":${target == null ? 'null' : '"${target}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GenerateTranslationDrafts',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/generateTranslationDrafts',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class LogAnalyticsEventCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? eventName = '',
    String? propsJson = '',
    String? screen = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"eventName":${eventName == null ? 'null' : '"${eventName}"'},"propsJson":${propsJson == null ? 'null' : '"${propsJson}"'},"screen":${screen == null ? 'null' : '"${screen}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'LogAnalyticsEvent',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/logAnalyticsEvent',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SaveProfileDetailsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? displayName = '',
    String? country = '',
    String? regionCity = '',
    String? timezone = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"displayName":${displayName == null ? 'null' : '"${displayName}"'},"country":${country == null ? 'null' : '"${country}"'},"regionCity":${regionCity == null ? 'null' : '"${regionCity}"'},"timezone":${timezone == null ? 'null' : '"${timezone}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SaveProfileDetails',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SaveOnboardingLanguageCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? preferredLanguage = '',
    String? surveyResponses = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"preferredLanguage":${preferredLanguage == null ? 'null' : '"${preferredLanguage}"'},"surveyResponses":${surveyResponses == null ? 'null' : '"${surveyResponses}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SaveOnboardingLanguage',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SaveProfileDetailsV2Call {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? displayName = '',
    String? phone = '',
    String? country = '',
    String? regionCity = '',
    String? timezone = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"displayName":${displayName == null ? 'null' : '"${displayName}"'},"phone":${phone == null ? 'null' : '"${phone}"'},"country":${country == null ? 'null' : '"${country}"'},"regionCity":${regionCity == null ? 'null' : '"${regionCity}"'},"timezone":${timezone == null ? 'null' : '"${timezone}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SaveProfileDetailsV2',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetTodayContentCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetTodayContent',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getTodayContent',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SaveOnboardingSurveyCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? preferredLanguage = '',
    String? hearAbout = '',
    String? growthGoal = '',
  }) async {
    final ffApiRequestBody = '''
{"authToken":${authToken == null ? 'null' : '"${authToken}"'},"preferredLanguage":${preferredLanguage == null ? 'null' : '"${preferredLanguage}"'},"hearAbout":${hearAbout == null ? 'null' : '"${hearAbout}"'},"growthGoal":${growthGoal == null ? 'null' : '"${growthGoal}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SaveOnboardingSurvey',
      apiUrl:
          'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/updateUserProfile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
