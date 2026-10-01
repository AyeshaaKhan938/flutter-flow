import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/backend/backend.dart';

/// Picks today's encouragement as Kingdom Heirs specified for the 365
/// Daily Encouragements library (random daily display):
/// - only published records with Active = Y are eligible;
/// - one encouragement per day, from a shuffled order kept per member;
/// - nothing repeats until the whole active pool has been shown;
/// - a new cycle never starts with any of the previous 30 shown;
/// - Random Weight biases the shuffle (all 1 = equal chance).
///
/// Works offline from the Firestore cache, and keeps the same pick for the
/// whole day.
class EncouragementRotation {
  static const _kRecentWindow = 30;

  static String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  /// Today's encouragement, or null when none is published/active.
  static Future<EncouragementsRecord?> today() async {
    final List<EncouragementsRecord> pool;
    try {
      pool = (await queryEncouragementsRecordOnce(
        queryBuilder: (q) => q.where('status', isEqualTo: 'published'),
      ))
          .where((e) => e.snapshotData['active'] != false)
          .where((e) => e.quote.en.trim().isNotEmpty)
          .toList();
    } catch (_) {
      return null;
    }
    if (pool.isEmpty) {
      return null;
    }
    final byId = {for (final e in pool) _idOf(e): e};

    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final prefsKey = 'encouragement_rotation_$uid';
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> state;
    try {
      state = Map<String, dynamic>.from(
          jsonDecode(prefs.getString(prefsKey) ?? '{}') as Map);
    } catch (_) {
      state = {};
    }
    final today = _todayKey();
    final current = state['current'] as String?;
    if (state['date'] == today && current != null && byId[current] != null) {
      return byId[current];
    }

    var queue = List<String>.from(state['queue'] ?? const [])
        .where(byId.containsKey)
        .toList();
    final recent = List<String>.from(state['recent'] ?? const []);
    if (queue.isEmpty) {
      queue = _weightedShuffle(pool);
      // Start the new cycle with items not shown in the last 30 days.
      if (pool.length > _kRecentWindow) {
        final recentSet = recent.toSet();
        queue = [
          ...queue.where((id) => !recentSet.contains(id)),
          ...queue.where(recentSet.contains),
        ];
      }
    }
    final pick = queue.removeAt(0);
    recent.add(pick);
    if (recent.length > _kRecentWindow) {
      recent.removeRange(0, recent.length - _kRecentWindow);
    }
    await prefs.setString(
      prefsKey,
      jsonEncode({
        'date': today,
        'current': pick,
        'queue': queue,
        'recent': recent,
      }),
    );
    return byId[pick];
  }

  static String _idOf(EncouragementsRecord e) =>
      e.stableId.isNotEmpty ? e.stableId : e.reference.id;

  /// Weighted random order (Efraimidis–Spirakis): higher Random Weight
  /// tends to come earlier; equal weights give a uniform shuffle.
  static List<String> _weightedShuffle(List<EncouragementsRecord> pool) {
    final rng = Random();
    final keyed = pool.map((e) {
      final w = (e.snapshotData['randomWeight'] as num?)?.toDouble() ?? 1.0;
      final key = pow(rng.nextDouble(), 1 / (w <= 0 ? 1.0 : w)).toDouble();
      return MapEntry(_idOf(e), key);
    }).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return keyed.map((e) => e.key).toList();
  }
}
