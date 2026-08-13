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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Activitate & sincronizare')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(Icons.favorite_rounded, color: colorScheme.onPrimaryContainer),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Health Connect / Apple Health', style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: colorScheme.secondaryContainer, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(Icons.bluetooth_rounded, color: colorScheme.onSecondaryContainer),
              ),
              title: const Text('Cântar Bluetooth'),
              subtitle: const Text('Conectează direct un cântar inteligent'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const BluetoothScaleScreen())),
            ),
          ),
          const SizedBox(height: 20),
          Text('Istoric greutate', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (weightEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Nicio înregistrare încă.',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (final entry in weightEntries.reversed.take(10))
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.monitor_weight_outlined, color: colorScheme.primary, size: 20),
                      title: Text(
                        '${entry.weightKg.toStringAsFixed(1)} kg',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text('${entry.date.day}.${entry.date.month}.${entry.date.year}'),
                      trailing: Text(_sourceLabel(entry.source), style: Theme.of(context).textTheme.bodySmall),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSyncBody(BuildContext context, WidgetRef ref, ActivitySyncState state) {
    return switch (state) {
      ActivitySyncIdle() => FilledButton.icon(
        onPressed: () => ref.read(activitySyncControllerProvider.notifier).sync(),
        icon: const Icon(Icons.sync_rounded),
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
              _StatColumn(icon: Icons.directions_walk_rounded, value: '${summary.steps}', label: 'pași azi'),
              _StatColumn(
                icon: Icons.local_fire_department_rounded,
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
            icon: const Icon(Icons.sync_rounded),
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
            icon: const Icon(Icons.sync_rounded),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: colorScheme.primaryContainer, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Icon(icon, color: colorScheme.onPrimaryContainer),
        ),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
