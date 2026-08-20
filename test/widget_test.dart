// Basic smoke test: verifies the auth/onboarding gate routes correctly —
// signed out -> login, signed in without a profile -> onboarding, signed
// in with a profile -> the food log home screen.

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/app.dart';
import 'package:calorie_app/data/models/user_profile.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';

void main() {
  testWidgets('CalorieApp shows the food log with all meal sections for a user with a saved profile', (
    WidgetTester tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('ro');
    tester.platformDispatcher.localesTestValue = const [Locale('ro')];
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    // Tall surface so every meal card (including the last, "Gustare") is
    // actually mounted by the ListView's sliver viewport rather than left
    // unbuilt below the default 600px test viewport.
    tester.view.physicalSize = const Size(1080, 3400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final mockUser = MockUser(uid: 'test-uid', email: 'test@example.com');
    final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
    final fakeFirestore = FakeFirebaseFirestore();
    final profile = UserProfile(
      heightCm: 170,
      weightKg: 70,
      age: 30,
      sex: Sex.female,
      activityLevel: ActivityLevel.moderate,
      goal: Goal.lose,
      targetRateKgPerWeek: 0.5,
      programStartDate: DateTime(2026, 1, 1),
    );
    await fakeFirestore.collection('users').doc('test-uid').set(profile.toJson());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          firestoreProvider.overrideWithValue(fakeFirestore),
        ],
        child: const CalorieApp(),
      ),
    );
    // Not pumpAndSettle: the workout card's lifting-icon badge repeats
    // forever (deliberately, it's a decorative loop), so it never
    // "settles" — a bounded pump sequence instead, enough for the
    // auth/profile streams and router redirect to resolve.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Dimineață'), findsOneWidget);
    expect(find.text('Prânz'), findsOneWidget);
    expect(find.text('Seară'), findsOneWidget);
    expect(find.text('Gustare'), findsOneWidget);
  });

  testWidgets('CalorieApp sends a signed-in user with no saved profile to onboarding', (
    WidgetTester tester,
  ) async {
    tester.platformDispatcher.localeTestValue = const Locale('ro');
    tester.platformDispatcher.localesTestValue = const [Locale('ro')];
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    final mockUser = MockUser(uid: 'test-uid', email: 'test@example.com');
    final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
    final fakeFirestore = FakeFirebaseFirestore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          firestoreProvider.overrideWithValue(fakeFirestore),
        ],
        child: const CalorieApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Câțiva ani și sexul biologic'), findsOneWidget);
  });

  testWidgets('CalorieApp shows the login screen when signed out', (WidgetTester tester) async {
    tester.platformDispatcher.localeTestValue = const Locale('ro');
    tester.platformDispatcher.localesTestValue = const [Locale('ro')];
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    final mockAuth = MockFirebaseAuth(signedIn: false);
    final fakeFirestore = FakeFirebaseFirestore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          firestoreProvider.overrideWithValue(fakeFirestore),
        ],
        child: const CalorieApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Autentificare'), findsOneWidget);
  });
}
