import 'dart:async';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/custom_code/languages/translation_service.dart';

/// The Kingdom Heirs core journey, in order (pathway `stableId`s). Used when a
/// pathway document has no `track` field, and as a tie-breaker for `order`.
const kCorePathwayIds = [
  'come-and-see',
  'rooted-in-christ',
  'journey-into-discipleship-evangelism',
  'holy-spirit-in-the-life-of-every-christian',
  'kingdom-heirs-foundations',
  'counterfeit-gospels',
  'inner-healing-and-deliverance',
];

/// Certificate id for completing every core pathway.
const kCoreCertificateId = 'core-discipleship';
const kCoreCertificateTitle =
    'Kingdom Heirs Core Discipleship Program Certificate';

/// Shown on every certificate, as Kingdom Heirs requires.
const kCertificateNotice =
    'This certificate recognizes completion of a Kingdom Heirs discipleship '
    'pathway. It is not an accredited degree, professional credential, '
    'ordination or ministry license. Any ministry or leadership role '
    'requires a separate Kingdom Heirs approval process.';

/// Number of core pathways that make up the full core journey.
const kCorePathwayCount = 7;

/// Minimum quiz score (percent) that counts as passed for progression.
const kMinPassingScore = 80;

/// The member's standing on one published pathway.
class PathwayStatus {
  PathwayStatus({
    required this.pathway,
    required this.track,
    required this.step,
    required this.completed,
    required this.unlocked,
    this.lockedBy,
    this.lessonsTotal = 0,
    this.lessonsCompleted = 0,
    this.quizzesTotal = 0,
    this.quizzesPassed = 0,
  });

  final PathwaysRecord pathway;

  /// 'core' or 'additional'.
  final String track;

  /// 1-based position in the core journey (0 for additional studies).
  final int step;
  final bool completed;
  final bool unlocked;

  /// The core pathway to complete before this one opens (when locked).
  final PathwaysRecord? lockedBy;
  final int lessonsTotal;
  final int lessonsCompleted;
  final int quizzesTotal;
  final int quizzesPassed;

  String get stableId => pathway.stableId;
  bool get isCore => track == 'core';

  /// English title of the blocking pathway ('' when unlocked).
  String get lockedByTitle => lockedBy?.title.en ?? '';
}

/// The member's progression across all published pathways.
class PathwayProgression {
  PathwayProgression({
    required this.core,
    required this.additional,
    required this.issuedCertificateIds,
  });

  /// Published core pathways in journey order.
  final List<PathwayStatus> core;

  /// Published additional studies ("Continue Growing"), never locked.
  final List<PathwayStatus> additional;

  /// Certificates already stored in users/{uid}/certificates.
  final Set<String> issuedCertificateIds;

  static PathwayProgression get empty => PathwayProgression(
        core: const [],
        additional: const [],
        issuedCertificateIds: <String>{},
      );

  Iterable<PathwayStatus> get all => [...core, ...additional];

  PathwayStatus? statusFor(String? pathwayId) =>
      all.where((s) => s.stableId == pathwayId).firstOrNull;

  /// The core pathway after [pathwayId], if any.
  PathwayStatus? nextCoreAfter(String? pathwayId) {
    final i = core.indexWhere((s) => s.stableId == pathwayId);
    return i >= 0 && i + 1 < core.length ? core[i + 1] : null;
  }

  /// True when all seven core pathways are published and completed.
  bool get coreJourneyCompleted =>
      core.length >= kCorePathwayCount && core.every((s) => s.completed);

  /// Whether the member has earned [certificateId] (a pathway stableId or
  /// [kCoreCertificateId]).
  bool hasEarned(String? certificateId) {
    if (certificateId == kCoreCertificateId) {
      return coreJourneyCompleted;
    }
    return statusFor(certificateId)?.completed ?? false;
  }
}

/// Loads published pathways, lessons and quizzes plus the member's lesson
/// progress and quiz attempts, and works out which core pathways are
/// completed and unlocked. Uses the same backend calls (same parameters) as
/// the pages, so cached responses keep it working offline.
class PathwayProgressionService {
  PathwayProgressionService._();
  static final PathwayProgressionService instance =
      PathwayProgressionService._();

  PathwayProgression? _cached;
  String? _cachedUid;
  Future<PathwayProgression>? _inFlight;

  /// The last computed progression for the signed-in member, if any.
  PathwayProgression? get cached =>
      _cachedUid == currentUserUid ? _cached : null;

  /// Returns the cached progression, computing it when missing or [force].
  Future<PathwayProgression> load({bool force = false}) {
    final hit = cached;
    if (!force && hit != null) {
      return Future.value(hit);
    }
    return _inFlight ??= _compute().whenComplete(() => _inFlight = null);
  }

  /// Recomputes from Firestore and the backend.
  Future<PathwayProgression> refresh() => load(force: true);

  void clear() {
    _cached = null;
    _cachedUid = null;
  }

  static String trackOf(PathwaysRecord p) {
    final raw = (p.snapshotData['track'] as String? ?? '').trim().toLowerCase();
    if (raw == 'core' || raw == 'additional') {
      return raw;
    }
    return kCorePathwayIds.contains(p.stableId) ? 'core' : 'additional';
  }

  /// CMS `order`, with pathways of unknown order last.
  static int _compareOrder(PathwaysRecord a, PathwaysRecord b) {
    final ao = a.hasOrder() ? a.order : 1 << 30;
    final bo = b.hasOrder() ? b.order : 1 << 30;
    if (ao != bo) {
      return ao.compareTo(bo);
    }
    int known(PathwaysRecord p) {
      final i = kCorePathwayIds.indexOf(p.stableId);
      return i < 0 ? 1 << 20 : i;
    }

    final k = known(a).compareTo(known(b));
    return k != 0 ? k : a.stableId.compareTo(b.stableId);
  }

  static String _quizId(QuizzesRecord q) =>
      q.stableId.isNotEmpty ? q.stableId : q.reference.id;

  static int? _toInt(dynamic v) =>
      v is num ? v.toInt() : (v is String ? int.tryParse(v.trim()) : null);

  Future<PathwayProgression> _compute() async {
    final uid = currentUserUid;
    final token = currentJwtToken;

    final results = await Future.wait<dynamic>([
      queryPathwaysRecordOnce(
        queryBuilder: (q) => q.where('status', isEqualTo: 'published'),
        limit: 100,
      ).catchError((_) => <PathwaysRecord>[]),
      queryLessonsRecordOnce(
        queryBuilder: (q) => q.where('status', isEqualTo: 'published'),
        limit: 1000,
      ).catchError((_) => <LessonsRecord>[]),
      queryQuizzesRecordOnce().catchError((_) => <QuizzesRecord>[]),
      _issuedCertificateIds(uid),
    ]);
    final pathways = (results[0] as List).cast<PathwaysRecord>();
    final lessons = (results[1] as List).cast<LessonsRecord>();
    final quizzes = (results[2] as List).cast<QuizzesRecord>();
    final issued = results[3] as Set<String>;

    // Published lessons per pathway; only pathways with lessons are shown.
    final lessonsByPathway = <String, List<LessonsRecord>>{};
    for (final l in lessons) {
      if (l.pathwayId.isNotEmpty) {
        lessonsByPathway.putIfAbsent(l.pathwayId, () => []).add(l);
      }
    }
    final lessonPathway = {
      for (final l in lessons)
        if (l.stableId.isNotEmpty) l.stableId: l.pathwayId,
    };

    final visible = pathways
        .where((p) =>
            p.status == 'published' &&
            p.stableId.isNotEmpty &&
            (lessonsByPathway[p.stableId]?.isNotEmpty ?? false))
        .toList()
      ..sort(_compareOrder);

    // Published quizzes per pathway (by pathwayId, else via their lesson,
    // else the pathway document they live under). A quiz attached to an
    // unpublished lesson can't be reached, so it is not required.
    final quizzesByPathway = <String, List<QuizzesRecord>>{};
    for (final q in quizzes) {
      if (q.status != 'published') {
        continue;
      }
      if (q.lessonId.isNotEmpty && !lessonPathway.containsKey(q.lessonId)) {
        continue;
      }
      var pathwayId = (q.snapshotData['pathwayId'] as String? ?? '').trim();
      if (pathwayId.isEmpty) {
        pathwayId = lessonPathway[q.lessonId] ?? '';
      }
      if (pathwayId.isEmpty) {
        final parent = q.reference.parent.parent;
        if (parent != null && parent.parent.id == 'pathways') {
          pathwayId = pathways
                  .where((p) => p.reference.id == parent.id)
                  .firstOrNull
                  ?.stableId ??
              parent.id;
        }
      }
      if (pathwayId.isNotEmpty) {
        quizzesByPathway.putIfAbsent(pathwayId, () => []).add(q);
      }
    }

    // Lesson progress for every visible pathway, in parallel.
    final progress = await Future.wait(visible.map((p) async {
      try {
        final r = await GetPathwayProgressCall.call(
          authToken: token,
          pathwayId: p.stableId,
        );
        return r.succeeded
            ? PathwayProgressResponseStruct.maybeFromMap(r.jsonBody)
            : null;
      } catch (_) {
        return null;
      }
    }));

    final statusInputs = <String, ({int total, int done, bool lessonsDone})>{};
    for (var i = 0; i < visible.length; i++) {
      final p = visible[i];
      final published = lessonsByPathway[p.stableId]!;
      final csv = progress[i]?.completedLessonsCsv ?? '';
      final doneIds = csv
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet();
      var done = published.where((l) => doneIds.contains(l.stableId)).length;
      if (doneIds.isEmpty) {
        // Older responses without the list: fall back to the count.
        done = (progress[i]?.completedCount ?? 0).clamp(0, published.length);
      }
      statusInputs[p.stableId] = (
        total: published.length,
        done: done,
        lessonsDone: done >= published.length,
      );
    }

    // Quiz attempts, only where they can change the outcome (all lessons
    // done), to keep the number of calls down.
    final quizPassed = <String, bool>{};
    await Future.wait([
      for (final p in visible)
        if (statusInputs[p.stableId]!.lessonsDone)
          for (final q in quizzesByPathway[p.stableId] ?? <QuizzesRecord>[])
            () async {
              quizPassed[_quizId(q)] = await _quizPassed(q, token);
            }(),
    ]);

    final core = <PathwayStatus>[];
    final additional = <PathwayStatus>[];
    PathwaysRecord? previousCore;
    var previousCompleted = true;
    for (final p in visible) {
      final input = statusInputs[p.stableId]!;
      final pathwayQuizzes = quizzesByPathway[p.stableId] ?? [];
      final passed =
          pathwayQuizzes.where((q) => quizPassed[_quizId(q)] == true).length;
      // A certificate already issued means it was completed when issued;
      // content added later never takes that back.
      final completed = issued.contains(p.stableId) ||
          (input.total > 0 &&
              input.lessonsDone &&
              passed == pathwayQuizzes.length);
      final track = trackOf(p);
      if (track == 'core') {
        // Unpublished core pathways are skipped: the next published one
        // follows the last published one before it.
        final unlocked = previousCompleted;
        core.add(PathwayStatus(
          pathway: p,
          track: track,
          step: core.length + 1,
          completed: completed,
          unlocked: unlocked,
          lockedBy: unlocked ? null : previousCore,
          lessonsTotal: input.total,
          lessonsCompleted: input.done,
          quizzesTotal: pathwayQuizzes.length,
          quizzesPassed: passed,
        ));
        previousCore = p;
        previousCompleted = previousCompleted && completed;
      } else {
        additional.add(PathwayStatus(
          pathway: p,
          track: track,
          step: 0,
          completed: completed,
          unlocked: true,
          lessonsTotal: input.total,
          lessonsCompleted: input.done,
          quizzesTotal: pathwayQuizzes.length,
          quizzesPassed: passed,
        ));
      }
    }

    final result = PathwayProgression(
      core: core,
      additional: additional,
      issuedCertificateIds: issued,
    );
    _cached = result;
    _cachedUid = uid;
    return result;
  }

  /// Passed at 80% or higher (or the quiz's own passing score if higher).
  Future<bool> _quizPassed(QuizzesRecord quiz, String? token) async {
    try {
      final r = await GetQuizAttemptCall.call(
        authToken: token,
        quizId: _quizId(quiz),
      );
      if (!r.succeeded) {
        return false;
      }
      final attempt = QuizAttemptResponseStruct.maybeFromMap(r.jsonBody);
      if (attempt == null || !attempt.hasAttempt) {
        return false;
      }
      final docScore = _toInt(quiz.snapshotData['passingScore']) ?? 0;
      final threshold = [kMinPassingScore, docScore, attempt.passingScore]
          .reduce((a, b) => a > b ? a : b);
      if (attempt.percentage >= threshold) {
        return true;
      }
      // Trust the backend's pass only when its own bar was at least 80%.
      return attempt.passed &&
          attempt.passingScore >= kMinPassingScore &&
          attempt.passingScore >= docScore;
    } catch (_) {
      return false;
    }
  }

  static CollectionReference<Map<String, dynamic>> certificatesOf(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('certificates');

  Future<Set<String>> _issuedCertificateIds(String uid) async {
    if (uid.isEmpty) {
      return {};
    }
    try {
      final snap = await certificatesOf(uid).get();
      return snap.docs.map((d) => d.id).toSet();
    } catch (_) {
      return {};
    }
  }

  /// Creates users/{uid}/certificates/{id} for every earned certificate not
  /// yet stored. Best effort; existing certificates are never rewritten.
  Future<void> issueEarnedCertificates(PathwayProgression progression) async {
    final uid = currentUserUid;
    if (uid.isEmpty) {
      return;
    }
    final toIssue = <String, String>{
      for (final s in progression.all)
        if (s.completed && !progression.issuedCertificateIds.contains(s.stableId))
          s.stableId: s.pathway.title.en,
      if (progression.coreJourneyCompleted &&
          !progression.issuedCertificateIds.contains(kCoreCertificateId))
        kCoreCertificateId: kCoreCertificateTitle,
    };
    for (final entry in toIssue.entries) {
      unawaited(issueCertificate(entry.key, entry.value).then((_) {
        progression.issuedCertificateIds.add(entry.key);
      }).catchError((_) {}));
    }
  }

  /// Stores the certificate once (create only); returns its data.
  Future<Map<String, dynamic>?> issueCertificate(
    String certificateId,
    String title,
  ) async {
    final uid = currentUserUid;
    if (uid.isEmpty) {
      return null;
    }
    final ref = certificatesOf(uid).doc(certificateId);
    try {
      final existing = await ref.get();
      if (existing.exists) {
        return existing.data();
      }
    } catch (_) {}
    final data = <String, dynamic>{
      'pathwayId': certificateId,
      'title': title,
      'memberName': memberDisplayName(),
      'certificateId': certificateNumber(uid, certificateId),
      'issuedAt': FieldValue.serverTimestamp(),
    };
    // Not awaited: offline, the write is queued and synced later.
    unawaited(ref.set(data).catchError((_) {}));
    return {...data, 'issuedAt': null};
  }

  static String memberDisplayName() {
    final name = currentUserDisplayName.trim();
    return name.isNotEmpty ? name : currentUserEmail;
  }

  /// Stable, human-readable certificate number for [uid] + [certificateId].
  static String certificateNumber(String uid, String certificateId) {
    int fnv(String s, int seed) {
      var h = seed;
      for (final c in s.codeUnits) {
        h ^= c;
        h = (h * 0x01000193) & 0xFFFFFFFF;
      }
      return h;
    }

    final key = '$uid|$certificateId';
    String part(int seed) =>
        fnv(key, seed).toRadixString(36).toUpperCase().padLeft(7, '0');
    return 'KH-${part(0x811C9DC5).substring(0, 5)}-${part(0x01000193).substring(0, 5)}';
  }
}

/// Localized labels for progression screens: compiled en/es/ur/lg text,
/// else machine translation of the English (via [TranslationService]).
/// `{title}`, `{n}`, `{date}`, `{id}` placeholders are filled from [args].
String progressionText(
  String english,
  String? lang, [
  Map<String, String> args = const {},
]) {
  final code = (lang ?? 'en').trim().toLowerCase();
  String fill(String s) {
    var out = s;
    args.forEach((k, v) => out = out.replaceAll('{$k}', v));
    return out;
  }

  final compiled = _kProgressionLabels[english]?[code];
  if (code == 'en' || code.isEmpty) {
    return fill(english);
  }
  if (compiled != null) {
    return fill(compiled);
  }
  return TranslationService.instance.translate(fill(english), code);
}

const _kProgressionLabels = <String, Map<String, String>>{
  'Core Pathway': {
    'es': 'Camino principal',
    'ur': 'بنیادی راستہ',
    'lg': 'Omukutu Omukulu',
  },
  'Complete each pathway in order. The next one unlocks when you finish all its lessons and pass its quizzes with 80% or higher.':
      {
    'es':
        'Completa cada camino en orden. El siguiente se desbloquea cuando terminas todas sus lecciones y apruebas sus cuestionarios con 80% o más.',
    'ur':
        'ہر راستہ ترتیب سے مکمل کریں۔ اگلا راستہ تب کھلتا ہے جب آپ اس کے تمام اسباق مکمل کریں اور اس کے کوئز 80% یا زیادہ نمبروں سے پاس کریں۔',
    'lg':
        "Maliriza buli mukutu mu nsengeka yaagwo. Oguddako guggulwawo bw'omaliriza amasomo gaagwo gonna era n'oyita ebibuuzo byagwo ku 80% oba okusingawo.",
  },
  'Additional Studies — Continue Growing': {
    'es': 'Estudios adicionales — Sigue creciendo',
    'ur': 'اضافی مطالعے — بڑھتے رہیں',
    'lg': 'Ebisomesebwa Ebirala — Weeyongere Okukula',
  },
  'Grow deeper at your own pace. These studies are always open.': {
    'es': 'Profundiza a tu propio ritmo. Estos estudios siempre están abiertos.',
    'ur': 'اپنی رفتار سے گہرائی میں بڑھیں۔ یہ مطالعے ہمیشہ کھلے رہتے ہیں۔',
    'lg': 'Weeyongere okukula mu mbeera yo. Ebisomesebwa bino bulijjo biggule.',
  },
  'Step {n}': {
    'es': 'Paso {n}',
    'ur': 'مرحلہ {n}',
    'lg': 'Omutendera {n}',
  },
  'Complete {title} to unlock': {
    'es': 'Completa {title} para desbloquear',
    'ur': 'کھولنے کے لیے {title} مکمل کریں',
    'lg': 'Maliriza {title} okuggulawo',
  },
  'Completed': {
    'es': 'Completado',
    'ur': 'مکمل',
    'lg': 'Kiwedde',
  },
  'View certificate': {
    'es': 'Ver certificado',
    'ur': 'سرٹیفکیٹ دیکھیں',
    'lg': 'Laba satifikeeti',
  },
  'My certificates': {
    'es': 'Mis certificados',
    'ur': 'میرے سرٹیفکیٹ',
    'lg': 'Satifikeeti zange',
  },
  kCoreCertificateTitle: {
    'es': 'Certificado del Programa de Discipulado Central de Kingdom Heirs',
    'ur': 'کنگڈم ہائرز بنیادی شاگردی پروگرام سرٹیفکیٹ',
    'lg': 'Satifikeeti ya Pulogulaamu y’Obuyigirizwa Obukulu eya Kingdom Heirs',
  },
  kCertificateNotice: {
    'es': 'Este certificado reconoce la finalización de un camino de discipulado de Kingdom Heirs. No es un título acreditado, una credencial profesional, una ordenación ni una licencia ministerial. Cualquier función ministerial o de liderazgo requiere un proceso de aprobación aparte de Kingdom Heirs.',
    'ur': 'یہ سرٹیفکیٹ کنگڈم ہائرز کے شاگردی کے ایک راستے کی تکمیل کا اعتراف ہے۔ یہ کوئی تسلیم شدہ ڈگری، پیشہ ورانہ سند، تقرری (آرڈینیشن) یا خدمت کا لائسنس نہیں۔ کسی بھی خدمت یا قیادت کے کردار کے لیے کنگڈم ہائرز کی الگ منظوری درکار ہے۔',
    'lg': 'Satifikeeti eno ekakasa okumaliriza omukutu gw’obuyigirizwa ogwa Kingdom Heirs. Si diguli ekkirizibwa, si bbaluwa ya bukugu, si kutongozebwa mu buweereza era si layisinsi ya buweereza. Omulimu gwonna ogw’obuweereza oba obukulembeze gwetaaga okukkirizibwa okw’enjawulo okwa Kingdom Heirs.',
  },
  'Coming soon': {
    'es': 'Próximamente',
    'ur': 'جلد آ رہا ہے',
    'lg': 'Kijja mangu',
  },
  'This pathway is not available yet.': {
    'es': 'Este camino aún no está disponible.',
    'ur': 'یہ راستہ ابھی دستیاب نہیں۔',
    'lg': 'Omukutu guno tegunnabaawo.',
  },
  'Complete lesson {n} first.': {
    'es': 'Primero completa la lección {n}.',
    'ur': 'پہلے سبق {n} مکمل کریں۔',
    'lg': 'Sooka omaliriza essomo {n}.',
  },
  'This pathway is locked': {
    'es': 'Este camino está bloqueado',
    'ur': 'یہ راستہ ابھی بند ہے',
    'lg': 'Omukutu guno gusibiddwa',
  },
  'Complete {title}, including all its lessons and quizzes (80% or higher), to unlock this pathway.':
      {
    'es':
        'Completa {title}, incluidas todas sus lecciones y cuestionarios (80% o más), para desbloquear este camino.',
    'ur':
        'یہ راستہ کھولنے کے لیے {title} مکمل کریں، اس کے تمام اسباق اور کوئز (80% یا زیادہ) سمیت۔',
    'lg':
        "Maliriza {title}, nga mw'otwalidde amasomo gaagwo gonna n'ebibuuzo (80% oba okusingawo), okuggulawo omukutu guno.",
  },
  'Go to {title}': {
    'es': 'Ir a {title}',
    'ur': '{title} پر جائیں',
    'lg': 'Genda ku {title}',
  },
  'Pathway complete!': {
    'es': '¡Camino completado!',
    'ur': 'راستہ مکمل ہو گیا!',
    'lg': 'Omukutu guwedde!',
  },
  'Well done. You finished every lesson and passed every quiz.': {
    'es':
        'Bien hecho. Terminaste todas las lecciones y aprobaste todos los cuestionarios.',
    'ur': 'شاباش۔ آپ نے تمام اسباق مکمل کیے اور تمام کوئز پاس کیے۔',
    'lg': "Weebale nnyo. Omalirizza buli ssomo era n'oyita buli kibuuzo.",
  },
  'Continue to {title}': {
    'es': 'Continuar con {title}',
    'ur': '{title} کی طرف بڑھیں',
    'lg': 'Weeyongereyo ku {title}',
  },
  'View Core Discipleship Certificate': {
    'es': 'Ver el Certificado de Discipulado Principal',
    'ur': 'بنیادی شاگردی کا سرٹیفکیٹ دیکھیں',
    'lg': "Laba Satifikeeti y'Obuyigirizwa Obukulu",
  },
  'Explore pathways': {
    'es': 'Explorar caminos',
    'ur': 'راستے دیکھیں',
    'lg': 'Laba emikutu',
  },
  'Certificate of Completion': {
    'es': 'Certificado de finalización',
    'ur': 'تکمیل کا سرٹیفکیٹ',
    'lg': "Satifikeeti y'Okumaliriza",
  },
  'This certifies that': {
    'es': 'Se certifica que',
    'ur': 'یہ تصدیق کی جاتی ہے کہ',
    'lg': 'Kino kikakasa nti',
  },
  'has completed': {
    'es': 'ha completado',
    'ur': 'نے مکمل کیا',
    'lg': 'amalirizza',
  },
  'all seven core pathways of the Kingdom Heirs discipleship journey': {
    'es':
        'los siete caminos principales del recorrido de discipulado de Kingdom Heirs',
    'ur': 'Kingdom Heirs شاگردی کے سفر کے ساتوں بنیادی راستے',
    'lg':
        "emikutu omusanvu emikulu egy'olugendo lw'obuyigirizwa bwa Kingdom Heirs",
  },
  'Completed on {date}': {
    'es': 'Completado el {date}',
    'ur': 'تاریخِ تکمیل: {date}',
    'lg': 'Kyamalirizibwa nga {date}',
  },
  'Issued {date}': {
    'es': 'Emitido el {date}',
    'ur': 'جاری کردہ: {date}',
    'lg': 'Yafulumizibwa nga {date}',
  },
  'Certificate ID: {id}': {
    'es': 'ID del certificado: {id}',
    'ur': 'سرٹیفکیٹ آئی ڈی: {id}',
    'lg': 'Namba ya satifikeeti: {id}',
  },
  'Share / Save': {
    'es': 'Compartir / Guardar',
    'ur': 'شیئر / محفوظ کریں',
    'lg': 'Gabana / Tereka',
  },
  'Certificate': {
    'es': 'Certificado',
    'ur': 'سرٹیفکیٹ',
    'lg': 'Satifikeeti',
  },
  'Not earned yet': {
    'es': 'Aún no obtenido',
    'ur': 'ابھی حاصل نہیں ہوا',
    'lg': 'Tekinnafunibwa',
  },
  'Finish every lesson and pass every quiz with 80% or higher to earn this certificate.':
      {
    'es':
        'Termina todas las lecciones y aprueba todos los cuestionarios con 80% o más para obtener este certificado.',
    'ur':
        'یہ سرٹیفکیٹ حاصل کرنے کے لیے تمام اسباق مکمل کریں اور تمام کوئز 80% یا زیادہ نمبروں سے پاس کریں۔',
    'lg':
        'Maliriza buli ssomo era oyite buli kibuuzo ku 80% oba okusingawo okufuna satifikeeti eno.',
  },
  'Complete all seven core pathways to earn this certificate.': {
    'es':
        'Completa los siete caminos principales para obtener este certificado.',
    'ur':
        'یہ سرٹیفکیٹ حاصل کرنے کے لیے ساتوں بنیادی راستے مکمل کریں۔',
    'lg': 'Maliriza emikutu omusanvu emikulu okufuna satifikeeti eno.',
  },
  'No certificates yet. Complete a pathway to earn your first certificate.': {
    'es':
        'Aún no tienes certificados. Completa un camino para obtener tu primer certificado.',
    'ur':
        'ابھی کوئی سرٹیفکیٹ نہیں۔ اپنا پہلا سرٹیفکیٹ حاصل کرنے کے لیے کوئی راستہ مکمل کریں۔',
    'lg':
        'Tonnafuna satifikeeti. Maliriza omukutu okufuna satifikeeti yo esooka.',
  },
  'Could not share the certificate.': {
    'es': 'No se pudo compartir el certificado.',
    'ur': 'سرٹیفکیٹ شیئر نہیں ہو سکا۔',
    'lg': 'Satifikeeti tesobodde kugabanwa.',
  },
  'Every member begins the Kingdom Heirs core journey with {title}.': {
    'es':
        'Todo miembro comienza el recorrido principal de Kingdom Heirs con {title}.',
    'ur': 'ہر رکن Kingdom Heirs کے بنیادی سفر کا آغاز {title} سے کرتا ہے۔',
    'lg': 'Buli mmemba atandika olugendo olukulu olwa Kingdom Heirs ne {title}.',
  },
  'Loading…': {
    'es': 'Cargando…',
    'ur': 'لوڈ ہو رہا ہے…',
    'lg': 'Kitikka…',
  },
};
