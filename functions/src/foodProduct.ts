import { getFirestore } from "firebase-admin/firestore";

/** Mirrors MicronutrientProfile on the Dart side. */
export interface MicronutrientsResult {
  vitaminCMg: number | null;
  vitaminDMcg: number | null;
  calciumMg: number | null;
  ironMg: number | null;
  magnesiumMg: number | null;
  potassiumMg: number | null;
}

export interface FoodProductResult {
  barcode: string | null;
  name: string;
  brand: string | null;
  kcalPer100g: number;
  proteinPer100g: number | null;
  carbsPer100g: number | null;
  fatPer100g: number | null;
  imageUrl: string | null;
  micronutrients: MicronutrientsResult | null;
}

export function numberOrNull(value: number | string | undefined): number | null {
  if (value === undefined || value === null) return null;
  const num = typeof value === "number" ? value : Number(value);
  return Number.isFinite(num) ? num : null;
}

/** Falls back to computing kcal from kJ — many hits only carry the kJ field. */
export function kcalPer100g(nutriments: Record<string, number | string | undefined>): number | null {
  const kcal = numberOrNull(nutriments["energy-kcal_100g"]);
  if (kcal !== null) return kcal;
  const kj = numberOrNull(nutriments["energy-kj_100g"]);
  return kj !== null ? kj / 4.184 : null;
}

/**
 * Pulls the six tracked micronutrients from OFF's nutriments object when
 * present — coverage is sparse (most contributors scan macros, not the
 * full vitamin/mineral panel), so this returns null fields rather than
 * fabricating a number, same as every other optional nutrient here.
 */
export function extractMicronutrients(
  nutriments: Record<string, number | string | undefined>,
): MicronutrientsResult | null {
  const result: MicronutrientsResult = {
    vitaminCMg: numberOrNull(nutriments["vitamin-c_100g"]),
    vitaminDMcg: numberOrNull(nutriments["vitamin-d_100g"]),
    calciumMg: numberOrNull(nutriments["calcium_100g"]),
    ironMg: numberOrNull(nutriments["iron_100g"]),
    magnesiumMg: numberOrNull(nutriments["magnesium_100g"]),
    potassiumMg: numberOrNull(nutriments["potassium_100g"]),
  };
  const hasAnyValue = Object.values(result).some((v) => v !== null);
  return hasAnyValue ? result : null;
}

/**
 * Best-effort write-through cache keyed by barcode (see firestore.rules —
 * clients can read foodsCache but never write it). Products without a
 * barcode simply aren't cached; there's no good cache key for those.
 */
export async function cacheProducts(products: FoodProductResult[]): Promise<void> {
  const withBarcode = products.filter((p) => p.barcode);
  if (withBarcode.length === 0) return;
  const db = getFirestore();
  const batch = db.batch();
  for (const product of withBarcode) {
    batch.set(db.collection("foodsCache").doc(product.barcode as string), product, { merge: true });
  }
  await batch.commit();
}
