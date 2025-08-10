import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/oecd_countries.dart';
import '../viewmodels/country_indicators_view_model.dart';

class CountryIndicatorsScreen extends StatelessWidget {
  const CountryIndicatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CountryIndicatorsViewModel()..loadLatestValues(),
      child: Scaffold(
        appBar: AppBar(title: const Text('OECD Indicators (latest year)')),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CountryIndicatorsViewModel>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Text('Country:'),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: vm.countryIso3,
                  items: [
                    for (final c in oecdCountries)
                      DropdownMenuItem(
                        value: c['code'],
                        child: Text('${c['name']} (${c['code']})'),
                      ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      context.read<CountryIndicatorsViewModel>().setCountry(v);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              if (vm.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (vm.errorMessage != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Error: ${vm.errorMessage}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (vm.values.isEmpty) {
                return const Center(child: Text('No data'));
              }
              return ListView.separated(
                itemCount: vm.values.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final v = vm.values[index];
                  final valueText = v.value == null
                      ? 'N/A'
                      : v.value.toString();
                  return ListTile(
                    title: Text(v.indicatorName),
                    subtitle: Text('${v.countryName} • ${v.year}'),
                    trailing: Text(
                      valueText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
