import 'package:flutter/foundation.dart';

import '../../../constants/indicators_catalog.dart';
import '../models/indicator_value.dart';
import '../repositories/indicator_repository.dart';

class CountryIndicatorsViewModel extends ChangeNotifier {
  CountryIndicatorsViewModel({IndicatorRepository? repository})
    : _repository = repository ?? IndicatorRepository();

  final IndicatorRepository _repository;

  String _countryIso3 = 'KOR';
  bool _isLoading = false;
  String? _errorMessage;
  List<IndicatorValue> _values = const [];

  String get countryIso3 => _countryIso3;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<IndicatorValue> get values => _values;

  void setCountry(String iso3) {
    if (_countryIso3 == iso3) return;
    _countryIso3 = iso3;
    loadLatestValues();
  }

  Future<void> loadLatestValues() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<IndicatorValue> results = [];
      for (final entry in indicatorsCatalog.entries) {
        final v = await _repository.getLatestValue(
          countryIso3: _countryIso3,
          indicatorCode: entry.key,
        );
        if (v != null) results.add(v);
      }
      _values = results;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
