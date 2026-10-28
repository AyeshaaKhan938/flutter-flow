import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_page_model.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/custom_code/languages/language_registry.dart';
export 'profile_page_model.dart';

/// Member profile: name, role, preferred language, sign-out, and an
/// (unguarded) admin content-management link.
class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  static String routeName = 'ProfilePage';
  static String routePath = '/profile';

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  static const _kSupportUrl =
      'https://kingdomheirsfoundation.com/partner-with-us';
  static const _kSupportBody =
      'All Kingdom Heirs discipleship and recovery resources are free for '
      'everyone. They are supported by voluntary gifts. Giving is optional '
      'and never changes your access.';
  static const _kSupportLabels = <String, Map<String, String>>{
    'Support Kingdom Heirs': {
      'es': 'Apoya a Kingdom Heirs',
      'ur': 'کنگڈم ہائرز کی مدد کریں',
      'lg': 'Wagira Kingdom Heirs',
    },
    _kSupportBody: {
      'es':
          'Todos los recursos de discipulado y recuperación de Kingdom Heirs son gratuitos para todos. Se sostienen con donaciones voluntarias. Dar es opcional y nunca cambia tu acceso.',
      'ur':
          'کنگڈم ہائرز کے تمام شاگردی اور بحالی کے وسائل سب کے لیے مفت ہیں۔ یہ رضاکارانہ عطیات سے چلتے ہیں۔ عطیہ دینا اختیاری ہے اور آپ کی رسائی کبھی نہیں بدلتی۔',
      'lg':
          'Ebikozesebwa byonna ebya Kingdom Heirs eby’obuyigirizwa n’okuwona bya bwereere eri buli muntu. Biwagirwa ebirabo by’abantu ku bwagazi. Okugaba si kya buwaze era tekikyusa ngeri gy’okozesaamu app.',
    },
    'Give or become a monthly partner': {
      'es': 'Donar o ser socio mensual',
      'ur': 'عطیہ دیں یا ماہانہ شراکت دار بنیں',
      'lg': 'Gaba oba beera munnaffe buli mwezi',
    },
  };

  String _supportText(String english) =>
      _kSupportLabels[english]?[_model.currentLanguage] ?? english;

  late ProfilePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.profileResult = await GetUserProfileV3Call.call(
        authToken: currentJwtToken,
      );

      if ((_model.profileResult?.succeeded ?? true)) {
        _model.userRole = UserProfileResponseStruct.maybeFromMap(
                (_model.profileResult?.jsonBody ?? ''))
            ?.role;
        safeSetState(() {});
        _model.currentLanguage = UserProfileResponseStruct.maybeFromMap(
                (_model.profileResult?.jsonBody ?? ''))
            ?.preferredLanguage;
        // CMS-added languages: the device choice wins (backend reports English).
        _model.currentLanguage =
            LanguageRegistry.resolveMemberLanguage(_model.currentLanguage);
        safeSetState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: true,
          title: Text(
            FFLocalizations.of(context).getText(
              'j72mxzfg' /* Profile */,
            ),
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Approved Kingdom Heirs Foundation logo.
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: Image.asset(
                      'assets/images/kh_logo_full.png',
                      height: 120.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: 72.0,
                    height: 72.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      shape: BoxShape.circle,
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Text(
                      FFLocalizations.of(context).getText(
                        '76mcghq4' /* KH */,
                      ),
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 28.8,
                      ),
                    ),
                  ),
                  AuthUserStreamWidget(
                    builder: (context) => Text(
                      currentUserDisplayName,
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineSmall
                                    .fontStyle,
                              ),
                    ),
                  ),
                  if (!(_model.userRole == 'member'))
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        _model.profileAdminGateResult =
                            await GetUserProfileV3Call.call(
                          authToken: currentJwtToken,
                        );

                        if ((_model.profileAdminGateResult?.succeeded ??
                            true)) {
                          _model.userRole =
                              UserProfileResponseStruct.maybeFromMap((_model
                                          .profileAdminGateResult?.jsonBody ??
                                      ''))
                                  ?.role;
                          safeSetState(() {});
                          if (UserProfileResponseStruct.maybeFromMap((_model
                                          .profileAdminGateResult?.jsonBody ??
                                      ''))
                                  ?.role ==
                              'admin') {
                            context
                                .pushNamed(AdminPathwaysPageWidget.routeName);
                          } else if (UserProfileResponseStruct.maybeFromMap(
                                      (_model.profileAdminGateResult
                                              ?.jsonBody ??
                                          ''))
                                  ?.role ==
                              'ministry_reviewer') {
                            context
                                .pushNamed(AdminPathwaysPageWidget.routeName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Admin access required.',
                                  style: TextStyle(),
                                ),
                                duration: Duration(milliseconds: 4000),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Could not verify admin role.',
                                style: TextStyle(),
                              ),
                              duration: Duration(milliseconds: 4000),
                            ),
                          );
                        }

                        safeSetState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 16.0,
                              color: Color(0x18162040),
                              offset: Offset(
                                0.0,
                                5.0,
                              ),
                              spreadRadius: -6.0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  '7vc4b05s' /* Manage Content (Admin) */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  '4hs8hcel' /* Visible only to admin and mini... */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(height: 4.0)),
                          ),
                        ),
                      ),
                    ),
                  if (!(_model.userRole == 'member'))
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(AdminPathwaysPageWidget.routeName);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 16.0,
                              color: Color(0x18162040),
                              offset: Offset(
                                0.0,
                                5.0,
                              ),
                              spreadRadius: -6.0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'yy8jszmc' /* Manage Content (Admin) */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  '01vumem0' /* Visible only to admin and mini... */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(height: 4.0)),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'o8r4yn5u' /* Language */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                          // Languages come from the CMS (`languages`), so
                          // new ones need no app update.
                          custom_widgets.LanguageSelector(
                            selected: _model.currentLanguage,
                            onSelected: (code) async {
                              _model.currentLanguage = code;
                              safeSetState(() {});
                              await actions.setPreferredLanguage(
                                context,
                                currentJwtToken,
                                code,
                              );
                              safeSetState(() {});
                            },
                          ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                  ),
                  // Support Kingdom Heirs: discreet and optional. Opens the
                  // Kingdom Heirs Foundation giving page (Givebutter) in the
                  // browser; nothing in the app depends on giving.
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _supportText('Support Kingdom Heirs'),
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600),
                                  letterSpacing: 0.0,
                                ),
                          ),
                          Text(
                            _supportText(_kSupportBody),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              alignment: AlignmentDirectional.centerStart,
                            ),
                            onPressed: () => launchUrl(
                              Uri.parse(_kSupportUrl),
                              mode: LaunchMode.externalApplication,
                            ),
                            icon: Icon(Icons.favorite_outline,
                                size: 18.0,
                                color: FlutterFlowTheme.of(context).primary),
                            label: Text(
                              _supportText('Give or become a monthly partner'),
                              style: FlutterFlowTheme.of(context)
                                  .labelLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ].divide(const SizedBox(height: 8.0)),
                      ),
                    ),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      GoRouter.of(context).prepareAuthEvent();
                      // Remove this member's private data from the device.
                      await actions.clearMemberOfflineData();
                      await authManager.signOut();
                      GoRouter.of(context).clearRedirectLocation();

                      context.goNamedAuth(
                          SignInPageWidget.routeName, context.mounted);
                    },
                    text: FFLocalizations.of(context).getText(
                      'fqju2unp' /* Sign Out */,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Colors.transparent,
                      textStyle: TextStyle(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ].divide(SizedBox(height: 20.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
