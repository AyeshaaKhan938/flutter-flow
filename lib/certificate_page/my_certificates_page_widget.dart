import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/custom_code/languages/language_registry.dart';
import '/custom_code/languages/translation_service.dart';
import '/custom_code/pathway_progression.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'certificate_page_widget.dart' show formatCertificateDate;

/// The member's issued certificates (users/{uid}/certificates).
class MyCertificatesPageWidget extends StatefulWidget {
  const MyCertificatesPageWidget({super.key});

  static String routeName = 'MyCertificatesPage';
  static String routePath = '/certificates';

  @override
  State<MyCertificatesPageWidget> createState() =>
      _MyCertificatesPageWidgetState();
}

class _MyCertificatesPageWidgetState extends State<MyCertificatesPageWidget> {
  Map<String, PathwaysRecord> _pathwaysById = {};

  String get _lang => LanguageRegistry.contentLanguage;

  String _t(String english, [Map<String, String> args = const {}]) =>
      progressionText(english, _lang, args);

  @override
  void initState() {
    super.initState();
    _loadPathways();
    // Issue any certificate earned but not stored yet; the list below
    // updates through its snapshot stream.
    PathwayProgressionService.instance.load().then(
        PathwayProgressionService.instance.issueEarnedCertificates,
        onError: (_) {});
  }

  Future<void> _loadPathways() async {
    try {
      final pathways = await queryPathwaysRecordOnce(limit: 100);
      if (mounted) {
        setState(() => _pathwaysById = {for (final p in pathways) p.stableId: p});
      }
    } catch (_) {}
  }

  String _titleFor(String id, String stored) {
    if (id == kCoreCertificateId) {
      return _t(kCoreCertificateTitle);
    }
    return _pathwaysById[id]?.title.forLanguage(_lang) ??
        (stored.isNotEmpty ? stored : id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final uid = currentUserUid;
    return ListenableBuilder(
      listenable: TranslationService.instance,
      builder: (context, _) => Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.primaryBackground,
          automaticallyImplyLeading: true,
          title: Text(
            _t('My certificates'),
            style: theme.titleLarge.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w600),
              fontSize: 22.0,
              letterSpacing: 0.0,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: uid.isEmpty
              ? const SizedBox.shrink()
              : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream:
                      PathwayProgressionService.certificatesOf(uid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: theme.primary),
                      );
                    }
                    final docs = snapshot.data!.docs.toList()
                      ..sort((a, b) {
                        DateTime at(QueryDocumentSnapshot<Map<String, dynamic>> d) {
                          final v = d.data()['issuedAt'];
                          return v is Timestamp ? v.toDate() : DateTime.now();
                        }

                        return at(b).compareTo(at(a));
                      });
                    if (docs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium_outlined,
                                  size: 56.0, color: theme.secondaryText),
                              const SizedBox(height: 12.0),
                              Text(
                                _t('No certificates yet. Complete a pathway to earn your first certificate.'),
                                textAlign: TextAlign.center,
                                style: theme.bodyMedium.override(
                                  font: GoogleFonts.inter(),
                                  color: theme.secondaryText,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(20.0),
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                      itemBuilder: (context, i) {
                        final data = docs[i].data();
                        final id = docs[i].id;
                        final issued = data['issuedAt'];
                        final date = formatCertificateDate(
                          issued is Timestamp ? issued.toDate() : DateTime.now(),
                          _lang,
                        );
                        final isCore = id == kCoreCertificateId;
                        return Material(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(16.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: isCore
                                  ? BorderSide(color: theme.secondary, width: 1.5)
                                  : BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            leading: Icon(
                              isCore
                                  ? Icons.workspace_premium
                                  : Icons.emoji_events_outlined,
                              color: theme.secondary,
                              size: 32.0,
                            ),
                            title: Text(
                              _titleFor(id, data['title'] as String? ?? ''),
                              style: theme.titleSmall.override(
                                font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600),
                                letterSpacing: 0.0,
                              ),
                            ),
                            subtitle: Text(
                              _t('Issued {date}', {'date': date}),
                              style: theme.labelMedium.override(
                                font: GoogleFonts.inter(),
                                color: theme.secondaryText,
                                letterSpacing: 0.0,
                              ),
                            ),
                            trailing: Icon(Icons.chevron_right,
                                color: theme.secondaryText),
                            onTap: () => context.pushNamed(
                              CertificatePageWidget.routeName,
                              queryParameters: {
                                'pathwayId':
                                    serializeParam(id, ParamType.String),
                              }.withoutNulls,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
