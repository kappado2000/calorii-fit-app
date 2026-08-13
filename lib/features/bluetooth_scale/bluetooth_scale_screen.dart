import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bluetooth_scale_providers.dart';

class BluetoothScaleScreen extends ConsumerWidget {
  const BluetoothScaleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bluetoothScaleControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cântar Bluetooth')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(context, ref, state),
      ),
      floatingActionButton: state is ScaleScanning
          ? null
          : FloatingActionButton.extended(
              onPressed: () => ref.read(bluetoothScaleControllerProvider.notifier).startScan(),
              icon: const Icon(Icons.bluetooth_searching),
              label: const Text('Caută cântare'),
            ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BluetoothScaleState state) {
    return switch (state) {
      ScaleScanIdle() => const Center(
        child: Text('Apasă "Caută cântare" și pornește-ți cântarul lângă telefon.'),
      ),
      ScaleScanning(:final devices) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LinearProgressIndicator(),
          const SizedBox(height: 12),
          const Text('Se caută...'),
          const SizedBox(height: 12),
          Expanded(
            child: devices.isEmpty
                ? const Center(child: Text('Niciun cântar găsit încă.'))
                : ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final result = devices[index];
                      final name = result.device.platformName.isNotEmpty
                          ? result.device.platformName
                          : result.device.remoteId.str;
                      return ListTile(
                        leading: const Icon(Icons.monitor_weight_outlined),
                        title: Text(name),
                        subtitle: Text('RSSI ${result.rssi}'),
                        onTap: () => ref
                            .read(bluetoothScaleControllerProvider.notifier)
                            .connectAndlisten(result.device),
                      );
                    },
                  ),
          ),
        ],
      ),
      ScaleConnecting() => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CircularProgressIndicator(), SizedBox(height: 12), Text('Se conectează...')],
        ),
      ),
      ScaleWeightReceived(:final weightKg) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 56),
            const SizedBox(height: 12),
            Text('${weightKg.toStringAsFixed(1)} kg', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            const Text('Greutate salvată.'),
          ],
        ),
      ),
      ScaleError(:final message) => Center(
        child: Text(
          'Eroare: $message',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ),
    };
  }
}
