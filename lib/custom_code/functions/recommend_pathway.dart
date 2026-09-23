import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

String recommendPathway(
  int q1,
  int q2,
  int q3,
  int q4,
  int q5,
) {
  int total = q1 + q2 + q3 + q4 + q5;

  if (total <= 9) {
    return 'Come & See';
  } else {
    return 'Growing in Faith';
  }
}
