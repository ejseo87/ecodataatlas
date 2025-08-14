import 'dart:convert';
import 'dart:io';

import 'package:ecodataatlas/api_services/api_worldbank/services/worldbank_api_service.dart';

// Fetch latest indicator values for a country across four sections and export as JSON
Future<void> main(List<String> args) async {
  // Country ISO3; default to KOR (Korea, Rep.)
  final String countryIso3 = args.isNotEmpty ? args.first.toUpperCase() : 'KOR';

  final worldBank = WorldBankApiService();

  // Section -> list of indicator code -> display name
  final Map<String, Map<String, String>> sections = {
    'social': {
      'SI.POV.DDAY':
          'Poverty headcount ratio at \$3.00 a day (2021 PPP) (% of population)',
      'SP.DYN.LE00.IN': 'Life expectancy at birth, total (years)',
      'SP.POP.GROW': 'Population growth (annual %)',
      'SP.POP.TOTL': 'Population, total',
      'EN.URB.MCTY.TL.ZS':
          'Population in urban agglomerations of more than 1 million (% of total population)',
      'EN.URB.LCTY.UR.ZS':
          'Population in the largest city (% of urban population)',
      'SM.POP.NETM': 'Net migration',
    },
    'economic': {
      'NY.GDP.MKTP.CD': 'GDP (current US\$)',
      'NY.GDP.PCAP.CD': 'GDP per capita (current US\$)',
      'NY.GDP.MKTP.KD.ZG': 'GDP growth (annual %)',
      'NE.TRD.GNFS.ZS': 'Trade (% of GDP)',
      'SL.UEM.TOTL.ZS': 'Unemployment, total (% of total labor force)',
      'FP.CPI.TOTL.ZG': 'Inflation, consumer prices (annual %)',
      'BX.TRF.PWKR.DT.GD.ZS': 'Personal remittances, received (% of GDP)',
    },
    'environment': {
      'AG.LND.FRST.ZS': 'Forest area (% of land area)',
      'EN.GHG.CO2.PC.CE.AR5':
          'Carbon dioxide (CO2) emissions excluding LULUCF per capita (t CO2e/capita)',
    },
    'institutions': {
      'CC.EST': 'Control of Corruption: Estimate',
      'GE.EST': 'Government Effectiveness: Estimate',
      'RL.EST': 'Rule of Law: Estimate',
      'RQ.EST': 'Regulatory Quality: Estimate',
      'PV.EST':
          'Political Stability and Absence of Violence/Terrorism: Estimate',
      'VA.EST': 'Voice and Accountability: Estimate',
    },
  };

  Future<Map<String, dynamic>> fetchForSection(
    String sectionName,
    Map<String, String> indicators,
  ) async {
    final List<Map<String, dynamic>> items = [];
    for (final entry in indicators.entries) {
      final code = entry.key;
      final label = entry.value;
      try {
        final value = await worldBank.fetchLatestIndicatorValue(
          countryIso3: countryIso3,
          indicatorCode: code,
        );
        items.add({
          'code': code,
          'name': label,
          'year': value?.year,
          'value': value?.value,
        });
      } catch (e) {
        items.add({'code': code, 'name': label, 'error': e.toString()});
      }
    }
    return {sectionName: items};
  }

  final Map<String, dynamic> payload = {
    'country': {'code': countryIso3},
    'source': 'World Bank Data API (WDI/WGI)',
  };

  // Fetch sequentially to keep it simple and avoid rate limits
  for (final sectionEntry in sections.entries) {
    final sectionData = await fetchForSection(
      sectionEntry.key,
      sectionEntry.value,
    );
    payload.addAll(sectionData);
  }

  final now = DateTime.now().toLocal();
  final yyyymmdd = _formatYyyyMmDd(now);

  // Ensure output directory exists
  final outputDir = Directory('assets/worldbank');
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }

  // Filename pattern: 'oecdCountires.code' + 'YYYYMMDD'.json (note: requested typo preserved)
  final fileName = 'oecdCountires.$countryIso3$yyyymmdd.json';
  final outputFile = File('${outputDir.path}/$fileName');

  await outputFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(payload),
  );
  // Print the path for convenience
  // ignore: avoid_print
  print('Saved: ${outputFile.path}');
}

String _formatYyyyMmDd(DateTime dt) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${dt.year}${two(dt.month)}${two(dt.day)}';
}
