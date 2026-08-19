import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/features/auth/account_deletion_service.dart';

void main() {
  test(
    'deleteAccountWithPassword wipes every per-user subcollection and the profile doc',
    () async {
      final mockUser = MockUser(uid: 'test-uid', email: 'test@example.com');
      final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      final firestore = FakeFirebaseFirestore();
      final userDoc = firestore.collection('users').doc('test-uid');

      // Seed the profile doc plus every subcollection the service is
      // responsible for clearing (see _userSubcollections).
      await userDoc.set({'heightCm': 170, 'weightKg': 70});
      await userDoc.collection('foodLogs').doc('log1').set({'foodName': 'Măr'});
      await userDoc.collection('customFoods').doc('food1').set({'name': 'Ovăz'});
      await userDoc.collection('weightEntries').doc('w1').set({'weightKg': 70});
      await userDoc.collection('workouts').doc('workout1').set({'activityType': 'running'});

      final service = AccountDeletionService(firestore, mockAuth);
      await service.deleteAccountWithPassword('correct-password');

      expect((await userDoc.get()).exists, isFalse);
      expect((await userDoc.collection('foodLogs').get()).docs, isEmpty);
      expect((await userDoc.collection('customFoods').get()).docs, isEmpty);
      expect((await userDoc.collection('weightEntries').get()).docs, isEmpty);
      expect((await userDoc.collection('workouts').get()).docs, isEmpty);
      // Not asserted: mockAuth.currentUser becoming null — MockUser.delete()
      // is a documented no-op in firebase_auth_mocks (it doesn't simulate
      // sign-out), so that would test the mock, not our code. The real
      // Firebase SDK does clear currentUser on delete().
    },
  );

  test('deleteAccountWithPassword pages through a subcollection bigger than one batch', () async {
    final mockUser = MockUser(uid: 'test-uid', email: 'test@example.com');
    final mockAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
    final firestore = FakeFirebaseFirestore();
    final userDoc = firestore.collection('users').doc('test-uid');
    await userDoc.set({'heightCm': 170});

    // Bigger than the service's internal page size (300), so this only
    // passes if the paging loop actually keeps fetching until empty
    // instead of stopping after the first page.
    for (var i = 0; i < 650; i++) {
      await userDoc.collection('foodLogs').doc('log$i').set({'foodName': 'item $i'});
    }

    final service = AccountDeletionService(firestore, mockAuth);
    await service.deleteAccountWithPassword('correct-password');

    expect((await userDoc.collection('foodLogs').get()).docs, isEmpty);
  });
}
