import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/indicator.dart';
import '../models/indicator_value.dart';

class WorldBankApiService {
  static const String _baseUrl = 'https://api.worldbank.org/v2';

  Future<List<Indicator>> fetchIndicators({
    int perPage = 20,
    int page = 1,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/indicator?format=json&per_page=$perPage&page=$page',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load indicators: ${response.statusCode}');
    }

    final dynamic decoded = json.decode(utf8.decode(response.bodyBytes));
    if (decoded is List && decoded.length >= 2 && decoded[1] is List) {
      final List list = decoded[1] as List;
      return list
          .map((e) => Indicator.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // If format unexpected, return empty
    return const <Indicator>[];
  }

  // Fetch a single indicator latest value for a country. Returns the most recent non-null year up to now.
  Future<IndicatorValue?> fetchLatestIndicatorValue({
    required String countryIso3,
    required String indicatorCode,
  }) async {
    // MRV=1 returns most recent data (<= current year). Avoid date ranges that 400 on some series.
    final uri = Uri.parse(
      '$_baseUrl/country/$countryIso3/indicator/$indicatorCode?format=json&MRV=1',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load values: ${response.statusCode}');
    }
    final dynamic decoded = json.decode(utf8.decode(response.bodyBytes));
    if (decoded is List && decoded.length >= 2 && decoded[1] is List) {
      final List list = decoded[1] as List;
      for (final item in list) {
        final map = item as Map<String, dynamic>;
        if (map['value'] != null) {
          return IndicatorValue.fromSeriesJson(map);
        }
      }
    }
    return null;
  }
}
