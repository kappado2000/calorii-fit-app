import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/firestore/user_profile_firestore_datasource.dart';
import '../../data/datasources/remote/firestore/weight_entries_firestore_datasource.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/weight_entry.dart';
import '../../domain/usecases/tdee_calculator.dart';
import '../auth/uid_provider.dart';
import '../food_log/food_log_providers.dart';

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final uid = ref.watch(currentUidProvider);
  return UserProfileFirestoreDataSource(ref.watch(firestoreProvider), uid).watch();
});

/// Null while the profile hasn't loaded yet or doesn't exist — screens that
/// need it should gate on `userProfileProvider` directly for loading/error
/// states; this is a convenience for "do I have a computed target right now".
final tdeeResultProvider = Provider<TdeeResult?>((ref) {
  final profile = ref.watch(userProfileProvider).valueOrNull;
  if (profile == null) return null;
  return const TdeeCalculator().calculate(profile);
});

final weightEntriesProvider = StreamProvider<List<WeightEntry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  return WeightEntriesFirestoreDataSource(ref.watch(firestoreProvider), uid).watchAll();
});

class ProfileController {
  ProfileController(this._profileDataSource, this._weightDataSource);

  final UserProfileFirestoreDataSource _profileDataSource;
  final WeightEntriesFirestoreDataSource _weightDataSource;

  Future<void> saveProfile(UserProfile profile) => _profileDataSource.save(profile);

  Future<void> logWeight(double weightKg, {DateTime? date, WeightSource source = WeightSource.manual}) {
    return _weightDataSource.add(date ?? DateTime.now(), weightKg, source);
  }
}

final profileControllerProvider = Provider<ProfileController>((ref) {
  final uid = ref.watch(currentUidProvider);
  final firestore = ref.watch(firestoreProvider);
  return ProfileController(
    UserProfileFirestoreDataSource(firestore, uid),
    WeightEntriesFirestoreDataSource(firestore, uid),
  );
});
