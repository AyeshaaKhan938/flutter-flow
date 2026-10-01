import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'language_registry.dart';
import 'translation_service.dart';

/// App-root glue for CMS languages, used by main.dart (small hand edits).

/// Bumped whenever the registry or translations change.
int _languageDataVersion = 0;
int get languageDataVersion => _languageDataVersion;

/// Something that changes when translations or the language list change.
final Listenable languageDataListenable = Listenable.merge([
  LanguageRegistry.instance,
  TranslationService.instance,
]);

void bumpLanguageDataVersion() => _languageDataVersion++;

/// Loads the member's content language, the language list and its cached
/// translations before the first frame.
Future<void> initializeLanguageSupport() async {
  await LanguageRegistry.instance.initialize();
  await TranslationService.instance
      .loadLanguage(LanguageRegistry.contentLanguage);
}

/// Marker resource for [ContentLanguageRefreshDelegate].
class ContentLanguageVersion {
  const ContentLanguageVersion(this.version);
  final int version;
}

/// A localizations delegate whose only job is to make the Localizations
/// widget reload when translations arrive. Reloading notifies every widget
/// that reads localizations (all pages via FFLocalizations.of), so screens
/// rebuild with the new text without a restart.
class ContentLanguageRefreshDelegate
    extends LocalizationsDelegate<ContentLanguageVersion> {
  const ContentLanguageRefreshDelegate(this.version);
  final int version;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<ContentLanguageVersion> load(Locale locale) =>
      SynchronousFuture(ContentLanguageVersion(version));

  @override
  bool shouldReload(ContentLanguageRefreshDelegate old) =>
      old.version != version;
}

/// Applies the content language's text direction. Compiled languages
/// (en/es/ur/lg) get it from their Flutter locale already; a CMS-added
/// language runs on an English framework locale, so its `rtl` flag from
/// the registry decides here.
Widget withContentDirectionality(Widget child) {
  final code = LanguageRegistry.contentLanguage;
  if (kCompiledLanguages.contains(code)) {
    return child;
  }
  return Directionality(
    textDirection: LanguageRegistry.instance.isRtl(code)
        ? TextDirection.rtl
        : TextDirection.ltr,
    child: child,
  );
}
