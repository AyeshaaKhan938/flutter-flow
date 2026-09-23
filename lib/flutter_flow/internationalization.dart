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

  static List<String> languages() => ['en', 'ur', 'es'];

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
  }) =>
      [enText, urText, esText][languageIndex] ?? '';

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
      'ur': 'راستے',
    },
    '5rmrdz56': {
      'en': 'Pathways',
      'es': 'Senderos',
      'ur': 'راستے',
    },
    '184lycny': {
      'en': 'Discipleship journeys you can start today.',
      'es': 'Caminos de discipulado que puedes comenzar hoy mismo.',
      'ur': 'شاگردی کا سفر آپ آج سے شروع کر سکتے ہیں۔',
    },
  },
  // TodayPage
  {
    '3vonyhg4': {
      'en': 'Today',
      'es': 'Hoy',
      'ur': 'آج',
    },
    'pymmndk7': {
      'en': 'Ask Kingdom Heirs (RAG)',
      'es': '',
      'ur': '',
    },
    'yhb29ikd': {
      'en': 'Kingdom Heirs',
      'es': 'Herederos del reino',
      'ur': 'بادشاہی کے وارث',
    },
    '6yw0o7zm': {
      'en': 'Growing together. Living the mission.',
      'es': 'Creciendo juntos. Viviendo la misión.',
      'ur': 'ایک ساتھ بڑھنا۔ مشن کو جینا۔',
    },
    '9k0upj1o': {
      'en': 'Today\'s Scripture',
      'es': 'Escritura de hoy',
      'ur': 'آج کا کلام',
    },
    'zxk458lu': {
      'en': 'Encouragement',
      'es': 'Estímulo',
      'ur': 'حوصلہ افزائی',
    },
    'c3m7uoy7': {
      'en': 'Announcements',
      'es': 'Anuncios',
      'ur': 'اعلانات',
    },
  },
  // OnboardingSurveyPage
  {
    '7yk94zey': {
      'en': 'Welcome',
      'es': 'Bienvenido',
      'ur': 'خوش آمدید',
    },
    't2tw8glq': {
      'en': 'Choose your language',
      'es': '',
      'ur': '',
    },
    'xh51k31m': {
      'en':
          'English, Spanish, Urdu (RTL), and Luganda (content falls back to English where translations are missing).',
      'es': '',
      'ur': '',
    },
    'tcjox8sn': {
      'en': 'English',
      'es': '',
      'ur': '',
    },
    'ek8h59pw': {
      'en': 'Español',
      'es': '',
      'ur': '',
    },
    'opqncqj2': {
      'en': 'اردو',
      'es': '',
      'ur': '',
    },
    'qls181sb': {
      'en': 'Luganda',
      'es': '',
      'ur': '',
    },
    '4j67k168': {
      'en': 'How did you hear about Kingdom Heirs?',
      'es': '',
      'ur': '',
    },
    'wb8r0eh4': {
      'en': 'What are you hoping to grow in?',
      'es': '',
      'ur': '',
    },
    'h4l5v7tc': {
      'en': 'Continue',
      'es': '',
      'ur': '',
    },
  },
  // SignUpPage
  {
    'framilt1': {
      'en': 'Create Account',
      'es': 'Crear una cuenta',
      'ur': 'اکاؤنٹ بنائیں',
    },
    'a5147fnc': {
      'en': 'Create your account',
      'es': 'Crea tu cuenta',
      'ur': 'اپنا اکاؤنٹ بنائیں',
    },
    '4uemf7j5': {
      'en': 'Full name',
      'es': 'Nombre completo',
      'ur': 'پورا نام',
    },
    '3wnu1x92': {
      'en': 'Email',
      'es': 'Correo electrónico',
      'ur': 'ای میل',
    },
    'zt7pzvuw': {
      'en': 'Password',
      'es': 'Contraseña',
      'ur': 'پاس ورڈ',
    },
    'q2vm203a': {
      'en': 'Sign Up',
      'es': 'Inscribirse',
      'ur': 'سائن اپ کریں۔',
    },
  },
  // SignInPage
  {
    'j7g77u4j': {
      'en': 'Sign In',
      'es': 'Iniciar sesión',
      'ur': 'سائن ان کریں۔',
    },
    'q27e3qze': {
      'en': 'Kingdom Heirs',
      'es': 'Herederos del reino',
      'ur': 'بادشاہی کے وارث',
    },
    'xqlay70v': {
      'en': 'Sign in to continue your journey',
      'es': 'Inicia sesión para continuar tu viaje.',
      'ur': 'اپنا سفر جاری رکھنے کے لیے سائن ان کریں۔',
    },
    'uxww49cp': {
      'en': 'Age',
      'es': 'Correo electrónico',
      'ur': 'ای میل',
    },
    'dvhl6pis': {
      'en': 'Age',
      'es': '',
      'ur': '',
    },
    '3tyry75h': {
      'en': 'Phone Number',
      'es': 'Correo electrónico',
      'ur': 'ای میل',
    },
    'rd7m3pj1': {
      'en': 'Phone Number (Optional)',
      'es': '',
      'ur': '',
    },
    'ez1wpigw': {
      'en': 'City / Country',
      'es': 'Correo electrónico',
      'ur': 'ای میل',
    },
    'lngboaf7': {
      'en': 'City/Country',
      'es': '',
      'ur': '',
    },
    'xxhea5vj': {
      'en': 'Email',
      'es': 'Correo electrónico',
      'ur': 'ای میل',
    },
    'k6vtv918': {
      'en': 'Password',
      'es': 'Contraseña',
      'ur': 'پاس ورڈ',
    },
    'qigpwmgk': {
      'en': 'Sign In',
      'es': 'Iniciar sesión',
      'ur': 'سائن ان کریں۔',
    },
    'x3s67bww': {
      'en': 'Create an account',
      'es': 'Crear una cuenta',
      'ur': 'ایک اکاؤنٹ بنائیں',
    },
  },
  // AdminPathwaysPage
  {
    '8a6xbi8k': {
      'en': 'Manage Pathways',
      'es': 'Gestionar vías',
      'ur': 'راستوں کا نظم کریں۔',
    },
    'jz8jsiaf': {
      'en': 'Publish announcement',
      'es': '',
      'ur': '',
    },
    '4vci4sbx': {
      'en':
          'Saves to announcements and can send localized FCM using each member preferredLanguage.',
      'es': '',
      'ur': '',
    },
    '1ccn96wk': {
      'en': 'Title (EN)',
      'es': '',
      'ur': '',
    },
    '0lhahpo6': {
      'en': 'Title (ES draft)',
      'es': '',
      'ur': '',
    },
    'q3x9kohh': {
      'en': 'Title (UR draft)',
      'es': '',
      'ur': '',
    },
    'm1dy9t41': {
      'en': 'Body (EN)',
      'es': '',
      'ur': '',
    },
    'c5cr8hgv': {
      'en': 'Body (ES draft)',
      'es': '',
      'ur': '',
    },
    '0iub2yof': {
      'en': 'Body (UR draft)',
      'es': '',
      'ur': '',
    },
    'ntdrmux1': {
      'en': 'Publish + notify members',
      'es': '',
      'ur': '',
    },
    'kgp1nv6b': {
      'en': 'Save announcement only (no push)',
      'es': '',
      'ur': '',
    },
    'q6mq841w': {
      'en': 'Translation drafts',
      'es': '',
      'ur': '',
    },
    'fhohg5wy': {
      'en': 'Generate ES/UR pathway drafts',
      'es': '',
      'ur': '',
    },
    '4upku5le': {
      'en': 'Generate ES/UR lesson drafts',
      'es': '',
      'ur': '',
    },
    'wkid62i1': {
      'en': 'Assessment rules (live)',
      'es': '',
      'ur': '',
    },
    'l2bs79bt': {
      'en':
          'Edit score bands, overrides, and explanations. Changes apply to new submits immediately — no app release.',
      'es': '',
      'ur': '',
    },
    'uo92yaak': {
      'en': 'Load active config',
      'es': '',
      'ur': '',
    },
    'sqm4uwaa': {
      'en': 'Assessment version',
      'es': '',
      'ur': '',
    },
    'mxpyprz5': {
      'en': 'Score bands JSON',
      'es': '',
      'ur': '',
    },
    '53e751an': {
      'en': 'Overrides JSON',
      'es': '',
      'ur': '',
    },
    'abdgzy7s': {
      'en': 'Explanations JSON',
      'es': '',
      'ur': '',
    },
    '6zkmejjg': {
      'en': 'Point map JSON',
      'es': '',
      'ur': '',
    },
    't0p9hilp': {
      'en': 'Save & activate rules',
      'es': '',
      'ur': '',
    },
    'e3yc7ebr': {
      'en': 'Admin report',
      'es': '',
      'ur': '',
    },
    '8gr2edeb': {
      'en': 'Refresh report',
      'es': '',
      'ur': '',
    },
    'jlpv7k2u': {
      'en': 'Create content',
      'es': '',
      'ur': '',
    },
    '4yvy61cq': {
      'en': 'Create pathway (draft)',
      'es': '',
      'ur': '',
    },
    '31vjzirp': {
      'en': 'Title (English)',
      'es': '',
      'ur': '',
    },
    '0qer9c69': {
      'en': 'Stable ID (e.g. come-and-see)',
      'es': '',
      'ur': '',
    },
    'd1vd8i2k': {
      'en': 'Create Pathway',
      'es': '',
      'ur': '',
    },
    'flizzuzv': {
      'en': 'Create lesson (draft)',
      'es': '',
      'ur': '',
    },
    'u4297vic': {
      'en': 'Lesson title (English)',
      'es': '',
      'ur': '',
    },
    'zk0ekyyf': {
      'en': 'Stable ID (e.g. LESSON-COME-001)',
      'es': '',
      'ur': '',
    },
    '1ddemhqa': {
      'en': 'Parent pathway stableId',
      'es': '',
      'ur': '',
    },
    'dmvkrtrk': {
      'en': 'Scripture ref (e.g. John 3:16)',
      'es': '',
      'ur': '',
    },
    '81pcpgvs': {
      'en': 'Create Lesson',
      'es': '',
      'ur': '',
    },
    '6ku1r7wp': {
      'en': 'Edit content',
      'es': '',
      'ur': '',
    },
    'qy1uhfab': {
      'en': 'Edit pathway',
      'es': '',
      'ur': '',
    },
    '5xl35md5': {
      'en': 'Stable ID to update',
      'es': '',
      'ur': '',
    },
    'gipfyn9f': {
      'en': 'New title (English)',
      'es': '',
      'ur': '',
    },
    '4z54k5p9': {
      'en': 'Status: draft | in_review | published',
      'es': '',
      'ur': '',
    },
    'bd0eimw8': {
      'en': 'Update Pathway',
      'es': '',
      'ur': '',
    },
    'ounn6gex': {
      'en': 'Edit lesson',
      'es': '',
      'ur': '',
    },
    'x30beon5': {
      'en': 'Parent pathway stableId',
      'es': '',
      'ur': '',
    },
    'p389fojk': {
      'en': 'Lesson stableId',
      'es': '',
      'ur': '',
    },
    'pditiayw': {
      'en': 'New title',
      'es': '',
      'ur': '',
    },
    'fivaqvz7': {
      'en': 'Scripture ref',
      'es': '',
      'ur': '',
    },
    '7t9cmwn0': {
      'en': 'Reflection prompt',
      'es': '',
      'ur': '',
    },
    '3zabe2mp': {
      'en': 'Status: draft | in_review | published',
      'es': '',
      'ur': '',
    },
    'molltaja': {
      'en': 'Update Lesson',
      'es': '',
      'ur': '',
    },
    'd8682e0k': {
      'en': 'Pathways (all statuses)',
      'es': '',
      'ur': '',
    },
    'us7flsgc': {
      'en': 'Submit',
      'es': '',
      'ur': '',
    },
    'prem5u25': {
      'en': 'Publish',
      'es': '',
      'ur': '',
    },
    'kn1x55x3': {
      'en': 'Unpublish',
      'es': '',
      'ur': '',
    },
    '3jh28ea7': {
      'en': 'Delete',
      'es': '',
      'ur': '',
    },
    '5t7q6hnw': {
      'en': 'Daily Scripture (all statuses)',
      'es': '',
      'ur': '',
    },
    '41n51lru': {
      'en': 'Lessons (all statuses)',
      'es': '',
      'ur': '',
    },
    'w5di1mwb': {
      'en': 'Submit for Review',
      'es': '',
      'ur': '',
    },
    'gvlpz0hk': {
      'en': 'Approve & Publish',
      'es': '',
      'ur': '',
    },
    'mqk397iq': {
      'en': 'Back to Draft',
      'es': '',
      'ur': '',
    },
    'sjxbois2': {
      'en': 'Unpublish',
      'es': '',
      'ur': '',
    },
    'kwmzul5z': {
      'en': 'Quizzes (all statuses)',
      'es': '',
      'ur': '',
    },
    'ukc7prir': {
      'en': 'Submit for Review',
      'es': '',
      'ur': '',
    },
    'lt1h1tu5': {
      'en': 'Approve & Publish',
      'es': '',
      'ur': '',
    },
    '30p71cwk': {
      'en': 'Back to Draft',
      'es': '',
      'ur': '',
    },
    't58atw7n': {
      'en': 'Unpublish',
      'es': '',
      'ur': '',
    },
    'ix7r9qf2': {
      'en': 'Bulk Curriculum Importer',
      'es': '',
      'ur': '',
    },
    'uqss0gyk': {
      'en': 'Paste CSV with a header row. Target collection buttons below.',
      'es': '',
      'ur': '',
    },
    '51667gmm': {
      'en': 'pathways',
      'es': '',
      'ur': '',
    },
    'wvf9wapw': {
      'en': 'pathways',
      'es': '',
      'ur': '',
    },
    'vlzev2eo': {
      'en': 'lessons',
      'es': '',
      'ur': '',
    },
    '58lwjmah': {
      'en': 'lessons',
      'es': '',
      'ur': '',
    },
    'd3guiznk': {
      'en': 'dailyScripture',
      'es': '',
      'ur': '',
    },
    '3w9gf0wx': {
      'en': 'dailyScripture',
      'es': '',
      'ur': '',
    },
    '9no23ll9': {
      'en': 'encouragements',
      'es': '',
      'ur': '',
    },
    'nnddtd6k': {
      'en': 'encouragements',
      'es': '',
      'ur': '',
    },
    'af5wygnu': {
      'en': 'Target:',
      'es': '',
      'ur': '',
    },
    'iya56y70': {
      'en': 'CSV content (header row + data rows)',
      'es': '',
      'ur': '',
    },
    'gwqh9f43': {
      'en': 'Preview Import',
      'es': '',
      'ur': '',
    },
    'ghnr6u7d': {
      'en': 'Confirm Import',
      'es': '',
      'ur': '',
    },
    'knblstbn': {
      'en': 'Create:',
      'es': '',
      'ur': '',
    },
    'oqhoucg6': {
      'en': 'Update:',
      'es': '',
      'ur': '',
    },
    'i9y7yj5k': {
      'en': 'No change:',
      'es': '',
      'ur': '',
    },
    '5uhx0759': {
      'en': 'Errors:',
      'es': '',
      'ur': '',
    },
  },
  // ProfilePage
  {
    'j72mxzfg': {
      'en': 'Profile',
      'es': 'Perfil',
      'ur': 'پروفائل',
    },
    '76mcghq4': {
      'en': 'KH',
      'es': 'KH',
      'ur': 'کے ایچ',
    },
    '7vc4b05s': {
      'en': 'Manage Content (Admin)',
      'es': '',
      'ur': '',
    },
    '4hs8hcel': {
      'en': 'Visible only to admin and ministry reviewer roles',
      'es': '',
      'ur': '',
    },
    'yy8jszmc': {
      'en': 'Manage Content (Admin)',
      'es': 'Gestionar contenido (Administrador)',
      'ur': 'مواد کا نظم کریں (ایڈمن)',
    },
    '01vumem0': {
      'en': 'Visible only to admin and ministry reviewer roles',
      'es': '',
      'ur': '',
    },
    'fqju2unp': {
      'en': 'Sign Out',
      'es': 'Desconectar',
      'ur': 'سائن آؤٹ کریں۔',
    },
  },
  // HomePage
  {
    'w78798ta': {
      'en': 'Kingdom Heirs',
      'es': 'Herederos del reino',
      'ur': 'بادشاہی کے وارث',
    },
    '7ec1wh56': {
      'en': 'Welcome to Kingdom Heirs',
      'es': '',
      'ur': '',
    },
    '1vsevym5': {
      'en': 'Let\'s finish setting up your profile before you get started.',
      'es': '',
      'ur': '',
    },
    '6vh1zqtn': {
      'en': 'Complete Setup',
      'es': '',
      'ur': '',
    },
    'cwwrqyk9': {
      'en': 'Kingdom Heirs',
      'es': '',
      'ur': '',
    },
    'e2cz07tb': {
      'en': 'Growing together. Living the mission.',
      'es': '',
      'ur': '',
    },
    'hn2w2hzp': {
      'en': 'Today\'s Scripture',
      'es': '',
      'ur': '',
    },
    'f95iqp6h': {
      'en': 'Psalm 23:1',
      'es': '',
      'ur': '',
    },
    '81somjju': {
      'en': 'The Lord is my shepherd; I shall not want.',
      'es': '',
      'ur': '',
    },
    '8lwnidzn': {
      'en': 'Go to Today',
      'es': '',
      'ur': '',
    },
  },
  // RecommendationResultPage
  {
    'h20hmmdb': {
      'en': 'Recommendation',
      'es': 'Recomendación',
      'ur': 'سفارش',
    },
    'wjzhtvic': {
      'en': 'Your recommended starting pathway',
      'es': 'Su ruta de inicio recomendada',
      'ur': 'آپ کا تجویز کردہ ابتدائی راستہ',
    },
    'fgp4wla3': {
      'en': 'Additional resource',
      'es': '',
      'ur': '',
    },
    'scr433ev': {
      'en':
          'One of your answers indicates that focused support for freedom, renewed identity and accountability may also help you. The New Man is available as a private additional pathway alongside your primary recommendation.',
      'es': '',
      'ur': '',
    },
    '4rf7c0y8': {
      'en': 'Open The New Man',
      'es': '',
      'ur': '',
    },
    'vihsxgf9': {
      'en': 'Start Recommended Pathway',
      'es': '',
      'ur': '',
    },
    '8qk80eyh': {
      'en': 'Browse All Pathways',
      'es': '',
      'ur': '',
    },
    'prbzjx78': {
      'en': 'Retake Assessment',
      'es': '',
      'ur': '',
    },
  },
  // AssessmentQuestionsPage
  {
    'fpbwh2bz': {
      'en': 'Assessment',
      'es': 'Evaluación',
      'ur': 'تشخیص',
    },
    '7vtg9s4j': {
      'en':
          'Choose the answer that most honestly describes where you are today. There are no perfect answers, and your responses are private.',
      'es': '',
      'ur': '',
    },
    '4fcxos8p': {
      'en': 'Back',
      'es': '',
      'ur': '',
    },
    'zuc5p36d': {
      'en': 'Next',
      'es': '',
      'ur': '',
    },
    'n7b1yro2': {
      'en': 'See My Recommendation',
      'es': '',
      'ur': '',
    },
  },
  // AssessmentIntroPage
  {
    '1ki627fe': {
      'en': 'Recommendation Survey',
      'es': 'Encuesta de recomendaciones',
      'ur': 'سفارشی سروے',
    },
    'ipurt5ia': {
      'en': 'Get a recommended starting pathway',
      'es': 'Obtén una ruta de inicio recomendada',
      'ur': 'ایک تجویز کردہ ابتدائی راستہ حاصل کریں۔',
    },
    '8p4qe9ww': {
      'en':
          'This takes about 3–5 minutes. Your answers help recommend a starting pathway. Come & See is available in Phase 1.',
      'es':
          'Esto lleva entre 3 y 5 minutos. Tus respuestas ayudan a recomendar un plan de acción inicial. El programa \"Ven y descubre\" está disponible en la Fase 1.',
      'ur':
          'اس میں تقریباً 3-5 منٹ لگتے ہیں۔ آپ کے جوابات ایک ابتدائی راستے کی تجویز کرنے میں مدد کرتے ہیں۔ آؤ اور دیکھیں فیز 1 میں دستیاب ہے۔',
    },
    'tl3wz64i': {
      'en': 'Start',
      'es': 'Comenzar',
      'ur': 'شروع کریں۔',
    },
    'mqh1tihu': {
      'en': 'Maybe Later',
      'es': 'Quizás más tarde',
      'ur': 'شاید بعد میں',
    },
  },
  // NotificationPermissionPrimerPage
  {
    'p0yjpdhn': {
      'en': 'Notifications',
      'es': 'Notificaciones',
      'ur': 'اطلاعات',
    },
    'zgtmex2c': {
      'en': 'Stay encouraged',
      'es': '',
      'ur': '',
    },
    'cmqw7x55': {
      'en': 'Enable notifications for reminders and ministry announcements.',
      'es': '',
      'ur': '',
    },
    'tizfjqgx': {
      'en': 'Enable notifications',
      'es': '',
      'ur': '',
    },
    'i0ha3zd1': {
      'en': 'Not now',
      'es': '',
      'ur': '',
    },
  },
  // ProfileTimezonePage
  {
    'q2074qos': {
      'en': 'Profile',
      'es': 'Perfil',
      'ur': 'پروفائل',
    },
    'lo7rztsz': {
      'en': 'Set your profile and timezone',
      'es': 'Configura tu perfil y zona horaria.',
      'ur': 'اپنا پروفائل اور ٹائم زون سیٹ کریں۔',
    },
    'za004bbg': {
      'en': 'Display name',
      'es': 'Nombre para mostrar',
      'ur': 'ڈسپلے کا نام',
    },
    'yl4b4c3b': {
      'en': 'Country',
      'es': 'País',
      'ur': 'ملک',
    },
    '8w4eskar': {
      'en': 'Region / City (optional)',
      'es': 'Región/Ciudad (opcional)',
      'ur': 'علاقہ/شہر (اختیاری)',
    },
    'x7ww7xv9': {
      'en': 'Timezone (e.g. America/New_York)',
      'es': 'Zona horaria (por ejemplo, América/Nueva_York)',
      'ur': 'ٹائم زون (جیسے امریکہ/نیویارک)',
    },
    'rlcvmmgf': {
      'en': 'Save & Continue',
      'es': 'Guardar y continuar',
      'ur': 'محفوظ کریں اور جاری رکھیں',
    },
    '62y5jqc2': {
      'en': 'Back',
      'es': 'Atrás',
      'ur': 'پیچھے',
    },
  },
  // ResetPasswordPage
  {
    '3garuwah': {
      'en': 'Reset Password',
      'es': 'Restablecer contraseña',
      'ur': 'پاس ورڈ ری سیٹ کریں۔',
    },
    'dplz64jm': {
      'en': 'Request a password reset link',
      'es': 'Solicitar un enlace para restablecer la contraseña',
      'ur': 'پاس ورڈ دوبارہ ترتیب دینے کے لنک کی درخواست کریں۔',
    },
    '2ahh5sx9': {
      'en': 'Email',
      'es': 'Correo electrónico',
      'ur': 'ای میل',
    },
    'irolbfvq': {
      'en': 'Send Reset Link',
      'es': 'Enviar enlace de reinicio',
      'ur': 'ری سیٹ لنک بھیجیں۔',
    },
  },
  // PathwayOverviewPage
  {
    '628s6g31': {
      'en': 'Complete each lesson at your own pace.',
      'es': '',
      'ur': '',
    },
    'zquctcb5': {
      'en': 'Progress:',
      'es': '',
      'ur': '',
    },
    '10pobw15': {
      'en': 'of',
      'es': '',
      'ur': '',
    },
    '0lligapo': {
      'en': 'lessons complete',
      'es': '',
      'ur': '',
    },
    '8la73y6n': {
      'en': 'Quizzes',
      'es': '',
      'ur': '',
    },
    'tk5n04z3': {
      'en': 'Quiz 1 after Lesson 7 · Quiz 2 after Lesson 14 · 80% to pass',
      'es': '',
      'ur': '',
    },
    'cp7vkmln': {
      'en': 'Take Come & See Quiz 1',
      'es': '',
      'ur': '',
    },
    'm9uk4ao4': {
      'en': 'Take Come & See Quiz 2',
      'es': '',
      'ur': '',
    },
    'bnbr5hsc': {
      'en': 'Done',
      'es': '',
      'ur': '',
    },
  },
  // DailyLessonPage
  {
    '08fffnlc': {
      'en': 'Today\'s Lesson',
      'es': '',
      'ur': '',
    },
    'ulfcisps': {
      'en': 'Tap to open full passage',
      'es': '',
      'ur': '',
    },
    'a9sggm4d': {
      'en': 'Reflection',
      'es': '',
      'ur': '',
    },
    'mxafye6w': {
      'en': 'Offline copy',
      'es': '',
      'ur': '',
    },
    'iqt2xhma': {
      'en': 'Reflection',
      'es': '',
      'ur': '',
    },
    'tcuq774j': {
      'en': 'Write your reflection',
      'es': '',
      'ur': '',
    },
    'uf1bp2bt': {
      'en': 'Mark Complete',
      'es': '',
      'ur': '',
    },
  },
  // QuizPage
  {
    'ks7bydo5': {
      'en': 'Quiz',
      'es': '',
      'ur': '',
    },
    'tswhxj7y': {
      'en': 'Passing score: 80%',
      'es': '',
      'ur': '',
    },
    'c92tx0i4': {
      'en': 'Question 1',
      'es': '',
      'ur': '',
    },
    '7csm1ktb': {
      'en': 'Question 2',
      'es': '',
      'ur': '',
    },
    's2bdowil': {
      'en': 'Question 3',
      'es': '',
      'ur': '',
    },
    'jtgjh1jw': {
      'en': 'Question 4',
      'es': '',
      'ur': '',
    },
    'b4c2c5bk': {
      'en': 'Question 5',
      'es': '',
      'ur': '',
    },
    'jgvqcmxk': {
      'en': 'Question 6',
      'es': '',
      'ur': '',
    },
    'dwigt2dd': {
      'en': 'Question 7',
      'es': '',
      'ur': '',
    },
    'ybuoluf6': {
      'en': 'Question 8',
      'es': '',
      'ur': '',
    },
    '65hn5om4': {
      'en': 'Question 9',
      'es': '',
      'ur': '',
    },
    'tllr1ath': {
      'en': 'Question 10',
      'es': '',
      'ur': '',
    },
    'eppz0h10': {
      'en': 'Submit Quiz',
      'es': '',
      'ur': '',
    },
    'zinew1h9': {
      'en': 'Quiz Complete',
      'es': '',
      'ur': '',
    },
    '6vpg4uzd': {
      'en': 'Score:',
      'es': '',
      'ur': '',
    },
    'xkja33sq': {
      'en': '%',
      'es': '',
      'ur': '',
    },
    'wp0lyzsu': {
      'en': 'You passed!',
      'es': '',
      'ur': '',
    },
    'pfck554s': {
      'en': 'You did not reach 80%. You can retake this quiz.',
      'es': '',
      'ur': '',
    },
    '9u8uaqcz': {
      'en': 'Retake Quiz',
      'es': '',
      'ur': '',
    },
    '1pybxyhz': {
      'en': 'Back to Pathway',
      'es': '',
      'ur': '',
    },
  },
  // RagSearchPage
  {
    'h52bomin': {
      'en': 'Ask Kingdom Heirs',
      'es': '',
      'ur': '',
    },
    'xqpai7gi': {
      'en': 'Answers use only approved Kingdom Heirs content, with citations.',
      'es': '',
      'ur': '',
    },
    'jnv7j14j': {
      'en': 'Ask about Scripture, pathways, or lessons…',
      'es': '',
      'ur': '',
    },
    '8cqdqvpm': {
      'en': 'Search',
      'es': '',
      'ur': '',
    },
    'pa7q0vso': {
      'en': 'Answer',
      'es': '',
      'ur': '',
    },
    '70neur48': {
      'en': 'Citations',
      'es': '',
      'ur': '',
    },
  },
  // OfflineBanner
  {
    'yuwzkfxq': {
      'en': 'You\'re offline. Some content may be out of date.',
      'es':
          'Estás sin conexión. Es posible que parte del contenido esté desactualizado.',
      'ur': 'آپ آف لائن ہیں۔ کچھ مواد پرانا ہو سکتا ہے۔',
    },
  },
  // Miscellaneous
  {
    'q90g43vc': {
      'en': '',
      'es': '',
      'ur': '',
    },
    '4too3r4k': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'wm1tfpew': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'k9lzgt5i': {
      'en': '',
      'es': '',
      'ur': '',
    },
    '9gluya7y': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'rsrhjmdd': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'y7acp44c': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'v5lbki34': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'rh9ygi8d': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'a25r9tva': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'hcs9a5ht': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'w14802za': {
      'en': '',
      'es': '',
      'ur': '',
    },
    '4rgcu8f2': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'wysxacgi': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'wfeqw4rg': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'pdh51knd': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'lzvbf60x': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'l8xooheo': {
      'en': '',
      'es': '',
      'ur': '',
    },
    '0uho0g0i': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'qfwdfa71': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'k20igtlw': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'coslv4h3': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'tumwevty': {
      'en': '',
      'es': '',
      'ur': '',
    },
    '32qklt6r': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'lvf2m5us': {
      'en': '',
      'es': '',
      'ur': '',
    },
    'mb17j7z7': {
      'en': '',
      'es': '',
      'ur': '',
    },
  },
].reduce((a, b) => a..addAll(b));
