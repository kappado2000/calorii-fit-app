import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/weight_entry.dart';
import '../../l10n/app_localizations.dart';
import '../bluetooth_scale/bluetooth_scale_screen.dart';
import '../profile/profile_providers.dart';
import 'activity_sync_providers.dart';
import 'activity_sync_state.dart';
import 'weight_entry_dialog.dart';

class ActivitySyncScreen extends ConsumerWidget {
  const ActivitySyncScreen({super.key});

  static const _borderColor = Color(0xFF2FA84F);
  static const _cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    side: BorderSide(color: _borderColor, width: 1),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activitySyncControllerProvider);
    final weightEntries = ref.watch(weightEntriesProvider).valueOrNull ?? [];
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.activityAndSync)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: _cardShape,
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
                        child: Text(l10n.healthConnectTitle, style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.healthConnectDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  _buildSyncBody(context, ref, state, l10n),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: _cardShape,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: colorScheme.secondaryContainer, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(Icons.bluetooth_rounded, color: colorScheme.onSecondaryContainer),
              ),
              title: Text(l10n.bluetoothScaleTitle),
              subtitle: Text(l10n.bluetoothScaleSubtitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const BluetoothScaleScreen())),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.weightHistoryTitle, style: Theme.of(context).textTheme.titleMedium),
              TextButton.icon(
                onPressed: () => WeightEntryDialog.show(context),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.addLabel),
              ),
            ],
          ),
          if (weightEntries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                l10n.noEntriesYet,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            )
          else
            Card(
              shape: _cardShape,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (final entry in weightEntries.reversed.take(10))
                    Dismissible(
                      key: ValueKey(entry.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: colorScheme.errorContainer,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete_outline_rounded, color: colorScheme.onErrorContainer),
                      ),
                      onDismissed: (_) => ref.read(profileControllerProvider).deleteWeight(entry.id),
                      child: ListTile(
                        dense: true,
                        leading: Icon(Icons.monitor_weight_outlined, color: colorScheme.primary, size: 20),
                        title: Text(
                          '${entry.weightKg.toStringAsFixed(1)} kg',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(_formatDateTime(entry.date)),
                        trailing: Text(_sourceLabel(l10n, entry.source), style: Theme.of(context).textTheme.bodySmall),
                        onTap: entry.source == WeightSource.manual
                            ? () => WeightEntryDialog.show(context, existing: entry)
                            : null,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d.$m.${dt.year}, $h:$min';
  }

  Widget _buildSyncBody(BuildContext context, WidgetRef ref, ActivitySyncState state, AppLocalizations l10n) {
    return switch (state) {
      ActivitySyncIdle() => FilledButton.icon(
        onPressed: () => ref.read(activitySyncControllerProvider.notifier).sync(),
        icon: const Icon(Icons.sync_rounded),
        label: Text(l10n.syncButton),
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
              _StatColumn(icon: Icons.directions_walk_rounded, value: '${summary.steps}', label: l10n.stepsToday),
              _StatColumn(
                icon: Icons.local_fire_department_rounded,
                value: summary.activeCaloriesBurned.round().toString(),
                label: l10n.activeKcal,
              ),
            ],
          ),
          if (newWeightKg != null) ...[
            const SizedBox(height: 12),
            Text(
              l10n.newWeightFetched(newWeightKg.toStringAsFixed(1)),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => ref.read(activitySyncControllerProvider.notifier).sync(),
            icon: const Icon(Icons.sync_rounded),
            label: Text(l10n.syncAgain),
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
            label: Text(l10n.retry),
          ),
        ],
      ),
    };
  }

  String _sourceLabel(AppLocalizations l10n, WeightSource source) {
    switch (source) {
      case WeightSource.manual:
        return l10n.weightSourceManual;
      case WeightSource.healthConnect:
        return l10n.weightSourceHealthConnect;
      case WeightSource.appleHealth:
        return l10n.weightSourceAppleHealth;
      case WeightSource.bluetoothScale:
        return l10n.weightSourceBluetoothScale;
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
