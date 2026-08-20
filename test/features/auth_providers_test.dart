import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/features/auth/auth_providers.dart';
import 'package:calorie_app/features/auth/uid_provider.dart';

void main() {
  test('currentUidProvider throws when read without a signed-in user', () {
    final container = ProviderContainer(
      overrides: [firebaseAuthProvider.overrideWithValue(MockFirebaseAuth(signedIn: false))],
    );
    addTearDown(container.dispose);

    expect(() => container.read(currentUidProvider), throwsA(isA<StateError>()));
  });

  test('currentUidProvider returns the signed-in uid', () async {
    final mockAuth = MockFirebaseAuth(
      mockUser: MockUser(uid: 'test-uid', email: 'test@example.com'),
      signedIn: true,
    );
    final container = ProviderContainer(overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)]);
    addTearDown(container.dispose);
    await pumpEventQueue();

    expect(container.read(currentUidProvider), 'test-uid');
  });

  test('authControllerProvider.signOut delegates to FirebaseAuth', () async {
    final mockAuth = MockFirebaseAuth(
      mockUser: MockUser(uid: 'test-uid', email: 'test@example.com'),
      signedIn: true,
    );
    final container = ProviderContainer(overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)]);
    addTearDown(container.dispose);

    expect(mockAuth.currentUser, isNotNull);
    await container.read(authControllerProvider).signOut();
    expect(mockAuth.currentUser, isNull);
  });
}
