// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

Future<ImportSummaryResponseStruct> runCurriculumImport(
  String? collection,
  String? csvText,
  bool? previewOnly,
) async {
  ImportSummaryResponseStruct fail(String message) =>
      ImportSummaryResponseStruct(
        created: 0,
        updated: 0,
        unchanged: 0,
        errorCount: 1,
        firstErrorMessage: message,
      );
  final target = (collection ?? '').trim();
  final csv = csvText ?? '';
  if (target.isEmpty) return fail('Choose a target collection first.');
  if (csv.trim().isEmpty) return fail('Paste the CSV content first.');
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return fail('Please sign in again.');
    final token = await user.getIdToken();
    final res = await http
        .post(
          Uri.parse(
            'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/importCurriculum',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'authToken': token,
            'collection': target,
            'csvText': csv,
            'previewOnly': previewOnly == true ? 'true' : 'false',
          }),
        )
        .timeout(const Duration(seconds: 120));
    final body = jsonDecode(res.body);
    if (body is Map && body.containsKey('created')) {
      return ImportSummaryResponseStruct.fromMap(
          Map<String, dynamic>.from(body));
    }
    return fail(
        '${(body is Map ? body['error'] : null) ?? 'Import failed (HTTP ${res.statusCode}).'}');
  } catch (e) {
    return fail(
        'Could not reach the server. Check your connection and try again.');
  }
}
