import * as functionsV1 from "firebase-functions/v1";
import { getFirestore, FieldPath } from "firebase-admin/firestore";
import { getApps, initializeApp } from "firebase-admin/app";

if (getApps().length === 0) {
  initializeApp();
}

/**
 * photoAnalysisQuota/{uid}_{date} docs (see analyzePhoto.ts) live outside
 * users/{uid} specifically so clients can never read/write them directly
 * (firestore.rules denies all client access), which also means
 * AccountDeletionService on the client physically cannot clean them up
 * itself. This Auth trigger is the only place that can: it fires whenever a
 * user is deleted, through any path (in-app deletion, console, admin API),
 * and removes every quota-counter doc for that uid via the Admin SDK.
 */
export const onUserDeleted = functionsV1.auth.user().onDelete(async (user) => {
  const db = getFirestore();
  const prefix = user.uid + "_";
  // Doc IDs are "{uid}_{YYYY-MM-DD}", so every character after the prefix
  // is a digit or hyphen (ASCII 45-57). "z" (ASCII 122) sorts above all of
  // those, so it is a safe upper bound for a starts-with-prefix range
  // query, without reaching for an exotic Unicode code point.
  const prefixUpperBound = prefix + "z";

  const snapshot = await db
    .collection("photoAnalysisQuota")
    .where(FieldPath.documentId(), ">=", prefix)
    .where(FieldPath.documentId(), "<", prefixUpperBound)
    .get();

  if (snapshot.empty) return;

  const batch = db.batch();
  snapshot.docs.forEach((doc) => batch.delete(doc.ref));
  await batch.commit();
});
