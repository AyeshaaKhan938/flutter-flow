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

const _locationsEndpoint =
    'https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/getLocations';

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
      _loadingCountries = true;
      _countriesFailed = false;
    });
    try {
      final res = await http
          .post(Uri.parse(_locationsEndpoint),
              headers: {'Content-Type': 'application/json'}, body: '{}')
          .timeout(const Duration(seconds: 20));
      final list = (jsonDecode(res.body)['countries'] as List)
          .map((c) => {'code': '${c['code']}', 'name': '${c['name']}'})
          .toList();
      if (!mounted) return;
      setState(() {
        _countries = list;
        _loadingCountries = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingCountries = false;
        _countriesFailed = true;
      });
    }
  }

  Future<void> _loadCities(String code) async {
    setState(() {
      _loadingCities = true;
      _cities = [];
    });
    try {
      final res = await http
          .post(Uri.parse(_locationsEndpoint),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'country': code}))
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
