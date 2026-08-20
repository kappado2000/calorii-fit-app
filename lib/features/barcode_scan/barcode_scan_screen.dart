import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../data/models/food_product.dart';
import '../../l10n/app_localizations.dart';
import '../food_log/food_log_providers.dart';

/// Scans a product barcode and resolves it via the `lookupBarcode` Cloud
/// Function. Pops with the resolved [FoodProduct] on success, or with
/// nothing if the user backs out — the caller (AddFoodEntrySheet) treats a
/// null pop as "no product selected" and simply stays on the search sheet.
class BarcodeScanScreen extends ConsumerStatefulWidget {
  const BarcodeScanScreen({super.key});

  static Future<FoodProduct?> show(BuildContext context) {
    return Navigator.of(context).push<FoodProduct?>(
      MaterialPageRoute(builder: (_) => const BarcodeScanScreen()),
    );
  }

  @override
  ConsumerState<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

enum _LookupStatus { scanning, loading, notFound }

class _BarcodeScanScreenState extends ConsumerState<BarcodeScanScreen> {
  final _controller = MobileScannerController(formats: const [BarcodeFormat.ean13, BarcodeFormat.ean8]);
  _LookupStatus _status = _LookupStatus.scanning;
  String? _lastNotFoundBarcode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_status != _LookupStatus.scanning) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() => _status = _LookupStatus.loading);
    try {
      final product = await ref.read(lookupBarcodeApiClientProvider).lookup(code);
      if (!mounted) return;
      if (product != null) {
        Navigator.of(context).pop(product);
        return;
      }
      setState(() {
        _status = _LookupStatus.notFound;
        _lastNotFoundBarcode = code;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _status = _LookupStatus.notFound;
        _lastNotFoundBarcode = code;
      });
    }
  }

  void _resumeScanning() {
    setState(() {
      _status = _LookupStatus.scanning;
      _lastNotFoundBarcode = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context).barcodeScanTitle),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).barcodeToggleTorch,
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                return Icon(state.torchState == TorchState.on ? Icons.flash_on : Icons.flash_off);
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          const _ScanFrameOverlay(),
          if (_status == _LookupStatus.loading)
            const ColoredBox(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_status == _LookupStatus.notFound) _NotFoundPanel(onRetry: _resumeScanning, barcode: _lastNotFoundBarcode),
        ],
      ),
    );
  }
}

class _ScanFrameOverlay extends StatelessWidget {
  const _ScanFrameOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          width: 260,
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _NotFoundPanel extends StatelessWidget {
  const _NotFoundPanel({required this.onRetry, required this.barcode});

  final VoidCallback onRetry;
  final String? barcode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 36),
            const SizedBox(height: 8),
            Text(
              l10n.barcodeNotFound(barcode ?? ''),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.addManually),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(onPressed: onRetry, child: Text(l10n.scanAgain)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
