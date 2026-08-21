import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { getApps, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { authenticator } from "otplib";

if (getApps().length === 0) {
  initializeApp();
}

const ADMIN_ACTIVATION_PASSWORD = defineSecret("ADMIN_ACTIVATION_PASSWORD");
/** Base32 TOTP seed (RFC 6238) added to an authenticator app once (Google
 * Authenticator, Authy, etc.) — free, no per-check cost, unlike SMS. */
const ADMIN_TOTP_SECRET = defineSecret("ADMIN_TOTP_SECRET");

interface ActivateAdminRequest {
  password: string;
  totpCode: string;
}

interface ActivateAdminResult {
  success: true;
}

/**
 * Grants the calling account the `admin` custom claim once both [password]
 * and [totpCode] check out — two independent factors (something you know,
 * something you have), both verified only server-side, so neither can be
 * extracted from the app binary the way a client-side check could be. The
 * client must force-refresh its ID token (getIdToken(true)) after this
 * succeeds for the new claim to actually take effect on subsequent
 * requests/rules checks — custom claims only propagate on token refresh,
 * not instantly.
 */
export const activateAdmin = onCall<ActivateAdminRequest>(
  { secrets: [ADMIN_ACTIVATION_PASSWORD, ADMIN_TOTP_SECRET], region: "europe-west1" },
  async (request): Promise<ActivateAdminResult> => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Trebuie să fii autentificat.");
    }
    const password = request.data.password;
    if (!password || password !== ADMIN_ACTIVATION_PASSWORD.value()) {
      throw new HttpsError("permission-denied", "Cod incorect.");
    }

    const totpCode = request.data.totpCode?.trim();
    const validCode = !!totpCode && authenticator.verify({ token: totpCode, secret: ADMIN_TOTP_SECRET.value() });
    if (!validCode) {
      throw new HttpsError("permission-denied", "Cod din aplicația de autentificare incorect.");
    }

    await getAuth().setCustomUserClaims(request.auth.uid, { admin: true });
    return { success: true };
  },
);
