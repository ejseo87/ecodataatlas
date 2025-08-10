import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/indicator_view_model.dart';

class IndicatorScreen extends StatelessWidget {
  const IndicatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('World Bank Indicators')),
      body: Consumer<IndicatorViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${vm.errorMessage}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (vm.indicators.isEmpty) {
            return const Center(child: Text('No indicators found'));
          }
          return RefreshIndicator(
            onRefresh: () =>
                context.read<IndicatorViewModel>().loadIndicators(),
            child: ListView.separated(
              itemCount: vm.indicators.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final indicator = vm.indicators[index];
                return ListTile(
                  title: Text(indicator.name),
                  subtitle: Text(indicator.id),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<IndicatorViewModel>().loadIndicators(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
