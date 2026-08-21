import * as functionsV1 from "firebase-functions/v1";
import { getFirestore, FieldPath, CollectionReference, DocumentData } from "firebase-admin/firestore";
import { getApps, initializeApp } from "firebase-admin/app";

if (getApps().length === 0) {
  initializeApp();
}

/** Every top-level daily-quota collection that keys docs by "{uid}_{date}"
 * (see dailyQuota.ts's checkAndIncrementDailyQuota) — each needs the same
 * prefix-range cleanup on account deletion. */
const DAILY_QUOTA_COLLECTIONS = ["photoAnalysisQuota", "aiFoodLookupQuota"];

/** Cumulative (non-date-keyed) quota collections — one doc per uid, no
 * suffix (see dailyQuota.ts's checkAndIncrementCumulativeQuota) — deleted
 * directly by id rather than a prefix-range query. */
const CUMULATIVE_QUOTA_COLLECTIONS = ["aiFoodLookupTrialQuota"];

/** Mirrors AccountDeletionService's _userSubcollections on the client —
 * kept in sync manually, same as that list's own comment says. Needed
 * here too because this trigger is the *only* cleanup that ever runs for
 * an account deleted outside the app's own "delete my account" flow (the
 * Firebase Console, the Admin SDK, a support request) — without it, that
 * path deletes the Auth user but silently orphans every Firestore doc. */
const USER_SUBCOLLECTIONS = ["customFoods", "foodLogs", "weightEntries", "workouts", "hydrationEntries", "recipes"];

async function deleteCollection(collection: CollectionReference<DocumentData>): Promise<void> {
  const pageSize = 300;
  const db = collection.firestore;
  while (true) {
    const snapshot = await collection.limit(pageSize).get();
    if (snapshot.empty) return;
    const batch = db.batch();
    snapshot.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();
    if (snapshot.docs.length < pageSize) return;
  }
}

/**
 * Fires whenever a user is deleted, through any path (in-app deletion,
 * Firebase Console, Admin API) — removes every quota-counter doc for that
 * uid (which the client can never touch directly, see firestore.rules)
 * and the user's full users/{uid} subtree, so no path to account deletion
 * leaves orphaned data behind.
 */
export const onUserDeleted = functionsV1.auth.user().onDelete(async (user) => {
  const db = getFirestore();
  const prefix = user.uid + "_";
  // Doc IDs are "{uid}_{YYYY-MM-DD}", so every character after the prefix
  // is a digit or hyphen (ASCII 45-57). "z" (ASCII 122) sorts above all of
  // those, so it is a safe upper bound for a starts-with-prefix range
  // query, without reaching for an exotic Unicode code point.
  const prefixUpperBound = prefix + "z";

  for (const collection of DAILY_QUOTA_COLLECTIONS) {
    const snapshot = await db
      .collection(collection)
      .where(FieldPath.documentId(), ">=", prefix)
      .where(FieldPath.documentId(), "<", prefixUpperBound)
      .get();

    if (snapshot.empty) continue;

    const batch = db.batch();
    snapshot.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();
  }

  for (const collection of CUMULATIVE_QUOTA_COLLECTIONS) {
    await db.collection(collection).doc(user.uid).delete();
  }

  const userDoc = db.collection("users").doc(user.uid);
  for (const name of USER_SUBCOLLECTIONS) {
    await deleteCollection(userDoc.collection(name));
  }
  await userDoc.delete();
});
