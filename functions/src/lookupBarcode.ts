import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { getApps, initializeApp } from "firebase-admin/app";
import { FoodProductResult, kcalPer100g, extractMicronutrients, numberOrNull, cacheProducts } from "./foodProduct";

if (getApps().length === 0) {
  initializeApp();
}

interface LookupBarcodeRequest {
  barcode: string;
}

interface LookupBarcodeResult {
  product: FoodProductResult | null;
}

interface OffProductResponse {
  status?: number;
  product?: {
    code?: string;
    product_name?: string;
    product_name_ro?: string;
    brands?: string;
    nutriments?: Record<string, number | string | undefined>;
  };
}

/**
 * A barcode scan is an exact lookup, unlike the free-text `searchFoods`
 * flow — so it's worth checking the shared `foodsCache` first (populated by
 * every prior search or scan, by anyone) before hitting Open Food Facts at
 * all. This is the "future barcode-scan feature" the cache comment in
 * searchFoods.ts already anticipated.
 */
export const lookupBarcode = onCall<LookupBarcodeRequest>(
  { region: "europe-west1", cpu: 1, memory: "256MiB" },
  async (request): Promise<LookupBarcodeResult> => {
    const barcode = request.data.barcode?.trim();
    if (!barcode) {
      throw new HttpsError("invalid-argument", "barcode must not be empty.");
    }

    const db = getFirestore();
    const cached = await db.collection("foodsCache").doc(barcode).get();
    if (cached.exists) {
      return { product: cached.data() as FoodProductResult };
    }

    const response = await fetch(`https://world.openfoodfacts.org/api/v2/product/${barcode}.json`);
    if (!response.ok) {
      throw new HttpsError("unavailable", `Open Food Facts returned HTTP ${response.status}.`);
    }

    const data = (await response.json()) as OffProductResponse;
    if (data.status !== 1 || !data.product) {
      return { product: null };
    }

    const name = (data.product.product_name_ro || data.product.product_name || "").trim();
    const nutriments = data.product.nutriments ?? {};
    const kcal = kcalPer100g(nutriments);
    if (!name || kcal === null || kcal <= 0) {
      return { product: null };
    }

    const product: FoodProductResult = {
      barcode,
      name,
      brand: data.product.brands?.split(",")[0]?.trim() || null,
      kcalPer100g: kcal,
      proteinPer100g: numberOrNull(nutriments["proteins_100g"]),
      carbsPer100g: numberOrNull(nutriments["carbohydrates_100g"]),
      fatPer100g: numberOrNull(nutriments["fat_100g"]),
      imageUrl: null,
      micronutrients: extractMicronutrients(nutriments),
    };

    await cacheProducts([product]);

    return { product };
  }
);
