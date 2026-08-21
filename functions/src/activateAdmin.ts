import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { getApps, initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";

if (getApps().length === 0) {
  initializeApp();
}

const ADMIN_ACTIVATION_PASSWORD = defineSecret("ADMIN_ACTIVATION_PASSWORD");

interface ActivateAdminRequest {
  password: string;
}

interface ActivateAdminResult {
  success: true;
}

/**
 * Grants the calling account the `admin` custom claim once [password]
 * matches the secret held in Secret Manager — checked only server-side, so
 * it can never be extracted from the app binary the way a client-side
 * check could be. The client must force-refresh its ID token
 * (User.getIdTokenResult(true) or getIdToken(true)) after this succeeds for
 * the new claim to actually take effect on subsequent requests/rules
 * checks — custom claims only propagate on token refresh, not instantly.
 */
export const activateAdmin = onCall<ActivateAdminRequest>(
  { secrets: [ADMIN_ACTIVATION_PASSWORD], region: "europe-west1" },
  async (request): Promise<ActivateAdminResult> => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Trebuie să fii autentificat.");
    }
    const password = request.data.password;
    if (!password || password !== ADMIN_ACTIVATION_PASSWORD.value()) {
      throw new HttpsError("permission-denied", "Cod incorect.");
    }

    await getAuth().setCustomUserClaims(request.auth.uid, { admin: true });
    return { success: true };
  },
);
