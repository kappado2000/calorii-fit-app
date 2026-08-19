import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getApps, initializeApp } from "firebase-admin/app";
import { genericFoodsTable } from "./genericFoodsTable";
import { FoodProductResult, kcalPer100g, extractMicronutrients, cacheProducts, numberOrNull } from "./foodProduct";

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

/**
 * search.openfoodfacts.org (search-a-licious) — the actively maintained
 * search API, covering both foods AND beverages worldwide. The legacy
 * world.openfoodfacts.org/cgi/search.pl endpoint used previously turned out
 * to be flaky/intermittently down (confirmed live: a "temporarily
 * unavailable" response mid-session), which is the real reason searches were
 * unreliable, not just a relevance problem.
 *
 * Deliberately not scoping the query to a specific field (e.g.
 * product_name_ro) — most products, including ones sold in Romania, don't
 * have a populated Romanian name, so a language-scoped field match misses
 * the vast majority of real products. Plain full-text `q` searches product
 * name, brand, categories and ingredients together, which is broader but
 * necessarily less precise — reranked below to compensate.
 */
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
    // This API's image field is a nested per-crop/per-size object rather
    // than a ready-made URL — not worth reconstructing since the app
    // doesn't render a product image in the search results list today.
    imageUrl: null,
    micronutrients: extractMicronutrients(nutriments),
  };
}

/**
 * The API's own relevance ranking weighs popularity/completeness heavily,
 * which routinely surfaces a product that merely *mentions* the query (e.g.
 * crackers "cu vin alb") ahead of a product that actually *is* the thing
 * searched for. A simple, robust correction: results whose own name starts
 * with the query move to the front, in their original relative order;
 * everything else keeps following after, also in original order. This is
 * intentionally naive (no stemming/diacritic-folding) rather than a deeper
 * relevance model — it fixes the common "generic descriptor" case without
 * risking new false negatives from more aggressive matching.
 */
function foldDiacritics(value: string): string {
  return value
    .toLowerCase()
    .replace(/[ăâ]/g, "a")
    .replace(/[î]/g, "i")
    .replace(/[șş]/g, "s")
    .replace(/[țţ]/g, "t");
}

/**
 * Two words match if identical, if one is a genuine prefix of the other
 * (handles "morcov"/"morcovi", compound-name lookups like "ciuperci"
 * inside "ciuperci champignon"), or — for words of 5+ characters — if
 * they're identical except for their very last character. That last rule
 * is deliberately narrow (5-char floor, 1-char tolerance only) because
 * it's specifically covering the common Romanian singular/plural pattern
 * where only the final vowel changes ("roșie"/"roșii" ->
 * "rosi_"/"rosi_", "castravete"/"castraveți" -> "castravet_"/"castravet_")
 * — confirmed live: searching "roșie" or "castravete" (singular) found
 * nothing, because the curated table stores the plural form. A looser
 * (4-char, 1-char) tolerance was tried first but produced a real false
 * positive: "somn" (catfish) fuzzy-matched "somon" (salmon) at a shared
 * 3-character prefix. Truly irregular plurals (măr/mere, pară/pere,
 * vinete/vânătă, cireșe/cireașă) share no useful prefix at all and are
 * handled instead with an explicit alias in the item's stored name.
 */
function wordsFuzzyMatch(a: string, b: string): boolean {
  if (a === b) return true;
  if (a.length >= 3 && b.length >= 3 && (a.startsWith(b) || b.startsWith(a))) return true;
  const minLen = Math.min(a.length, b.length);
  if (minLen < 5) return false;
  return a.slice(0, minLen - 1) === b.slice(0, minLen - 1);
}

/**
 * Matches the curated staples table (see genericFoodsTable.ts) — every
 * word in the query must fuzzy-match some word in the item's name
 * (diacritic- and case-insensitive), so "vin alb"/"vin rosu" (no
 * diacritics typed) and singular/plural variants ("roșie" finding
 * "Roșii") both match correctly. These are guaranteed-relevant,
 * guaranteed-complete entries, so matches are always shown ahead of
 * external results.
 */
function matchGenericFoodItems(query: string): FoodProductResult[] {
  const queryWords = foldDiacritics(query).split(/\s+/).filter(Boolean);
  if (queryWords.length === 0) return [];

  return genericFoodsTable
    .filter((item) => {
      const itemWords = foldDiacritics(item.name).split(/[^a-z0-9]+/).filter(Boolean);
      return queryWords.every((word) => itemWords.some((itemWord) => wordsFuzzyMatch(word, itemWord)));
    })
    .map((item) => ({
      barcode: null,
      name: item.name,
      brand: null,
      kcalPer100g: item.kcalPer100g,
      proteinPer100g: item.proteinPer100g,
      carbsPer100g: item.carbsPer100g,
      fatPer100g: item.fatPer100g,
      imageUrl: null,
      micronutrients: item.micronutrients
        ? {
            vitaminCMg: item.micronutrients.vitaminCMg ?? null,
            vitaminDMcg: item.micronutrients.vitaminDMcg ?? null,
            calciumMg: item.micronutrients.calciumMg ?? null,
            ironMg: item.micronutrients.ironMg ?? null,
            magnesiumMg: item.micronutrients.magnesiumMg ?? null,
            potassiumMg: item.micronutrients.potassiumMg ?? null,
          }
        : null,
    }));
}

function rerankByNamePrefix(products: FoodProductResult[], query: string): FoodProductResult[] {
  const normalizedQuery = query.trim().toLowerCase();
  const startsWithQuery = (p: FoodProductResult) => p.name.trim().toLowerCase().startsWith(normalizedQuery);
  const prefixMatches = products.filter(startsWithQuery);
  const rest = products.filter((p) => !startsWithQuery(p));
  return [...prefixMatches, ...rest];
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
