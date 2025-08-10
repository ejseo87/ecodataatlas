import 'package:flutter/foundation.dart';

import '../models/indicator.dart';
import '../repositories/indicator_repository.dart';

class IndicatorViewModel extends ChangeNotifier {
  IndicatorViewModel({IndicatorRepository? repository})
    : _repository = repository ?? IndicatorRepository();

  final IndicatorRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  List<Indicator> _indicators = const [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Indicator> get indicators => _indicators;

  Future<void> loadIndicators() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _repository.getIndicators(perPage: 25);
      _indicators = results;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
