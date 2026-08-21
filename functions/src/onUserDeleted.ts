import * as functionsV1 from "firebase-functions/v1";
import { getFirestore, FieldPath } from "firebase-admin/firestore";
import { getApps, initializeApp } from "firebase-admin/app";

if (getApps().length === 0) {
  initializeApp();
}

/** Every top-level daily-quota collection that keys docs by "{uid}_{date}"
 * (see dailyQuota.ts) — each needs the same cleanup on account deletion. */
const QUOTA_COLLECTIONS = ["photoAnalysisQuota", "aiFoodLookupQuota"];

/**
 * Quota docs (see dailyQuota.ts) live outside users/{uid} specifically so
 * clients can never read/write them directly (firestore.rules denies all
 * client access), which also means AccountDeletionService on the client
 * physically cannot clean them up itself. This Auth trigger is the only
 * place that can: it fires whenever a user is deleted, through any path
 * (in-app deletion, console, admin API), and removes every quota-counter
 * doc for that uid, across every quota collection, via the Admin SDK.
 */
export const onUserDeleted = functionsV1.auth.user().onDelete(async (user) => {
  const db = getFirestore();
  const prefix = user.uid + "_";
  // Doc IDs are "{uid}_{YYYY-MM-DD}", so every character after the prefix
  // is a digit or hyphen (ASCII 45-57). "z" (ASCII 122) sorts above all of
  // those, so it is a safe upper bound for a starts-with-prefix range
  // query, without reaching for an exotic Unicode code point.
  const prefixUpperBound = prefix + "z";

  for (const collection of QUOTA_COLLECTIONS) {
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
});
