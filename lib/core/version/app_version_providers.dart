import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../firebase/firestore_provider.dart';
import 'semantic_version.dart';

/// The version the app was actually built with (pubspec.yaml's `version:`
/// field, read at runtime from the platform).
final installedVersionProvider = FutureProvider<SemanticVersion>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return SemanticVersion.tryParse(info.version) ?? const SemanticVersion(0, 0, 0);
});

/// Remote version policy — a single small doc at `appConfig/version`,
/// written manually in the Firebase console (or by a future release
/// script) each time a build ships. Missing entirely (new project, doc
/// not created yet) is treated as "no gate" rather than an error, since
/// there's nothing to compare against.
class VersionPolicy {
  const VersionPolicy({required this.latest, required this.minSupported, this.message});

  final SemanticVersion latest;
  final SemanticVersion minSupported;

  /// Optional human-readable note about what changed — shown in the
  /// update prompt when set.
  final String? message;
}

final versionPolicyProvider = StreamProvider<VersionPolicy?>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('appConfig').doc('version').snapshots().map((snap) {
    final data = snap.data();
    if (data == null) return null;
    final latest = SemanticVersion.tryParse(data['latest'] as String? ?? '');
    final minSupported = SemanticVersion.tryParse(data['minSupported'] as String? ?? '');
    if (latest == null || minSupported == null) return null;
    return VersionPolicy(latest: latest, minSupported: minSupported, message: data['message'] as String?);
  });
});

enum VersionStatus { upToDate, updateAvailable, updateRequired }

/// Combines the installed version with the remote policy into a single
/// status — the actual decision the UI acts on. Stays `upToDate` while
/// either half hasn't resolved yet, so the app never blocks on a slow
/// network read at startup.
final versionStatusProvider = Provider<VersionStatus>((ref) {
  final installed = ref.watch(installedVersionProvider).valueOrNull;
  final policy = ref.watch(versionPolicyProvider).valueOrNull;
  if (installed == null || policy == null) return VersionStatus.upToDate;

  if (installed < policy.minSupported) return VersionStatus.updateRequired;
  if (installed < policy.latest) return VersionStatus.updateAvailable;
  return VersionStatus.upToDate;
});
