import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/firestore/food_log_firestore_datasource.dart';
import '../../data/datasources/remote/firestore/user_profile_firestore_datasource.dart';
import '../../data/datasources/remote/firestore/weight_entries_firestore_datasource.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/weight_entry.dart';
import '../../domain/usecases/adaptive_tdee_calculator.dart';
import '../../domain/usecases/tdee_calculator.dart';
import '../auth/uid_provider.dart';
import '../food_log/food_log_providers.dart';

const _adaptiveTdeeWindowDays = 21;

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final uid = ref.watch(currentUidProvider);
  return UserProfileFirestoreDataSource(ref.watch(firestoreProvider), uid).watch();
});

/// The last [_adaptiveTdeeWindowDays] of daily intake totals — kept
/// separate from progress_providers.dart's period-based history since
/// this window (21 days) doesn't match either of that screen's periods.
final _adaptiveTdeeIntakeHistoryProvider = StreamProvider<Map<DateTime, double>>((ref) {
  final uid = ref.watch(currentUidProvider);
  final today = normalizeDate(DateTime.now());
  final start = today.subtract(const Duration(days: _adaptiveTdeeWindowDays - 1));
  return FoodLogFirestoreDataSource(ref.watch(firestoreProvider), uid).watchDailyTotalsForRange(start, today);
});

/// The raw adaptive estimate, independent of whether the user has opted
/// in (profile.useAdaptiveTdee) — computed whenever there's enough data,
/// so a "here's what we'd use" status card can show before the user
/// flips the toggle, not just after.
final adaptiveTdeeEstimateProvider = Provider<AdaptiveTdeeResult?>((ref) {
  final weightEntries = ref.watch(weightEntriesProvider).valueOrNull ?? const [];
  final intake = ref.watch(_adaptiveTdeeIntakeHistoryProvider).valueOrNull ?? const {};
  return const AdaptiveTdeeCalculator(
    windowDays: _adaptiveTdeeWindowDays,
  ).calculate(weightEntries: weightEntries, dailyIntake: intake, asOf: DateTime.now());
});

final weightEntriesProvider = StreamProvider<List<WeightEntry>>((ref) {
  final uid = ref.watch(currentUidProvider);
  return WeightEntriesFirestoreDataSource(ref.watch(firestoreProvider), uid).watchAll();
});

/// Null while the profile hasn't loaded yet or doesn't exist — screens that
/// need it should gate on `userProfileProvider` directly for loading/error
/// states; this is a convenience for "do I have a computed target right now".
///
/// BMR/TDEE is based on the most recently logged weight, not the static
/// weight captured once at onboarding — a diet moves body weight over
/// time, and the calorie budget should track that, not the day the
/// profile was created. Every earlier weight entry still feeds the
/// weight-trend chart/adaptive TDEE below; only the single latest one
/// substitutes into the formula here. Falls back to the onboarding
/// weight when no entries have been logged yet.
final tdeeResultProvider = Provider<TdeeResult?>((ref) {
  final profile = ref.watch(userProfileProvider).valueOrNull;
  if (profile == null) return null;
  final weightEntries = ref.watch(weightEntriesProvider).valueOrNull ?? const [];
  final effectiveProfile = weightEntries.isEmpty
      ? profile
      : profile.copyWithWeightKg(weightEntries.last.weightKg);

  const calculator = TdeeCalculator();
  final staticResult = calculator.calculate(effectiveProfile);
  if (!profile.useAdaptiveTdee) return staticResult;

  final adaptive = ref.watch(adaptiveTdeeEstimateProvider);
  if (adaptive == null) return staticResult;

  // Distrust an adaptive estimate too far from the population-average
  // formula — more likely sparse/noisy data than a genuinely unusual
  // metabolism, and a wildly different number would erode trust in the
  // feature rather than build it.
  final ratio = adaptive.estimatedTdee / staticResult.tdee;
  if (ratio < 0.6 || ratio > 1.4) return staticResult;

  return calculator.withTdeeOverride(adaptive.estimatedTdee, effectiveProfile);
});

class ProfileController {
  ProfileController(this._profileDataSource, this._weightDataSource);

  final UserProfileFirestoreDataSource _profileDataSource;
  final WeightEntriesFirestoreDataSource _weightDataSource;

  Future<void> saveProfile(UserProfile profile) => _profileDataSource.save(profile);

  Future<void> logWeight(double weightKg, {DateTime? date, WeightSource source = WeightSource.manual}) {
    return _weightDataSource.add(date ?? DateTime.now(), weightKg, source);
  }

  Future<void> updateWeight(String id, {required DateTime date, required double weightKg}) {
    return _weightDataSource.update(id, date: date, weightKg: weightKg);
  }

  Future<void> deleteWeight(String id) => _weightDataSource.delete(id);
}

final profileControllerProvider = Provider<ProfileController>((ref) {
  final uid = ref.watch(currentUidProvider);
  final firestore = ref.watch(firestoreProvider);
  return ProfileController(
    UserProfileFirestoreDataSource(firestore, uid),
    WeightEntriesFirestoreDataSource(firestore, uid),
  );
});
