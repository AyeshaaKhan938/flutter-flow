import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';
import '/custom_code/pathway_progression.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

// Kingdom Heirs home palette (navy, warm gold, ivory, sage), as approved in
// the home-screen concept of 2026-10-26.
const _kNavy = Color(0xFF1A2A4A);
const _kGold = Color(0xFFC4A35A);
const _kGoldText = Color(0xFF8A6D2B);
const _kGoldSoft = Color(0xFFF3ECDC);
const _kIvory = Color(0xFFF7F5F0);
const _kCard = Color(0xFFFFFDF9);
const _kLine = Color(0xFFE8E4DC);
const _kSage = Color(0xFF4F6E55);
const _kSageSoft = Color(0xFFEEF2EA);
const _kMuted = Color(0xFF5E584F);
const _kLocked = Color(0xFFE6E2DA);

/// Kingdom Heirs giving page (same as the Profile support card).
const _kGivingUrl = 'https://kingdomheirsfoundation.com/partner-with-us';

/// Kingdom Heirs' YouTube channel (teaching library). Teachings open in
/// YouTube or the browser; the app never hosts or downloads video.
const _kYouTubeUrl = 'https://youtube.com/@kingdomheirsco';

/// Approved Kingdom Heirs crown (from the Kingdom Heirs Foundation logo).
const _kLogoAsset = 'assets/images/kh_logo.png';

/// Short labels for the seven core pathways in the journey row.
const _kCoreShortLabels = {
  'come-and-see': 'Come & See',
  'rooted-in-christ': 'Rooted',
  'journey-into-discipleship-evangelism': 'Disciple',
  'holy-spirit-in-the-life-of-every-christian': 'Holy Spirit',
  'kingdom-heirs-foundations': 'Foundations',
  'inner-healing-and-deliverance': 'Healing',
  'counterfeit-gospels': 'Truth',
};

/// The member's home: greeting, today's Scripture, the seven-pathway journey,
/// one-tap continuation, ministry entry points and voluntary giving.
class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Today's verse from API.Bible (reference chosen in the CMS). Empty until
  // loaded, in which case Psalm 119:105 is shown.
  String _todayScriptureRef = '';
  String _todayScriptureText = '';

  PathwayProgression? _progression;

  bool _giftMonthly = true;
  int _giftAmount = 10;

  String get _lang => LanguageRegistry.contentLanguage;

  String _t(String english) => _lang == 'en'
      ? english
      : TranslationService.instance.translate(english, _lang);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _loadProgression();
      _model.profileResult = await GetUserProfileV2Call.call(
        authToken: currentJwtToken,
      );
      if ((_model.profileResult?.succeeded ?? true)) {
        _model.isOnboardingComplete = UserProfileResponseStruct.maybeFromMap(
                (_model.profileResult?.jsonBody ?? ''))
            ?.onboardingCompleted;
        safeSetState(() {});
      }
      final today = await GetTodayContentCall.call(
        authToken: currentJwtToken,
      );
      final content =
          TodayContentResponseStruct.maybeFromMap(today.jsonBody ?? '');
      // Same day as the Today screen: the published record for the
      // member's own date wins over the backend, which uses server (UTC)
      // time. The verse itself comes from API.Bible; the CMS text is Kingdom
      // Heirs commentary and is never displayed here as Scripture.
      var ref = '';
      try {
        final now = DateTime.now();
        final day = now.month == 2 && now.day == 29 ? 28 : now.day;
        final date = '${now.month.toString().padLeft(2, '0')}-'
            '${day.toString().padLeft(2, '0')}';
        final records = await queryDailyScriptureRecordOnce(
          queryBuilder: (q) => q.where('date', isEqualTo: date),
        );
        ref = records
                .where((r) => r.status == 'published')
                .firstOrNull
                ?.verseRef ??
            '';
      } catch (_) {}
      if (ref.isEmpty && today.succeeded && content != null) {
        ref = content.scriptureRef;
      }
      if (ref.isNotEmpty) {
        final passage = await actions.fetchBiblePassage(
          ref,
          content?.language ?? _lang,
        );
        if (passage != null && passage.text.isNotEmpty) {
          _todayScriptureRef = passage.reference;
          _todayScriptureText = passage.text.trim();
          safeSetState(() {});
        }
      }
    });
  }

  Future<void> _loadProgression({bool force = false}) async {
    try {
      final p = await PathwayProgressionService.instance.load(force: force);
      _progression = p;
      safeSetState(() {});
    } catch (_) {
      // The journey row then shows every step as not started.
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return _t('Good morning,');
    if (h < 17) return _t('Good afternoon,');
    return _t('Good evening,');
  }

  String get _firstName {
    final name = currentUserDisplayName.trim();
    return name.isEmpty ? '' : name.split(RegExp(r'\s+')).first;
  }

  /// The first core pathway that is open and not yet completed.
  PathwayStatus? get _current {
    final core = _progression?.core ?? const <PathwayStatus>[];
    for (final s in core) {
      if (s.unlocked && !s.completed) return s;
    }
    return null;
  }

  Future<void> _continueJourney() async {
    final current = _current;
    if (current != null) {
      await context.pushNamed(
        PathwayOverviewPageWidget.routeName,
        queryParameters: {
          'pathwayId': serializeParam(current.stableId, ParamType.String),
        }.withoutNulls,
      );
      _loadProgression(force: true);
    } else if (_progression?.coreJourneyCompleted ?? false) {
      context.pushNamed(MyCertificatesPageWidget.routeName);
    } else {
      context.goNamed(PathwayListPageWidget.routeName);
    }
  }

  void _showComingSoon(String title, String body, IconData icon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _kCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icon, color: _kGoldText, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style: GoogleFonts.lora(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: _kNavy)),
                ),
              ]),
              const SizedBox(height: 12),
              _Pill(label: _t('Coming soon'), bg: _kGoldSoft, fg: _kGoldText),
              const SizedBox(height: 12),
              Text(body,
                  style: GoogleFonts.inter(
                      fontSize: 15, height: 1.5, color: _kMuted)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    backgroundColor: _kNavy,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text(_t('Close'),
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _kIvory,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: RefreshIndicator(
              color: _kGoldText,
              onRefresh: () => _loadProgression(force: true),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                children: [
                  _greetingBlock(),
                  if (_model.isOnboardingComplete != true &&
                      _model.profileResult != null)
                    _setupCard(),
                  _scriptureCard(),
                  const SizedBox(height: 14),
                  _journeyCard(),
                  const SizedBox(height: 14),
                  _continueCard(),
                  const SizedBox(height: 10),
                  _entryCard(
                    icon: Icons.emoji_events_outlined,
                    iconColor: _kNavy,
                    title: _t('Sports Tournaments'),
                    subtitle: _t('Faith. Teamwork. A Greater Purpose.'),
                    badge: _t('Coming soon'),
                    onTap: () => _showComingSoon(
                      _t('Sports Tournaments'),
                      _t('Coaches will register their teams here and see the '
                          'calendar of tournaments scheduled in different '
                          'countries, with dates and times. You will also be '
                          'able to request a tournament in your city. After '
                          'each tournament, players are welcomed into the '
                          'Kingdom Heirs discipleship pathways.'),
                      Icons.emoji_events_outlined,
                    ),
                  ),
                  _entryCard(
                    icon: Icons.groups_outlined,
                    iconColor: _kGoldText,
                    title: _t('Kingdom Heirs School Clubs'),
                    subtitle: _t('Bring faith and purpose to your school.'),
                    badge: _t('Coming soon'),
                    onTap: () => _showComingSoon(
                      _t('Kingdom Heirs School Clubs'),
                      _t('Students and leaders will start and join Kingdom '
                          'Heirs clubs at their school, with lessons, '
                          'missions and tools for club leaders.'),
                      Icons.groups_outlined,
                    ),
                  ),
                  _entryCard(
                    icon: Icons.landscape_outlined,
                    iconColor: _kSage,
                    title: _t('Breaking Free From Addiction'),
                    subtitle: _t('Hope. Healing. A New Tomorrow.'),
                    badge: _t('Coming soon'),
                    onTap: () => _showComingSoon(
                      _t('Breaking Free From Addiction'),
                      _t('The From Bondage to Freedom pathway and private '
                          'recovery tools will open here.'),
                      Icons.landscape_outlined,
                    ),
                  ),
                  _entryCard(
                    icon: Icons.chat_bubble_outline,
                    iconColor: _kGoldText,
                    title: _t('Ask Kingdom Heirs'),
                    subtitle:
                        _t('Get biblical answers and encouragement.'),
                    badge: _t('New'),
                    onTap: () =>
                        context.pushNamed(RagSearchPageWidget.routeName),
                  ),
                  _entryCard(
                    icon: Icons.play_circle_outline,
                    iconColor: _kNavy,
                    title: _t('Kingdom Heirs Teachings'),
                    subtitle: _t('Watch video teachings on YouTube.'),
                    badge: _t('YouTube'),
                    onTap: () => launchURL(_kYouTubeUrl),
                  ),
                  const SizedBox(height: 8),
                  _givingCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _kNavy,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 10, 16),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                height: 34,
                child: Image.asset(
                  _kLogoAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      CustomPaint(painter: _CrownPainter()),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kingdom Heirs',
                        style: GoogleFonts.lora(
                            fontSize: 23, color: const Color(0xFFFFFDF9))),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'DISCIPLES  ·  LEADERS  ·  A BRIGHTER WORLD',
                        style: GoogleFonts.inter(
                            fontSize: 9.5,
                            letterSpacing: 1.6,
                            color: const Color(0xFFD9BC74)),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: _t('Announcements'),
                onPressed: () => context.pushNamed(TodayPageWidget.routeName),
                icon: const Icon(Icons.notifications_none,
                    color: Color(0xFFFFFDF9), size: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _greetingBlock() {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _SunriseHillsPainter())),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_greeting,
                    style: GoogleFonts.lora(fontSize: 22, color: _kNavy)),
                Text(
                  _firstName.isEmpty ? _t('Welcome home') : _firstName,
                  style: GoogleFonts.lora(
                      fontSize: 34,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                      color: _kNavy),
                ),
                const SizedBox(height: 4),
                Text(_t('Yahweh is faithful in every step.'),
                    style: GoogleFonts.lora(fontSize: 15, color: _kMuted)),
                const SizedBox(height: 10),
                Container(
                  width: 44,
                  height: 3,
                  decoration: BoxDecoration(
                      color: _kGold, borderRadius: BorderRadius.circular(2)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _setupCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _tappableCard(
        color: _kGoldSoft,
        border: const Color(0xFFE3D5B2),
        onTap: () => context.pushNamed(OnboardingSurveyPageWidget.routeName),
        child: Row(children: [
          const Icon(Icons.flag_outlined, color: _kGoldText, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_t('Finish setting up'),
                    style: GoogleFonts.lora(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _kNavy)),
                Text(_t('Answer a few questions so we can suggest where to begin.'),
                    style: GoogleFonts.inter(fontSize: 13, color: _kMuted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _kMuted),
        ]),
      ),
    );
  }

  Widget _scriptureCard() {
    final hasVerse = _todayScriptureText.isNotEmpty;
    final verse = hasVerse
        ? _todayScriptureText
        : 'Your word is a lamp to my feet, and a light for my path.';
    final reference = hasVerse ? _todayScriptureRef : 'Psalm 119:105';
    return _tappableCard(
      onTap: () => context.pushNamed(TodayPageWidget.routeName),
      shadow: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: _kGoldSoft, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.menu_book_outlined,
                color: _kGoldText, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_t("Today's Scripture").toUpperCase(),
                    style: GoogleFonts.inter(
                        fontSize: 10.5,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                        color: _kGoldText)),
                const SizedBox(height: 6),
                Text('“$verse”',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(
                        fontSize: 17, height: 1.35, color: _kNavy)),
                const SizedBox(height: 6),
                Text('— $reference',
                    style: GoogleFonts.lora(fontSize: 13.5, color: _kMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _journeyCard() {
    final statuses = {
      for (final s in _progression?.core ?? const <PathwayStatus>[])
        s.stableId: s
    };
    final currentId = _current?.stableId;
    var step = 1;
    for (var i = 0; i < kCorePathwayIds.length; i++) {
      if (statuses[kCorePathwayIds[i]]?.completed ?? false) step = i + 2;
    }
    if (step > kCorePathwayCount) step = kCorePathwayCount;
    final stepLabel = _t('Step {n} of {total}')
        .replaceAll('{n}', '$step')
        .replaceAll('{total}', '$kCorePathwayCount');

    return _tappableCard(
      onTap: () => context.goNamed(PathwayListPageWidget.routeName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(_t('Your Discipleship Journey'),
                    style: GoogleFonts.lora(fontSize: 19, color: _kNavy)),
              ),
              Text(stepLabel.toUpperCase(),
                  style: GoogleFonts.inter(
                      fontSize: 10.5,
                      letterSpacing: 1.4,
                      fontWeight: FontWeight.w700,
                      color: _kGoldText)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < kCorePathwayIds.length; i++)
                Expanded(
                  child: _JourneyStep(
                    number: i + 1,
                    label: _t(_kCoreShortLabels[kCorePathwayIds[i]] ?? ''),
                    completed:
                        statuses[kCorePathwayIds[i]]?.completed ?? false,
                    current: kCorePathwayIds[i] == currentId,
                    isFirst: i == 0,
                    isLast: i == kCorePathwayIds.length - 1,
                    previousDone: i > 0 &&
                        (statuses[kCorePathwayIds[i - 1]]?.completed ?? false),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _continueCard() {
    final current = _current;
    final done = _progression?.coreJourneyCompleted ?? false;
    final String title;
    final String subtitle;
    if (current != null) {
      title = _t('Continue: {title}')
          .replaceAll('{title}', current.pathway.title.forLanguage(_lang));
      subtitle = current.lessonsTotal > 0
          ? _t('Lesson {n} of {total}')
              .replaceAll('{n}',
                  '${(current.lessonsCompleted + 1).clamp(1, current.lessonsTotal)}')
              .replaceAll('{total}', '${current.lessonsTotal}')
          : _t("Build your foundation in God's Word.");
    } else if (done) {
      title = _t('Journey complete');
      subtitle = _t('View your Commissioning Certificate.');
    } else {
      title = _t('Begin your journey');
      subtitle = _t("Build your foundation in God's Word.");
    }
    return _tappableCard(
      color: _kSageSoft,
      border: const Color(0xFFD7E0D2),
      onTap: _continueJourney,
      child: Row(
        children: [
          const Icon(Icons.eco_outlined, color: _kSage, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lora(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: _kNavy)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: GoogleFonts.lora(fontSize: 13.5, color: _kMuted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
                color: _kGold, borderRadius: BorderRadius.circular(22)),
            child: Text(done ? _t('View') : _t('Continue'),
                style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
          const Icon(Icons.chevron_right, color: _kMuted),
        ],
      ),
    );
  }

  Widget _entryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badge,
    required VoidCallback onTap,
  }) {
    final isNew = badge == _t('New');
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _tappableCard(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(width: 40, child: Icon(icon, color: iconColor, size: 34)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.lora(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: _kNavy)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: GoogleFonts.lora(fontSize: 13.5, color: _kMuted)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _Pill(
              label: badge,
              bg: isNew ? _kSageSoft : const Color(0xFFE6EEF8),
              fg: isNew ? _kSage : const Color(0xFF2C4F7C),
            ),
            const Icon(Icons.chevron_right, color: _kMuted),
          ],
        ),
      ),
    );
  }

  Widget _givingCard() {
    const amounts = [5, 10, 25, 50];
    final selected = _giftMonthly
        ? _t('\${amount} / month').replaceAll('{amount}', '$_giftAmount')
        : _t('\${amount} one-time').replaceAll('{amount}', '$_giftAmount');
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _kLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_t('Help Keep Discipleship Free'),
              style: GoogleFonts.lora(
                  fontSize: 21, fontWeight: FontWeight.w700, color: _kNavy)),
          const SizedBox(height: 6),
          Text(
              _t('Your generosity helps provide biblical teaching, recovery '
                  'resources, and discipleship tools to people around the '
                  'world.'),
              style: GoogleFonts.inter(
                  fontSize: 14.5, height: 1.45, color: _kMuted)),
          const SizedBox(height: 14),
          Row(children: [
            _segment(_t('Monthly'), _giftMonthly,
                () => setState(() => _giftMonthly = true)),
            const SizedBox(width: 6),
            _segment(_t('One-time'), !_giftMonthly,
                () => setState(() => _giftMonthly = false)),
          ]),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final a in amounts) ...[
                Expanded(
                  child: _AmountChip(
                    label: '\$$a',
                    selected: a == _giftAmount,
                    onTap: () => setState(() => _giftAmount = a),
                  ),
                ),
                if (a != amounts.last) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: _kGoldSoft, borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_t('Your selected gift'),
                    style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: _kNavy)),
                const SizedBox(height: 2),
                Text(selected,
                    style: GoogleFonts.lora(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _kNavy)),
                const SizedBox(height: 4),
                Text(
                    _t('You will complete your gift securely on the Kingdom '
                        'Heirs giving page. Giving is always voluntary.'),
                    style: GoogleFonts.inter(fontSize: 12.5, color: _kMuted)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => launchURL(_kGivingUrl),
              style: TextButton.styleFrom(
                backgroundColor: _kNavy,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(_t('Visit Kingdom Heirs Giving Page'),
                  style: GoogleFonts.inter(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _segment(String label, bool selected, VoidCallback onTap) {
    return Material(
      color: selected ? _kGoldSoft : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: selected ? _kNavy : const Color(0xFF8C867C))),
        ),
      ),
    );
  }

  Widget _tappableCard({
    required Widget child,
    required VoidCallback onTap,
    Color color = _kCard,
    Color border = _kLine,
    bool shadow = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: shadow
            ? const [
                BoxShadow(
                    color: Color(0x141A2A4A),
                    blurRadius: 18,
                    offset: Offset(0, 6))
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.bg, required this.fg});

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _kNavy : _kCard,
      shape: StadiumBorder(
          side: BorderSide(color: selected ? _kNavy : _kLine, width: 1.5)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Center(
            child: Text(label,
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : _kNavy)),
          ),
        ),
      ),
    );
  }
}

/// One step of the seven-pathway row: a circle (done, current or locked)
/// joined to its neighbours by a thin line, with a short label underneath.
class _JourneyStep extends StatelessWidget {
  const _JourneyStep({
    required this.number,
    required this.label,
    required this.completed,
    required this.current,
    required this.isFirst,
    required this.isLast,
    required this.previousDone,
  });

  final int number;
  final String label;
  final bool completed;
  final bool current;
  final bool isFirst;
  final bool isLast;
  final bool previousDone;

  @override
  Widget build(BuildContext context) {
    final Widget circle;
    if (completed) {
      circle = const CircleAvatar(
        radius: 16,
        backgroundColor: _kSage,
        child: Icon(Icons.check, size: 18, color: Colors.white),
      );
    } else if (current) {
      circle = Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _kGold,
          shape: BoxShape.circle,
          border: Border.all(color: _kGoldSoft, width: 3),
        ),
        alignment: Alignment.center,
        child: Text('$number',
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
      );
    } else {
      circle = const CircleAvatar(
        radius: 16,
        backgroundColor: _kLocked,
        child: Icon(Icons.lock_outline, size: 15, color: Color(0xFF8C867C)),
      );
    }
    Color lineColor(bool done) => done ? const Color(0xFFCDB683) : _kLocked;
    return Column(
      children: [
        SizedBox(
          height: 34,
          child: Row(
            children: [
              Expanded(
                child: Container(
                    height: 2,
                    color: isFirst ? Colors.transparent : lineColor(previousDone)),
              ),
              circle,
              Expanded(
                child: Container(
                    height: 2,
                    color: isLast ? Colors.transparent : lineColor(completed)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text('$number',
            style: GoogleFonts.inter(fontSize: 10, color: _kMuted)),
        Text(label.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 2,
            style: GoogleFonts.inter(
                fontSize: 8.5,
                height: 1.2,
                letterSpacing: 0.3,
                fontWeight: current ? FontWeight.w700 : FontWeight.w500,
                color: current
                    ? _kGoldText
                    : completed
                        ? _kSage
                        : _kMuted)),
      ],
    );
  }
}

/// Drawn crown, shown only if the logo asset cannot be loaded.
class _CrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final crown = Path()
      ..moveTo(w * 0.08, h * 0.78)
      ..lineTo(w * 0.04, h * 0.22)
      ..lineTo(w * 0.28, h * 0.50)
      ..lineTo(w * 0.50, h * 0.08)
      ..lineTo(w * 0.72, h * 0.50)
      ..lineTo(w * 0.96, h * 0.22)
      ..lineTo(w * 0.92, h * 0.78)
      ..close();
    canvas.drawPath(
        crown,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1DDA4), Color(0xFFC4A35A)],
          ).createShader(Offset.zero & size));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.08, h * 0.84, w * 0.84, h * 0.12),
            const Radius.circular(2)),
        Paint()..color = const Color(0xFFC4A35A));
    for (final x in [0.04, 0.50, 0.96]) {
      canvas.drawCircle(Offset(w * x, h * (x == 0.50 ? 0.08 : 0.22)), 2.6,
          Paint()..color = const Color(0xFFF1DDA4));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Soft sunrise over hills behind the greeting.
class _SunriseHillsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sun = Offset(w * 0.86, h * 0.42);
    canvas.drawCircle(
        sun,
        h * 0.9,
        Paint()
          ..shader = RadialGradient(colors: [
            const Color(0xFFFFE3A3).withValues(alpha: 0.55),
            const Color(0xFFFFE3A3).withValues(alpha: 0.0),
          ]).createShader(Rect.fromCircle(center: sun, radius: h * 0.9)));
    canvas.drawCircle(sun, 9, Paint()..color = const Color(0xFFFFF4D6));

    Path hill(double startY, List<Offset> peaks) {
      final p = Path()..moveTo(w * 0.38, h);
      p.lineTo(w * 0.38, startY);
      for (final o in peaks) {
        p.lineTo(o.dx, o.dy);
      }
      p
        ..lineTo(w, h)
        ..close();
      return p;
    }

    canvas.drawPath(
        hill(h * 0.95, [
          Offset(w * 0.55, h * 0.62),
          Offset(w * 0.66, h * 0.70),
          Offset(w * 0.80, h * 0.48),
          Offset(w, h * 0.60),
        ]),
        Paint()..color = const Color(0xFFDCD6CB).withValues(alpha: 0.55));
    canvas.drawPath(
        hill(h, [
          Offset(w * 0.62, h * 0.82),
          Offset(w * 0.74, h * 0.74),
          Offset(w * 0.90, h * 0.84),
          Offset(w, h * 0.76),
        ]),
        Paint()..color = const Color(0xFFC9C2B4).withValues(alpha: 0.45));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
