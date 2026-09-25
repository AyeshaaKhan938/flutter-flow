import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'sign_up_page_model.dart';
export 'sign_up_page_model.dart';

/// Member sign-up.
///
/// Mock-backed for now; swap for app.ensureFirebaseAuth once the client
/// Firebase project is connected.
class SignUpPageWidget extends StatefulWidget {
  const SignUpPageWidget({super.key});

  static String routeName = 'SignUpPage';
  static String routePath = '/sign-up';

  @override
  State<SignUpPageWidget> createState() => _SignUpPageWidgetState();
}

class _SignUpPageWidgetState extends State<SignUpPageWidget> {
  late SignUpPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignUpPageModel());

    _model.fullNameFieldTextController ??= TextEditingController();
    _model.fullNameFieldFocusNode ??= FocusNode();

    _model.phoneFieldTextController ??= TextEditingController();
    _model.phoneFieldFocusNode ??= FocusNode();

    _model.signUpEmailFieldTextController ??= TextEditingController();
    _model.signUpEmailFieldFocusNode ??= FocusNode();

    _model.signUpPasswordFieldTextController ??= TextEditingController();
    _model.signUpPasswordFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
              'framilt1' /* Create Account */,
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
            padding: EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/kingdom-heirs-discipleshipapp.firebasestorage.app/o/branding%2Fphoto_03.jpg?alt=media',
                      width: double.infinity,
                      height: 110.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      'a5147fnc' /* Create your account */,
                    ),
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                  ),
                  TextFormField(
                    controller: _model.fullNameFieldTextController,
                    focusNode: _model.fullNameFieldFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.fullNameFieldTextController',
                      Duration(milliseconds: 2000),
                      () async {
                        _model.fullName =
                            _model.fullNameFieldTextController.text;
                        safeSetState(() {});
                      },
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: FFLocalizations.of(context).getText(
                        '4uemf7j5' /* Full name */,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      filled: true,
                    ),
                    style: TextStyle(),
                    maxLines: null,
                    validator: _model.fullNameFieldTextControllerValidator
                        .asValidator(context),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _model.phoneFieldTextController,
                        focusNode: _model.phoneFieldFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.phoneFieldTextController',
                          Duration(milliseconds: 2000),
                          () async {
                            _model.phone = _model.phoneFieldTextController.text;
                            safeSetState(() {});
                          },
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: FFLocalizations.of(context).getText(
                            '0yamf9ha' /* Phone number (optional) */,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          filled: true,
                        ),
                        style: TextStyle(),
                        maxLines: null,
                        validator: _model.phoneFieldTextControllerValidator
                            .asValidator(context),
                      ),
                      Container(
                        child: custom_widgets.CountryCityPicker(),
                      ),
                    ].divide(SizedBox(height: 14.0)),
                  ),
                  TextFormField(
                    controller: _model.signUpEmailFieldTextController,
                    focusNode: _model.signUpEmailFieldFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.signUpEmailFieldTextController',
                      Duration(milliseconds: 2000),
                      () async {
                        _model.email =
                            _model.signUpEmailFieldTextController.text;
                        safeSetState(() {});
                      },
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: FFLocalizations.of(context).getText(
                        '3wnu1x92' /* Email */,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      filled: true,
                    ),
                    style: TextStyle(),
                    maxLines: null,
                    keyboardType: TextInputType.emailAddress,
                    validator: _model.signUpEmailFieldTextControllerValidator
                        .asValidator(context),
                  ),
                  TextFormField(
                    controller: _model.signUpPasswordFieldTextController,
                    focusNode: _model.signUpPasswordFieldFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.signUpPasswordFieldTextController',
                      Duration(milliseconds: 2000),
                      () async {
                        _model.password =
                            _model.signUpPasswordFieldTextController.text;
                        safeSetState(() {});
                      },
                    ),
                    obscureText: !_model.signUpPasswordFieldVisibility,
                    decoration: InputDecoration(
                      labelText: FFLocalizations.of(context).getText(
                        'zt7pzvuw' /* Password */,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0x00000000),
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      filled: true,
                      suffixIcon: InkWell(
                        onTap: () async {
                          safeSetState(() =>
                              _model.signUpPasswordFieldVisibility =
                                  !_model.signUpPasswordFieldVisibility);
                        },
                        focusNode: FocusNode(skipTraversal: true),
                        child: Icon(
                          _model.signUpPasswordFieldVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 22,
                        ),
                      ),
                    ),
                    style: TextStyle(),
                    validator: _model.signUpPasswordFieldTextControllerValidator
                        .asValidator(context),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      if (FFAppState().signupCountry == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please choose your country.',
                              style: TextStyle(),
                            ),
                            duration: Duration(milliseconds: 4000),
                          ),
                        );
                      } else {
                        GoRouter.of(context).prepareAuthEvent();

                        final user = await authManager.createAccountWithEmail(
                          context,
                          _model.signUpEmailFieldTextController.text,
                          _model.signUpPasswordFieldTextController.text,
                        );
                        if (user == null) {
                          return;
                        }

                        await UsersRecord.collection
                            .doc(user.uid)
                            .update(createUsersRecordData(
                              role: '',
                              fullName: _model.fullNameFieldTextController.text,
                            ));

                        _model.signupSaveResult =
                            await actions.saveSignupProfile(
                          _model.fullNameFieldTextController.text,
                          _model.phoneFieldTextController.text,
                          FFAppState().signupCountry,
                          FFAppState().signupCity,
                        );
                        if (Navigator.of(context).canPop()) {
                          context.pop();
                        }
                        context.pushNamedAuth(
                            OnboardingSurveyPageWidget.routeName,
                            context.mounted);
                      }

                      safeSetState(() {});
                    },
                    text: FFLocalizations.of(context).getText(
                      'q2vm203a' /* Sign Up */,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).secondary,
                      textStyle: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryText,
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
