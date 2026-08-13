import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/weight_entry.dart';
import '../../domain/usecases/weight_scale_ble_parser.dart';
import '../profile/profile_providers.dart';

/// Standard Bluetooth SIG Weight Scale Service / Weight Measurement
/// characteristic — see weight_scale_ble_parser.dart.
final weightScaleServiceUuid = Guid('0000181d-0000-1000-8000-00805f9b34fb');
final weightMeasurementCharUuid = Guid('00002a9d-0000-1000-8000-00805f9b34fb');

sealed class BluetoothScaleState {}

class ScaleScanIdle extends BluetoothScaleState {}

class ScaleScanning extends BluetoothScaleState {
  ScaleScanning(this.devices);
  final List<ScanResult> devices;
}

class ScaleConnecting extends BluetoothScaleState {}

class ScaleWeightReceived extends BluetoothScaleState {
  ScaleWeightReceived(this.weightKg);
  final double weightKg;
}

class ScaleError extends BluetoothScaleState {
  ScaleError(this.message);
  final String message;
}

class BluetoothScaleController extends StateNotifier<BluetoothScaleState> {
  BluetoothScaleController(this._ref) : super(ScaleScanIdle());

  final Ref _ref;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<List<int>>? _valueSubscription;

  Future<void> startScan() async {
    state = ScaleScanning(const []);
    try {
      _scanSubscription?.cancel();
      _scanSubscription = FlutterBluePlus.onScanResults.listen((results) {
        state = ScaleScanning(results);
      });
      await FlutterBluePlus.startScan(
        withServices: [weightScaleServiceUuid],
        timeout: const Duration(seconds: 15),
      );
    } catch (e) {
      state = ScaleError(e.toString());
    }
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    await _scanSubscription?.cancel();
  }

  Future<void> connectAndlisten(BluetoothDevice device) async {
    await stopScan();
    state = ScaleConnecting();
    try {
      // NOTE: flutter_blue_plus requires declaring a license type per its
      // own terms — `nonprofit` covers personal/nonprofit/educational use.
      // Revisit (paid `commercial` license) if this app is ever sold or
      // run as a for-profit product — see the package's LICENSE file.
      await device.connect(license: License.nonprofit, timeout: const Duration(seconds: 10));
      final services = await device.discoverServices();
      final service = services.firstWhere((s) => s.uuid == weightScaleServiceUuid);
      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid == weightMeasurementCharUuid,
      );

      await characteristic.setNotifyValue(true);
      _valueSubscription?.cancel();
      _valueSubscription = characteristic.onValueReceived.listen((bytes) async {
        final weightKg = parseWeightScaleMeasurementKg(bytes);
        if (weightKg == null) return;
        state = ScaleWeightReceived(weightKg);
        await _ref
            .read(profileControllerProvider)
            .logWeight(weightKg, source: WeightSource.bluetoothScale);
      });
    } catch (e) {
      state = ScaleError(e.toString());
    }
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _valueSubscription?.cancel();
    super.dispose();
  }
}

final bluetoothScaleControllerProvider =
    StateNotifierProvider.autoDispose<BluetoothScaleController, BluetoothScaleState>((ref) {
      return BluetoothScaleController(ref);
    });
