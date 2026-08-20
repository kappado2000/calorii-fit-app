import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'app_version_providers.dart';

/// Wraps the whole app. `updateRequired` blocks with a full-screen notice
/// (below [minSupported] — the app may not even work correctly anymore, so
/// this can't be dismissed). `updateAvailable` is a one-time, dismissible
/// banner — never nags on every launch once dismissed for that version.
class AppVersionGate extends ConsumerStatefulWidget {
  const AppVersionGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppVersionGate> createState() => _AppVersionGateState();
}

class _AppVersionGateState extends ConsumerState<AppVersionGate> {
  bool _bannerDismissed = false;

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(versionStatusProvider);

    if (status == VersionStatus.updateRequired) {
      return _UpdateRequiredScreen(message: ref.watch(versionPolicyProvider).valueOrNull?.message);
    }

    return Stack(
      children: [
        widget.child,
        if (status == VersionStatus.updateAvailable && !_bannerDismissed)
          _UpdateAvailableBanner(
            message: ref.watch(versionPolicyProvider).valueOrNull?.message,
            onDismiss: () => setState(() => _bannerDismissed = true),
          ),
      ],
    );
  }
}

class _UpdateRequiredScreen extends StatelessWidget {
  const _UpdateRequiredScreen({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    // No nested MaterialApp — this renders inside MaterialApp.router's
    // own builder, so Theme/Directionality/Navigator are already
    // established; wrapping again here would create two competing
    // Navigators for no benefit.
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.system_update_rounded, size: 56),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context).updateRequiredTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message ?? AppLocalizations.of(context).updateRequiredMessage,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdateAvailableBanner extends StatelessWidget {
  const _UpdateAvailableBanner({this.message, required this.onDismiss});

  final String? message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Material(
          color: Theme.of(context).colorScheme.inverseSurface,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              children: [
                Icon(Icons.system_update_rounded, color: Theme.of(context).colorScheme.onInverseSurface),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message ?? AppLocalizations.of(context).updateAvailableMessage,
                    style: TextStyle(color: Theme.of(context).colorScheme.onInverseSurface),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.onInverseSurface),
                  onPressed: onDismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
