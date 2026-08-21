import { HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";

/**
 * Atomically checks and increments today's count for [uid] in one document
 * (`{collection}/{uid}_{date}`, a top-level collection — never nested under
 * users/{uid}, which clients can read/write directly; these collections
 * must only ever be touched by the Admin SDK, see firestore.rules). Throws
 * resource-exhausted once [limit] is hit, aborting the transaction so the
 * count doesn't increment past it. Shared by every Cloud Function that
 * calls the Anthropic API directly, since each needs the same anti-abuse
 * ceiling (a cost/cost-of-abuse concern, not a monetization gate — a
 * paid-tier limit, if any, is a separate, higher-level product decision
 * layered on top of this).
 */
export async function checkAndIncrementDailyQuota(
  collection: string,
  uid: string,
  limit: number,
  exceededMessage: string,
): Promise<void> {
  const db = getFirestore();
  const today = new Date().toISOString().slice(0, 10);
  const docRef = db.collection(collection).doc(`${uid}_${today}`);

  await db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(docRef);
    const count = (snapshot.data()?.count as number | undefined) ?? 0;
    if (count >= limit) {
      throw new HttpsError("resource-exhausted", exceededMessage);
    }
    transaction.set(docRef, { count: count + 1, updatedAt: FieldValue.serverTimestamp() }, { merge: true });
  });
}
