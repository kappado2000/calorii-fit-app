// Basic smoke test: verifies a signed-in user sees the food log (home
// screen as of Phase 1) with its three meal sections, without throwing.

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/app.dart';
import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/food_log/food_log_providers.dart';

void main() {
  testWidgets('CalorieApp shows the food log with all three meal sections when signed in', (
    WidgetTester tester,
  ) async {
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

    expect(find.text('Dimineață'), findsOneWidget);
    expect(find.text('Prânz'), findsOneWidget);
    expect(find.text('Seară'), findsOneWidget);
    expect(find.text('Total azi'), findsOneWidget);
  });

  testWidgets('CalorieApp shows the login screen when signed out', (WidgetTester tester) async {
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
