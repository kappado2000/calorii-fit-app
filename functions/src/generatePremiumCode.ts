import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getApps, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore, FieldValue } from "firebase-admin/firestore";

if (getApps().length === 0) {
  initializeApp();
}

interface GeneratePremiumCodeRequest {
  targetEmail: string;
  durationDays: number;
}

interface GeneratePremiumCodeResult {
  code: string;
}

// Excludes visually-confusable characters (0/O, 1/I/L) — this code gets
// read off one screen and typed into another, so unambiguous glyphs matter
// more than a larger alphabet.
const CODE_CHARS = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";
const CODE_LENGTH = 8;

function randomCode(): string {
  let code = "";
  for (let i = 0; i < CODE_LENGTH; i++) {
    code += CODE_CHARS[Math.floor(Math.random() * CODE_CHARS.length)];
  }
  return code;
}

/**
 * Admin-only: mints a premiumCodes/{code} doc bound to a specific account
 * (see redeemPremiumCode.ts) — every code is generated for one named
 * person, not a first-come-first-served giveaway, matching the explicit
 * requirement that the admin controls exactly who gets access and for how
 * long. If the target account already exists, the code is bound to its
 * uid (tighter — survives an email change); otherwise it's bound to the
 * email itself and resolved against the redeemer's own verified email.
 */
export const generatePremiumCode = onCall<GeneratePremiumCodeRequest>(
  { region: "europe-west1" },
  async (request): Promise<GeneratePremiumCodeResult> => {
    if (!request.auth || request.auth.token.admin !== true) {
      throw new HttpsError("permission-denied", "Doar contul admin poate genera coduri.");
    }
    const targetEmail = request.data.targetEmail?.trim().toLowerCase();
    const durationDays = request.data.durationDays;
    if (!targetEmail || !durationDays || durationDays <= 0) {
      throw new HttpsError("invalid-argument", "targetEmail and a positive durationDays are required.");
    }

    let targetUid: string | null = null;
    try {
      const userRecord = await getAuth().getUserByEmail(targetEmail);
      targetUid = userRecord.uid;
    } catch {
      // Account doesn't exist yet — the code still gets generated, bound
      // by email; redemption resolves against the caller's own email.
    }

    const db = getFirestore();
    let code = randomCode();
    // Collision odds are astronomically low (32^8 possibilities) but this
    // grants real access, so checking costs nothing and removes any doubt.
    while ((await db.collection("premiumCodes").doc(code).get()).exists) {
      code = randomCode();
    }

    await db
      .collection("premiumCodes")
      .doc(code)
      .set({
        code,
        targetEmail,
        targetUid,
        durationDays,
        createdAt: FieldValue.serverTimestamp(),
        createdByUid: request.auth.uid,
        status: "pending",
        redeemedAt: null,
        redeemedByUid: null,
      });

    return { code };
  },
);
