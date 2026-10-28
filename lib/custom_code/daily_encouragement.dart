import '/backend/backend.dart';

/// Today's encouragement from the 365 Daily Encouragements library, tied to
/// its assigned date (Kingdom Heirs, 2026-10-28) so the Today screen shows
/// one day's devotional: the Scripture, Daily Truth and encouragement all
/// come from the member's own local calendar date.
///
/// Only published records with Active = Y show. The library has 365 days,
/// so 29 February shows 28 February. Read from Firestore (cached), so this
/// also works offline.
class DailyEncouragement {
  /// The "MM-DD" key for [now] in the member's local time.
  static String dateKey(DateTime now) {
    final day = now.month == 2 && now.day == 29 ? 28 : now.day;
    return '${now.month.toString().padLeft(2, '0')}-'
        '${day.toString().padLeft(2, '0')}';
  }

  /// Today's encouragement, or null when none is published for the date.
  static Future<EncouragementsRecord?> today() async {
    final date = dateKey(DateTime.now());
    try {
      final records = await queryEncouragementsRecordOnce(
        queryBuilder: (q) => q.where('date', isEqualTo: date),
      );
      return records
          .where((e) => e.status == 'published')
          .where((e) => e.snapshotData['active'] != false)
          .where((e) => e.quote.en.trim().isNotEmpty)
          .firstOrNull;
    } catch (_) {
      return null;
    }
  }
}
