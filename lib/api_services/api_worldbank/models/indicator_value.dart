class IndicatorValue {
  final String indicatorCode;
  final String indicatorName;
  final String countryCode;
  final String countryName;
  final int year;
  final num? value;

  const IndicatorValue({
    required this.indicatorCode,
    required this.indicatorName,
    required this.countryCode,
    required this.countryName,
    required this.year,
    required this.value,
  });

  factory IndicatorValue.fromSeriesJson(Map<String, dynamic> json) {
    return IndicatorValue(
      indicatorCode: (json['indicator']?['id'] ?? '').toString(),
      indicatorName: (json['indicator']?['value'] ?? '').toString(),
      countryCode: (json['countryiso3code'] ?? '').toString(),
      countryName: (json['country'] ?? '').toString(),
      year: int.tryParse((json['date'] ?? '').toString()) ?? 0,
      value: json['value'] as num?,
    );
  }
}
