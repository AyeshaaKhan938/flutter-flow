import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/custom_code/certificate_pdf.dart';
import '/custom_code/languages/translation_service.dart';

/// The Kingdom Heirs core journey, in order (pathway `stableId`s). Used when a
/// pathway document has no `track` field, and as a tie-breaker for `order`.
/// These are the seven required pathways for the Commissioning Certificate.
const kCorePathwayIds = [
  'come-and-see',
  'rooted-in-christ',
  'journey-into-discipleship-evangelism',
  'holy-spirit-in-the-life-of-every-christian',
  'kingdom-heirs-foundations',
  'inner-healing-and-deliverance',
  'counterfeit-gospels',
];

/// Certificate id for completing all seven required core pathways (kept as
/// 'core-discipleship' so certificates already issued stay valid).
const kCoreCertificateId = 'core-discipleship';
const kCoreCertificateTitle = 'Kingdom Heirs Commissioning Certificate';

/// Title of the certificate earned for every required or optional pathway.
const kPathwayCertificateTitle = 'Pathway Certificate of Completion';

/// Shown on every Pathway Certificate (no commissioning language).
const kCertificateNotice = kPathwayCertificateNotice;

/// The commissioning wording, exactly as Kingdom Heirs approved it
/// (2026-10-14). {name} is the member's name. English only: doctrinal
/// wording is not translated until a ministry reviewer approves it.
const kCommissioningStatement =
    'Having faithfully completed the required Kingdom Heirs Discipleship '
    'Pathways and satisfied the learning and assessment requirements, this '
    'certifies that {name} is commissioned by Kingdom Heirs Foundation to go '
    'into all the world, proclaim the Gospel of Jesus Christ, pray for the '
    'sick, make disciples, and serve the least of these in the name of Jesus '
    'Christ.';

/// The commissioning wording with the member's name filled in.
String commissioningStatementFor(String memberName) =>
    kCommissioningStatement.replaceAll('{name}',
        memberName.trim().isEmpty ? 'this disciple' : memberName.trim());
const kCommissioningReferences = 'Mark 16:15 · Matthew 28:19 · Matthew 25:40';

/// Number of core pathways that make up the full core journey.
const kCorePathwayCount = 7;

/// Default passing standard (percent) for every required quiz.
const kDefaultPassingScore = 80;

/// A pathway's passing standard: the pathway document's `passingScore`
/// (1-100) when set, else [kDefaultPassingScore]. This lets one pathway use a
/// different standard later (planned: from-bondage-to-freedom at 75%).
int passingScoreFor(PathwaysRecord pathway) {
  final v =
      PathwayProgressionService._toInt(pathway.snapshotData['passingScore']);
  return v != null && v > 0 && v <= 100 ? v : kDefaultPassingScore;
}

/// One quiz result as correct answers out of questions.
class QuizScore {
  const QuizScore(this.correct, this.total);

  final int correct;
  final int total;

  double get ratio => total > 0 ? correct / total : 0;

  /// At least [percent]% correct (exact; no rounding up).
  bool passes(int percent) => total > 0 && correct * 100 >= percent * total;

  Map<String, dynamic> toMap() => {'correct': correct, 'total': total};

  static QuizScore? fromMap(dynamic data) {
    if (data is! Map) {
      return null;
    }
    final correct = PathwayProgressionService._toInt(data['correct']);
    final total = PathwayProgressionService._toInt(data['total']);
    if (correct == null || total == null || total <= 0) {
      return null;
    }
    return QuizScore(correct.clamp(0, total), total);
  }

  /// The higher of two scores (by percentage; more questions on a tie).
  static QuizScore? best(QuizScore? a, QuizScore? b) {
    if (a == null) {
      return b;
    }
    if (b == null) {
      return a;
    }
    if (a.ratio != b.ratio) {
      return a.ratio > b.ratio ? a : b;
    }
    return a.total >= b.total ? a : b;
  }
}

/// A certificate grade: total correct answers over total questions across
/// the required quizzes (best attempt per quiz) — not an average of
/// percentages.
class CertificateGrade {
  const CertificateGrade(this.correct, this.total);

  factory CertificateGrade.of(Iterable<QuizScore> scores) {
    var correct = 0;
    var total = 0;
    for (final s in scores) {
      correct += s.correct;
      total += s.total;
    }
    return CertificateGrade(correct, total);
  }

  final int correct;
  final int total;

  /// Whole percent, or null when there are no quiz questions.
  int? get percent => total > 0 ? (correct * 100 / total).round() : null;
}

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
    this.passingScore = kDefaultPassingScore,
    this.requiredQuizIds = const [],
    this.quizScores = const {},
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

  /// Passing standard (percent) for this pathway's quizzes.
  final int passingScore;

  /// Published quizzes of this pathway (all of them are required).
  final List<String> requiredQuizIds;

  /// The member's best score per quiz id (only quizzes with an attempt).
  final Map<String, QuizScore> quizScores;

  String get stableId => pathway.stableId;
  bool get isCore => track == 'core';

  /// English title of the blocking pathway ('' when unlocked).
  String get lockedByTitle => lockedBy?.title.en ?? '';

  /// Pathway grade from the best attempt of every required quiz.
  CertificateGrade get grade => CertificateGrade.of(
      requiredQuizIds.map((id) => quizScores[id]).whereType<QuizScore>());
}

/// The member's progression across all published pathways.
class PathwayProgression {
  PathwayProgression({
    required this.core,
    required this.additional,
    required this.issuedCertificates,
  });

  /// Published core pathways in journey order.
  final List<PathwayStatus> core;

  /// Published additional studies ("Continue Growing"), never locked.
  final List<PathwayStatus> additional;

  /// Certificates already stored in users/{uid}/certificates, by id.
  final Map<String, Map<String, dynamic>> issuedCertificates;

  static PathwayProgression get empty => PathwayProgression(
        core: const [],
        additional: const [],
        issuedCertificates: {},
      );

  Set<String> get issuedCertificateIds => issuedCertificates.keys.toSet();

  Iterable<PathwayStatus> get all => [...core, ...additional];

  PathwayStatus? statusFor(String? pathwayId) =>
      all.where((s) => s.stableId == pathwayId).firstOrNull;

  /// The core pathway after [pathwayId], if any.
  PathwayStatus? nextCoreAfter(String? pathwayId) {
    final i = core.indexWhere((s) => s.stableId == pathwayId);
    return i >= 0 && i + 1 < core.length ? core[i + 1] : null;
  }

  /// True when all seven required pathways are published and completed (in
  /// order: each one only unlocks after the one before it). Optional
  /// studies never count.
  bool get coreJourneyCompleted =>
      core.length >= kCorePathwayCount && core.every((s) => s.completed);

  /// Overall program grade: correct answers over questions across every
  /// quiz of the seven required pathways (best attempt per quiz).
  CertificateGrade get commissioningGrade => CertificateGrade.of([
        for (final s in core)
          ...s.requiredQuizIds
              .map((id) => s.quizScores[id])
              .whereType<QuizScore>(),
      ]);

  /// Whether the member has earned [certificateId] (a pathway stableId or
  /// [kCoreCertificateId]).
  bool hasEarned(String? certificateId) {
    if (certificateId == kCoreCertificateId) {
      return coreJourneyCompleted;
    }
    return statusFor(certificateId)?.completed ?? false;
  }

  /// Current grade for [certificateId] (null when not earned).
  CertificateGrade? gradeFor(String certificateId) {
    if (!hasEarned(certificateId)) {
      return null;
    }
    return certificateId == kCoreCertificateId
        ? commissioningGrade
        : statusFor(certificateId)?.grade;
  }
}

/// Best quiz scores seen on this device, per member. The backend's
/// getQuizAttempt returns a single attempt, so the best score is also kept
/// here (and on issued certificates) to grade from the highest attempt.
class _QuizBestScores {
  static String _key(String uid) => 'kh_quiz_best_$uid';

  static Future<Map<String, QuizScore>> load(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key(uid));
      if (raw == null || raw.isEmpty) {
        return {};
      }
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return {};
      }
      return {
        for (final e in decoded.entries)
          if (QuizScore.fromMap(e.value) != null)
            e.key as String: QuizScore.fromMap(e.value)!,
      };
    } catch (_) {
      return {};
    }
  }

  static Future<void> save(String uid, Map<String, QuizScore> scores) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _key(uid),
        jsonEncode({for (final e in scores.entries) e.key: e.value.toMap()}),
      );
    } catch (_) {}
  }
}

/// Loads published pathways, lessons and quizzes plus the member's lesson
/// progress and quiz attempts, and works out which core pathways are
/// completed and unlocked. Uses the same backend calls (same parameters) as
/// the pages, so cached responses keep it working offline.
///
/// A pathway is completed when 100% of its published lessons are complete
/// and every published quiz is passed at the pathway's standard (80% by
/// default) with the member's highest score. Reflections are saved with
/// lesson completion and no lesson marks a reflection as required, so
/// lesson completion covers the reflection requirement.
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

  /// Remembers a quiz result (e.g. right after submitting) so the highest
  /// attempt counts even if the backend later reports a lower retake.
  static Future<void> recordQuizScore(
    String? quizId, {
    int? correct,
    int? total,
  }) async {
    final uid = currentUserUid;
    if (uid.isEmpty ||
        quizId == null ||
        quizId.isEmpty ||
        correct == null ||
        total == null ||
        total <= 0) {
      return;
    }
    final scores = await _QuizBestScores.load(uid);
    final best = QuizScore.best(
        scores[quizId], QuizScore(correct.clamp(0, total), total));
    if (best != null && !identical(best, scores[quizId])) {
      scores[quizId] = best;
      await _QuizBestScores.save(uid, scores);
    }
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

  /// Number of questions in a quiz document (`questions` list or map).
  static int _questionCount(QuizzesRecord q) {
    final questions = q.questions;
    if (questions is List) {
      return questions.length;
    }
    if (questions is Map) {
      return questions.length;
    }
    return 0;
  }

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
      _issuedCertificates(uid),
      _QuizBestScores.load(uid),
    ]);
    final pathways = (results[0] as List).cast<PathwaysRecord>();
    final lessons = (results[1] as List).cast<LessonsRecord>();
    final quizzes = (results[2] as List).cast<QuizzesRecord>();
    final issued = results[3] as Map<String, Map<String, dynamic>>;
    final localBest = results[4] as Map<String, QuizScore>;

    // Best scores already recorded on issued certificates.
    final storedBest = <String, QuizScore>{};
    for (final cert in issued.values) {
      final scores = cert['quizScores'];
      if (scores is Map) {
        scores.forEach((id, value) {
          final s = QuizScore.fromMap(value);
          if (id is String && s != null) {
            storedBest[id] = QuizScore.best(storedBest[id], s)!;
          }
        });
      }
    }

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

    // Quiz attempts, only where they can change the outcome or the grade
    // (all lessons done, or a certificate already issued), to keep the
    // number of calls down.
    final fetched = <String, QuizScore?>{};
    await Future.wait([
      for (final p in visible)
        if (statusInputs[p.stableId]!.lessonsDone ||
            issued.containsKey(p.stableId))
          for (final q in quizzesByPathway[p.stableId] ?? <QuizzesRecord>[])
            () async {
              fetched[_quizId(q)] = await _attemptScore(q, token);
            }(),
    ]);

    // Highest score per quiz: backend attempt, this device, certificates.
    final best = <String, QuizScore>{};
    for (final id in {...fetched.keys, ...localBest.keys, ...storedBest.keys}) {
      final s = QuizScore.best(
          QuizScore.best(fetched[id], localBest[id]), storedBest[id]);
      if (s != null) {
        best[id] = s;
      }
    }
    if (uid.isNotEmpty) {
      final merged = {...localBest};
      var changed = false;
      fetched.forEach((id, s) {
        final b = QuizScore.best(merged[id], s);
        if (b != null && !identical(b, merged[id])) {
          merged[id] = b;
          changed = true;
        }
      });
      if (changed) {
        unawaited(_QuizBestScores.save(uid, merged));
      }
    }

    final core = <PathwayStatus>[];
    final additional = <PathwayStatus>[];
    PathwaysRecord? previousCore;
    var previousCompleted = true;
    for (final p in visible) {
      final input = statusInputs[p.stableId]!;
      final pathwayQuizzes = quizzesByPathway[p.stableId] ?? [];
      final quizIds = pathwayQuizzes.map(_quizId).toList();
      final threshold = passingScoreFor(p);
      final scores = {
        for (final id in quizIds)
          if (best[id] != null) id: best[id]!,
      };
      final passed =
          quizIds.where((id) => scores[id]?.passes(threshold) ?? false).length;
      // A certificate already issued means it was completed when issued;
      // content added later never takes that back.
      final completed = issued.containsKey(p.stableId) ||
          (input.total > 0 && input.lessonsDone && passed == quizIds.length);
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
          quizzesTotal: quizIds.length,
          quizzesPassed: passed,
          passingScore: threshold,
          requiredQuizIds: quizIds,
          quizScores: scores,
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
          quizzesTotal: quizIds.length,
          quizzesPassed: passed,
          passingScore: threshold,
          requiredQuizIds: quizIds,
          quizScores: scores,
        ));
      }
    }

    final result = PathwayProgression(
      core: core,
      additional: additional,
      issuedCertificates: issued,
    );
    _cached = result;
    _cachedUid = uid;
    return result;
  }

  /// The member's attempt as reported by getQuizAttempt, as correct answers
  /// out of questions. When the response has no counts, they are derived
  /// from the percentage and the quiz document's question count.
  Future<QuizScore?> _attemptScore(QuizzesRecord quiz, String? token) async {
    try {
      final r = await GetQuizAttemptCall.call(
        authToken: token,
        quizId: _quizId(quiz),
      );
      if (!r.succeeded) {
        return null;
      }
      final attempt = QuizAttemptResponseStruct.maybeFromMap(r.jsonBody);
      if (attempt == null || !attempt.hasAttempt) {
        return null;
      }
      if (attempt.total > 0) {
        return QuizScore(
            attempt.correctCount.clamp(0, attempt.total), attempt.total);
      }
      // Percentage only: correct = round(pct x questions / 100). Quizzes
      // have at most 10 questions in the app, used when the count is unknown.
      final questions = _questionCount(quiz) > 0 ? _questionCount(quiz) : 10;
      final pct = attempt.percentage.clamp(0, 100);
      return QuizScore((pct * questions / 100).round(), questions);
    } catch (_) {
      return null;
    }
  }

  static CollectionReference<Map<String, dynamic>> certificatesOf(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('certificates');

  Future<Map<String, Map<String, dynamic>>> _issuedCertificates(
      String uid) async {
    if (uid.isEmpty) {
      return {};
    }
    try {
      final snap = await certificatesOf(uid).get();
      return {for (final d in snap.docs) d.id: d.data()};
    } catch (_) {
      return {};
    }
  }

  /// Issues every earned certificate not yet stored, and raises the stored
  /// grade of issued ones when the member has since improved a quiz score.
  /// Best effort.
  Future<void> issueEarnedCertificates(PathwayProgression progression) async {
    final ids = [
      for (final s in progression.all)
        if (s.completed) s.stableId,
      if (progression.coreJourneyCompleted) kCoreCertificateId,
    ];
    for (final id in ids) {
      unawaited(syncCertificate(progression, id).catchError((_) => null));
    }
  }

  /// Returns the stored certificate [certificateId], creating it the first
  /// time it is earned. Name, completion date and certificate ID never
  /// change after that; only the grade may be raised (Firestore rules
  /// enforce this). Returns null when not earned.
  Future<Map<String, dynamic>?> syncCertificate(
    PathwayProgression progression,
    String certificateId,
  ) async {
    final uid = currentUserUid;
    if (uid.isEmpty || !progression.hasEarned(certificateId)) {
      return progression.issuedCertificates[certificateId];
    }
    final isCore = certificateId == kCoreCertificateId;
    final status = isCore ? null : progression.statusFor(certificateId);
    final grade = progression.gradeFor(certificateId);
    final scores = <String, QuizScore>{
      if (isCore)
        for (final s in progression.core) ...s.quizScores
      else
        ...?status?.quizScores,
    };
    final gradeFields = <String, dynamic>{
      if (grade?.percent != null) 'grade': grade!.percent,
      if (grade != null) 'correctCount': grade.correct,
      if (grade != null) 'questionCount': grade.total,
      'quizScores': {for (final e in scores.entries) e.key: e.value.toMap()},
    };

    final ref = certificatesOf(uid).doc(certificateId);
    var existing = progression.issuedCertificates[certificateId];
    if (existing == null) {
      try {
        final snap = await ref.get();
        existing = snap.exists ? snap.data() : null;
      } catch (_) {}
    }

    if (existing != null) {
      final stored = _toInt(existing['grade']);
      final improved = grade?.percent != null &&
          (stored == null || grade!.percent! > stored);
      if (!improved) {
        progression.issuedCertificates[certificateId] = existing;
        return existing;
      }
      final update = {
        ...gradeFields,
        'gradeUpdatedAt': FieldValue.serverTimestamp(),
      };
      // Not awaited: offline, the write is queued and synced later.
      unawaited(ref.update(update).catchError((_) {}));
      final updated = {
        ...existing,
        ...gradeFields,
        'gradeUpdatedAt': Timestamp.now(),
      };
      progression.issuedCertificates[certificateId] = updated;
      return updated;
    }

    final data = <String, dynamic>{
      'pathwayId': certificateId,
      'type': isCore ? 'commissioning' : 'pathway',
      'title': isCore
          ? kCoreCertificateTitle
          : (status?.pathway.title.en ?? certificateId),
      'memberName': memberDisplayName(),
      'certificateId': certificateNumber(uid, certificateId),
      'passingScore': isCore
          ? kDefaultPassingScore
          : (status?.passingScore ?? kDefaultPassingScore),
      ...gradeFields,
      'issuedAt': FieldValue.serverTimestamp(),
      'completedAt': FieldValue.serverTimestamp(),
    };
    // Not awaited: offline, the write is queued and synced later.
    unawaited(ref.set(data).catchError((_) {}));
    final now = Timestamp.now();
    final local = {...data, 'issuedAt': now, 'completedAt': now};
    progression.issuedCertificates[certificateId] = local;
    return local;
  }

  /// The member's full name from their profile, else the account name.
  static String memberDisplayName() {
    final fullName = (currentUserDocument?.fullName ?? '').trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }
    final name = currentUserDisplayName.trim();
    return name.isNotEmpty ? name : currentUserEmail;
  }

  /// Completion date of a stored certificate (`completedAt`, or `issuedAt`
  /// on certificates issued before `completedAt` existed).
  static DateTime completedAtOf(Map<String, dynamic> data) {
    final v = data['completedAt'] ?? data['issuedAt'];
    return v is Timestamp ? v.toDate() : DateTime.now();
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
    'es':
        'Profundiza a tu propio ritmo. Estos estudios siempre están abiertos.',
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
    'es': 'Certificado de Comisionamiento de Kingdom Heirs',
    'ur': 'کنگڈم ہائرز کمیشننگ سرٹیفکیٹ',
    'lg': "Satifikeeti y'Okutumibwa eya Kingdom Heirs",
  },
  kPathwayCertificateTitle: {
    'es': 'Certificado de finalización del camino',
    'ur': 'راستے کی تکمیل کا سرٹیفکیٹ',
    'lg': "Satifikeeti y'Okumaliriza Omukutu",
  },
  kCommissioningReferences: {
    'es': 'Marcos 16:15 · Mateo 28:19 · Mateo 25:40',
    'ur': 'مرقس 16:15 · متی 28:19 · متی 25:40',
    'lg': 'Makko 16:15 · Matayo 28:19 · Matayo 25:40',
  },
  kCommissioningDisclaimer: {
    'es':
        'Este es un certificado de comisionamiento y reconocimiento ministerial de Kingdom Heirs. No es un título académico acreditado, una licencia profesional ni una credencial de ordenación.',
    'ur':
        'یہ کنگڈم ہائرز کی خدمتی کمیشننگ اور اعتراف کا سرٹیفکیٹ ہے۔ یہ کوئی تسلیم شدہ تعلیمی ڈگری، پیشہ ورانہ لائسنس یا تقرری (آرڈینیشن) کی سند نہیں۔',
    'lg':
        "Eno satifikeeti ya Kingdom Heirs ey'okutumibwa n'okusiimibwa mu buweereza. Si diguli ya ssomero ekkirizibwa, si layisinsi ya bukugu, era si bbaluwa ya kutongozebwa.",
  },
  'Grade {grade}': {
    'es': 'Calificación {grade}',
    'ur': 'گریڈ {grade}',
    'lg': 'Obubonero {grade}',
  },
  'Completed {date} · Grade {grade}': {
    'es': 'Completado el {date} · Calificación {grade}',
    'ur': 'تکمیل: {date} · گریڈ {grade}',
    'lg': 'Kyamalirizibwa {date} · Obubonero {grade}',
  },
  'Download PDF': {
    'es': 'Descargar PDF',
    'ur': 'پی ڈی ایف ڈاؤن لوڈ کریں',
    'lg': 'Wanula PDF',
  },
  'Your grade was updated to {grade}. Your certificate ID and completion date stay the same.':
      {
    'es':
        'Tu calificación se actualizó a {grade}. El ID del certificado y la fecha de finalización no cambian.',
    'ur':
        'آپ کا گریڈ {grade} کر دیا گیا ہے۔ آپ کے سرٹیفکیٹ کی آئی ڈی اور تاریخِ تکمیل وہی رہیں گی۔',
    'lg':
        "Obubonero bwo bukyusiddwa okudda ku {grade}. Namba ya satifikeeti n'olunaku lw'okumaliriza tebikyuka.",
  },
  'The official certificate is issued in English.': {
    'es': 'El certificado oficial se emite en inglés.',
    'ur': 'سرکاری سرٹیفکیٹ انگریزی میں جاری کیا جاتا ہے۔',
    'lg': 'Satifikeeti entongole efulumizibwa mu Lungereza.',
  },
  kCertificateNotice: {
    'es':
        'Este certificado reconoce la finalización de un camino de discipulado de Kingdom Heirs. No es un título acreditado, una credencial profesional, una ordenación ni una licencia ministerial. Cualquier función ministerial o de liderazgo requiere un proceso de aprobación aparte de Kingdom Heirs.',
    'ur':
        'یہ سرٹیفکیٹ کنگڈم ہائرز کے شاگردی کے ایک راستے کی تکمیل کا اعتراف ہے۔ یہ کوئی تسلیم شدہ ڈگری، پیشہ ورانہ سند، تقرری (آرڈینیشن) یا خدمت کا لائسنس نہیں۔ کسی بھی خدمت یا قیادت کے کردار کے لیے کنگڈم ہائرز کی الگ منظوری درکار ہے۔',
    'lg':
        'Satifikeeti eno ekakasa okumaliriza omukutu gw’obuyigirizwa ogwa Kingdom Heirs. Si diguli ekkirizibwa, si bbaluwa ya bukugu, si kutongozebwa mu buweereza era si layisinsi ya buweereza. Omulimu gwonna ogw’obuweereza oba obukulembeze gwetaaga okukkirizibwa okw’enjawulo okwa Kingdom Heirs.',
  },
  'Based on your answers, {title} will be especially meaningful for you. It unlocks as you complete the core pathways before it.':
      {
    'es':
        'Según tus respuestas, {title} será especialmente significativo para ti. Se desbloquea a medida que completas los caminos principales anteriores.',
    'ur':
        'آپ کے جوابات کی بنیاد پر {title} آپ کے لیے خاص طور پر بامعنی ہوگا۔ یہ اس سے پہلے کے بنیادی راستے مکمل کرنے پر کھلتا ہے۔',
    'lg':
        'Okusinziira ku by’oddamu, {title} kijja kukuyamba nnyo. Kiggulwawo bw’omaliriza emikutu emikulu egikisooka.',
  },
  'Based on your answers, we also suggest {title}. You can explore it any time under Additional Studies.':
      {
    'es':
        'Según tus respuestas, también te sugerimos {title}. Puedes explorarlo en cualquier momento en Estudios adicionales.',
    'ur':
        'آپ کے جوابات کی بنیاد پر ہم {title} بھی تجویز کرتے ہیں۔ آپ اسے کسی بھی وقت اضافی مطالعات میں دیکھ سکتے ہیں۔',
    'lg':
        'Okusinziira ku by’oddamu, era tukuwa amagezi ku {title}. Osobola okukisoma essaawa yonna wansi wa Ebyokusoma Ebirala.',
  },
  '{n} lessons': {
    'es': '{n} lecciones',
    'ur': '{n} اسباق',
    'lg': 'Amasomo {n}',
  },
  'Current Pathway': {
    'es': 'Camino actual',
    'ur': 'موجودہ راستہ',
    'lg': 'Omukutu gw’oliko',
  },
  'Locked': {
    'es': 'Bloqueado',
    'ur': 'مقفل',
    'lg': 'Kisibiddwa',
  },
  'Start': {
    'es': 'Comenzar',
    'ur': 'شروع کریں',
    'lg': 'Tandika',
  },
  'Continue': {
    'es': 'Continuar',
    'ur': 'جاری رکھیں',
    'lg': 'Weeyongereyo',
  },
  'Complete your current pathway to unlock.': {
    'es': 'Completa tu camino actual para desbloquearlo.',
    'ur': 'اسے کھولنے کے لیے اپنا موجودہ راستہ مکمل کریں۔',
    'lg': 'Maliriza omukutu gw’oliko okuguggulawo.',
  },
  'What you will discover': {
    'es': 'Lo que descubrirás',
    'ur': 'آپ کیا دریافت کریں گے',
    'lg': 'By’ogenda okuzuula',
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
  'View Commissioning Certificate': {
    'es': 'Ver el Certificado de Comisionamiento',
    'ur': 'کمیشننگ سرٹیفکیٹ دیکھیں',
    'lg': "Laba Satifikeeti y'Okutumibwa",
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
  'Finish every lesson and pass every quiz with {n}% or higher to earn this certificate.':
      {
    'es':
        'Termina todas las lecciones y aprueba todos los cuestionarios con {n}% o más para obtener este certificado.',
    'ur':
        'یہ سرٹیفکیٹ حاصل کرنے کے لیے تمام اسباق مکمل کریں اور تمام کوئز {n}% یا زیادہ نمبروں سے پاس کریں۔',
    'lg':
        'Maliriza buli ssomo era oyite buli kibuuzo ku {n}% oba okusingawo okufuna satifikeeti eno.',
  },
  'Complete all seven required pathways in order, passing every quiz with 80% or higher, to earn this certificate.':
      {
    'es':
        'Completa en orden los siete caminos requeridos, aprobando todos los cuestionarios con 80% o más, para obtener este certificado.',
    'ur':
        'یہ سرٹیفکیٹ حاصل کرنے کے لیے ساتوں لازمی راستے ترتیب سے مکمل کریں اور تمام کوئز 80% یا زیادہ نمبروں سے پاس کریں۔',
    'lg':
        'Maliriza emikutu omusanvu egyetaagisa mu nsengeka yaagyo, ng’oyita buli kibuuzo ku 80% oba okusingawo, okufuna satifikeeti eno.',
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
    'lg':
        'Buli mmemba atandika olugendo olukulu olwa Kingdom Heirs ne {title}.',
  },
  'Loading…': {
    'es': 'Cargando…',
    'ur': 'لوڈ ہو رہا ہے…',
    'lg': 'Kitikka…',
  },
};
