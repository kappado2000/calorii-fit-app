import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/firebase/firestore_provider.dart';
import '../../data/datasources/remote/cloud_functions/admin_api_client.dart';
import '../../data/datasources/remote/firestore/premium_codes_firestore_datasource.dart';
import '../../data/models/premium_code.dart';
import '../auth/auth_providers.dart';
import '../auth/uid_provider.dart';

/// True once the signed-in account carries the `admin` custom claim (see
/// functions/src/activateAdmin.ts) — re-evaluated whenever the ID token
/// changes, which is exactly what fires right after AdminController
/// force-refreshes it post-activation.
final isAdminProvider = StreamProvider<bool>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.idTokenChanges().asyncMap((user) async {
    if (user == null) return false;
    final result = await user.getIdTokenResult();
    return result.claims?['admin'] == true;
  });
});

/// The signed-in user's own `premiumUntil` (see redeemPremiumCode.ts) —
/// null for an account with no active grant. Watches the doc directly
/// (not through UserProfile.fromJson, which gates on onboarding fields
/// existing) so premium status is visible even before onboarding.
final currentUserPremiumUntilProvider = StreamProvider<DateTime?>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final uid = ref.watch(currentUidProvider);
  return firestore.collection('users').doc(uid).snapshots().map((snapshot) {
    final timestamp = snapshot.data()?['premiumUntil'] as Timestamp?;
    return timestamp?.toDate();
  });
});

/// True for the admin account (unconditionally — see the "1 pentru admin"
/// decision) or an account with a currently-unexpired premium grant (see
/// the "3 pentru coduri" decision: premium does NOT get the admin's quota
/// bypass, only feature access like the bulk AI-completion button below).
final isPremiumActiveProvider = Provider<bool>((ref) {
  final isAdmin = ref.watch(isAdminProvider).valueOrNull ?? false;
  if (isAdmin) return true;
  final premiumUntil = ref.watch(currentUserPremiumUntilProvider).valueOrNull;
  return premiumUntil != null && premiumUntil.isAfter(DateTime.now());
});

/// Mirrors functions/src/premiumAccess.ts's isInTrial — a free account is
/// in trial for its first 14 days (from Firebase Auth's own account
/// creation time, read synchronously since it never changes for a signed-in
/// session). Purely advisory client-side (so the UI can show the AI
/// features as available instead of locked); the server independently
/// enforces the trial's cumulative AI-search cap and expiry, so an
/// optimistic client check here can never grant more than the server
/// actually allows.
final isInTrialProvider = Provider<bool>((ref) {
  final creationTime = ref.watch(firebaseAuthProvider).currentUser?.metadata.creationTime;
  if (creationTime == null) return false;
  return DateTime.now().difference(creationTime) < const Duration(days: 14);
});

/// Whether the AI-based nutrition-analysis features (search fallback,
/// per-entry/bulk macro completion) should be shown as available rather
/// than locked — true for premium/admin (unlimited-relative-to-free) or a
/// free account still inside its trial window (limited, cumulative cap
/// enforced server-side — see aiFoodLookup.ts).
final canUseAiFeaturesProvider = Provider<bool>((ref) {
  return ref.watch(isPremiumActiveProvider) || ref.watch(isInTrialProvider);
});

class PremiumStats {
  const PremiumStats({required this.totalUsers, required this.activePremiumUsers});

  final int totalUsers;
  final int activePremiumUsers;
}

/// Admin-only (see firestore.rules) — a plain server-side count, not a
/// downloaded document list, so it stays cheap regardless of user count.
final premiumStatsProvider = FutureProvider.autoDispose<PremiumStats>((ref) async {
  final dataSource = PremiumCodesFirestoreDataSource(ref.watch(firestoreProvider));
  final results = await Future.wait([dataSource.totalUserCount(), dataSource.activePremiumUserCount()]);
  return PremiumStats(totalUsers: results[0], activePremiumUsers: results[1]);
});

/// Every code the admin has ever generated, most recent first — the
/// visibility into "how many codes, for which accounts, for how long"
/// the admin needs.
final premiumCodesProvider = StreamProvider.autoDispose<List<PremiumCode>>((ref) {
  return PremiumCodesFirestoreDataSource(ref.watch(firestoreProvider)).watchCodes();
});

class AdminController {
  AdminController(this._apiClient, this._auth);

  final AdminApiClient _apiClient;
  final FirebaseAuth _auth;

  Future<void> activateAdmin(String password, String totpCode) async {
    final idToken = await _requireIdToken();
    await _apiClient.activateAdmin(password: password, totpCode: totpCode, idToken: idToken);
    // Custom claims only take effect once the client holds a fresh ID
    // token — without this forced refresh, isAdminProvider (and every
    // subsequent Cloud Function call's request.auth.token.admin check)
    // would keep seeing the pre-activation token for up to ~1h.
    await _auth.currentUser?.getIdToken(true);
  }

  Future<String> generatePremiumCode({required String targetEmail, required int durationDays}) async {
    final idToken = await _requireIdToken();
    return _apiClient.generatePremiumCode(targetEmail: targetEmail, durationDays: durationDays, idToken: idToken);
  }

  Future<DateTime> redeemPremiumCode(String code) async {
    final idToken = await _requireIdToken();
    final iso = await _apiClient.redeemPremiumCode(code: code, idToken: idToken);
    return DateTime.parse(iso);
  }

  Future<String> _requireIdToken() async {
    final token = await _auth.currentUser?.getIdToken();
    if (token == null) throw AdminApiException('Trebuie să fii autentificat.');
    return token;
  }
}

final adminControllerProvider = Provider<AdminController>((ref) {
  return AdminController(ref.watch(adminApiClientProvider), ref.watch(firebaseAuthProvider));
});
