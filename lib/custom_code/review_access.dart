import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';

/// Roles that may open every pathway, lesson and quiz without completing
/// the earlier ones, so Kingdom Heirs can review content and formatting.
/// `content_reviewer` has no admin rights; it only lifts the locks. Roles
/// are set on users/{uid}.role in the Firebase console (never by the app).
const kReviewRoles = ['admin', 'ministry_reviewer', 'content_reviewer'];

/// Internal testers: the review roles, plus `internal_tester`, which keeps
/// the normal locks. Internal testers may see languages hidden from general
/// members and unreviewed machine translations, always labelled (approved
/// by Kingdom Heirs for internal testing only, November 2026).
const kInternalTesterRoles = [...kReviewRoles, 'internal_tester'];

/// Whether the signed-in account is a content reviewer. Members never are.
class ReviewAccess {
  static String? _uid;
  static bool _reviewer = false;
  static bool _tester = false;

  /// Cached result for the signed-in account, false until [load] ran.
  static bool get isReviewer => _uid == currentUserUid && _reviewer;

  /// Whether the signed-in account is an internal tester (see
  /// [kInternalTesterRoles]). False until [load] ran.
  static bool get isInternalTester => _uid == currentUserUid && _tester;

  /// Signed out: nothing unreviewed is shown on this device.
  static void clear() {
    _uid = null;
    _reviewer = false;
    _tester = false;
    TranslationService.instance.previewMachine = false;
    LanguageRegistry.instance.showTesterLanguages = false;
  }

  static Future<bool> load() async {
    final uid = currentUserUid;
    if (uid.isEmpty) {
      return false;
    }
    if (_uid == uid) {
      return _reviewer;
    }
    var reviewer = false;
    var tester = false;
    try {
      final ref = currentUserReference;
      if (ref != null) {
        final user = await UsersRecord.getDocumentOnce(ref);
        reviewer = kReviewRoles.contains(user.role);
        tester = kInternalTesterRoles.contains(user.role);
      }
    } catch (_) {
      return false; // Not cached: checked again next time.
    }
    _uid = uid;
    _reviewer = reviewer;
    _tester = tester;
    TranslationService.instance.previewMachine = tester;
    LanguageRegistry.instance.showTesterLanguages = tester;
    return reviewer;
  }
}
