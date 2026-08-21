import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getApps, initializeApp } from "firebase-admin/app";
import { getFirestore, FieldValue, Timestamp } from "firebase-admin/firestore";

if (getApps().length === 0) {
  initializeApp();
}

interface RedeemPremiumCodeRequest {
  code: string;
}

interface RedeemPremiumCodeResult {
  premiumUntil: string;
}

/**
 * Redeems a premiumCodes/{code} doc minted by generatePremiumCode.ts —
 * verifies the caller is actually who the code was generated for (by uid
 * if the account existed at generation time, otherwise by their verified
 * email), marks the code used, and grants premiumUntil on the caller's own
 * users/{uid} doc. Everything happens in one transaction so a code can
 * never be redeemed twice, even under concurrent requests.
 */
export const redeemPremiumCode = onCall<RedeemPremiumCodeRequest>(
  { region: "europe-west1" },
  async (request): Promise<RedeemPremiumCodeResult> => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Trebuie să fii autentificat.");
    }
    const code = request.data.code?.trim().toUpperCase();
    if (!code) {
      throw new HttpsError("invalid-argument", "code is required.");
    }

    const uid = request.auth.uid;
    const callerEmail = (request.auth.token.email as string | undefined)?.toLowerCase();
    const db = getFirestore();
    const codeRef = db.collection("premiumCodes").doc(code);
    const userRef = db.collection("users").doc(uid);

    const premiumUntil = await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(codeRef);
      if (!snapshot.exists) {
        throw new HttpsError("not-found", "Cod invalid.");
      }
      const data = snapshot.data()!;
      if (data.status !== "pending") {
        throw new HttpsError("failed-precondition", "Acest cod a fost deja folosit.");
      }

      const boundToThisCaller = data.targetUid ? data.targetUid === uid : data.targetEmail === callerEmail;
      if (!boundToThisCaller) {
        throw new HttpsError("permission-denied", "Acest cod este alocat altui cont.");
      }

      const durationDays = data.durationDays as number;
      const until = Timestamp.fromMillis(Date.now() + durationDays * 24 * 60 * 60 * 1000);

      transaction.update(codeRef, {
        status: "redeemed",
        redeemedAt: FieldValue.serverTimestamp(),
        redeemedByUid: uid,
      });
      transaction.set(userRef, { premiumUntil: until }, { merge: true });

      return until;
    });

    return { premiumUntil: premiumUntil.toDate().toISOString() };
  },
);
