import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/components/simple_list_tile_widget.dart';
import '/components/status_badge_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_pathways_page_model.dart';
export 'admin_pathways_page_model.dart';

/// CMS foundation scaffold (KH-10): read-only pathway list with status.
///
/// Not role-gated yet — real RBAC needs live Firebase Auth + the security
/// rules in backend/firestore/firestore.rules connected first.
class AdminPathwaysPageWidget extends StatefulWidget {
  const AdminPathwaysPageWidget({super.key});

  static String routeName = 'AdminPathwaysPage';
  static String routePath = '/admin/pathways';

  @override
  State<AdminPathwaysPageWidget> createState() =>
      _AdminPathwaysPageWidgetState();
}

class _AdminPathwaysPageWidgetState extends State<AdminPathwaysPageWidget> {
  late AdminPathwaysPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminPathwaysPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.loadedLessonsAdmin = await queryLessonsRecordOnce(
        limit: 20,
      );
      _model.liveLessonsList =
          _model.loadedLessonsAdmin!.toList().cast<LessonsRecord>();
      safeSetState(() {});
      _model.loadedQuizzesAdmin = await queryQuizzesRecordOnce(
        limit: 20,
      );
      _model.liveQuizzesList =
          _model.loadedQuizzesAdmin!.toList().cast<QuizzesRecord>();
      safeSetState(() {});
    });

    _model.annTitleEnFieldTextController ??= TextEditingController();
    _model.annTitleEnFieldFocusNode ??= FocusNode();

    _model.annTitleEsFieldTextController ??= TextEditingController();
    _model.annTitleEsFieldFocusNode ??= FocusNode();

    _model.annTitleUrFieldTextController ??= TextEditingController();
    _model.annTitleUrFieldFocusNode ??= FocusNode();

    _model.annBodyEnFieldTextController ??= TextEditingController();
    _model.annBodyEnFieldFocusNode ??= FocusNode();

    _model.annBodyEsFieldTextController ??= TextEditingController();
    _model.annBodyEsFieldFocusNode ??= FocusNode();

    _model.annBodyUrFieldTextController ??= TextEditingController();
    _model.annBodyUrFieldFocusNode ??= FocusNode();

    _model.cfgVersionFieldTextController ??= TextEditingController();
    _model.cfgVersionFieldFocusNode ??= FocusNode();

    _model.cfgBandsFieldTextController ??= TextEditingController();
    _model.cfgBandsFieldFocusNode ??= FocusNode();

    _model.cfgOverridesFieldTextController ??= TextEditingController();
    _model.cfgOverridesFieldFocusNode ??= FocusNode();

    _model.cfgExplanationsFieldTextController ??= TextEditingController();
    _model.cfgExplanationsFieldFocusNode ??= FocusNode();

    _model.cfgPointMapFieldTextController ??= TextEditingController();
    _model.cfgPointMapFieldFocusNode ??= FocusNode();

    _model.newPathwayTitleFieldTextController ??= TextEditingController();
    _model.newPathwayTitleFieldFocusNode ??= FocusNode();

    _model.newPathwayStableIdFieldTextController ??= TextEditingController();
    _model.newPathwayStableIdFieldFocusNode ??= FocusNode();

    _model.newLessonTitleFieldTextController ??= TextEditingController();
    _model.newLessonTitleFieldFocusNode ??= FocusNode();

    _model.newLessonStableIdFieldTextController ??= TextEditingController();
    _model.newLessonStableIdFieldFocusNode ??= FocusNode();

    _model.newLessonPathwayIdFieldTextController ??= TextEditingController();
    _model.newLessonPathwayIdFieldFocusNode ??= FocusNode();

    _model.newLessonScriptureRefFieldTextController ??= TextEditingController();
    _model.newLessonScriptureRefFieldFocusNode ??= FocusNode();

    _model.editPathwayStableIdFieldTextController ??= TextEditingController();
    _model.editPathwayStableIdFieldFocusNode ??= FocusNode();

    _model.editPathwayTitleFieldTextController ??= TextEditingController();
    _model.editPathwayTitleFieldFocusNode ??= FocusNode();

    _model.editPathwayStatusFieldTextController ??= TextEditingController();
    _model.editPathwayStatusFieldFocusNode ??= FocusNode();

    _model.editLessonPathwayIdFieldTextController ??= TextEditingController();
    _model.editLessonPathwayIdFieldFocusNode ??= FocusNode();

    _model.editLessonStableIdFieldTextController ??= TextEditingController();
    _model.editLessonStableIdFieldFocusNode ??= FocusNode();

    _model.editLessonTitleFieldTextController ??= TextEditingController();
    _model.editLessonTitleFieldFocusNode ??= FocusNode();

    _model.editLessonScriptureRefFieldTextController ??=
        TextEditingController();
    _model.editLessonScriptureRefFieldFocusNode ??= FocusNode();

    _model.editLessonReflectionFieldTextController ??= TextEditingController();
    _model.editLessonReflectionFieldFocusNode ??= FocusNode();

    _model.editLessonStatusFieldTextController ??= TextEditingController();
    _model.editLessonStatusFieldFocusNode ??= FocusNode();

    _model.importCsvFieldTextController ??= TextEditingController();
    _model.importCsvFieldFocusNode ??= FocusNode();
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
              '8a6xbi8k' /* Manage Pathways */,
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
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'jz8jsiaf' /* Publish announcement */,
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
                          Text(
                            FFLocalizations.of(context).getText(
                              '4vci4sbx' /* Saves to announcements and can... */,
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                          ),
                          TextFormField(
                            controller: _model.annTitleEnFieldTextController,
                            focusNode: _model.annTitleEnFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.annTitleEnFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.annTitleEn =
                                    _model.annTitleEnFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                '1ccn96wk' /* Title (EN) */,
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
                            validator: _model
                                .annTitleEnFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller: _model.annTitleEsFieldTextController,
                            focusNode: _model.annTitleEsFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.annTitleEsFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.annTitleEs =
                                    _model.annTitleEsFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                '0lhahpo6' /* Title (ES draft) */,
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
                            validator: _model
                                .annTitleEsFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller: _model.annTitleUrFieldTextController,
                            focusNode: _model.annTitleUrFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.annTitleUrFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.annTitleUr =
                                    _model.annTitleUrFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                'q3x9kohh' /* Title (UR draft) */,
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
                            validator: _model
                                .annTitleUrFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller: _model.annBodyEnFieldTextController,
                            focusNode: _model.annBodyEnFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.annBodyEnFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.annBodyEn =
                                    _model.annBodyEnFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                'm1dy9t41' /* Body (EN) */,
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
                            maxLines: 3,
                            validator: _model
                                .annBodyEnFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller: _model.annBodyEsFieldTextController,
                            focusNode: _model.annBodyEsFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.annBodyEsFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.annBodyEs =
                                    _model.annBodyEsFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                'c5cr8hgv' /* Body (ES draft) */,
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
                            maxLines: 2,
                            validator: _model
                                .annBodyEsFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller: _model.annBodyUrFieldTextController,
                            focusNode: _model.annBodyUrFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.annBodyUrFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.annBodyUr =
                                    _model.annBodyUrFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                '0iub2yof' /* Body (UR draft) */,
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
                            maxLines: 2,
                            validator: _model
                                .annBodyUrFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              _model.publishAnnResult =
                                  await PublishAnnouncementCall.call(
                                audience: 'all',
                                sendPush: 'true',
                                authToken: currentJwtToken,
                                titleEn: _model.annTitleEn,
                                titleEs: _model.annTitleEs,
                                titleUr: _model.annTitleUr,
                                bodyEn: _model.annBodyEn,
                                bodyEs: _model.annBodyEs,
                                bodyUr: _model.annBodyUr,
                              );

                              if ((_model.publishAnnResult?.succeeded ??
                                  true)) {
                                _model.annNote =
                                    PublishAnnouncementResponseStruct
                                            .maybeFromMap((_model
                                                    .publishAnnResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.note;
                                safeSetState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Announcement published.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                                _model.annAnalytics =
                                    await LogAnalyticsEventCall.call(
                                  eventName: 'admin_announcement_published',
                                  propsJson: '{}',
                                  screen: 'AdminPathwaysPage',
                                  authToken: currentJwtToken,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Could not publish announcement.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              }

                              safeSetState(() {});
                            },
                            text: FFLocalizations.of(context).getText(
                              'ntdrmux1' /* Publish + notify members */,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).secondary,
                              textStyle: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              _model.publishAnnOnlyResult =
                                  await PublishAnnouncementCall.call(
                                audience: 'all',
                                sendPush: 'false',
                                authToken: currentJwtToken,
                                titleEn: _model.annTitleEn,
                                titleEs: _model.annTitleEs,
                                titleUr: _model.annTitleUr,
                                bodyEn: _model.annBodyEn,
                                bodyEs: _model.annBodyEs,
                                bodyUr: _model.annBodyUr,
                              );

                              if ((_model.publishAnnOnlyResult?.succeeded ??
                                  true)) {
                                _model.annNote =
                                    PublishAnnouncementResponseStruct
                                            .maybeFromMap((_model
                                                    .publishAnnOnlyResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.note;
                                safeSetState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Announcement saved.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Could not save announcement.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              }

                              safeSetState(() {});
                            },
                            text: FFLocalizations.of(context).getText(
                              'kgp1nv6b' /* Save announcement only (no pus... */,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: Colors.transparent,
                              textStyle: TextStyle(
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              elevation: 0.0,
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          Text(
                            _model.annNote!,
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            FFLocalizations.of(context).getText(
                              'q6mq841w' /* Translation drafts */,
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
                          FFButtonWidget(
                            onPressed: () async {
                              _model.pathwayDraftsResult =
                                  await GenerateTranslationDraftsCall.call(
                                target: 'pathways',
                                authToken: currentJwtToken,
                              );

                              if ((_model.pathwayDraftsResult?.succeeded ??
                                  true)) {
                                _model.translationNote =
                                    TranslationDraftsResponseStruct
                                            .maybeFromMap((_model
                                                    .pathwayDraftsResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.note;
                                safeSetState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Pathway translation drafts generated.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Could not generate pathway drafts.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              }

                              safeSetState(() {});
                            },
                            text: FFLocalizations.of(context).getText(
                              'fhohg5wy' /* Generate ES/UR pathway drafts */,
                            ),
                            options: FFButtonOptions(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).tertiary,
                              textStyle: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              _model.lessonDraftsResult =
                                  await GenerateTranslationDraftsCall.call(
                                target: 'lessons',
                                authToken: currentJwtToken,
                              );

                              if ((_model.lessonDraftsResult?.succeeded ??
                                  true)) {
                                _model.translationNote =
                                    TranslationDraftsResponseStruct
                                            .maybeFromMap((_model
                                                    .lessonDraftsResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.note;
                                safeSetState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Lesson translation drafts generated.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Could not generate lesson drafts.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              }

                              safeSetState(() {});
                            },
                            text: FFLocalizations.of(context).getText(
                              '4upku5le' /* Generate ES/UR lesson drafts */,
                            ),
                            options: FFButtonOptions(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).tertiary,
                              textStyle: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          Text(
                            _model.translationNote!,
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontStyle,
                                ),
                          ),
                        ].divide(SizedBox(height: 8.0)),
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'wkid62i1' /* Assessment rules (live) */,
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
                          Text(
                            FFLocalizations.of(context).getText(
                              'l2bs79bt' /* Edit score bands, overrides, a... */,
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              _model.loadedAssessmentConfig =
                                  await GetAssessmentConfigCall.call(
                                authToken: currentJwtToken,
                              );

                              if ((_model.loadedAssessmentConfig?.succeeded ??
                                  true)) {
                                _model.cfgVersion =
                                    AssessmentConfigResponseStruct.maybeFromMap(
                                            (_model.loadedAssessmentConfig
                                                    ?.jsonBody ??
                                                ''))
                                        ?.assessmentVersion;
                                safeSetState(() {});
                                _model.cfgScoreBandsJson =
                                    AssessmentConfigResponseStruct.maybeFromMap(
                                            (_model.loadedAssessmentConfig
                                                    ?.jsonBody ??
                                                ''))
                                        ?.scoreBandsJson;
                                safeSetState(() {});
                                _model.cfgOverridesJson =
                                    AssessmentConfigResponseStruct.maybeFromMap(
                                            (_model.loadedAssessmentConfig
                                                    ?.jsonBody ??
                                                ''))
                                        ?.overridesJson;
                                safeSetState(() {});
                                _model.cfgExplanationsJson =
                                    AssessmentConfigResponseStruct.maybeFromMap(
                                            (_model.loadedAssessmentConfig
                                                    ?.jsonBody ??
                                                ''))
                                        ?.explanationsJson;
                                safeSetState(() {});
                                _model.cfgPointMapJson =
                                    AssessmentConfigResponseStruct.maybeFromMap(
                                            (_model.loadedAssessmentConfig
                                                    ?.jsonBody ??
                                                ''))
                                        ?.pointMapJson;
                                safeSetState(() {});
                                _model.cfgNote =
                                    AssessmentConfigResponseStruct.maybeFromMap(
                                            (_model.loadedAssessmentConfig
                                                    ?.jsonBody ??
                                                ''))
                                        ?.note;
                                safeSetState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Could not load assessment config.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              }

                              safeSetState(() {});
                            },
                            text: FFLocalizations.of(context).getText(
                              'uo92yaak' /* Load active config */,
                            ),
                            options: FFButtonOptions(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).tertiary,
                              textStyle: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          TextFormField(
                            controller: _model.cfgVersionFieldTextController,
                            focusNode: _model.cfgVersionFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.cfgVersionFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.cfgVersion =
                                    _model.cfgVersionFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                'sqm4uwaa' /* Assessment version */,
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
                            validator: _model
                                .cfgVersionFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller: _model.cfgBandsFieldTextController,
                            focusNode: _model.cfgBandsFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.cfgBandsFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.cfgScoreBandsJson =
                                    _model.cfgBandsFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                'mxpyprz5' /* Score bands JSON */,
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
                            maxLines: 4,
                            validator: _model
                                .cfgBandsFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller: _model.cfgOverridesFieldTextController,
                            focusNode: _model.cfgOverridesFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.cfgOverridesFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.cfgOverridesJson =
                                    _model.cfgOverridesFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                '53e751an' /* Overrides JSON */,
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
                            maxLines: 4,
                            validator: _model
                                .cfgOverridesFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller:
                                _model.cfgExplanationsFieldTextController,
                            focusNode: _model.cfgExplanationsFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.cfgExplanationsFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.cfgExplanationsJson = _model
                                    .cfgExplanationsFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                'abdgzy7s' /* Explanations JSON */,
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
                            maxLines: 4,
                            validator: _model
                                .cfgExplanationsFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller: _model.cfgPointMapFieldTextController,
                            focusNode: _model.cfgPointMapFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.cfgPointMapFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.cfgPointMapJson =
                                    _model.cfgPointMapFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                '6zkmejjg' /* Point map JSON */,
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
                            maxLines: 2,
                            validator: _model
                                .cfgPointMapFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              _model.savedAssessmentConfig =
                                  await UpdateAssessmentConfigCall.call(
                                activate: 'true',
                                authToken: currentJwtToken,
                                assessmentVersion: _model.cfgVersion,
                                scoreBandsJson: _model.cfgScoreBandsJson,
                                overridesJson: _model.cfgOverridesJson,
                                explanationsJson: _model.cfgExplanationsJson,
                                pointMapJson: _model.cfgPointMapJson,
                              );

                              if ((_model.savedAssessmentConfig?.succeeded ??
                                  true)) {
                                _model.cfgNote =
                                    AssessmentConfigUpdateResponseStruct
                                            .maybeFromMap((_model
                                                    .savedAssessmentConfig
                                                    ?.jsonBody ??
                                                ''))
                                        ?.note;
                                safeSetState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Assessment rules saved and activated.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Could not save assessment config.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              }

                              safeSetState(() {});
                            },
                            text: FFLocalizations.of(context).getText(
                              't0p9hilp' /* Save & activate rules */,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).secondary,
                              textStyle: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          Text(
                            _model.cfgNote!,
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontStyle,
                                ),
                          ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'e3yc7ebr' /* Admin report */,
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
                          FFButtonWidget(
                            onPressed: () async {
                              _model.adminReportResult =
                                  await GetAdminReportCall.call(
                                authToken: currentJwtToken,
                              );

                              if ((_model.adminReportResult?.succeeded ??
                                  true)) {
                                _model.reportPathwayCount =
                                    AdminReportResponseStruct.maybeFromMap(
                                            (_model.adminReportResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.pathwayCount;
                                safeSetState(() {});
                                _model.reportLessonCount =
                                    AdminReportResponseStruct.maybeFromMap(
                                            (_model.adminReportResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.lessonCount;
                                safeSetState(() {});
                                _model.reportQuizCount =
                                    AdminReportResponseStruct.maybeFromMap(
                                            (_model.adminReportResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.quizCount;
                                safeSetState(() {});
                                _model.reportMemberCount =
                                    AdminReportResponseStruct.maybeFromMap(
                                            (_model.adminReportResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.memberCount;
                                safeSetState(() {});
                                _model.reportLastImport =
                                    AdminReportResponseStruct.maybeFromMap(
                                            (_model.adminReportResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.lastImportSummary;
                                safeSetState(() {});
                                _model.reportLastRag =
                                    AdminReportResponseStruct.maybeFromMap(
                                            (_model.adminReportResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.lastRagQuestion;
                                safeSetState(() {});
                                _model.reportNote =
                                    AdminReportResponseStruct.maybeFromMap(
                                            (_model.adminReportResult
                                                    ?.jsonBody ??
                                                ''))
                                        ?.note;
                                safeSetState(() {});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Could not load admin report.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              }

                              safeSetState(() {});
                            },
                            text: FFLocalizations.of(context).getText(
                              '8gr2edeb' /* Refresh report */,
                            ),
                            options: FFButtonOptions(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).tertiary,
                              textStyle: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          Text(
                            functions.formatAdminCount(
                                'Pathways', _model.reportPathwayCount)!,
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            functions.formatAdminCount(
                                'Lessons', _model.reportLessonCount)!,
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            functions.formatAdminCount(
                                'Quizzes', _model.reportQuizCount)!,
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            functions.formatAdminCount(
                                'Members', _model.reportMemberCount)!,
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            _model.reportLastImport!,
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                          ),
                          Text(
                            _model.reportLastRag!,
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                          ),
                          Text(
                            _model.reportNote!,
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontStyle,
                                ),
                          ),
                        ].divide(SizedBox(height: 8.0)),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'jlpv7k2u' /* Create content */,
                        ),
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontStyle,
                            ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  '4yvy61cq' /* Create pathway (draft) */,
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
                              TextFormField(
                                controller:
                                    _model.newPathwayTitleFieldTextController,
                                focusNode: _model.newPathwayTitleFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.newPathwayTitleFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.newPathwayTitle = _model
                                        .newPathwayTitleFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    '31vjzirp' /* Title (English) */,
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
                                validator: _model
                                    .newPathwayTitleFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model
                                    .newPathwayStableIdFieldTextController,
                                focusNode:
                                    _model.newPathwayStableIdFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.newPathwayStableIdFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.newPathwayStableId = _model
                                        .newPathwayStableIdFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    '0qer9c69' /* Stable ID (e.g. come-and-see) */,
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
                                validator: _model
                                    .newPathwayStableIdFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  _model.boCreatePathwayResult =
                                      await actions.adminCreatePathway(
                                    _model.newPathwayTitle,
                                    _model.newPathwayStableId,
                                  );
                                  if (_model.boCreatePathwayResult ==
                                      'created') {
                                    _model.boPathwaysAfterCreate =
                                        await queryPathwaysRecordOnce(
                                      limit: 50,
                                    );
                                    _model.livePathwaysList = _model
                                        .boPathwaysAfterCreate!
                                        .toList()
                                        .cast<PathwaysRecord>();
                                    safeSetState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Pathway created as draft.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else if (_model.boCreatePathwayResult ==
                                      'missing_fields') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Title and stable ID are required.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Could not create pathway.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  }

                                  safeSetState(() {});
                                },
                                text: FFLocalizations.of(context).getText(
                                  'd1vd8i2k' /* Create Pathway */,
                                ),
                                options: FFButtonOptions(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  textStyle: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'flizzuzv' /* Create lesson (draft) */,
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
                              TextFormField(
                                controller:
                                    _model.newLessonTitleFieldTextController,
                                focusNode: _model.newLessonTitleFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.newLessonTitleFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.newLessonTitle = _model
                                        .newLessonTitleFieldTextController.text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    'u4297vic' /* Lesson title (English) */,
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
                                validator: _model
                                    .newLessonTitleFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller:
                                    _model.newLessonStableIdFieldTextController,
                                focusNode:
                                    _model.newLessonStableIdFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.newLessonStableIdFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.newLessonStableId = _model
                                        .newLessonStableIdFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    'zk0ekyyf' /* Stable ID (e.g. LESSON-COME-00... */,
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
                                validator: _model
                                    .newLessonStableIdFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model
                                    .newLessonPathwayIdFieldTextController,
                                focusNode:
                                    _model.newLessonPathwayIdFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.newLessonPathwayIdFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.newLessonPathwayId = _model
                                        .newLessonPathwayIdFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    '1ddemhqa' /* Parent pathway stableId */,
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
                                validator: _model
                                    .newLessonPathwayIdFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model
                                    .newLessonScriptureRefFieldTextController,
                                focusNode:
                                    _model.newLessonScriptureRefFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.newLessonScriptureRefFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.newLessonScriptureRef = _model
                                        .newLessonScriptureRefFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    'dmvkrtrk' /* Scripture ref (e.g. John 3:16) */,
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
                                validator: _model
                                    .newLessonScriptureRefFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  _model.boCreateLessonResult =
                                      await actions.adminCreateLesson(
                                    _model.newLessonTitle,
                                    _model.newLessonStableId,
                                    _model.newLessonPathwayId,
                                    _model.newLessonScriptureRef,
                                  );
                                  if (_model.boCreateLessonResult ==
                                      'created') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Lesson created as draft under pathway.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else if (_model.boCreateLessonResult ==
                                      'missing_fields') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Title, stable ID, and pathway are required.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else if (_model.boCreateLessonResult ==
                                      'pathway_not_found') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'No pathway found for that stable ID.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Could not create lesson.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  }

                                  safeSetState(() {});
                                },
                                text: FFLocalizations.of(context).getText(
                                  '81pcpgvs' /* Create Lesson */,
                                ),
                                options: FFButtonOptions(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  textStyle: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12.0)),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          '6ku1r7wp' /* Edit content */,
                        ),
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .fontStyle,
                            ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'qy1uhfab' /* Edit pathway */,
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
                              TextFormField(
                                controller: _model
                                    .editPathwayStableIdFieldTextController,
                                focusNode:
                                    _model.editPathwayStableIdFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.editPathwayStableIdFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.editPathwayStableId = _model
                                        .editPathwayStableIdFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    '5xl35md5' /* Stable ID to update */,
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
                                validator: _model
                                    .editPathwayStableIdFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller:
                                    _model.editPathwayTitleFieldTextController,
                                focusNode:
                                    _model.editPathwayTitleFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.editPathwayTitleFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.editPathwayTitle = _model
                                        .editPathwayTitleFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    'gipfyn9f' /* New title (English) */,
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
                                validator: _model
                                    .editPathwayTitleFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller:
                                    _model.editPathwayStatusFieldTextController,
                                focusNode:
                                    _model.editPathwayStatusFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.editPathwayStatusFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.editPathwayStatus = _model
                                        .editPathwayStatusFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    '4z54k5p9' /* Status: draft | in_review | pu... */,
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
                                validator: _model
                                    .editPathwayStatusFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  _model.boUpdatePathwayResult =
                                      await actions.adminUpdatePathway(
                                    _model.editPathwayStableId,
                                    _model.editPathwayTitle,
                                    _model.editPathwayStatus,
                                  );
                                  if (_model.boUpdatePathwayResult ==
                                      'updated') {
                                    _model.boPathwaysAfterEdit =
                                        await queryPathwaysRecordOnce(
                                      limit: 50,
                                    );
                                    _model.livePathwaysList = _model
                                        .boPathwaysAfterEdit!
                                        .toList()
                                        .cast<PathwaysRecord>();
                                    safeSetState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Pathway updated.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else if (_model.boUpdatePathwayResult ==
                                      'not_found') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Pathway not found for that stable ID.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else if (_model.boUpdatePathwayResult ==
                                      'missing_fields') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Stable ID (and title or status) required.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Could not update pathway.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  }

                                  safeSetState(() {});
                                },
                                text: FFLocalizations.of(context).getText(
                                  'bd0eimw8' /* Update Pathway */,
                                ),
                                options: FFButtonOptions(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  textStyle: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'ounn6gex' /* Edit lesson */,
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
                              TextFormField(
                                controller: _model
                                    .editLessonPathwayIdFieldTextController,
                                focusNode:
                                    _model.editLessonPathwayIdFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.editLessonPathwayIdFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.editLessonPathwayId = _model
                                        .editLessonPathwayIdFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    'x30beon5' /* Parent pathway stableId */,
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
                                validator: _model
                                    .editLessonPathwayIdFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model
                                    .editLessonStableIdFieldTextController,
                                focusNode:
                                    _model.editLessonStableIdFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.editLessonStableIdFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.editLessonStableId = _model
                                        .editLessonStableIdFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    'p389fojk' /* Lesson stableId */,
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
                                validator: _model
                                    .editLessonStableIdFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller:
                                    _model.editLessonTitleFieldTextController,
                                focusNode: _model.editLessonTitleFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.editLessonTitleFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.editLessonTitle = _model
                                        .editLessonTitleFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    'pditiayw' /* New title */,
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
                                validator: _model
                                    .editLessonTitleFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model
                                    .editLessonScriptureRefFieldTextController,
                                focusNode:
                                    _model.editLessonScriptureRefFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.editLessonScriptureRefFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.editLessonScriptureRef = _model
                                        .editLessonScriptureRefFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    'fivaqvz7' /* Scripture ref */,
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
                                validator: _model
                                    .editLessonScriptureRefFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model
                                    .editLessonReflectionFieldTextController,
                                focusNode:
                                    _model.editLessonReflectionFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.editLessonReflectionFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.editLessonReflection = _model
                                        .editLessonReflectionFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    '7t9cmwn0' /* Reflection prompt */,
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
                                validator: _model
                                    .editLessonReflectionFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller:
                                    _model.editLessonStatusFieldTextController,
                                focusNode:
                                    _model.editLessonStatusFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.editLessonStatusFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.editLessonStatus = _model
                                        .editLessonStatusFieldTextController
                                        .text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: FFLocalizations.of(context).getText(
                                    '3zabe2mp' /* Status: draft | in_review | pu... */,
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
                                validator: _model
                                    .editLessonStatusFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  _model.boUpdateLessonResult =
                                      await actions.adminUpdateLesson(
                                    _model.editLessonPathwayId,
                                    _model.editLessonStableId,
                                    _model.editLessonTitle,
                                    _model.editLessonScriptureRef,
                                    _model.editLessonReflection,
                                    _model.editLessonStatus,
                                  );
                                  if (_model.boUpdateLessonResult ==
                                      'updated') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Lesson updated.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else if (_model.boUpdateLessonResult ==
                                      'not_found') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Lesson not found.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else if (_model.boUpdateLessonResult ==
                                      'pathway_not_found') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Parent pathway not found.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else if (_model.boUpdateLessonResult ==
                                      'missing_fields') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Pathway + lesson stable IDs are required.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Could not update lesson.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  }

                                  safeSetState(() {});
                                },
                                text: FFLocalizations.of(context).getText(
                                  'molltaja' /* Update Lesson */,
                                ),
                                options: FFButtonOptions(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  textStyle: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ].divide(SizedBox(height: 10.0)),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12.0)),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      'd8682e0k' /* Pathways (all statuses) */,
                    ),
                    style: FlutterFlowTheme.of(context).titleMedium.override(
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
                  Builder(
                    builder: (context) {
                      final livePathwaysListItem =
                          _model.livePathwaysList.toList();

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: livePathwaysListItem.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8.0),
                        itemBuilder: (context, livePathwaysListItemIndex) {
                          final livePathwaysListItemItem =
                              livePathwaysListItem[livePathwaysListItemIndex];
                          return Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      wrapWithModel(
                                        model: _model.simpleListTileModels1
                                            .getModel(
                                          livePathwaysListItemIndex.toString(),
                                          livePathwaysListItemIndex,
                                        ),
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: SimpleListTileWidget(
                                          key: Key(
                                            'Keyuj5_${livePathwaysListItemIndex.toString()}',
                                          ),
                                          subtitle:
                                              livePathwaysListItemItem.stableId,
                                          title:
                                              livePathwaysListItemItem.title.en,
                                        ),
                                      ),
                                      wrapWithModel(
                                        model:
                                            _model.statusBadgeModels1.getModel(
                                          livePathwaysListItemIndex.toString(),
                                          livePathwaysListItemIndex,
                                        ),
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: StatusBadgeWidget(
                                          key: Key(
                                            'Keyqla_${livePathwaysListItemIndex.toString()}',
                                          ),
                                          label:
                                              livePathwaysListItemItem.status,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (livePathwaysListItemItem.status ==
                                          'draft')
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await livePathwaysListItemItem
                                                .reference
                                                .update(
                                                    createPathwaysRecordData(
                                              status: 'in_review',
                                            ));
                                            _model.boPathwaysAfterSubmit =
                                                await queryPathwaysRecordOnce(
                                              limit: 50,
                                            );
                                            _model.livePathwaysList = _model
                                                .boPathwaysAfterSubmit!
                                                .toList()
                                                .cast<PathwaysRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Submitted for review.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'us7flsgc' /* Submit */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      if (!(livePathwaysListItemItem.status ==
                                          'published'))
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await livePathwaysListItemItem
                                                .reference
                                                .update(
                                                    createPathwaysRecordData(
                                              status: 'published',
                                            ));
                                            _model.boPathwaysAfterPublish =
                                                await queryPathwaysRecordOnce(
                                              limit: 50,
                                            );
                                            _model.livePathwaysList = _model
                                                .boPathwaysAfterPublish!
                                                .toList()
                                                .cast<PathwaysRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Pathway published.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'prem5u25' /* Publish */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .success,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      if (livePathwaysListItemItem.status ==
                                          'published')
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await livePathwaysListItemItem
                                                .reference
                                                .update(
                                                    createPathwaysRecordData(
                                              status: 'draft',
                                            ));
                                            _model.boPathwaysAfterUnpublish =
                                                await queryPathwaysRecordOnce(
                                              limit: 50,
                                            );
                                            _model.livePathwaysList = _model
                                                .boPathwaysAfterUnpublish!
                                                .toList()
                                                .cast<PathwaysRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Pathway unpublished.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'kn1x55x3' /* Unpublish */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Colors.transparent,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                            ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          await livePathwaysListItemItem
                                              .reference
                                              .delete();
                                          _model.boPathwaysAfterDelete =
                                              await queryPathwaysRecordOnce(
                                            limit: 50,
                                          );
                                          _model.livePathwaysList = _model
                                              .boPathwaysAfterDelete!
                                              .toList()
                                              .cast<PathwaysRecord>();
                                          safeSetState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Pathway deleted.',
                                                style: TextStyle(),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                            ),
                                          );

                                          safeSetState(() {});
                                        },
                                        text:
                                            FFLocalizations.of(context).getText(
                                          '3jh28ea7' /* Delete */,
                                        ),
                                        options: FFButtonOptions(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: Colors.transparent,
                                          textStyle: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                          ),
                                          elevation: 0.0,
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      '5t7q6hnw' /* Daily Scripture (all statuses) */,
                    ),
                    style: FlutterFlowTheme.of(context).titleMedium.override(
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Builder(
                        builder: (context) {
                          final liveScriptureListItem =
                              _model.liveScriptureList.toList();

                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: liveScriptureListItem.length,
                            separatorBuilder: (_, __) => SizedBox(height: 8.0),
                            itemBuilder: (context, liveScriptureListItemIndex) {
                              final liveScriptureListItemItem =
                                  liveScriptureListItem[
                                      liveScriptureListItemIndex];
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  wrapWithModel(
                                    model:
                                        _model.simpleListTileModels2.getModel(
                                      liveScriptureListItemIndex.toString(),
                                      liveScriptureListItemIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: SimpleListTileWidget(
                                      key: Key(
                                        'Keyoio_${liveScriptureListItemIndex.toString()}',
                                      ),
                                      subtitle: liveScriptureListItemItem.date,
                                      title: liveScriptureListItemItem.verseRef,
                                    ),
                                  ),
                                  wrapWithModel(
                                    model: _model.statusBadgeModels2.getModel(
                                      liveScriptureListItemIndex.toString(),
                                      liveScriptureListItemIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: StatusBadgeWidget(
                                      key: Key(
                                        'Keyagc_${liveScriptureListItemIndex.toString()}',
                                      ),
                                      label: liveScriptureListItemItem.status,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      Text(
                        FFLocalizations.of(context).getText(
                          '41n51lru' /* Lessons (all statuses) */,
                        ),
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
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
                      Builder(
                        builder: (context) {
                          final liveLessonsListItem =
                              _model.liveLessonsList.toList();

                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: liveLessonsListItem.length,
                            separatorBuilder: (_, __) => SizedBox(height: 8.0),
                            itemBuilder: (context, liveLessonsListItemIndex) {
                              final liveLessonsListItemItem =
                                  liveLessonsListItem[liveLessonsListItemIndex];
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      wrapWithModel(
                                        model: _model.simpleListTileModels3
                                            .getModel(
                                          liveLessonsListItemIndex.toString(),
                                          liveLessonsListItemIndex,
                                        ),
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: SimpleListTileWidget(
                                          key: Key(
                                            'Keyaaj_${liveLessonsListItemIndex.toString()}',
                                          ),
                                          subtitle:
                                              liveLessonsListItemItem.stableId,
                                          title:
                                              liveLessonsListItemItem.title.en,
                                        ),
                                      ),
                                      wrapWithModel(
                                        model:
                                            _model.statusBadgeModels3.getModel(
                                          liveLessonsListItemIndex.toString(),
                                          liveLessonsListItemIndex,
                                        ),
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: StatusBadgeWidget(
                                          key: Key(
                                            'Keyit6_${liveLessonsListItemIndex.toString()}',
                                          ),
                                          label: liveLessonsListItemItem.status,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (liveLessonsListItemItem.status ==
                                          'draft')
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await liveLessonsListItemItem
                                                .reference
                                                .update(createLessonsRecordData(
                                              status: 'in_review',
                                            ));
                                            _model.loadedLessonsAdminAfterSubmit =
                                                await queryLessonsRecordOnce(
                                              limit: 20,
                                            );
                                            _model.liveLessonsList = _model
                                                .loadedLessonsAdminAfterSubmit!
                                                .toList()
                                                .cast<LessonsRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Submitted for review.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'w5di1mwb' /* Submit for Review */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      if (liveLessonsListItemItem.status ==
                                          'in_review')
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await liveLessonsListItemItem
                                                .reference
                                                .update(createLessonsRecordData(
                                              status: 'published',
                                            ));
                                            _model.loadedLessonsAdminAfterApprove =
                                                await queryLessonsRecordOnce(
                                              limit: 20,
                                            );
                                            _model.liveLessonsList = _model
                                                .loadedLessonsAdminAfterApprove!
                                                .toList()
                                                .cast<LessonsRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Approved and published.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'gvlpz0hk' /* Approve & Publish */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .success,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      if (liveLessonsListItemItem.status ==
                                          'in_review')
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await liveLessonsListItemItem
                                                .reference
                                                .update(createLessonsRecordData(
                                              status: 'draft',
                                            ));
                                            _model.loadedLessonsAdminAfterReject =
                                                await queryLessonsRecordOnce(
                                              limit: 20,
                                            );
                                            _model.liveLessonsList = _model
                                                .loadedLessonsAdminAfterReject!
                                                .toList()
                                                .cast<LessonsRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Sent back to draft.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'mqk397iq' /* Back to Draft */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Colors.transparent,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      if (liveLessonsListItemItem.status ==
                                          'published')
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await liveLessonsListItemItem
                                                .reference
                                                .update(createLessonsRecordData(
                                              status: 'draft',
                                            ));
                                            _model.loadedLessonsAdminAfterUnpublish =
                                                await queryLessonsRecordOnce(
                                              limit: 20,
                                            );
                                            _model.liveLessonsList = _model
                                                .loadedLessonsAdminAfterUnpublish!
                                                .toList()
                                                .cast<LessonsRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Unpublished.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'sjxbois2' /* Unpublish */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Colors.transparent,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                            ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                    ].divide(SizedBox(width: 6.0)),
                                  ),
                                ].divide(SizedBox(height: 6.0)),
                              );
                            },
                          );
                        },
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      Text(
                        FFLocalizations.of(context).getText(
                          'kwmzul5z' /* Quizzes (all statuses) */,
                        ),
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
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
                      Builder(
                        builder: (context) {
                          final liveQuizzesListItem =
                              _model.liveQuizzesList.toList();

                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: liveQuizzesListItem.length,
                            separatorBuilder: (_, __) => SizedBox(height: 8.0),
                            itemBuilder: (context, liveQuizzesListItemIndex) {
                              final liveQuizzesListItemItem =
                                  liveQuizzesListItem[liveQuizzesListItemIndex];
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      wrapWithModel(
                                        model: _model.simpleListTileModels4
                                            .getModel(
                                          liveQuizzesListItemIndex.toString(),
                                          liveQuizzesListItemIndex,
                                        ),
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: SimpleListTileWidget(
                                          key: Key(
                                            'Keyyb6_${liveQuizzesListItemIndex.toString()}',
                                          ),
                                          subtitle:
                                              liveQuizzesListItemItem.lessonId,
                                          title:
                                              liveQuizzesListItemItem.stableId,
                                        ),
                                      ),
                                      wrapWithModel(
                                        model:
                                            _model.statusBadgeModels4.getModel(
                                          liveQuizzesListItemIndex.toString(),
                                          liveQuizzesListItemIndex,
                                        ),
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: StatusBadgeWidget(
                                          key: Key(
                                            'Keyh27_${liveQuizzesListItemIndex.toString()}',
                                          ),
                                          label: liveQuizzesListItemItem.status,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (liveQuizzesListItemItem.status ==
                                          'draft')
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await liveQuizzesListItemItem
                                                .reference
                                                .update(createQuizzesRecordData(
                                              status: 'in_review',
                                            ));
                                            _model.loadedQuizzesAdminAfterSubmit =
                                                await queryQuizzesRecordOnce(
                                              limit: 20,
                                            );
                                            _model.liveQuizzesList = _model
                                                .loadedQuizzesAdminAfterSubmit!
                                                .toList()
                                                .cast<QuizzesRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Submitted for review.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'ukc7prir' /* Submit for Review */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      if (liveQuizzesListItemItem.status ==
                                          'in_review')
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await liveQuizzesListItemItem
                                                .reference
                                                .update(createQuizzesRecordData(
                                              status: 'published',
                                            ));
                                            _model.loadedQuizzesAdminAfterApprove =
                                                await queryQuizzesRecordOnce(
                                              limit: 20,
                                            );
                                            _model.liveQuizzesList = _model
                                                .loadedQuizzesAdminAfterApprove!
                                                .toList()
                                                .cast<QuizzesRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Approved and published.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            'lt1h1tu5' /* Approve & Publish */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context)
                                                .success,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      if (liveQuizzesListItemItem.status ==
                                          'in_review')
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await liveQuizzesListItemItem
                                                .reference
                                                .update(createQuizzesRecordData(
                                              status: 'draft',
                                            ));
                                            _model.loadedQuizzesAdminAfterReject =
                                                await queryQuizzesRecordOnce(
                                              limit: 20,
                                            );
                                            _model.liveQuizzesList = _model
                                                .loadedQuizzesAdminAfterReject!
                                                .toList()
                                                .cast<QuizzesRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Sent back to draft.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            '30p71cwk' /* Back to Draft */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Colors.transparent,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                            ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      if (liveQuizzesListItemItem.status ==
                                          'published')
                                        FFButtonWidget(
                                          onPressed: () async {
                                            await liveQuizzesListItemItem
                                                .reference
                                                .update(createQuizzesRecordData(
                                              status: 'draft',
                                            ));
                                            _model.loadedQuizzesAdminAfterUnpublish =
                                                await queryQuizzesRecordOnce(
                                              limit: 20,
                                            );
                                            _model.liveQuizzesList = _model
                                                .loadedQuizzesAdminAfterUnpublish!
                                                .toList()
                                                .cast<QuizzesRecord>();
                                            safeSetState(() {});
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Unpublished.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );

                                            safeSetState(() {});
                                          },
                                          text: FFLocalizations.of(context)
                                              .getText(
                                            't58atw7n' /* Unpublish */,
                                          ),
                                          options: FFButtonOptions(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            color: Colors.transparent,
                                            textStyle: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                            ),
                                            elevation: 0.0,
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                    ].divide(SizedBox(width: 6.0)),
                                  ),
                                ].divide(SizedBox(height: 6.0)),
                              );
                            },
                          );
                        },
                      ),
                    ].divide(SizedBox(height: 20.0)),
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            FFLocalizations.of(context).getText(
                              'ix7r9qf2' /* Bulk Curriculum Importer */,
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
                          Text(
                            FFLocalizations.of(context).getText(
                              'uqss0gyk' /* Paste CSV with a header row. T... */,
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_model.importCollection == 'pathways')
                                    FFButtonWidget(
                                      onPressed: () async {
                                        _model.importCollection = 'pathways';
                                        safeSetState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        '51667gmm' /* pathways */,
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        textStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  if (!(_model.importCollection == 'pathways'))
                                    FFButtonWidget(
                                      onPressed: () async {
                                        _model.importCollection = 'pathways';
                                        safeSetState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'wvf9wapw' /* pathways */,
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: Colors.transparent,
                                        textStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        ),
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_model.importCollection == 'lessons')
                                    FFButtonWidget(
                                      onPressed: () async {
                                        _model.importCollection = 'lessons';
                                        safeSetState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'vlzev2eo' /* lessons */,
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        textStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  if (!(_model.importCollection == 'lessons'))
                                    FFButtonWidget(
                                      onPressed: () async {
                                        _model.importCollection = 'lessons';
                                        safeSetState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        '58lwjmah' /* lessons */,
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: Colors.transparent,
                                        textStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        ),
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_model.importCollection ==
                                      'dailyScripture')
                                    FFButtonWidget(
                                      onPressed: () async {
                                        _model.importCollection =
                                            'dailyScripture';
                                        safeSetState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'd3guiznk' /* dailyScripture */,
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        textStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  if (!(_model.importCollection ==
                                      'dailyScripture'))
                                    FFButtonWidget(
                                      onPressed: () async {
                                        _model.importCollection =
                                            'dailyScripture';
                                        safeSetState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        '3w9gf0wx' /* dailyScripture */,
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: Colors.transparent,
                                        textStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        ),
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_model.importCollection ==
                                      'encouragements')
                                    FFButtonWidget(
                                      onPressed: () async {
                                        _model.importCollection =
                                            'encouragements';
                                        safeSetState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        '9no23ll9' /* encouragements */,
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .secondary,
                                        textStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  if (!(_model.importCollection ==
                                      'encouragements'))
                                    FFButtonWidget(
                                      onPressed: () async {
                                        _model.importCollection =
                                            'encouragements';
                                        safeSetState(() {});
                                      },
                                      text: FFLocalizations.of(context).getText(
                                        'nnddtd6k' /* encouragements */,
                                      ),
                                      options: FFButtonOptions(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: Colors.transparent,
                                        textStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                        ),
                                        elevation: 0.0,
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                ],
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'af5wygnu' /* Target: */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                _model.importCollection!,
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                          TextFormField(
                            controller: _model.importCsvFieldTextController,
                            focusNode: _model.importCsvFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.importCsvFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.importCsvText =
                                    _model.importCsvFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                'iya56y70' /* CSV content (header row + data... */,
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
                            maxLines: 8,
                            validator: _model
                                .importCsvFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  _model.importPreviewOutput =
                                      await actions.runCurriculumImport(
                                    _model.importCollection,
                                    _model.importCsvFieldTextController.text,
                                    true,
                                  );
                                  _model.importCreated =
                                      _model.importPreviewOutput?.created;
                                  safeSetState(() {});
                                  _model.importUpdated =
                                      _model.importPreviewOutput?.updated;
                                  safeSetState(() {});
                                  _model.importUnchanged =
                                      _model.importPreviewOutput?.unchanged;
                                  safeSetState(() {});
                                  _model.importErrorCount =
                                      _model.importPreviewOutput?.errorCount;
                                  safeSetState(() {});
                                  _model.importFirstError = _model
                                      .importPreviewOutput?.firstErrorMessage;
                                  safeSetState(() {});
                                  _model.importPreviewed = true;
                                  safeSetState(() {});

                                  safeSetState(() {});
                                },
                                text: FFLocalizations.of(context).getText(
                                  'gwqh9f43' /* Preview Import */,
                                ),
                                options: FFButtonOptions(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  textStyle: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              if (_model.importPreviewed ?? true)
                                FFButtonWidget(
                                  onPressed: () async {
                                    _model.importCommitOutput =
                                        await actions.runCurriculumImport(
                                      _model.importCollection,
                                      _model.importCsvFieldTextController.text,
                                      false,
                                    );
                                    _model.importCreated =
                                        _model.importCommitOutput?.created;
                                    safeSetState(() {});
                                    _model.importUpdated =
                                        _model.importCommitOutput?.updated;
                                    safeSetState(() {});
                                    _model.importUnchanged =
                                        _model.importCommitOutput?.unchanged;
                                    safeSetState(() {});
                                    _model.importErrorCount =
                                        _model.importCommitOutput?.errorCount;
                                    safeSetState(() {});
                                    _model.importFirstError = _model
                                        .importCommitOutput?.firstErrorMessage;
                                    safeSetState(() {});
                                    _model.importPreviewed = false;
                                    safeSetState(() {});
                                    if (_model.importErrorCount == 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Import complete. The app content is updated.',
                                            style: TextStyle(),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Import stopped. See the error below.',
                                            style: TextStyle(),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                        ),
                                      );
                                    }

                                    safeSetState(() {});
                                  },
                                  text: FFLocalizations.of(context).getText(
                                    'ghnr6u7d' /* Confirm Import */,
                                  ),
                                  options: FFButtonOptions(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).success,
                                    textStyle: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'knblstbn' /* Create: */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).success,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                _model.importCreated!.toString(),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).success,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  'oqhoucg6' /* Update: */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                _model.importUpdated!.toString(),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).tertiary,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  'i9y7yj5k' /* No change: */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                _model.importUnchanged!.toString(),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  '5uhx0759' /* Errors: */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).error,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                              Text(
                                _model.importErrorCount!.toString(),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).error,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                              ),
                            ].divide(SizedBox(width: 4.0)),
                          ),
                          if (!(_model.importErrorCount == 0))
                            Text(
                              _model.importFirstError!,
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
                                    color: FlutterFlowTheme.of(context).error,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                        ].divide(SizedBox(height: 12.0)),
                      ),
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
