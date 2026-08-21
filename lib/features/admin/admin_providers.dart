import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/firebase/firestore_provider.dart';
import '../../data/datasources/remote/cloud_functions/admin_api_client.dart';
import '../../data/datasources/remote/firestore/premium_codes_firestore_datasource.dart';
import '../../data/models/premium_code.dart';
import '../auth/auth_providers.dart';

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

  Future<void> activateAdmin(String password) async {
    final idToken = await _requireIdToken();
    await _apiClient.activateAdmin(password: password, idToken: idToken);
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
