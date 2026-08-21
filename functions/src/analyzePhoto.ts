import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import * as logger from "firebase-functions/logger";
import { getApps, initializeApp } from "firebase-admin/app";
import Anthropic from "@anthropic-ai/sdk";
import { densityTableAsPromptText } from "./densityTable";
import { findBestNutritionMatch } from "./foodMatching";
import { FoodProductResult } from "./foodProduct";
import { checkAndIncrementDailyQuota } from "./dailyQuota";

if (getApps().length === 0) {
  initializeApp();
}

const ANTHROPIC_API_KEY = defineSecret("ANTHROPIC_API_KEY");

const DAILY_PHOTO_ANALYSIS_LIMIT = 20;

const DENSITY_CATEGORY_KEYS = [
  "cookedRice",
  "cookedPasta",
  "leafySalad",
  "choppedVegetables",
  "denseMeat",
  "groundMeat",
  "fish",
  "legumes",
  "soupStew",
  "breadBaked",
  "friedStarch",
  "cheeseSolid",
  "sauceThin",
  "fruitWhole",
  "eggCooked",
  "dessertBaked",
  "unknown",
] as const;

/**
 * System prompt is identical across every request from every user, which is
 * exactly the case prompt caching is built for (see project plan, "Strategia
 * de prompt Claude Haiku 4.5"). Anthropic's minimum cacheable prefix on
 * Haiku 4.5 is 4096 tokens — the density table + instructions below are
 * padded with explicit guidance to comfortably clear that threshold.
 */
function buildSystemPrompt(): string {
  return `You are a food identification assistant for a nutrition-tracking app.
You will be shown a photo of a plate of food. Your job is ONLY to identify what
foods are present — you must NEVER estimate volume, weight, grams, or calories.
Portion volume is computed separately from a depth sensor on the user's device,
and calories/macros come from a nutrition database keyed off the food name.
Guessing numeric quantities yourself would bypass that pipeline and must be avoided.

For each distinct food item visible on the plate, report:
- label: a short, specific description, IN ROMANIAN (e.g. "piept de pui la
  grătar", not just "pui") — the app's users and its nutrition database are
  Romanian, and this label is both shown to the user as-is and used to look
  up real per-food nutrition data, so it must be a natural Romanian food name
- confidence: your identification confidence from 0 to 1
- boundingBox: the item's approximate region in the image, normalized 0-1
  (xMin, yMin, xMax, yMax), where (0,0) is the top-left corner
- estimatedDensityCategory: the single closest match from the density
  reference table below — this tells the app which density (g/cm3) to use
  when converting the depth-derived volume into grams
- textureCues: brief visual notes relevant to density (e.g. "glossy sauce
  coating suggests oil", "loosely piled, lots of air gaps between pieces")
- notes: anything else useful, or null

Also report:
- mixedPlateDetected: true if multiple distinct foods are touching/mixed
  together in a way that makes separating their boundaries hard
- overallConfidence: your overall confidence in the full analysis, 0 to 1

${densityTableAsPromptText()}

Guidance on edge cases:
- If a sauce or dressing coats another food rather than sitting separately,
  report it as a texture cue on that food's entry, not a separate item,
  unless there is a visually distinct pool/portion of it.
- If you cannot identify a food with reasonable confidence, still report your
  best guess but set confidence low rather than omitting the item.
- Composite dishes (curries, casseroles, mixed stir-fries) that cannot be
  cleanly split into components should be reported as a single item using
  the closest overall density category (usually soupStew or unknown), with
  mixedPlateDetected set to true and a note explaining why it wasn't split.
- Never output volume, weight, or calorie numbers under any circumstance —
  those fields do not exist in your output schema and must not appear in notes.`;
}

interface FoodItemResult {
  label: string;
  confidence: number;
  boundingBox: { xMin: number; yMin: number; xMax: number; yMax: number };
  estimatedDensityCategory: (typeof DENSITY_CATEGORY_KEYS)[number];
  textureCues: string;
  notes: string | null;
  /** Best-effort real per-100g nutrition match for [label] (see
   * foodMatching.ts) — null when nothing matched confidently. When present,
   * the client uses these real macros/micronutrients instead of the coarse
   * per-density-category placeholder average. Added after Claude's own
   * response, not part of its output schema. */
  nutritionMatch: FoodProductResult | null;
}

interface AnalyzePhotoResult {
  mixedPlateDetected: boolean;
  overallConfidence: number;
  items: FoodItemResult[];
}

interface AnalyzePhotoRequest {
  imageBase64: string;
  mediaType: "image/jpeg" | "image/png" | "image/webp";
}

const REPORT_TOOL_NAME = "report_food_items";

/**
 * Forcing tool_choice to a single tool is the reliable, long-stable way to
 * get schema-conformant JSON out of the Messages API — the tool's
 * input_schema is enforced on the tool_use block's `input`.
 */
function buildReportTool() {
  return {
    name: REPORT_TOOL_NAME,
    description: "Report the foods identified on the plate, following the exact schema.",
    input_schema: {
      type: "object" as const,
      properties: {
        mixedPlateDetected: { type: "boolean" as const },
        overallConfidence: { type: "number" as const, minimum: 0, maximum: 1 },
        items: {
          type: "array" as const,
          items: {
            type: "object" as const,
            properties: {
              label: { type: "string" as const },
              confidence: { type: "number" as const, minimum: 0, maximum: 1 },
              boundingBox: {
                type: "object" as const,
                properties: {
                  xMin: { type: "number" as const },
                  yMin: { type: "number" as const },
                  xMax: { type: "number" as const },
                  yMax: { type: "number" as const },
                },
                required: ["xMin", "yMin", "xMax", "yMax"],
              },
              estimatedDensityCategory: {
                type: "string" as const,
                enum: [...DENSITY_CATEGORY_KEYS],
              },
              textureCues: { type: "string" as const },
              notes: { type: ["string", "null"] as unknown as "string" },
            },
            required: ["label", "confidence", "boundingBox", "estimatedDensityCategory", "textureCues"],
          },
        },
      },
      required: ["mixedPlateDetected", "overallConfidence", "items"],
    },
  };
}

// TODO(Phase 2): once the app is registered with real attestation providers
// in the Firebase console (Play Integrity for Android; App Attest, which
// needs a paid Apple Developer account, for iOS), turn on
// `enforceAppCheck: true` below. Until then this only *logs* whether a
// request carried a valid App Check token (request.app), to see real-world
// coverage before enforcement can safely go on without locking out the
// app's own Sideloadly test builds. Auth + daily quota are handled below now.
export const analyzePhoto = onCall<AnalyzePhotoRequest>(
  { secrets: [ANTHROPIC_API_KEY], region: "europe-west1", cpu: 1, memory: "512MiB" },
  async (request): Promise<AnalyzePhotoResult> => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Trebuie să fii autentificat pentru a analiza o fotografie.");
    }
    if (!request.app) {
      logger.info("analyzePhoto called without a valid App Check token", { uid: request.auth.uid });
    }
    const { imageBase64, mediaType } = request.data;
    if (!imageBase64 || !mediaType) {
      throw new HttpsError("invalid-argument", "imageBase64 and mediaType are required.");
    }

    // The admin account (see activateAdmin.ts) has unlimited access to
    // every quota-gated function — that's the entire point of the role.
    if (request.auth.token.admin !== true) {
      await checkAndIncrementDailyQuota(
        "photoAnalysisQuota",
        request.auth.uid,
        DAILY_PHOTO_ANALYSIS_LIMIT,
        `Ai atins limita de ${DAILY_PHOTO_ANALYSIS_LIMIT} analize foto pe zi. Încearcă din nou mâine.`,
      );
    }

    const anthropic = new Anthropic({ apiKey: ANTHROPIC_API_KEY.value() });

    const message = await anthropic.messages.create({
      model: "claude-haiku-4-5",
      max_tokens: 1024,
      system: [
        {
          type: "text",
          text: buildSystemPrompt(),
          cache_control: { type: "ephemeral", ttl: "1h" },
        },
      ],
      messages: [
        {
          role: "user",
          content: [
            { type: "image", source: { type: "base64", media_type: mediaType, data: imageBase64 } },
            { type: "text", text: "Analyze this plate and report the foods you see." },
          ],
        },
      ],
      tools: [buildReportTool()],
      tool_choice: { type: "tool", name: REPORT_TOOL_NAME },
    });

    const toolUse = message.content.find((block) => block.type === "tool_use");
    if (!toolUse || toolUse.type !== "tool_use") {
      throw new HttpsError("internal", "Claude did not return a structured tool_use response.");
    }

    const result = toolUse.input as Omit<AnalyzePhotoResult, "items"> & {
      items: Omit<FoodItemResult, "nutritionMatch">[];
    };

    // Run every item's nutrition lookup in parallel — sequential lookups
    // would multiply this call's latency by the plate's item count, and
    // findBestNutritionMatch never throws (see foodMatching.ts), so one
    // slow/failed lookup can't take the rest down with it.
    const items: FoodItemResult[] = await Promise.all(
      result.items.map(async (item) => ({
        ...item,
        nutritionMatch: await findBestNutritionMatch(item.label),
      })),
    );

    return { ...result, items };
  }
);
