import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/remote/firestore/hydration_firestore_datasource.dart';
import '../../data/models/hydration_entry.dart';
import '../auth/uid_provider.dart';
import '../food_log/food_log_providers.dart';

const _uuid = Uuid();

/// No biometric-driven formula yet (unlike the calorie target) — a flat
/// daily target that matches the common "8 glasses" guidance most
/// competitor apps default to. Revisit if adaptive TDEE (Etapa 4) ever
/// grows a matching adaptive hydration target.
const double dailyHydrationTargetMl = 2000;

/// One tap adds this much — a standard glass.
const double hydrationGlassMl = 250;

class HydrationLogNotifier extends StateNotifier<List<HydrationEntry>> {
  HydrationLogNotifier(this._dataSource, this._date) : super([]) {
    _subscription = _dataSource.watchForDate(_date).listen((entries) => state = entries);
  }

  final HydrationFirestoreDataSource _dataSource;
  final DateTime _date;
  late final StreamSubscription<List<HydrationEntry>> _subscription;

  Future<void> addGlass() async {
    await _dataSource.add(HydrationEntry(id: _uuid.v4(), amountMl: hydrationGlassMl), _date);
  }

  /// Undoes the most recent tap — there's no per-entry list in the UI
  /// (just a running total with +/- buttons), so "remove" always means
  /// "undo the last add", not a pick-one-to-delete flow.
  Future<void> removeLastGlass() async {
    if (state.isEmpty) return;
    await _dataSource.delete(state.last.id);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final hydrationLogProvider =
    StateNotifierProvider.family<HydrationLogNotifier, List<HydrationEntry>, DateTime>((ref, date) {
      final uid = ref.watch(currentUidProvider);
      return HydrationLogNotifier(
        HydrationFirestoreDataSource(ref.watch(firestoreProvider), uid),
        normalizeDate(date),
      );
    });

final dailyHydrationTotalProvider = Provider.family<double, DateTime>((ref, date) {
  final entries = ref.watch(hydrationLogProvider(date));
  return entries.fold<double>(0, (sum, e) => sum + e.amountMl);
});
