import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getApps, initializeApp } from "firebase-admin/app";
import { FoodProductResult, kcalPer100g, extractMicronutrients, cacheProducts, numberOrNull } from "./foodProduct";
import { matchGenericFoodItems, rerankByNamePrefix } from "./foodMatching";

if (getApps().length === 0) {
  initializeApp();
}

interface SearchFoodsRequest {
  query: string;
}

interface SearchFoodsResult {
  products: FoodProductResult[];
}

interface OffHit {
  code?: string;
  product_name?: string;
  product_name_ro?: string;
  brands?: string[];
  nutriments?: Record<string, number | string | undefined>;
}

interface OffSearchResponse {
  hits?: OffHit[];
}

function buildSearchUrl(query: string): string {
  const params = new URLSearchParams({
    q: query,
    page_size: "50",
    langs: "ro",
  });
  return `https://search.openfoodfacts.org/search?${params.toString()}`;
}

function toResult(hit: OffHit): FoodProductResult | null {
  const name = (hit.product_name_ro || hit.product_name || "").trim();
  if (!name) return null;

  const nutriments = hit.nutriments ?? {};
  const kcal = kcalPer100g(nutriments);
  if (kcal === null || kcal <= 0) return null;

  return {
    barcode: hit.code ?? null,
    name,
    brand: hit.brands?.[0]?.trim() || null,
    kcalPer100g: kcal,
    proteinPer100g: numberOrNull(nutriments["proteins_100g"]),
    carbsPer100g: numberOrNull(nutriments["carbohydrates_100g"]),
    fatPer100g: numberOrNull(nutriments["fat_100g"]),
    imageUrl: null,
    micronutrients: extractMicronutrients(nutriments),
  };
}

export const searchFoods = onCall<SearchFoodsRequest>(
  { region: "europe-west1", cpu: 1, memory: "256MiB" },
  async (request): Promise<SearchFoodsResult> => {
    const query = request.data.query?.trim();
    if (!query || query.length < 2) {
      throw new HttpsError("invalid-argument", "query must be at least 2 characters.");
    }

    const genericMatches = matchGenericFoodItems(query);

    const response = await fetch(buildSearchUrl(query));
    if (!response.ok) {
      throw new HttpsError("unavailable", `Open Food Facts returned HTTP ${response.status}.`);
    }

    const data = (await response.json()) as OffSearchResponse;
    const offProducts = rerankByNamePrefix(
      (data.hits ?? [])
        .map(toResult)
        .filter((p): p is FoodProductResult => p !== null),
      query,
    );

    // Curated matches (always relevant, always complete) lead; external
    // results fill in behind, deduplicated by name so a beverage that OFF
    // does happen to have data for isn't shown twice.
    const genericNames = new Set(genericMatches.map((p) => p.name.toLowerCase()));
    const products = [
      ...genericMatches,
      ...offProducts.filter((p) => !genericNames.has(p.name.toLowerCase())),
    ].slice(0, 40);

    await cacheProducts(products);

    return { products };
  }
);
