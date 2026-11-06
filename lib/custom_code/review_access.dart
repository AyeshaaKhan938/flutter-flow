import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';

/// Roles that may open every pathway, lesson and quiz without completing
/// the earlier ones, so Kingdom Heirs can review content and formatting.
/// `content_reviewer` has no admin rights; it only lifts the locks. Roles
/// are set on users/{uid}.role in the Firebase console (never by the app).
const kReviewRoles = ['admin', 'ministry_reviewer', 'content_reviewer'];

/// Whether the signed-in account is a content reviewer. Members never are.
class ReviewAccess {
  static String? _uid;
  static bool _reviewer = false;

  /// Cached result for the signed-in account, false until [load] ran.
  static bool get isReviewer => _uid == currentUserUid && _reviewer;

  static Future<bool> load() async {
    final uid = currentUserUid;
    if (uid.isEmpty) {
      return false;
    }
    if (_uid == uid) {
      return _reviewer;
    }
    var reviewer = false;
    try {
      final ref = currentUserReference;
      if (ref != null) {
        final user = await UsersRecord.getDocumentOnce(ref);
        reviewer = kReviewRoles.contains(user.role);
      }
    } catch (_) {
      return false; // Not cached: checked again next time.
    }
    _uid = uid;
    _reviewer = reviewer;
    return reviewer;
  }
}
