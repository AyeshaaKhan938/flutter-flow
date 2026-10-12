import '/auth/firebase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/schema/structs/index.dart';
import '/custom_code/widgets/pathway_cover.dart';
import '/index.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rag_search_page_model.dart';
export 'rag_search_page_model.dart';

/// Ask questions limited to approved Kingdom Heirs content.
class RagSearchPageWidget extends StatefulWidget {
  const RagSearchPageWidget({super.key});

  static String routeName = 'RagSearchPage';
  static String routePath = '/search/rag';

  @override
  State<RagSearchPageWidget> createState() => _RagSearchPageWidgetState();
}

class _RagSearchPageWidgetState extends State<RagSearchPageWidget> {
  late RagSearchPageModel _model;

  /// Sources the answer was drawn from (label, pathwayId, ...).
  List<Map<String, dynamic>> _citations = [];
  bool _asking = false;

  /// Asks the private Kingdom Heirs Research Library (askKingdomHeirs).
  /// Answers come only from approved sources and always cite them.
  Future<void> _ask() async {
    final question = (_model.questionInput ?? '').trim();
    if (question.isEmpty || _asking) {
      return;
    }
    safeSetState(() {
      _asking = true;
      _model.answerText = '';
      _model.fallbackText = '';
      _citations = [];
    });
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('askKingdomHeirs',
              options:
                  HttpsCallableOptions(timeout: const Duration(seconds: 120)))
          .call({'question': question});
      final data = Map<String, dynamic>.from(result.data as Map);
      _model.answerText = '${data['answer'] ?? ''}';
      _citations = [
        for (final c in (data['citations'] as List? ?? const []))
          Map<String, dynamic>.from(c as Map),
      ];
    } on FirebaseFunctionsException catch (e) {
      final offline = e.code == 'unavailable';
      _model.fallbackText = offline
          ? switch (_model.memberLanguage) {
              'es' =>
                'Sin conexión. Preguntar a Kingdom Heirs necesita internet.',
              'ur' =>
                'آپ آف لائن ہیں۔ کنگڈم ہائرز سے پوچھنے کے لیے انٹرنیٹ درکار ہے۔',
              'lg' =>
                'Tolina yintaneeti. Okubuuza Kingdom Heirs kyetaaga yintaneeti.',
              _ =>
                "You're offline. Ask Kingdom Heirs needs an internet connection.",
            }
          : 'Ask Kingdom Heirs could not answer right now. Please try again.';
    } catch (_) {
      _model.fallbackText =
          'Ask Kingdom Heirs could not answer right now. Please try again.';
    } finally {
      safeSetState(() => _asking = false);
    }
  }

  /// "Report an issue" on an answer: wrong source, unhelpful, or a concern.
  /// Sent to Kingdom Heirs for review (reportAskIssue).
  Future<void> _reportIssue() async {
    const reasons = {
      'wrong_source': 'The source or citation looks wrong',
      'not_helpful': 'The answer was not helpful',
      'concern': 'I have a concern about this answer',
      'other': 'Something else',
    };
    var reason = 'wrong_source';
    final note = TextEditingController();
    final send = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Report an issue'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final e in reasons.entries)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(reason == e.key
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked),
                    title: Text(e.value),
                    onTap: () => setDialogState(() => reason = e.key),
                  ),
                TextField(
                  controller: note,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Optional note',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
    if (send != true) {
      return;
    }
    try {
      await FirebaseFunctions.instance.httpsCallable('reportAskIssue').call({
        'reason': reason,
        'note': note.text,
        'question': _model.questionInput ?? '',
        'answer': _model.answerText ?? '',
        'citations': [for (final c in _citations) '${c['label'] ?? ''}'],
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Thank you. Kingdom Heirs will review it.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Could not send the report. Please try again.')),
        );
      }
    }
  }

  /// One cited source: cover, "Source: Title, Chapter n — ..." and a link
  /// to its pathway (the pathway page keeps locked pathways locked).
  Widget _citationCard(Map<String, dynamic> c) {
    final theme = FlutterFlowTheme.of(context);
    final pathwayId = '${c['pathwayId'] ?? ''}';
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64.0,
            child: PathwayCover(pathwayId: pathwayId, height: 96.0),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${c['label'] ?? ''}',
                    style: theme.labelMedium.override(
                      font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      letterSpacing: 0.0,
                    ),
                  ),
                  if (pathwayId.isNotEmpty)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: AlignmentDirectional.centerStart,
                      ),
                      onPressed: () => context.pushNamed(
                        PathwayOverviewPageWidget.routeName,
                        queryParameters: {
                          'pathwayId':
                              serializeParam(pathwayId, ParamType.String),
                        }.withoutNulls,
                      ),
                      child: Text(
                        'Go to pathway',
                        style: theme.labelMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          color: theme.primary,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RagSearchPageModel());

    _model.ragQuestionFieldTextController ??= TextEditingController();
    _model.ragQuestionFieldFocusNode ??= FocusNode();
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
              'h52bomin' /* Ask Kingdom Heirs */,
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
                  Text(
                    FFLocalizations.of(context).getText(
                      'xqpai7gi' /* Answers use only approved King... */,
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  TextFormField(
                    controller: _model.ragQuestionFieldTextController,
                    focusNode: _model.ragQuestionFieldFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.ragQuestionFieldTextController',
                      Duration(milliseconds: 2000),
                      () async {
                        _model.questionInput =
                            _model.ragQuestionFieldTextController.text;
                        safeSetState(() {});
                      },
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: FFLocalizations.of(context).getText(
                        'jnv7j14j' /* Ask about Scripture, pathways,... */,
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
                    validator: _model.ragQuestionFieldTextControllerValidator
                        .asValidator(context),
                  ),
                  FFButtonWidget(
                    onPressed: () async {
                      _model.ragLangProfile = await GetUserProfileV4Call.call(
                        authToken: currentJwtToken,
                      );

                      if ((_model.ragLangProfile?.succeeded ?? true)) {
                        _model.memberLanguage =
                            UserProfileFullResponseStruct.maybeFromMap(
                                    (_model.ragLangProfile?.jsonBody ?? ''))
                                ?.preferredLanguage;
                        safeSetState(() {});
                        await _ask();
                      }

                      safeSetState(() {});
                    },
                    text: FFLocalizations.of(context).getText(
                      '8cqdqvpm' /* Search */,
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
                  Text(
                    FFLocalizations.of(context).getText(
                      'pa7q0vso' /* Answer */,
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
                  Text(
                    _model.answerText!,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          font: GoogleFonts.lora(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight:
                              FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                  ),
                  Text(
                    FFLocalizations.of(context).getText(
                      '70neur48' /* Citations */,
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
                  if (_asking) const Center(child: CircularProgressIndicator()),
                  for (final c in _citations) _citationCard(c),
                  if ((_model.answerText ?? '').isNotEmpty && !_asking)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: _reportIssue,
                        icon: const Icon(Icons.flag_outlined, size: 18.0),
                        label: const Text('Report an issue'),
                      ),
                    ),
                  Text(
                    _model.fallbackText!,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ].divide(SizedBox(height: 14.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
