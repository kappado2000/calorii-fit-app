import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { getAuth } from "firebase-admin/auth";

interface AuthLike {
  uid: string;
  token: Record<string, unknown>;
}

/**
 * True for the admin account, or an account with a currently-unexpired
 * premiumUntil (see redeemPremiumCode.ts). Reads Firestore directly
 * (Admin SDK — bypasses firestore.rules) rather than trusting a custom
 * claim for premium, since premiumUntil changes far more often than an
 * admin grant and custom claims only refresh on token renewal; a claim
 * would go stale exactly when it matters (right after redeeming a code).
 */
export async function isPremiumOrAdmin(auth: AuthLike): Promise<boolean> {
  if (auth.token.admin === true) return true;
  const snapshot = await getFirestore().collection("users").doc(auth.uid).get();
  const premiumUntil = snapshot.data()?.premiumUntil as Timestamp | undefined;
  return premiumUntil !== undefined && premiumUntil.toMillis() > Date.now();
}

/** Length of the free trial every new account gets — a taste of the full
 * experience (higher photo limit, some AI searches) before permanently
 * settling into the free tier's tighter caps. */
const TRIAL_DAYS = 14;

/**
 * True for the first [TRIAL_DAYS] days after a Firebase Auth account was
 * created. Uses Auth's own account-creation timestamp (not a Firestore
 * field written at onboarding time) so the trial clock starts at signup
 * itself, regardless of whether/when the user finishes onboarding.
 */
export async function isInTrial(uid: string): Promise<boolean> {
  const userRecord = await getAuth().getUser(uid);
  const createdAtMs = new Date(userRecord.metadata.creationTime).getTime();
  const trialMs = TRIAL_DAYS * 24 * 60 * 60 * 1000;
  return Date.now() - createdAtMs < trialMs;
}
