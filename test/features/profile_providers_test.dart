import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/data/models/user_profile.dart';
import 'package:calorie_app/domain/usecases/tdee_calculator.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';
import 'package:calorie_app/features/profile/profile_providers.dart';

ProviderContainer _buildContainer() {
  final mockUser = MockUser(uid: 'test-uid', email: 'test@example.com');
  final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
  final fakeFirestore = FakeFirebaseFirestore();

  final container = ProviderContainer(
    overrides: [
      firebaseAuthProvider.overrideWithValue(mockAuth),
      firestoreProvider.overrideWithValue(fakeFirestore),
    ],
  );
  container.listen(tdeeResultProvider, (_, _) {});
  return container;
}

UserProfile _profile({required double weightKg}) => UserProfile(
  heightCm: 165,
  weightKg: weightKg,
  age: 30,
  sex: Sex.female,
  activityLevel: ActivityLevel.sedentary,
  goal: Goal.maintain,
  targetRateKgPerWeek: 0,
  programStartDate: DateTime(2026, 1, 1),
);

void main() {
  test('with no weight entries, TDEE uses the profile\'s own weight', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    await container.read(profileControllerProvider).saveProfile(_profile(weightKg: 70));
    await pumpEventQueue();

    final result = container.read(tdeeResultProvider);
    final expected = const TdeeCalculator().calculate(_profile(weightKg: 70));
    expect(result!.bmr, closeTo(expected.bmr, 0.01));
  });

  test('the most recently logged weight overrides the profile weight in the TDEE formula', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    final controller = container.read(profileControllerProvider);
    await controller.saveProfile(_profile(weightKg: 70));
    await controller.logWeight(68, date: DateTime(2026, 3, 1));
    await controller.logWeight(65, date: DateTime(2026, 3, 10));
    await pumpEventQueue();

    final result = container.read(tdeeResultProvider);
    final expected = const TdeeCalculator().calculate(_profile(weightKg: 65));
    expect(result!.bmr, closeTo(expected.bmr, 0.01));
  });

  test('updateWeight changes both the value and date of an existing entry', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    final controller = container.read(profileControllerProvider);
    await controller.saveProfile(_profile(weightKg: 70));
    await controller.logWeight(68, date: DateTime(2026, 3, 1, 8, 0));
    await pumpEventQueue();

    final entryId = container.read(weightEntriesProvider).valueOrNull!.single.id;
    await controller.updateWeight(entryId, date: DateTime(2026, 3, 1, 9, 30), weightKg: 67.5);
    await pumpEventQueue();

    final updated = container.read(weightEntriesProvider).valueOrNull!.single;
    expect(updated.weightKg, 67.5);
    expect(updated.date, DateTime(2026, 3, 1, 9, 30));
  });

  test('deleteWeight removes exactly that entry and TDEE falls back to the next-latest', () async {
    final container = _buildContainer();
    addTearDown(container.dispose);
    final controller = container.read(profileControllerProvider);
    await controller.saveProfile(_profile(weightKg: 70));
    await controller.logWeight(68, date: DateTime(2026, 3, 1));
    await controller.logWeight(65, date: DateTime(2026, 3, 10));
    await pumpEventQueue();

    final entries = container.read(weightEntriesProvider).valueOrNull!;
    final latestId = entries.last.id;
    await controller.deleteWeight(latestId);
    await pumpEventQueue();

    expect(container.read(weightEntriesProvider).valueOrNull, hasLength(1));
    final result = container.read(tdeeResultProvider);
    final expected = const TdeeCalculator().calculate(_profile(weightKg: 68));
    expect(result!.bmr, closeTo(expected.bmr, 0.01));
  });
}
