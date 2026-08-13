import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/weight_entry.dart';
import '../bluetooth_scale/bluetooth_scale_screen.dart';
import '../profile/profile_providers.dart';
import 'activity_sync_providers.dart';
import 'activity_sync_state.dart';

class ActivitySyncScreen extends ConsumerWidget {
  const ActivitySyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activitySyncControllerProvider);
    final weightEntries = ref.watch(weightEntriesProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Activitate & sincronizare')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Health Connect / Apple Health',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Preia greutatea și activitatea fizică înregistrată de ceasul tău, prin platforma de sănătate a telefonului.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  _buildSyncBody(context, ref, state),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.bluetooth),
              title: const Text('Cântar Bluetooth'),
              subtitle: const Text('Conectează direct un cântar inteligent'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const BluetoothScaleScreen())),
            ),
          ),
          const SizedBox(height: 20),
          Text('Istoric greutate', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (weightEntries.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Nicio înregistrare încă.'),
            )
          else
            for (final entry in weightEntries.reversed.take(10))
              ListTile(
                dense: true,
                title: Text('${entry.weightKg.toStringAsFixed(1)} kg'),
                subtitle: Text('${entry.date.day}.${entry.date.month}.${entry.date.year}'),
                trailing: Text(_sourceLabel(entry.source)),
              ),
        ],
      ),
    );
  }

  Widget _buildSyncBody(BuildContext context, WidgetRef ref, ActivitySyncState state) {
    return switch (state) {
      ActivitySyncIdle() => FilledButton.icon(
        onPressed: () => ref.read(activitySyncControllerProvider.notifier).sync(),
        icon: const Icon(Icons.sync),
        label: const Text('Sincronizează'),
      ),
      ActivitySyncInProgress() => const Center(
        child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
      ),
      ActivitySyncSuccess(:final summary, :final newWeightKg) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatColumn(icon: Icons.directions_walk, value: '${summary.steps}', label: 'pași azi'),
              _StatColumn(
                icon: Icons.local_fire_department,
                value: summary.activeCaloriesBurned.round().toString(),
                label: 'kcal active',
              ),
            ],
          ),
          if (newWeightKg != null) ...[
            const SizedBox(height: 12),
            Text(
              'Greutate nouă preluată: ${newWeightKg.toStringAsFixed(1)} kg',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => ref.read(activitySyncControllerProvider.notifier).sync(),
            icon: const Icon(Icons.sync),
            label: const Text('Sincronizează din nou'),
          ),
        ],
      ),
      ActivitySyncFailed(:final message) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => ref.read(activitySyncControllerProvider.notifier).sync(),
            icon: const Icon(Icons.sync),
            label: const Text('Încearcă din nou'),
          ),
        ],
      ),
    };
  }

  String _sourceLabel(WeightSource source) {
    switch (source) {
      case WeightSource.manual:
        return 'manual';
      case WeightSource.healthConnect:
        return 'Health Connect';
      case WeightSource.appleHealth:
        return 'Apple Health';
      case WeightSource.bluetoothScale:
        return 'cântar BT';
    }
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
