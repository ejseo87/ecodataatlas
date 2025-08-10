import '../models/indicator.dart';
import '../models/indicator_value.dart';
import '../services/worldbank_api_service.dart';

class IndicatorRepository {
  IndicatorRepository({WorldBankApiService? api})
    : _api = api ?? WorldBankApiService();

  final WorldBankApiService _api;

  Future<List<Indicator>> getIndicators({int perPage = 20}) async {
    return _api.fetchIndicators(perPage: perPage);
  }

  Future<IndicatorValue?> getLatestValue({
    required String countryIso3,
    required String indicatorCode,
  }) {
    return _api.fetchLatestIndicatorValue(
      countryIso3: countryIso3,
      indicatorCode: indicatorCode,
    );
  }
}
