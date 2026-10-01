import '/custom_code/actions/index.dart' as actions;
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/push_notifications/push_notifications_util.dart';
import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import '/backend/mock/mock_debug_overlay.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'index.dart';
// Hand edit (keep after FlutterFlow sync): CMS-managed languages.
import '/custom_code/languages/language_app_support.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  // Start initial custom actions code
  await actions.ensureFirestoreOfflinePersistence();
  await initializeLanguageSupport();
  // End initial custom actions code

  await FFLocalizations.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  // Hand edit: the stored code is the member's content language, which may
  // be a CMS-added language; Flutter gets the nearest compiled locale.
  Locale? _locale = FFLocalizations.getStoredLocale() == null
      ? null
      : createLocale(
          LanguageRegistry.frameworkLocaleFor(LanguageRegistry.contentLanguage));

  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.path;
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  final authUserSub = authenticatedUserStream.listen((_) {});
  final fcmTokenSub = fcmTokenUserStream.listen(
    (_) {},
    // Registering a token can fail for reasons outside the app's control (a
    // browser without the Notification API, a revoked permission, a blocked
    // cloud call). Swallow it here so it can't surface as an unhandled zone
    // error and take down the app on login.
    onError: (e) => print('Error registering FCM token: $e'),
  );

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    // Hand edit: rebuild screens when translations or languages change.
    languageDataListenable.addListener(_onLanguageDataChanged);
    _router = createRouter(_appStateNotifier);
    userStream = kingdomHeirsDiscipleshipAppFirebaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
        // Download content in the background so the app works offline.
        if (user.loggedIn) {
          actions.prefetchOfflineContent();
        }
      });
    jwtTokenStream.listen((_) {});
    // Push progress, reflections and language changes made offline as soon
    // as the device reconnects, instead of waiting for a lesson to be opened.
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online && currentUserUid.isNotEmpty) {
        () async {
          try {
            await actions.refreshConnectivityAndSync(currentJwtToken);
          } catch (_) {}
          // Refresh the offline copy, including results of anything that
          // was just synced.
          await actions.prefetchOfflineContent(force: true);
        }();
      }
    });
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void _onLanguageDataChanged() {
    bumpLanguageDataVersion();
    safeSetState(() {});
  }

  @override
  void dispose() {
    languageDataListenable.removeListener(_onLanguageDataChanged);
    authUserSub.cancel();
    fcmTokenSub.cancel();
    _connectivitySub?.cancel();
    super.dispose();
  }

  void setLocale(String language) {
    // Hand edit: any CMS language; see _locale.
    LanguageRegistry.instance.setContentLanguage(language);
    safeSetState(() => _locale =
        createLocale(LanguageRegistry.frameworkLocaleFor(language)));
    FFLocalizations.storeLocale(language);
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kingdom Heirs Discipleship App',
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
        ContentLanguageRefreshDelegate(languageDataVersion), // Hand edit
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
        Locale('es'),
        Locale('lg'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
      // The mock-data debug panel is for development only; hide it from
      // members in release builds.
      // Hand edit: RTL for CMS-added right-to-left languages.
      builder: (_, child) => kReleaseMode
          ? withContentDirectionality(child!)
          : MockDebugOverlay(child: withContentDirectionality(child!)),
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({
    Key? key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  }) : super(key: key);

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'HomePage';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'HomePage': HomePageWidget(),
      'PathwayListPage': PathwayListPageWidget(),
      'BiblePage': BiblePageWidget(),
      'ProfilePage': ProfilePageWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: Container(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        child: SafeArea(
          child: GNav(
            selectedIndex: currentIndex,
            onTabChange: (i) => safeSetState(() {
              _currentPage = null;
              _currentPageName = tabs.keys.toList()[i];
            }),
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            color: FlutterFlowTheme.of(context).secondaryText,
            activeColor: FlutterFlowTheme.of(context).secondary,
            tabBackgroundColor: Color(0x22C4A35A),
            tabBorderRadius: 24.0,
            tabMargin: EdgeInsetsDirectional.fromSTEB(6.0, 8.0, 6.0, 22.0),
            padding: EdgeInsetsDirectional.fromSTEB(18.0, 10.0, 18.0, 10.0),
            gap: 8.0,
            mainAxisAlignment: MainAxisAlignment.center,
            duration: Duration(milliseconds: 500),
            haptic: false,
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: FFLocalizations.of(context).getText(
                  'amxdvirb' /* Home */,
                ),
              ),
              GButton(
                icon: Icons.menu_book,
                text: FFLocalizations.of(context).getText(
                  '6248jqp7' /* Pathways */,
                ),
              ),
              // Bible tab (hand-added): full Bible in the member's language.
              GButton(
                icon: Icons.auto_stories_outlined,
                text: switch (LanguageRegistry.contentLanguage) {
                  'es' => 'Biblia',
                  'ur' => 'بائبل',
                  'lg' => 'Baibuli',
                  'en' => 'Bible',
                  final lang =>
                    TranslationService.instance.translate('Bible', lang),
                },
              ),
              GButton(
                icon: Icons.person,
                text: FFLocalizations.of(context).getText(
                  'zv6tqbs6' /* Profile */,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
