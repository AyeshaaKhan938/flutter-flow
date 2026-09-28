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

import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<String> openScriptureReferenceSafe(
    String? scriptureRef, String? languageCode) async {
  scriptureRef ??= '';
  languageCode ??= '';
  final ref = scriptureRef.trim();
  if (ref.isEmpty) {
    return 'empty';
  }

  final results = await Connectivity().checkConnectivity();
  final offline =
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);
  if (offline) {
    return 'fallback';
  }

  final lang = languageCode.trim().toLowerCase();
  final version = switch (lang) {
    'es' => 'RVR1960',
    'ur' => 'URDULB',
    'lg' => 'NIV',
    _ => 'NIV',
  };

  // BibleGateway has no Luganda translation, so Luganda readers go to the
  // Luganda Bible 2003 (LB03) on bible.com when the reference parses.
  final lugandaUri = lang == 'lg' ? _lugandaBibleUri(ref) : null;
  final uri = lugandaUri ??
      Uri.https('www.biblegateway.com', '/passage/', {
        'search': ref,
        'version': version,
      });

  try {
    final can = await canLaunchUrl(uri);
    if (!can) {
      return 'fallback';
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    return launched ? 'opened' : 'fallback';
  } catch (_) {
    return 'fallback';
  }
}

const _usfmBooks = {
  'genesis': 'GEN',
  'exodus': 'EXO',
  'leviticus': 'LEV',
  'numbers': 'NUM',
  'deuteronomy': 'DEU',
  'joshua': 'JOS',
  'judges': 'JDG',
  'ruth': 'RUT',
  '1 samuel': '1SA',
  '2 samuel': '2SA',
  '1 kings': '1KI',
  '2 kings': '2KI',
  '1 chronicles': '1CH',
  '2 chronicles': '2CH',
  'ezra': 'EZR',
  'nehemiah': 'NEH',
  'esther': 'EST',
  'job': 'JOB',
  'psalm': 'PSA',
  'psalms': 'PSA',
  'proverbs': 'PRO',
  'ecclesiastes': 'ECC',
  'song of solomon': 'SNG',
  'song of songs': 'SNG',
  'isaiah': 'ISA',
  'jeremiah': 'JER',
  'lamentations': 'LAM',
  'ezekiel': 'EZK',
  'daniel': 'DAN',
  'hosea': 'HOS',
  'joel': 'JOL',
  'amos': 'AMO',
  'obadiah': 'OBA',
  'jonah': 'JON',
  'micah': 'MIC',
  'nahum': 'NAM',
  'habakkuk': 'HAB',
  'zephaniah': 'ZEP',
  'haggai': 'HAG',
  'zechariah': 'ZEC',
  'malachi': 'MAL',
  'matthew': 'MAT',
  'mark': 'MRK',
  'luke': 'LUK',
  'john': 'JHN',
  'acts': 'ACT',
  'romans': 'ROM',
  '1 corinthians': '1CO',
  '2 corinthians': '2CO',
  'galatians': 'GAL',
  'ephesians': 'EPH',
  'philippians': 'PHP',
  'colossians': 'COL',
  '1 thessalonians': '1TH',
  '2 thessalonians': '2TH',
  '1 timothy': '1TI',
  '2 timothy': '2TI',
  'titus': 'TIT',
  'philemon': 'PHM',
  'hebrews': 'HEB',
  'james': 'JAS',
  '1 peter': '1PE',
  '2 peter': '2PE',
  '1 john': '1JN',
  '2 john': '2JN',
  '3 john': '3JN',
  'jude': 'JUD',
  'revelation': 'REV',
};

/// Turns an English reference like "John 3:16-17" into a bible.com link
/// for the Luganda Bible 2003. Returns null if the reference can't be parsed.
Uri? _lugandaBibleUri(String ref) {
  final match = RegExp(r'^([1-3]?\s*[A-Za-z ]+?)\s+(\d+)(?::(\d+)(?:-(\d+))?)?')
      .firstMatch(ref.trim());
  if (match == null) {
    return null;
  }
  final bookName =
      match.group(1)!.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  final book = _usfmBooks[bookName];
  if (book == null) {
    return null;
  }
  var passage = '$book.${match.group(2)}';
  if (match.group(3) != null) {
    passage += '.${match.group(3)}';
    if (match.group(4) != null) {
      passage += '-${match.group(4)}';
    }
  }
  return Uri.https('www.bible.com', '/bible/2808/$passage.LB03');
}
