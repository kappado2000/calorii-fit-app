import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import { getApps, initializeApp } from "firebase-admin/app";
import Anthropic from "@anthropic-ai/sdk";
import { FoodProductResult, MicronutrientsResult } from "./foodProduct";
import { checkAndIncrementDailyQuota } from "./dailyQuota";

if (getApps().length === 0) {
  initializeApp();
}

const ANTHROPIC_API_KEY = defineSecret("ANTHROPIC_API_KEY");

const DAILY_AI_LOOKUP_LIMIT = 20;

interface AiFoodLookupRequest {
  query: string;
}

interface AiFoodLookupResult {
  /** Null when Claude itself wasn't confident this was a real, identifiable
   * food — the client must never present a low-confidence guess as if it
   * were a real product. */
  product: FoodProductResult | null;
  confidence: number;
}

const REPORT_TOOL_NAME = "report_food_nutrition";

/**
 * Fallback for when the app's own database (curated staples table + Open
 * Food Facts, see searchFoods.ts) finds nothing for a manually-typed food
 * name — asks Claude to identify the food and estimate its average
 * nutrition per 100g instead of forcing the user into fully manual entry.
 * Deliberately text-only (no image, unlike analyzePhoto.ts) and a small
 * prompt, so the cost per call is a small fraction of a photo analysis.
 */
function buildSystemPrompt(): string {
  return `You are a nutrition database assistant for a Romanian calorie-tracking app.
The user searched for a food by name and the app's own database (curated staples
table + Open Food Facts) found no match. Identify the most likely food they meant
and estimate its average nutritional values per 100g, so the app can offer it as a
usable entry.

Guidance:
- Prefer the most common, generic interpretation of the name (e.g. a home-cooked
  dish or a whole food) over an obscure or overly specific one.
- name: a short, natural Romanian food name — this becomes the entry's display name.
- kcalPer100g, proteinPer100g, carbsPer100g, fatPer100g: your best average estimate
  per 100 grams for this food as commonly prepared/sold. Grams/carbs/fat may be
  null if genuinely unknown, but kcalPer100g is always required.
- micronutrients: only include a value when you're genuinely confident about it for
  this specific food; omit fields you're unsure about rather than guessing.
- confidence: how sure you are this identification is what the user meant, 0 to 1.
  Set it to 0 if the query is nonsensical, gibberish, or not a food at all.`;
}

function buildReportTool() {
  return {
    name: REPORT_TOOL_NAME,
    description: "Report the identified food and its estimated nutrition per 100g.",
    input_schema: {
      type: "object" as const,
      properties: {
        name: { type: "string" as const },
        confidence: { type: "number" as const, minimum: 0, maximum: 1 },
        kcalPer100g: { type: "number" as const },
        proteinPer100g: { type: ["number", "null"] as unknown as "number" },
        carbsPer100g: { type: ["number", "null"] as unknown as "number" },
        fatPer100g: { type: ["number", "null"] as unknown as "number" },
        micronutrients: {
          type: ["object", "null"] as unknown as "object",
          properties: {
            vitaminCMg: { type: ["number", "null"] as unknown as "number" },
            vitaminDMcg: { type: ["number", "null"] as unknown as "number" },
            calciumMg: { type: ["number", "null"] as unknown as "number" },
            ironMg: { type: ["number", "null"] as unknown as "number" },
            magnesiumMg: { type: ["number", "null"] as unknown as "number" },
            potassiumMg: { type: ["number", "null"] as unknown as "number" },
          },
        },
      },
      required: ["name", "confidence", "kcalPer100g"],
    },
  };
}

interface ReportedNutrition {
  name: string;
  confidence: number;
  kcalPer100g: number;
  proteinPer100g: number | null;
  carbsPer100g: number | null;
  fatPer100g: number | null;
  micronutrients: MicronutrientsResult | null;
}

export const aiFoodLookup = onCall<AiFoodLookupRequest>(
  { secrets: [ANTHROPIC_API_KEY], region: "europe-west1", cpu: 1, memory: "256MiB" },
  async (request): Promise<AiFoodLookupResult> => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Trebuie să fii autentificat pentru a folosi căutarea AI.");
    }
    const query = request.data.query?.trim();
    if (!query || query.length < 2) {
      throw new HttpsError("invalid-argument", "query must be at least 2 characters.");
    }

    // The admin account (see activateAdmin.ts) has unlimited access to
    // every quota-gated function — that's the entire point of the role.
    if (request.auth.token.admin !== true) {
      await checkAndIncrementDailyQuota(
        "aiFoodLookupQuota",
        request.auth.uid,
        DAILY_AI_LOOKUP_LIMIT,
        `Ai atins limita de ${DAILY_AI_LOOKUP_LIMIT} căutări AI pe zi. Încearcă din nou mâine.`,
      );
    }

    const anthropic = new Anthropic({ apiKey: ANTHROPIC_API_KEY.value() });

    const message = await anthropic.messages.create({
      model: "claude-haiku-4-5",
      max_tokens: 512,
      system: buildSystemPrompt(),
      messages: [{ role: "user", content: `Identify this food and estimate its nutrition: "${query}"` }],
      tools: [buildReportTool()],
      tool_choice: { type: "tool", name: REPORT_TOOL_NAME },
    });

    const toolUse = message.content.find((block) => block.type === "tool_use");
    if (!toolUse || toolUse.type !== "tool_use") {
      throw new HttpsError("internal", "Claude did not return a structured tool_use response.");
    }

    const output = toolUse.input as ReportedNutrition;
    if (output.confidence <= 0 || !output.name) {
      return { product: null, confidence: output.confidence };
    }

    const product: FoodProductResult = {
      barcode: null,
      name: output.name,
      brand: null,
      kcalPer100g: output.kcalPer100g,
      proteinPer100g: output.proteinPer100g,
      carbsPer100g: output.carbsPer100g,
      fatPer100g: output.fatPer100g,
      imageUrl: null,
      micronutrients: output.micronutrients,
    };

    return { product, confidence: output.confidence };
  },
);
