import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/premium_code.dart';

/// Admin-only view (see firestore.rules — reads are gated by the `admin`
/// custom claim) into the codes the admin has generated and the two
/// headline stats the dashboard needs. All writes to these documents
/// happen server-side, via generatePremiumCode.ts / redeemPremiumCode.ts.
class PremiumCodesFirestoreDataSource {
  PremiumCodesFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _codes => _firestore.collection('premiumCodes');
  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection('users');

  /// Every code ever generated, most recent first.
  Stream<List<PremiumCode>> watchCodes() {
    return _codes.orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return PremiumCode(
          code: data['code'] as String,
          targetEmail: data['targetEmail'] as String,
          durationDays: (data['durationDays'] as num).toInt(),
          status: premiumCodeStatusFromWire(data['status'] as String? ?? 'pending'),
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          redeemedAt: (data['redeemedAt'] as Timestamp?)?.toDate(),
          redeemedByUid: data['redeemedByUid'] as String?,
        );
      }).toList(growable: false),
    );
  }

  /// Total registered accounts — a plain server-side count, not a
  /// downloaded document list, so it stays cheap regardless of user count.
  Future<int> totalUserCount() async {
    final result = await _users.count().get();
    return result.count ?? 0;
  }

  /// Accounts with a currently-active premium grant (premiumUntil in the
  /// future) — same aggregate-count approach as [totalUserCount].
  Future<int> activePremiumUserCount() async {
    final result = await _users.where('premiumUntil', isGreaterThan: Timestamp.now()).count().get();
    return result.count ?? 0;
  }
}
