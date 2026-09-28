// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;

const _citiesBase =
    'https://storage.googleapis.com/kingdom-heirs-discipleshipapp.firebasestorage.app/locations';

const _allCountries = <List<String>>[
  ['AF', 'Afghanistan'],
  ['AX', 'Aland Islands'],
  ['AL', 'Albania'],
  ['DZ', 'Algeria'],
  ['AS', 'American Samoa'],
  ['AD', 'Andorra'],
  ['AO', 'Angola'],
  ['AI', 'Anguilla'],
  ['AQ', 'Antarctica'],
  ['AG', 'Antigua And Barbuda'],
  ['AR', 'Argentina'],
  ['AM', 'Armenia'],
  ['AW', 'Aruba'],
  ['AU', 'Australia'],
  ['AT', 'Austria'],
  ['AZ', 'Azerbaijan'],
  ['BS', 'The Bahamas'],
  ['BH', 'Bahrain'],
  ['BD', 'Bangladesh'],
  ['BB', 'Barbados'],
  ['BY', 'Belarus'],
  ['BE', 'Belgium'],
  ['BZ', 'Belize'],
  ['BJ', 'Benin'],
  ['BM', 'Bermuda'],
  ['BT', 'Bhutan'],
  ['BO', 'Bolivia'],
  ['BA', 'Bosnia and Herzegovina'],
  ['BW', 'Botswana'],
  ['BV', 'Bouvet Island'],
  ['BR', 'Brazil'],
  ['IO', 'British Indian Ocean Territory'],
  ['BN', 'Brunei'],
  ['BG', 'Bulgaria'],
  ['BF', 'Burkina Faso'],
  ['BI', 'Burundi'],
  ['KH', 'Cambodia'],
  ['CM', 'Cameroon'],
  ['CA', 'Canada'],
  ['CV', 'Cape Verde'],
  ['KY', 'Cayman Islands'],
  ['CF', 'Central African Republic'],
  ['TD', 'Chad'],
  ['CL', 'Chile'],
  ['CN', 'China'],
  ['CX', 'Christmas Island'],
  ['CC', 'Cocos (Keeling) Islands'],
  ['CO', 'Colombia'],
  ['KM', 'Comoros'],
  ['CG', 'Congo'],
  ['CD', 'Democratic Republic of the Congo'],
  ['CK', 'Cook Islands'],
  ['CR', 'Costa Rica'],
  ['CI', 'Cote D\'Ivoire (Ivory Coast)'],
  ['HR', 'Croatia'],
  ['CU', 'Cuba'],
  ['CY', 'Cyprus'],
  ['CZ', 'Czech Republic'],
  ['DK', 'Denmark'],
  ['DJ', 'Djibouti'],
  ['DM', 'Dominica'],
  ['DO', 'Dominican Republic'],
  ['TL', 'East Timor'],
  ['EC', 'Ecuador'],
  ['EG', 'Egypt'],
  ['SV', 'El Salvador'],
  ['GQ', 'Equatorial Guinea'],
  ['ER', 'Eritrea'],
  ['EE', 'Estonia'],
  ['ET', 'Ethiopia'],
  ['FK', 'Falkland Islands'],
  ['FO', 'Faroe Islands'],
  ['FJ', 'Fiji Islands'],
  ['FI', 'Finland'],
  ['FR', 'France'],
  ['GF', 'French Guiana'],
  ['PF', 'French Polynesia'],
  ['TF', 'French Southern Territories'],
  ['GA', 'Gabon'],
  ['GM', 'The Gambia'],
  ['GE', 'Georgia'],
  ['DE', 'Germany'],
  ['GH', 'Ghana'],
  ['GI', 'Gibraltar'],
  ['GR', 'Greece'],
  ['GL', 'Greenland'],
  ['GD', 'Grenada'],
  ['GP', 'Guadeloupe'],
  ['GU', 'Guam'],
  ['GT', 'Guatemala'],
  ['GG', 'Guernsey and Alderney'],
  ['GN', 'Guinea'],
  ['GW', 'Guinea-Bissau'],
  ['GY', 'Guyana'],
  ['HT', 'Haiti'],
  ['HM', 'Heard Island and McDonald Islands'],
  ['HN', 'Honduras'],
  ['HK', 'Hong Kong S.A.R.'],
  ['HU', 'Hungary'],
  ['IS', 'Iceland'],
  ['IN', 'India'],
  ['ID', 'Indonesia'],
  ['IR', 'Iran'],
  ['IQ', 'Iraq'],
  ['IE', 'Ireland'],
  ['IL', 'Israel'],
  ['IT', 'Italy'],
  ['JM', 'Jamaica'],
  ['JP', 'Japan'],
  ['JE', 'Jersey'],
  ['JO', 'Jordan'],
  ['KZ', 'Kazakhstan'],
  ['KE', 'Kenya'],
  ['KI', 'Kiribati'],
  ['KP', 'North Korea'],
  ['KR', 'South Korea'],
  ['KW', 'Kuwait'],
  ['KG', 'Kyrgyzstan'],
  ['LA', 'Laos'],
  ['LV', 'Latvia'],
  ['LB', 'Lebanon'],
  ['LS', 'Lesotho'],
  ['LR', 'Liberia'],
  ['LY', 'Libya'],
  ['LI', 'Liechtenstein'],
  ['LT', 'Lithuania'],
  ['LU', 'Luxembourg'],
  ['MO', 'Macau S.A.R.'],
  ['MK', 'Macedonia'],
  ['MG', 'Madagascar'],
  ['MW', 'Malawi'],
  ['MY', 'Malaysia'],
  ['MV', 'Maldives'],
  ['ML', 'Mali'],
  ['MT', 'Malta'],
  ['IM', 'Man (Isle of)'],
  ['MH', 'Marshall Islands'],
  ['MQ', 'Martinique'],
  ['MR', 'Mauritania'],
  ['MU', 'Mauritius'],
  ['YT', 'Mayotte'],
  ['MX', 'Mexico'],
  ['FM', 'Micronesia'],
  ['MD', 'Moldova'],
  ['MC', 'Monaco'],
  ['MN', 'Mongolia'],
  ['ME', 'Montenegro'],
  ['MS', 'Montserrat'],
  ['MA', 'Morocco'],
  ['MZ', 'Mozambique'],
  ['MM', 'Myanmar'],
  ['NA', 'Namibia'],
  ['NR', 'Nauru'],
  ['NP', 'Nepal'],
  ['BQ', 'Bonaire, Sint Eustatius and Saba'],
  ['NL', 'Netherlands'],
  ['NC', 'New Caledonia'],
  ['NZ', 'New Zealand'],
  ['NI', 'Nicaragua'],
  ['NE', 'Niger'],
  ['NG', 'Nigeria'],
  ['NU', 'Niue'],
  ['NF', 'Norfolk Island'],
  ['MP', 'Northern Mariana Islands'],
  ['NO', 'Norway'],
  ['OM', 'Oman'],
  ['PK', 'Pakistan'],
  ['PW', 'Palau'],
  ['PS', 'Palestinian Territory Occupied'],
  ['PA', 'Panama'],
  ['PG', 'Papua new Guinea'],
  ['PY', 'Paraguay'],
  ['PE', 'Peru'],
  ['PH', 'Philippines'],
  ['PN', 'Pitcairn Island'],
  ['PL', 'Poland'],
  ['PT', 'Portugal'],
  ['PR', 'Puerto Rico'],
  ['QA', 'Qatar'],
  ['RE', 'Reunion'],
  ['RO', 'Romania'],
  ['RU', 'Russia'],
  ['RW', 'Rwanda'],
  ['SH', 'Saint Helena'],
  ['KN', 'Saint Kitts And Nevis'],
  ['LC', 'Saint Lucia'],
  ['PM', 'Saint Pierre and Miquelon'],
  ['VC', 'Saint Vincent And The Grenadines'],
  ['BL', 'Saint-Barthelemy'],
  ['MF', 'Saint-Martin (French part)'],
  ['WS', 'Samoa'],
  ['SM', 'San Marino'],
  ['ST', 'Sao Tome and Principe'],
  ['SA', 'Saudi Arabia'],
  ['SN', 'Senegal'],
  ['RS', 'Serbia'],
  ['SC', 'Seychelles'],
  ['SL', 'Sierra Leone'],
  ['SG', 'Singapore'],
  ['SK', 'Slovakia'],
  ['SI', 'Slovenia'],
  ['SB', 'Solomon Islands'],
  ['SO', 'Somalia'],
  ['ZA', 'South Africa'],
  ['GS', 'South Georgia'],
  ['SS', 'South Sudan'],
  ['ES', 'Spain'],
  ['LK', 'Sri Lanka'],
  ['SD', 'Sudan'],
  ['SR', 'Suriname'],
  ['SJ', 'Svalbard And Jan Mayen Islands'],
  ['SZ', 'Swaziland'],
  ['SE', 'Sweden'],
  ['CH', 'Switzerland'],
  ['SY', 'Syria'],
  ['TW', 'Taiwan'],
  ['TJ', 'Tajikistan'],
  ['TZ', 'Tanzania'],
  ['TH', 'Thailand'],
  ['TG', 'Togo'],
  ['TK', 'Tokelau'],
  ['TO', 'Tonga'],
  ['TT', 'Trinidad And Tobago'],
  ['TN', 'Tunisia'],
  ['TR', 'Turkey'],
  ['TM', 'Turkmenistan'],
  ['TC', 'Turks And Caicos Islands'],
  ['TV', 'Tuvalu'],
  ['UG', 'Uganda'],
  ['UA', 'Ukraine'],
  ['AE', 'United Arab Emirates'],
  ['GB', 'United Kingdom'],
  ['US', 'United States'],
  ['UM', 'United States Minor Outlying Islands'],
  ['UY', 'Uruguay'],
  ['UZ', 'Uzbekistan'],
  ['VU', 'Vanuatu'],
  ['VA', 'Vatican City State (Holy See)'],
  ['VE', 'Venezuela'],
  ['VN', 'Vietnam'],
  ['VG', 'Virgin Islands (British)'],
  ['VI', 'Virgin Islands (US)'],
  ['WF', 'Wallis And Futuna Islands'],
  ['EH', 'Western Sahara'],
  ['YE', 'Yemen'],
  ['ZM', 'Zambia'],
  ['ZW', 'Zimbabwe'],
  ['XK', 'Kosovo'],
  ['CW', 'Curaçao'],
  ['SX', 'Sint Maarten (Dutch part)'],
];

// label, cityLabel, search, pickCountry, pickCity, retry, countryFirst, use
const _pickerText = <String, List<String>>{
  'en': [
    'Country',
    'City (optional)',
    'Search',
    'Select your country',
    'Select your city',
    'Could not load the list. Tap to retry.',
    'Choose a country first',
    'Use'
  ],
  'es': [
    'País',
    'Ciudad (opcional)',
    'Buscar',
    'Selecciona tu país',
    'Selecciona tu ciudad',
    'No se pudo cargar la lista. Toca para reintentar.',
    'Primero elige un país',
    'Usar'
  ],
  'ur': [
    'ملک',
    'شہر (اختیاری)',
    'تلاش کریں',
    'اپنا ملک منتخب کریں',
    'اپنا شہر منتخب کریں',
    'فہرست لوڈ نہیں ہو سکی۔ دوبارہ کوشش کے لیے ٹیپ کریں۔',
    'پہلے ملک منتخب کریں',
    'استعمال کریں'
  ],
  'lg': [
    'Eggwanga',
    'Ekibuga (si kya buwaze)',
    'Noonya',
    'Londa eggwanga lyo',
    'Londa ekibuga kyo',
    'Olukalala terusobodde kuleetebwa. Kwata okuddamu.',
    'Sooka olonde eggwanga',
    'Kozesa'
  ],
};

class CountryCityPicker extends StatefulWidget {
  const CountryCityPicker({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<CountryCityPicker> createState() => _CountryCityPickerState();
}

class _CountryCityPickerState extends State<CountryCityPicker> {
  List<Map<String, String>> _countries = [];
  List<String> _cities = [];
  String _countryCode = '';
  bool _loadingCountries = true;
  bool _loadingCities = false;
  bool _countriesFailed = false;

  List<String> get _t {
    final code = FFLocalizations.of(context).languageCode;
    return _pickerText[code] ?? _pickerText['en']!;
  }

  @override
  void initState() {
    super.initState();
    // A fresh sign-up form starts empty.
    FFAppState().update(() {
      FFAppState().signupCountry = '';
      FFAppState().signupCity = '';
    });
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _countries =
          _allCountries.map((c) => {'code': c[0], 'name': c[1]}).toList();
      _loadingCountries = false;
      _countriesFailed = false;
    });
  }

  Future<void> _loadCities(String code) async {
    setState(() {
      _loadingCities = true;
      _cities = [];
    });
    try {
      final res = await http
          .get(Uri.parse('$_citiesBase/$code.json'))
          .timeout(const Duration(seconds: 20));
      final list =
          (jsonDecode(res.body)['cities'] as List).map((c) => '$c').toList();
      if (!mounted) return;
      setState(() {
        _cities = list;
        _loadingCities = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCities = false);
    }
  }

  Future<String?> _pick(String title, List<String> items,
      {bool allowCustom = false}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => _SearchSheet(
        title: title,
        items: items,
        searchHint: _t[2],
        useLabel: allowCustom ? _t[7] : null,
      ),
    );
  }

  Future<void> _chooseCountry() async {
    if (_countriesFailed) {
      await _loadCountries();
      return;
    }
    if (_loadingCountries) return;
    final name = await _pick(_t[3], _countries.map((c) => c['name']!).toList());
    if (name == null) return;
    final code = _countries.firstWhere((c) => c['name'] == name)['code']!;
    FFAppState().update(() {
      FFAppState().signupCountry = name;
      FFAppState().signupCity = '';
    });
    setState(() => _countryCode = code);
    await _loadCities(code);
  }

  Future<void> _chooseCity() async {
    if (_countryCode.isEmpty || _loadingCities) return;
    final name = await _pick(_t[4], _cities, allowCustom: true);
    if (name == null) return;
    FFAppState().update(() => FFAppState().signupCity = name);
    setState(() {});
  }

  Widget _field({
    required String label,
    required String value,
    required String placeholder,
    required VoidCallback onTap,
    bool loading = false,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        isEmpty: value.isEmpty,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x00000000)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x00000000)),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          suffixIcon: loading
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Icon(Icons.keyboard_arrow_down, color: theme.secondaryText),
        ),
        child: Text(value, style: theme.bodyMedium),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = _t;
    final country = FFAppState().signupCountry;
    final city = FFAppState().signupCity;
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _field(
            label: t[0],
            value: country,
            placeholder: _countriesFailed ? t[5] : t[3],
            loading: _loadingCountries,
            onTap: _chooseCountry,
          ),
          const SizedBox(height: 12),
          _field(
            label: t[1],
            value: city,
            placeholder: _countryCode.isEmpty ? t[6] : t[4],
            loading: _loadingCities,
            onTap: _chooseCity,
          ),
        ],
      ),
    );
  }
}

class _SearchSheet extends StatefulWidget {
  const _SearchSheet({
    required this.title,
    required this.items,
    required this.searchHint,
    this.useLabel,
  });

  final String title;
  final List<String> items;
  final String searchHint;
  final String? useLabel;

  @override
  State<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_SearchSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final q = _query.trim().toLowerCase();
    final matches = q.isEmpty
        ? widget.items
        : widget.items.where((i) => i.toLowerCase().contains(q)).toList();
    final showUse = widget.useLabel != null &&
        q.isNotEmpty &&
        !widget.items.any((i) => i.toLowerCase() == q);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Text(widget.title, style: theme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: matches.length + (showUse ? 1 : 0),
                itemBuilder: (context, i) {
                  if (showUse && i == matches.length) {
                    final typed = _query.trim();
                    return ListTile(
                      leading: const Icon(Icons.add),
                      title: Text('${widget.useLabel} “$typed”'),
                      onTap: () => Navigator.of(context).pop(typed),
                    );
                  }
                  final item = matches[i];
                  return ListTile(
                    title: Text(item, style: theme.bodyMedium),
                    onTap: () => Navigator.of(context).pop(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
