import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'ur', 'es', 'lg'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? urText = '',
    String? esText = '',
    String? lgText = '',
  }) =>
      [enText, urText, esText, lgText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // PathwayListPage
  {
    '8zakpprc': {
      'en': 'Pathways',
      'es': 'Senderos',
      'lg': 'Amakubo',
      'ur': 'راستے',
    },
    '5rmrdz56': {
      'en': 'Pathways',
      'es': 'Senderos',
      'lg': 'Amakubo',
      'ur': 'راستے',
    },
    '184lycny': {
      'en': 'Discipleship journeys you can start today.',
      'es': 'Caminos de discipulado que puedes comenzar hoy mismo.',
      'lg': 'Enkola z\'obuyigirizwa z\'osobola okutandika leero.',
      'ur': 'شاگردی کا سفر آپ آج سے شروع کر سکتے ہیں۔',
    },
    '0zu33ilr': {
      'en': 'Loading…',
      'es': 'Cargando…',
      'lg': 'Kuleeta…',
      'ur': 'لوڈ ہو رہا ہے…',
    },
    '6248jqp7': {
      'en': 'Pathways',
      'es': '',
      'lg': 'Amakubo',
      'ur': '',
    },
  },
  // TodayPage
  {
    '3vonyhg4': {
      'en': 'Today',
      'es': 'Hoy',
      'lg': 'Leero',
      'ur': 'آج',
    },
    'pymmndk7': {
      'en': 'Ask Kingdom Heirs (RAG)',
      'es': 'Pregunta a Kingdom Heirs',
      'lg': 'Buuza Kingdom Heirs',
      'ur': 'کنگڈم ہائرز سے پوچھیں',
    },
    'yhb29ikd': {
      'en': 'Kingdom Heirs',
      'es': 'Herederos del reino',
      'lg': 'Kingdom Heirs',
      'ur': 'بادشاہی کے وارث',
    },
    '6yw0o7zm': {
      'en': 'Growing together. Living the mission.',
      'es': 'Creciendo juntos. Viviendo la misión.',
      'lg': 'Tukulira wamu. Tubeera mu bubaka.',
      'ur': 'ایک ساتھ بڑھنا۔ مشن کو جینا۔',
    },
    '9k0upj1o': {
      'en': 'Today\'s Scripture',
      'es': 'Escritura de hoy',
      'lg': 'Ebyawandiikibwa by\'olwaleero',
      'ur': 'آج کا کلام',
    },
    'zxk458lu': {
      'en': 'Encouragement',
      'es': 'Estímulo',
      'lg': 'Okuzzaamu amaanyi',
      'ur': 'حوصلہ افزائی',
    },
    'c3m7uoy7': {
      'en': 'Announcements',
      'es': 'Anuncios',
      'lg': 'Ebirangiriro',
      'ur': 'اعلانات',
    },
  },
  // OnboardingSurveyPage
  {
    '7yk94zey': {
      'en': 'Welcome',
      'es': 'Bienvenido',
      'lg': 'Tukwaniriza',
      'ur': 'خوش آمدید',
    },
    't2tw8glq': {
      'en': 'Choose your language',
      'es': 'Elige tu idioma',
      'lg': 'Londa olulimi lwo',
      'ur': 'اپنی زبان منتخب کریں',
    },
    'xh51k31m': {
      'en':
          'English, Spanish, Urdu (RTL), and Luganda (content falls back to English where translations are missing).',
      'es': '',
      'lg':
          'English, Spanish, Urdu (RTL), and Luganda (content falls back to English where translations are missing).',
      'ur': '',
    },
    'tyvkilol': {
      'en': '✓ English',
      'es': '✓ English',
      'lg': '✓ English',
      'ur': '✓ English',
    },
    'o147mscj': {
      'en': 'English',
      'es': 'English',
      'lg': 'English',
      'ur': 'English',
    },
    'ivjkmu2g': {
      'en': '✓ Español',
      'es': '✓ Español',
      'lg': '✓ Español',
      'ur': '✓ Español',
    },
    'u2ase98s': {
      'en': 'Español',
      'es': 'Español',
      'lg': 'Español',
      'ur': 'Español',
    },
    '6v60ckxc': {
      'en': '✓ اردو',
      'es': '✓ اردو',
      'lg': '✓ اردو',
      'ur': '✓ اردو',
    },
    'z63wbotb': {
      'en': 'اردو',
      'es': 'اردو',
      'lg': 'اردو',
      'ur': 'اردو',
    },
    'ogv504bm': {
      'en': '✓ Luganda',
      'es': '✓ Luganda',
      'lg': '✓ Luganda',
      'ur': '✓ Luganda',
    },
    'ooi2ip6x': {
      'en': 'Luganda',
      'es': 'Luganda',
      'lg': 'Luganda',
      'ur': 'Luganda',
    },
    '4j67k168': {
      'en': 'How did you hear about Kingdom Heirs?',
      'es': '¿Cómo conociste Kingdom Heirs?',
      'lg': 'Wawulira otya ku Kingdom Heirs?',
      'ur': 'آپ نے کنگڈم ہائرز کے بارے میں کیسے سنا؟',
    },
    'wb8r0eh4': {
      'en': 'What are you hoping to grow in?',
      'es': '¿En qué esperas crecer?',
      'lg': 'Oyagala okukulaakulana mu ki?',
      'ur': 'آپ کس چیز میں بڑھنا چاہتے ہیں؟',
    },
    'h4l5v7tc': {
      'en': 'Continue',
      'es': 'Continuar',
      'lg': 'Weyongereyo',
      'ur': 'جاری رکھیں',
    },
  },
  // SignUpPage
  {
    'framilt1': {
      'en': 'Create Account',
      'es': 'Crear una cuenta',
      'lg': 'Kola Akawunti',
      'ur': 'اکاؤنٹ بنائیں',
    },
    'a5147fnc': {
      'en': 'Create your account',
      'es': 'Crea tu cuenta',
      'lg': 'Kola akawunti yo',
      'ur': 'اپنا اکاؤنٹ بنائیں',
    },
    '4uemf7j5': {
      'en': 'Full name',
      'es': 'Nombre completo',
      'lg': 'Erinnya lyo lyonna',
      'ur': 'پورا نام',
    },
    '0yamf9ha': {
      'en': 'Phone number (optional)',
      'es': 'Número de teléfono (opcional)',
      'lg': 'Ennamba ya ssimu (si ya buwaze)',
      'ur': 'فون نمبر (اختیاری)',
    },
    'nzbvfbut': {
      'en': 'Country',
      'es': 'País',
      'lg': 'Eggwanga',
      'ur': 'ملک',
    },
    '08bkphld': {
      'en': 'City (optional)',
      'es': 'Ciudad (opcional)',
      'lg': 'Ekibuga (si kya buwaze)',
      'ur': 'شہر (اختیاری)',
    },
    '3wnu1x92': {
      'en': 'Email',
      'es': 'Correo electrónico',
      'lg': 'Email',
      'ur': 'ای میل',
    },
    'zt7pzvuw': {
      'en': 'Password',
      'es': 'Contraseña',
      'lg': 'Ekigambo ky\'ekyama',
      'ur': 'پاس ورڈ',
    },
    'q2vm203a': {
      'en': 'Sign Up',
      'es': 'Inscribirse',
      'lg': 'Wewandiise',
      'ur': 'سائن اپ کریں۔',
    },
  },
  // SignInPage
  {
    'j7g77u4j': {
      'en': 'Sign In',
      'es': 'Iniciar sesión',
      'lg': 'Yingira',
      'ur': 'سائن ان کریں۔',
    },
    'q27e3qze': {
      'en': 'Kingdom Heirs',
      'es': 'Herederos del reino',
      'lg': 'Kingdom Heirs',
      'ur': 'بادشاہی کے وارث',
    },
    'xqlay70v': {
      'en': 'Sign in to continue your journey',
      'es': 'Inicia sesión para continuar tu viaje.',
      'lg': 'Yingira okweyongerayo n\'olugendo lwo',
      'ur': 'اپنا سفر جاری رکھنے کے لیے سائن ان کریں۔',
    },
    '2ahh5sx9': {
      'en': 'Email',
      'es': 'Correo electrónico',
      'lg': 'Email',
      'ur': 'ای میل',
    },
    'jwef6i19': {
      'en': 'Password',
      'es': 'Contraseña',
      'lg': 'Ekigambo ky\'ekyama',
      'ur': 'پاس ورڈ',
    },
    'qigpwmgk': {
      'en': 'Sign In',
      'es': 'Iniciar sesión',
      'lg': 'Yingira',
      'ur': 'سائن ان کریں',
    },
    'x3s67bww': {
      'en': 'Create an account',
      'es': 'Crear una cuenta',
      'lg': 'Kola akawunti',
      'ur': 'ایک اکاؤنٹ بنائیں',
    },
  },
  // AdminPathwaysPage
  {
    '8a6xbi8k': {
      'en': 'Manage Pathways',
      'es': 'Gestionar vías',
      'lg': 'Kola ku Makubo',
      'ur': 'راستوں کا نظم کریں۔',
    },
    'jz8jsiaf': {
      'en': 'Publish announcement',
      'es': '',
      'lg': 'Publish announcement',
      'ur': '',
    },
    '4vci4sbx': {
      'en':
          'Saves to announcements and can send localized FCM using each member preferredLanguage.',
      'es': '',
      'lg':
          'Saves to announcements and can send localized FCM using each member preferredLanguage.',
      'ur': '',
    },
    '1ccn96wk': {
      'en': 'Title (EN)',
      'es': '',
      'lg': 'Title (EN)',
      'ur': '',
    },
    '0lhahpo6': {
      'en': 'Title (ES draft)',
      'es': '',
      'lg': 'Title (ES draft)',
      'ur': '',
    },
    'q3x9kohh': {
      'en': 'Title (UR draft)',
      'es': '',
      'lg': 'Title (UR draft)',
      'ur': '',
    },
    'm1dy9t41': {
      'en': 'Body (EN)',
      'es': '',
      'lg': 'Body (EN)',
      'ur': '',
    },
    'c5cr8hgv': {
      'en': 'Body (ES draft)',
      'es': '',
      'lg': 'Body (ES draft)',
      'ur': '',
    },
    '0iub2yof': {
      'en': 'Body (UR draft)',
      'es': '',
      'lg': 'Body (UR draft)',
      'ur': '',
    },
    'ntdrmux1': {
      'en': 'Publish + notify members',
      'es': '',
      'lg': 'Publish + notify members',
      'ur': '',
    },
    'kgp1nv6b': {
      'en': 'Save announcement only (no push)',
      'es': '',
      'lg': 'Save announcement only (no push)',
      'ur': '',
    },
    'q6mq841w': {
      'en': 'Translation drafts',
      'es': '',
      'lg': 'Translation drafts',
      'ur': '',
    },
    'fhohg5wy': {
      'en': 'Generate ES/UR pathway drafts',
      'es': '',
      'lg': 'Generate ES/UR pathway drafts',
      'ur': '',
    },
    '4upku5le': {
      'en': 'Generate ES/UR lesson drafts',
      'es': '',
      'lg': 'Generate ES/UR lesson drafts',
      'ur': '',
    },
    'wkid62i1': {
      'en': 'Assessment rules (live)',
      'es': '',
      'lg': 'Assessment rules (live)',
      'ur': '',
    },
    'l2bs79bt': {
      'en':
          'Edit score bands, overrides, and explanations. Changes apply to new submits immediately — no app release.',
      'es': '',
      'lg':
          'Edit score bands, overrides, and explanations. Changes apply to new submits immediately — no app release.',
      'ur': '',
    },
    'uo92yaak': {
      'en': 'Load active config',
      'es': '',
      'lg': 'Load active config',
      'ur': '',
    },
    'sqm4uwaa': {
      'en': 'Assessment version',
      'es': '',
      'lg': 'Assessment version',
      'ur': '',
    },
    'mxpyprz5': {
      'en': 'Score bands JSON',
      'es': '',
      'lg': 'Score bands JSON',
      'ur': '',
    },
    '53e751an': {
      'en': 'Overrides JSON',
      'es': '',
      'lg': 'Overrides JSON',
      'ur': '',
    },
    'abdgzy7s': {
      'en': 'Explanations JSON',
      'es': '',
      'lg': 'Explanations JSON',
      'ur': '',
    },
    '6zkmejjg': {
      'en': 'Point map JSON',
      'es': '',
      'lg': 'Point map JSON',
      'ur': '',
    },
    't0p9hilp': {
      'en': 'Save & activate rules',
      'es': '',
      'lg': 'Save & activate rules',
      'ur': '',
    },
    'e3yc7ebr': {
      'en': 'Admin report',
      'es': '',
      'lg': 'Admin report',
      'ur': '',
    },
    '8gr2edeb': {
      'en': 'Refresh report',
      'es': '',
      'lg': 'Refresh report',
      'ur': '',
    },
    'jlpv7k2u': {
      'en': 'Create content',
      'es': '',
      'lg': 'Create content',
      'ur': '',
    },
    '4yvy61cq': {
      'en': 'Create pathway (draft)',
      'es': '',
      'lg': 'Create pathway (draft)',
      'ur': '',
    },
    '31vjzirp': {
      'en': 'Title (English)',
      'es': '',
      'lg': 'Title (English)',
      'ur': '',
    },
    '0qer9c69': {
      'en': 'Stable ID (e.g. come-and-see)',
      'es': '',
      'lg': 'Stable ID (e.g. come-and-see)',
      'ur': '',
    },
    'd1vd8i2k': {
      'en': 'Create Pathway',
      'es': '',
      'lg': 'Create Pathway',
      'ur': '',
    },
    'flizzuzv': {
      'en': 'Create lesson (draft)',
      'es': '',
      'lg': 'Create lesson (draft)',
      'ur': '',
    },
    'u4297vic': {
      'en': 'Lesson title (English)',
      'es': '',
      'lg': 'Lesson title (English)',
      'ur': '',
    },
    'zk0ekyyf': {
      'en': 'Stable ID (e.g. LESSON-COME-001)',
      'es': '',
      'lg': 'Stable ID (e.g. LESSON-COME-001)',
      'ur': '',
    },
    '1ddemhqa': {
      'en': 'Parent pathway stableId',
      'es': '',
      'lg': 'Parent pathway stableId',
      'ur': '',
    },
    'dmvkrtrk': {
      'en': 'Scripture ref (e.g. John 3:16)',
      'es': '',
      'lg': 'Scripture ref (e.g. John 3:16)',
      'ur': '',
    },
    '81pcpgvs': {
      'en': 'Create Lesson',
      'es': '',
      'lg': 'Create Lesson',
      'ur': '',
    },
    '6ku1r7wp': {
      'en': 'Edit content',
      'es': '',
      'lg': 'Edit content',
      'ur': '',
    },
    'qy1uhfab': {
      'en': 'Edit pathway',
      'es': '',
      'lg': 'Edit pathway',
      'ur': '',
    },
    '5xl35md5': {
      'en': 'Stable ID to update',
      'es': '',
      'lg': 'Stable ID to update',
      'ur': '',
    },
    'gipfyn9f': {
      'en': 'New title (English)',
      'es': '',
      'lg': 'New title (English)',
      'ur': '',
    },
    '4z54k5p9': {
      'en': 'Status: draft | in_review | published',
      'es': '',
      'lg': 'Status: draft | in_review | published',
      'ur': '',
    },
    'bd0eimw8': {
      'en': 'Update Pathway',
      'es': '',
      'lg': 'Update Pathway',
      'ur': '',
    },
    'ounn6gex': {
      'en': 'Edit lesson',
      'es': '',
      'lg': 'Edit lesson',
      'ur': '',
    },
    'x30beon5': {
      'en': 'Parent pathway stableId',
      'es': '',
      'lg': 'Parent pathway stableId',
      'ur': '',
    },
    'p389fojk': {
      'en': 'Lesson stableId',
      'es': '',
      'lg': 'Lesson stableId',
      'ur': '',
    },
    'pditiayw': {
      'en': 'New title',
      'es': '',
      'lg': 'New title',
      'ur': '',
    },
    'fivaqvz7': {
      'en': 'Scripture ref',
      'es': '',
      'lg': 'Scripture ref',
      'ur': '',
    },
    '7t9cmwn0': {
      'en': 'Reflection prompt',
      'es': '',
      'lg': 'Reflection prompt',
      'ur': '',
    },
    '3zabe2mp': {
      'en': 'Status: draft | in_review | published',
      'es': '',
      'lg': 'Status: draft | in_review | published',
      'ur': '',
    },
    'molltaja': {
      'en': 'Update Lesson',
      'es': '',
      'lg': 'Update Lesson',
      'ur': '',
    },
    'd8682e0k': {
      'en': 'Pathways (all statuses)',
      'es': '',
      'lg': 'Pathways (all statuses)',
      'ur': '',
    },
    'us7flsgc': {
      'en': 'Submit',
      'es': '',
      'lg': 'Submit',
      'ur': '',
    },
    'prem5u25': {
      'en': 'Publish',
      'es': '',
      'lg': 'Publish',
      'ur': '',
    },
    'kn1x55x3': {
      'en': 'Unpublish',
      'es': '',
      'lg': 'Unpublish',
      'ur': '',
    },
    '3jh28ea7': {
      'en': 'Delete',
      'es': '',
      'lg': 'Delete',
      'ur': '',
    },
    '5t7q6hnw': {
      'en': 'Daily Scripture (all statuses)',
      'es': '',
      'lg': 'Daily Scripture (all statuses)',
      'ur': '',
    },
    '41n51lru': {
      'en': 'Lessons (all statuses)',
      'es': '',
      'lg': 'Lessons (all statuses)',
      'ur': '',
    },
    'w5di1mwb': {
      'en': 'Submit for Review',
      'es': '',
      'lg': 'Submit for Review',
      'ur': '',
    },
    'gvlpz0hk': {
      'en': 'Approve & Publish',
      'es': '',
      'lg': 'Approve & Publish',
      'ur': '',
    },
    'mqk397iq': {
      'en': 'Back to Draft',
      'es': '',
      'lg': 'Back to Draft',
      'ur': '',
    },
    'sjxbois2': {
      'en': 'Unpublish',
      'es': '',
      'lg': 'Unpublish',
      'ur': '',
    },
    'kwmzul5z': {
      'en': 'Quizzes (all statuses)',
      'es': '',
      'lg': 'Quizzes (all statuses)',
      'ur': '',
    },
    'ukc7prir': {
      'en': 'Submit for Review',
      'es': '',
      'lg': 'Submit for Review',
      'ur': '',
    },
    'lt1h1tu5': {
      'en': 'Approve & Publish',
      'es': '',
      'lg': 'Approve & Publish',
      'ur': '',
    },
    '30p71cwk': {
      'en': 'Back to Draft',
      'es': '',
      'lg': 'Back to Draft',
      'ur': '',
    },
    't58atw7n': {
      'en': 'Unpublish',
      'es': '',
      'lg': 'Unpublish',
      'ur': '',
    },
    'ix7r9qf2': {
      'en': 'Bulk Curriculum Importer',
      'es': '',
      'lg': 'Bulk Curriculum Importer',
      'ur': '',
    },
    'uqss0gyk': {
      'en': 'Paste CSV with a header row. Target collection buttons below.',
      'es': '',
      'lg': 'Paste CSV with a header row. Target collection buttons below.',
      'ur': '',
    },
    '51667gmm': {
      'en': 'pathways',
      'es': '',
      'lg': 'pathways',
      'ur': '',
    },
    'wvf9wapw': {
      'en': 'pathways',
      'es': '',
      'lg': 'pathways',
      'ur': '',
    },
    'vlzev2eo': {
      'en': 'lessons',
      'es': '',
      'lg': 'lessons',
      'ur': '',
    },
    '58lwjmah': {
      'en': 'lessons',
      'es': '',
      'lg': 'lessons',
      'ur': '',
    },
    'd3guiznk': {
      'en': 'dailyScripture',
      'es': '',
      'lg': 'dailyScripture',
      'ur': '',
    },
    '3w9gf0wx': {
      'en': 'dailyScripture',
      'es': '',
      'lg': 'dailyScripture',
      'ur': '',
    },
    '9no23ll9': {
      'en': 'encouragements',
      'es': '',
      'lg': 'encouragements',
      'ur': '',
    },
    'nnddtd6k': {
      'en': 'encouragements',
      'es': '',
      'lg': 'encouragements',
      'ur': '',
    },
    'af5wygnu': {
      'en': 'Target:',
      'es': '',
      'lg': 'Target:',
      'ur': '',
    },
    'iya56y70': {
      'en': 'CSV content (header row + data rows)',
      'es': '',
      'lg': 'CSV content (header row + data rows)',
      'ur': '',
    },
    'gwqh9f43': {
      'en': 'Preview Import',
      'es': '',
      'lg': 'Preview Import',
      'ur': '',
    },
    'ghnr6u7d': {
      'en': 'Confirm Import',
      'es': '',
      'lg': 'Confirm Import',
      'ur': '',
    },
    'knblstbn': {
      'en': 'Create:',
      'es': '',
      'lg': 'Create:',
      'ur': '',
    },
    'oqhoucg6': {
      'en': 'Update:',
      'es': '',
      'lg': 'Update:',
      'ur': '',
    },
    'i9y7yj5k': {
      'en': 'No change:',
      'es': '',
      'lg': 'No change:',
      'ur': '',
    },
    '5uhx0759': {
      'en': 'Errors:',
      'es': '',
      'lg': 'Errors:',
      'ur': '',
    },
  },
  // ProfilePage
  {
    'j72mxzfg': {
      'en': 'Profile',
      'es': 'Perfil',
      'lg': 'Pulofayiro',
      'ur': 'پروفائل',
    },
    '76mcghq4': {
      'en': 'KH',
      'es': 'KH',
      'lg': 'KH',
      'ur': 'کے ایچ',
    },
    '7vc4b05s': {
      'en': 'Manage Content (Admin)',
      'es': '',
      'lg': 'Kola ku Bikozesebwa (Admin)',
      'ur': '',
    },
    '4hs8hcel': {
      'en': 'Visible only to admin and ministry reviewer roles',
      'es': '',
      'lg': 'Visible only to admin and ministry reviewer roles',
      'ur': '',
    },
    'yy8jszmc': {
      'en': 'Manage Content (Admin)',
      'es': 'Gestionar contenido (Administrador)',
      'lg': 'Kola ku Bikozesebwa (Admin)',
      'ur': 'مواد کا نظم کریں (ایڈمن)',
    },
    '01vumem0': {
      'en': 'Visible only to admin and ministry reviewer roles',
      'es': '',
      'lg': 'Visible only to admin and ministry reviewer roles',
      'ur': '',
    },
    'fqju2unp': {
      'en': 'Sign Out',
      'es': 'Desconectar',
      'lg': 'Fuluma',
      'ur': 'سائن آؤٹ کریں۔',
    },
    'zv6tqbs6': {
      'en': 'Profile',
      'es': '',
      'lg': 'Pulofayiro',
      'ur': '',
    },
  },
  // HomePage
  {
    'w78798ta': {
      'en': 'Kingdom Heirs',
      'es': 'Herederos del reino',
      'lg': 'Kingdom Heirs',
      'ur': 'بادشاہی کے وارث',
    },
    '7ec1wh56': {
      'en': 'Welcome to Kingdom Heirs',
      'es': 'Bienvenido a Kingdom Heirs',
      'lg': 'Tukwaniriza mu Kingdom Heirs',
      'ur': 'کنگڈم ہائرز میں خوش آمدید',
    },
    '1vsevym5': {
      'en': 'Let\'s finish setting up your profile before you get started.',
      'es': 'Terminemos de configurar tu perfil antes de comenzar.',
      'lg': 'Ka tumalirize pulofayiro yo nga tetunnatandika.',
      'ur': 'شروع کرنے سے پہلے اپنا پروفائل مکمل کر لیں۔',
    },
    '6vh1zqtn': {
      'en': 'Complete Setup',
      'es': 'Completar configuración',
      'lg': 'Maliriza okuteekawo',
      'ur': 'سیٹ اپ مکمل کریں',
    },
    'cwwrqyk9': {
      'en': 'Kingdom Heirs',
      'es': 'Kingdom Heirs',
      'lg': 'Kingdom Heirs',
      'ur': 'کنگڈم ہائرز',
    },
    'e2cz07tb': {
      'en': 'Growing together. Living the mission.',
      'es': 'Creciendo juntos. Viviendo la misión.',
      'lg': 'Tukulira wamu. Tubeera mu bubaka.',
      'ur': 'مل کر بڑھیں۔ مشن کو جئیں۔',
    },
    'hn2w2hzp': {
      'en': 'Today\'s Scripture',
      'es': 'La Escritura de hoy',
      'lg': 'Ebyawandiikibwa by\'olwaleero',
      'ur': 'آج کا کلامِ مقدس',
    },
    'f95iqp6h': {
      'en': 'Psalm 23:1',
      'es': 'Salmo 23:1',
      'lg': 'Zabbuli 23:1',
      'ur': 'زبور 23:1',
    },
    '81somjju': {
      'en': 'The Lord is my shepherd; I shall not want.',
      'es': 'El Señor es mi pastor; nada me faltará.',
      'lg': 'Mukama ye musumba wange; sijja kubulwa.',
      'ur': 'خداوند میرا چرواہا ہے، مجھے کچھ کمی نہ ہوگی۔',
    },
    '8lwnidzn': {
      'en': 'Go to Today',
      'es': 'Ir a Hoy',
      'lg': 'Genda ku Leero',
      'ur': 'آج پر جائیں',
    },
    'amxdvirb': {
      'en': 'Home',
      'es': '',
      'lg': '',
      'ur': '',
    },
  },
  // RecommendationResultPage
  {
    'h20hmmdb': {
      'en': 'Recommendation',
      'es': 'Recomendación',
      'lg': 'Ekyondagiddwa',
      'ur': 'سفارش',
    },
    'wjzhtvic': {
      'en': 'Your recommended starting pathway',
      'es': 'Su ruta de inicio recomendada',
      'lg': 'Ekkubo ly\'olondeddwa okutandikirako',
      'ur': 'آپ کا تجویز کردہ ابتدائی راستہ',
    },
    '36np8wwy': {
      'en': 'Come & See',
      'es': 'Ven y Mira',
      'lg': 'Jjangu Olabe',
      'ur': 'آؤ اور دیکھو',
    },
    'qsrevnri': {
      'en': 'Rooted in Christ',
      'es': 'Arraigados en Cristo',
      'lg': 'Ababisibbwa mu Kristo',
      'ur': 'مسیح میں جڑے ہوئے',
    },
    'poumktvn': {
      'en': 'Journey into Discipleship & Evangelism',
      'es': 'Camino hacia el Discipulado y la Evangelización',
      'lg': 'Olugendo mu Buyigirizwa n\'Okubuulira',
      'ur': 'شاگردی اور بشارت کا سفر',
    },
    '9cjo2wo6': {
      'en': 'Kingdom Heirs Foundations',
      'es': 'Fundamentos de Kingdom Heirs',
      'lg': 'Emisingi gya Kingdom Heirs',
      'ur': 'کنگڈم ہائرز کی بنیادیں',
    },
    'fgp4wla3': {
      'en': 'Additional resource',
      'es': 'Recurso adicional',
      'lg': 'Ekintu ekirala eky\'okuyamba',
      'ur': 'اضافی وسیلہ',
    },
    'scr433ev': {
      'en':
          'One of your answers indicates that focused support for freedom, renewed identity and accountability may also help you. The New Man is available as a private additional pathway alongside your primary recommendation.',
      'es': '',
      'lg':
          'One of your answers indicates that focused support for freedom, renewed identity and accountability may also help you. The New Man is available as a private additional pathway alongside your primary recommendation.',
      'ur': '',
    },
    '4rf7c0y8': {
      'en': 'Open The New Man',
      'es': 'Abrir El Nuevo Hombre',
      'lg': 'Ggulawo Omuntu Omuggya',
      'ur': 'نیا انسان کھولیں',
    },
    'vihsxgf9': {
      'en': 'Start Recommended Pathway',
      'es': 'Comenzar el camino recomendado',
      'lg': 'Tandika Ekkubo Eryondagiddwa',
      'ur': 'تجویز کردہ راستہ شروع کریں',
    },
    '8qk80eyh': {
      'en': 'Browse All Pathways',
      'es': 'Ver todos los caminos',
      'lg': 'Laba Amakubo Gonna',
      'ur': 'تمام راستے دیکھیں',
    },
    'prbzjx78': {
      'en': 'Retake Assessment',
      'es': 'Repetir la evaluación',
      'lg': 'Ddamu Okukeberebwa',
      'ur': 'جائزہ دوبارہ لیں',
    },
  },
  // AssessmentQuestionsPage
  {
    'fpbwh2bz': {
      'en': 'Assessment',
      'es': 'Evaluación',
      'lg': 'Okukeberebwa',
      'ur': 'تشخیص',
    },
    '7vtg9s4j': {
      'en':
          'Choose the answer that most honestly describes where you are today. There are no perfect answers, and your responses are private.',
      'es': '',
      'lg':
          'Choose the answer that most honestly describes where you are today. There are no perfect answers, and your responses are private.',
      'ur': '',
    },
    'uxvknhqk': {
      'en': 'Loading…',
      'es': 'Cargando…',
      'lg': 'Kuleeta…',
      'ur': 'لوڈ ہو رہا ہے…',
    },
    'ect7k9ew': {
      'en': 'Question',
      'es': 'Pregunta',
      'lg': 'Ekibuuzo',
      'ur': 'سوال',
    },
    'i6hn4w40': {
      'en': 'of 10',
      'es': 'de 10',
      'lg': 'ku 10',
      'ur': 'از 10',
    },
    '4fcxos8p': {
      'en': 'Back',
      'es': 'Atrás',
      'lg': 'Ddayo',
      'ur': 'واپس',
    },
    'zuc5p36d': {
      'en': 'Next',
      'es': 'Siguiente',
      'lg': 'Ekiddako',
      'ur': 'اگلا',
    },
    'n7b1yro2': {
      'en': 'See My Recommendation',
      'es': 'Ver mi recomendación',
      'lg': 'Laba Ekyondagiddwa',
      'ur': 'میری سفارش دیکھیں',
    },
  },
  // AssessmentIntroPage
  {
    '1ki627fe': {
      'en': 'Recommendation Survey',
      'es': 'Encuesta de recomendaciones',
      'lg': 'Okukebera Okuteesa',
      'ur': 'سفارشی سروے',
    },
    'ipurt5ia': {
      'en': 'Get a recommended starting pathway',
      'es': 'Obtén una ruta de inicio recomendada',
      'lg': 'Funa ekkubo ery\'okutandikirako',
      'ur': 'ایک تجویز کردہ ابتدائی راستہ حاصل کریں۔',
    },
    '8p4qe9ww': {
      'en':
          'This takes about 3–5 minutes. Your answers help recommend a starting pathway. Come & See is available in Phase 1.',
      'es':
          'Esto lleva entre 3 y 5 minutos. Tus respuestas ayudan a recomendar un plan de acción inicial. El programa \"Ven y descubre\" está disponible en la Fase 1.',
      'lg':
          'This takes about 3–5 minutes. Your answers help recommend a starting pathway. Come & See is available in Phase 1.',
      'ur':
          'اس میں تقریباً 3-5 منٹ لگتے ہیں۔ آپ کے جوابات ایک ابتدائی راستے کی تجویز کرنے میں مدد کرتے ہیں۔ آؤ اور دیکھیں فیز 1 میں دستیاب ہے۔',
    },
    'tl3wz64i': {
      'en': 'Start',
      'es': 'Comenzar',
      'lg': 'Tandika',
      'ur': 'شروع کریں۔',
    },
    'mqh1tihu': {
      'en': 'Maybe Later',
      'es': 'Quizás más tarde',
      'lg': 'Oboolyawo Oluvannyuma',
      'ur': 'شاید بعد میں',
    },
  },
  // NotificationPermissionPrimerPage
  {
    'p0yjpdhn': {
      'en': 'Notifications',
      'es': 'Notificaciones',
      'lg': 'Obubaka',
      'ur': 'اطلاعات',
    },
    'zgtmex2c': {
      'en': 'Stay encouraged',
      'es': 'Mantente animado',
      'lg': 'Beera n\'amaanyi',
      'ur': 'حوصلہ رکھیں',
    },
    'cmqw7x55': {
      'en': 'Enable notifications for reminders and ministry announcements.',
      'es':
          'Activa las notificaciones para recordatorios y anuncios del ministerio.',
      'lg': 'Kkiriza obubaka olw\'okujjukiza n\'ebirangiriro by\'obuweereza.',
      'ur': 'یاد دہانیوں اور خدمت کے اعلانات کے لیے اطلاعات فعال کریں۔',
    },
    'tizfjqgx': {
      'en': 'Enable notifications',
      'es': 'Activar notificaciones',
      'lg': 'Kkiriza obubaka',
      'ur': 'اطلاعات فعال کریں',
    },
    'i0ha3zd1': {
      'en': 'Not now',
      'es': 'Ahora no',
      'lg': 'Si kaakano',
      'ur': 'ابھی نہیں',
    },
  },
  // ProfileTimezonePage
  {
    'q2074qos': {
      'en': 'Profile',
      'es': 'Perfil',
      'lg': 'Pulofayiro',
      'ur': 'پروفائل',
    },
    'lo7rztsz': {
      'en': 'Set your profile and timezone',
      'es': 'Configura tu perfil y zona horaria.',
      'lg': 'Teekawo pulofayiro yo n\'essaawa y\'ekitundu',
      'ur': 'اپنا پروفائل اور ٹائم زون سیٹ کریں۔',
    },
    'za004bbg': {
      'en': 'Display name',
      'es': 'Nombre para mostrar',
      'lg': 'Erinnya erirabika',
      'ur': 'ڈسپلے کا نام',
    },
    'wo1o8h37': {
      'en': 'Phone number (optional)',
      'es': 'Número de teléfono (opcional)',
      'lg': 'Ennamba ya ssimu (si ya buwaze)',
      'ur': 'فون نمبر (اختیاری)',
    },
    'yl4b4c3b': {
      'en': 'Country',
      'es': 'País',
      'lg': 'Eggwanga',
      'ur': 'ملک',
    },
    '8w4eskar': {
      'en': 'Region / City (optional)',
      'es': 'Región/Ciudad (opcional)',
      'lg': 'Ekitundu / Ekibuga (si kya buwaze)',
      'ur': 'علاقہ/شہر (اختیاری)',
    },
    'x7ww7xv9': {
      'en': 'Timezone (e.g. America/New_York)',
      'es': 'Zona horaria (por ejemplo, América/Nueva_York)',
      'lg': 'Essaawa y\'ekitundu (okugeza America/New_York)',
      'ur': 'ٹائم زون (جیسے امریکہ/نیویارک)',
    },
    'rlcvmmgf': {
      'en': 'Save & Continue',
      'es': 'Guardar y continuar',
      'lg': 'Kuuma & Weyongereyo',
      'ur': 'محفوظ کریں اور جاری رکھیں',
    },
    '62y5jqc2': {
      'en': 'Back',
      'es': 'Atrás',
      'lg': 'Ddayo',
      'ur': 'پیچھے',
    },
  },
  // ResetPasswordPage
  {
    '3garuwah': {
      'en': 'Reset Password',
      'es': 'Restablecer contraseña',
      'lg': 'Ddamu Ekigambo ky\'Ekyama',
      'ur': 'پاس ورڈ ری سیٹ کریں۔',
    },
    'dplz64jm': {
      'en': 'Request a password reset link',
      'es': 'Solicitar un enlace para restablecer la contraseña',
      'lg': 'Saba ekiyungo eky\'okuddamu ekigambo ky\'ekyama',
      'ur': 'پاس ورڈ دوبارہ ترتیب دینے کے لنک کی درخواست کریں۔',
    },
    '2ahh5sx9': {
      'en': 'Email',
      'es': 'Correo electrónico',
      'lg': 'Email',
      'ur': 'ای میل',
    },
    'irolbfvq': {
      'en': 'Send Reset Link',
      'es': 'Enviar enlace de reinicio',
      'lg': 'Weereza Ekiyungo',
      'ur': 'ری سیٹ لنک بھیجیں۔',
    },
  },
  // PathwayOverviewPage
  {
    'ptjcyd50': {
      'en': 'Loading…',
      'es': 'Cargando…',
      'lg': 'Kuleeta…',
      'ur': 'لوڈ ہو رہا ہے…',
    },
    '628s6g31': {
      'en': 'Complete each lesson at your own pace.',
      'es': 'Completa cada lección a tu propio ritmo.',
      'lg': 'Maliriza buli ssomo mu sipiidi yo.',
      'ur': 'ہر سبق اپنی رفتار سے مکمل کریں۔',
    },
    'zquctcb5': {
      'en': 'Progress:',
      'es': 'Progreso:',
      'lg': 'Enkulaakulana:',
      'ur': 'پیش رفت:',
    },
    '10pobw15': {
      'en': 'of',
      'es': 'de',
      'lg': 'ku',
      'ur': 'از',
    },
    '0lligapo': {
      'en': 'lessons complete',
      'es': 'lecciones completadas',
      'lg': 'amasomo agamaliriziddwa',
      'ur': 'اسباق مکمل',
    },
    '8la73y6n': {
      'en': 'Quizzes',
      'es': 'Cuestionarios',
      'lg': 'Ebibuuzo',
      'ur': 'کوئز',
    },
    'tk5n04z3': {
      'en': 'Quiz 1 after Lesson 7 · Quiz 2 after Lesson 14 · 80% to pass',
      'es':
          'Cuestionario 1 tras la lección 7 · Cuestionario 2 tras la lección 14 · 80% para aprobar',
      'lg': 'Quiz 1 after Lesson 7 · Quiz 2 after Lesson 14 · 80% to pass',
      'ur': 'کوئز 1 سبق 7 کے بعد · کوئز 2 سبق 14 کے بعد · پاس ہونے کے لیے 80٪',
    },
    'cp7vkmln': {
      'en': 'Take Come & See Quiz 1',
      'es': 'Hacer el cuestionario 1 de Ven y Mira',
      'lg': 'Kola Ekibuuzo 1 ekya Jjangu Olabe',
      'ur': 'آؤ اور دیکھو کوئز 1 لیں',
    },
    'm9uk4ao4': {
      'en': 'Take Come & See Quiz 2',
      'es': 'Hacer el cuestionario 2 de Ven y Mira',
      'lg': 'Kola Ekibuuzo 2 ekya Jjangu Olabe',
      'ur': 'آؤ اور دیکھو کوئز 2 لیں',
    },
    'bnbr5hsc': {
      'en': 'Done',
      'es': 'Listo',
      'lg': 'Kiwedde',
      'ur': 'مکمل',
    },
  },
  // DailyLessonPage
  {
    '08fffnlc': {
      'en': 'Today\'s Lesson',
      'es': 'La lección de hoy',
      'lg': 'Essomo ly\'olwaleero',
      'ur': 'آج کا سبق',
    },
    'ulfcisps': {
      'en': 'Tap to open full passage',
      'es': 'Toca para abrir el pasaje completo',
      'lg': 'Kwata okuggulawo ekitundu kyonna',
      'ur': 'مکمل حوالہ کھولنے کے لیے ٹیپ کریں',
    },
    'a9sggm4d': {
      'en': 'Reflection',
      'es': 'Reflexión',
      'lg': 'Okufumiitiriza',
      'ur': 'غور و فکر',
    },
    'mxafye6w': {
      'en': 'Offline copy',
      'es': 'Copia sin conexión',
      'lg': 'Kopi etali ku mutimbagano',
      'ur': 'آف لائن کاپی',
    },
    'iqt2xhma': {
      'en': 'Reflection',
      'es': 'Reflexión',
      'lg': 'Okufumiitiriza',
      'ur': 'غور و فکر',
    },
    'tcuq774j': {
      'en': 'Write your reflection',
      'es': 'Escribe tu reflexión',
      'lg': 'Wandiika by\'ofumiitirizza',
      'ur': 'اپنا غور و فکر لکھیں',
    },
    'uf1bp2bt': {
      'en': 'Mark Complete',
      'es': 'Marcar como completada',
      'lg': 'Laga nti kiwedde',
      'ur': 'مکمل کا نشان لگائیں',
    },
  },
  // QuizPage
  {
    'ks7bydo5': {
      'en': 'Quiz',
      'es': 'Cuestionario',
      'lg': 'Ekibuuzo',
      'ur': 'کوئز',
    },
    'tswhxj7y': {
      'en': 'Passing score: 80%',
      'es': 'Puntaje para aprobar: 80%',
      'lg': 'Akabonero akayitibwako: 80%',
      'ur': 'پاس ہونے کا اسکور: 80٪',
    },
    'uxvknhqk': {
      'en': 'Loading…',
      'es': 'Cargando…',
      'lg': 'Kuleeta…',
      'ur': 'لوڈ ہو رہا ہے…',
    },
    'c92tx0i4': {
      'en': 'Question 1',
      'es': 'Pregunta 1',
      'lg': 'Ekibuuzo 1',
      'ur': 'سوال 1',
    },
    '7csm1ktb': {
      'en': 'Question 2',
      'es': 'Pregunta 2',
      'lg': 'Ekibuuzo 2',
      'ur': 'سوال 2',
    },
    's2bdowil': {
      'en': 'Question 3',
      'es': 'Pregunta 3',
      'lg': 'Ekibuuzo 3',
      'ur': 'سوال 3',
    },
    'jtgjh1jw': {
      'en': 'Question 4',
      'es': 'Pregunta 4',
      'lg': 'Ekibuuzo 4',
      'ur': 'سوال 4',
    },
    'b4c2c5bk': {
      'en': 'Question 5',
      'es': 'Pregunta 5',
      'lg': 'Ekibuuzo 5',
      'ur': 'سوال 5',
    },
    'jgvqcmxk': {
      'en': 'Question 6',
      'es': 'Pregunta 6',
      'lg': 'Ekibuuzo 6',
      'ur': 'سوال 6',
    },
    'dwigt2dd': {
      'en': 'Question 7',
      'es': 'Pregunta 7',
      'lg': 'Ekibuuzo 7',
      'ur': 'سوال 7',
    },
    'ybuoluf6': {
      'en': 'Question 8',
      'es': 'Pregunta 8',
      'lg': 'Ekibuuzo 8',
      'ur': 'سوال 8',
    },
    '65hn5om4': {
      'en': 'Question 9',
      'es': 'Pregunta 9',
      'lg': 'Ekibuuzo 9',
      'ur': 'سوال 9',
    },
    'tllr1ath': {
      'en': 'Question 10',
      'es': 'Pregunta 10',
      'lg': 'Ekibuuzo 10',
      'ur': 'سوال 10',
    },
    'eppz0h10': {
      'en': 'Submit Quiz',
      'es': 'Enviar cuestionario',
      'lg': 'Ssaayo Ekibuuzo',
      'ur': 'کوئز جمع کرائیں',
    },
    'zinew1h9': {
      'en': 'Quiz Complete',
      'es': 'Cuestionario completado',
      'lg': 'Ekibuuzo Kiwedde',
      'ur': 'کوئز مکمل',
    },
    '6vpg4uzd': {
      'en': 'Score:',
      'es': 'Puntaje:',
      'lg': 'Akabonero:',
      'ur': 'اسکور:',
    },
    'xkja33sq': {
      'en': '%',
      'es': '%',
      'lg': '%',
      'ur': '٪',
    },
    'wp0lyzsu': {
      'en': 'You passed!',
      'es': '¡Aprobaste!',
      'lg': 'Oyise!',
      'ur': 'آپ کامیاب ہو گئے!',
    },
    'pfck554s': {
      'en': 'You did not reach 80%. You can retake this quiz.',
      'es': 'No alcanzaste el 80%. Puedes repetir este cuestionario.',
      'lg': 'Tozzeeko ku 80%. Osobola okuddamu ekibuuzo kino.',
      'ur': 'آپ 80٪ تک نہیں پہنچے۔ آپ یہ کوئز دوبارہ لے سکتے ہیں۔',
    },
    '9u8uaqcz': {
      'en': 'Retake Quiz',
      'es': 'Repetir cuestionario',
      'lg': 'Ddamu Ekibuuzo',
      'ur': 'کوئز دوبارہ لیں',
    },
    '1pybxyhz': {
      'en': 'Back to Pathway',
      'es': 'Volver al camino',
      'lg': 'Ddayo ku Kkubo',
      'ur': 'راستے پر واپس جائیں',
    },
  },
  // RagSearchPage
  {
    'h52bomin': {
      'en': 'Ask Kingdom Heirs',
      'es': 'Pregunta a Kingdom Heirs',
      'lg': 'Buuza Kingdom Heirs',
      'ur': 'کنگڈم ہائرز سے پوچھیں',
    },
    'xqpai7gi': {
      'en': 'Answers use only approved Kingdom Heirs content, with citations.',
      'es':
          'Las respuestas usan solo contenido aprobado de Kingdom Heirs, con citas.',
      'lg':
          'Eby\'okuddamu bikozesa bya Kingdom Heirs ebikkirizibbwa byokka, n\'ebiragiro.',
      'ur': 'جوابات صرف منظور شدہ کنگڈم ہائرز مواد اور حوالہ جات پر مبنی ہیں۔',
    },
    'jnv7j14j': {
      'en': 'Ask about Scripture, pathways, or lessons…',
      'es': 'Pregunta sobre la Escritura, los caminos o las lecciones…',
      'lg': 'Buuza ku Byawandiikibwa, amakubo oba amasomo…',
      'ur': 'کلامِ مقدس، راستوں یا اسباق کے بارے میں پوچھیں…',
    },
    '8cqdqvpm': {
      'en': 'Search',
      'es': 'Buscar',
      'lg': 'Noonya',
      'ur': 'تلاش کریں',
    },
    'pa7q0vso': {
      'en': 'Answer',
      'es': 'Respuesta',
      'lg': 'Eky\'okuddamu',
      'ur': 'جواب',
    },
    '70neur48': {
      'en': 'Citations',
      'es': 'Citas',
      'lg': 'Ebiragiro',
      'ur': 'حوالہ جات',
    },
  },
  // OfflineBanner
  {
    'yuwzkfxq': {
      'en': 'You\'re offline. Some content may be out of date.',
      'es':
          'Estás sin conexión. Es posible que parte del contenido esté desactualizado.',
      'lg': 'You\'re offline. Some content may be out of date.',
      'ur': 'آپ آف لائن ہیں۔ کچھ مواد پرانا ہو سکتا ہے۔',
    },
  },
  // Miscellaneous
  {
    'q90g43vc': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    '4too3r4k': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'wm1tfpew': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'k9lzgt5i': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    '9gluya7y': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'rsrhjmdd': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'y7acp44c': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'v5lbki34': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'rh9ygi8d': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'a25r9tva': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'hcs9a5ht': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'w14802za': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    '4rgcu8f2': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'wysxacgi': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'wfeqw4rg': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'pdh51knd': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'lzvbf60x': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'l8xooheo': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    '0uho0g0i': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'qfwdfa71': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'k20igtlw': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'coslv4h3': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'tumwevty': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    '32qklt6r': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'lvf2m5us': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
    'mb17j7z7': {
      'en': '',
      'es': '',
      'lg': '',
      'ur': '',
    },
  },
].reduce((a, b) => a..addAll(b));
