import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { getApps, initializeApp } from "firebase-admin/app";

if (getApps().length === 0) {
  initializeApp();
}

interface FoodProductResult {
  barcode: string | null;
  name: string;
  brand: string | null;
  kcalPer100g: number;
  proteinPer100g: number | null;
  carbsPer100g: number | null;
  fatPer100g: number | null;
  imageUrl: string | null;
}

interface SearchFoodsRequest {
  query: string;
}

interface SearchFoodsResult {
  products: FoodProductResult[];
}

interface OffProduct {
  code?: string;
  product_name?: string;
  product_name_ro?: string;
  brands?: string;
  image_small_url?: string;
  nutriments?: Record<string, number | string | undefined>;
}

interface OffSearchResponse {
  products?: OffProduct[];
}

/**
 * Open Food Facts is a free, open, no-API-key nutrition database with strong
 * European/Romanian product coverage — exactly the "produse aflate in comert"
 * lookup the user asked for. We only ever ask it for products that carry a
 * usable kcal/100g value; anything else is useless for calorie tracking and
 * is filtered out rather than shown with a blank calorie field.
 */
function buildSearchUrl(query: string): string {
  const params = new URLSearchParams({
    search_terms: query,
    search_simple: "1",
    action: "process",
    json: "1",
    page_size: "25",
    lc: "ro",
    cc: "ro",
    fields: "code,product_name,product_name_ro,brands,nutriments,image_small_url",
  });
  return `https://world.openfoodfacts.org/cgi/search.pl?${params.toString()}`;
}

function toResult(product: OffProduct): FoodProductResult | null {
  const name = (product.product_name_ro || product.product_name || "").trim();
  if (!name) return null;

  const nutriments = product.nutriments ?? {};
  const kcal = numberOrNull(nutriments["energy-kcal_100g"]);
  if (kcal === null || kcal <= 0) return null;

  return {
    barcode: product.code ?? null,
    name,
    brand: product.brands?.split(",")[0]?.trim() || null,
    kcalPer100g: kcal,
    proteinPer100g: numberOrNull(nutriments["proteins_100g"]),
    carbsPer100g: numberOrNull(nutriments["carbohydrates_100g"]),
    fatPer100g: numberOrNull(nutriments["fat_100g"]),
    imageUrl: product.image_small_url ?? null,
  };
}

function numberOrNull(value: number | string | undefined): number | null {
  if (value === undefined || value === null) return null;
  const num = typeof value === "number" ? value : Number(value);
  return Number.isFinite(num) ? num : null;
}

/**
 * Best-effort write-through cache keyed by barcode (see firestore.rules —
 * clients can read foodsCache but never write it). Search results without a
 * barcode simply aren't cached; that's fine, the search call itself is what
 * we're trying to make cheap on repeat, and repeat searches still hit OFF
 * (there's no good cache key for a free-text query), but any barcode-bearing
 * product becomes instantly available to a future barcode-scan feature.
 */
async function cacheProducts(products: FoodProductResult[]): Promise<void> {
  const withBarcode = products.filter((p) => p.barcode);
  if (withBarcode.length === 0) return;
  const db = getFirestore();
  const batch = db.batch();
  for (const product of withBarcode) {
    batch.set(db.collection("foodsCache").doc(product.barcode as string), product, { merge: true });
  }
  await batch.commit();
}

export const searchFoods = onCall<SearchFoodsRequest>(
  { region: "europe-west1", cpu: 1, memory: "256MiB" },
  async (request): Promise<SearchFoodsResult> => {
    const query = request.data.query?.trim();
    if (!query || query.length < 2) {
      throw new HttpsError("invalid-argument", "query must be at least 2 characters.");
    }

    const response = await fetch(buildSearchUrl(query));
    if (!response.ok) {
      throw new HttpsError("unavailable", `Open Food Facts returned HTTP ${response.status}.`);
    }

    const data = (await response.json()) as OffSearchResponse;
    const products = (data.products ?? [])
      .map(toResult)
      .filter((p): p is FoodProductResult => p !== null)
      .slice(0, 20);

    await cacheProducts(products);

    return { products };
  }
);
