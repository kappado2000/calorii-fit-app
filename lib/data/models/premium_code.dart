enum PremiumCodeStatus { pending, redeemed, revoked }

/// A code minted by the admin (see generatePremiumCode.ts), read-only from
/// the client — every write happens server-side. Only the admin account
/// can ever read these (see firestore.rules), which is what makes the
/// admin dashboard's code list possible.
class PremiumCode {
  const PremiumCode({
    required this.code,
    required this.targetEmail,
    required this.durationDays,
    required this.status,
    required this.createdAt,
    this.redeemedAt,
    this.redeemedByUid,
  });

  final String code;
  final String targetEmail;
  final int durationDays;
  final PremiumCodeStatus status;
  final DateTime createdAt;
  final DateTime? redeemedAt;
  final String? redeemedByUid;
}

PremiumCodeStatus premiumCodeStatusFromWire(String value) {
  return PremiumCodeStatus.values.firstWhere((s) => s.name == value, orElse: () => PremiumCodeStatus.pending);
}
