import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'bluetooth_scale_providers.dart';

class BluetoothScaleScreen extends ConsumerWidget {
  const BluetoothScaleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bluetoothScaleControllerProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bluetoothScaleTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(context, ref, state),
      ),
      floatingActionButton: state is ScaleScanning
          ? null
          : FloatingActionButton.extended(
              onPressed: () => ref.read(bluetoothScaleControllerProvider.notifier).startScan(),
              icon: const Icon(Icons.bluetooth_searching_rounded),
              label: Text(l10n.bluetoothScaleSearch),
            ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BluetoothScaleState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return switch (state) {
      ScaleScanIdle() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(color: colorScheme.primaryContainer, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(Icons.bluetooth_rounded, size: 40, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.bluetoothScaleIdleHint,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      ScaleScanning(:final devices) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LinearProgressIndicator(),
          const SizedBox(height: 12),
          Text(l10n.bluetoothScaleSearching),
          const SizedBox(height: 12),
          Expanded(
            child: devices.isEmpty
                ? Center(child: Text(l10n.bluetoothScaleNoneFound))
                : ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final result = devices[index];
                      final name = result.device.platformName.isNotEmpty
                          ? result.device.platformName
                          : result.device.remoteId.str;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(Icons.monitor_weight_outlined, color: colorScheme.primary),
                          title: Text(name),
                          subtitle: Text('RSSI ${result.rssi}'),
                          onTap: () => ref
                              .read(bluetoothScaleControllerProvider.notifier)
                              .connectAndlisten(result.device),
                        ),
                      ).animate().fadeIn(duration: 250.ms);
                    },
                  ),
          ),
        ],
      ),
      ScaleConnecting() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [const CircularProgressIndicator(), const SizedBox(height: 12), Text(l10n.bluetoothScaleConnecting)],
        ),
      ),
      ScaleWeightReceived(:final weightKg) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 64)
                .animate()
                .scale(duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 12),
            Text(
              '${weightKg.toStringAsFixed(1)} kg',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(l10n.bluetoothScaleWeightSaved, style: TextStyle(color: colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
      ScaleError(:final message) => Center(
        child: Text(
          l10n.errorPrefixed(message),
          style: TextStyle(color: colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ),
    };
  }
}
