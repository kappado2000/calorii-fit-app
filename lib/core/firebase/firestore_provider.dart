import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Overridable in tests (e.g. with FakeFirebaseFirestore) rather than
/// reaching for FirebaseFirestore.instance directly in feature providers.
/// Lives here (not in food_log_providers.dart, its original home) so both
/// food_log and auth features can depend on it without an import cycle.
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
