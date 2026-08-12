import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";
import Anthropic from "@anthropic-ai/sdk";
import { densityTableAsPromptText } from "./densityTable";

const ANTHROPIC_API_KEY = defineSecret("ANTHROPIC_API_KEY");

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
- label: a short, specific description (e.g. "grilled chicken breast", not just "chicken")
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

// TODO(Phase 2): require a verified Firebase Auth token + App Check token,
// and add a per-user daily quota (Firestore counter) before calling Claude —
// see "Cloud Functions" section of the project plan. Phase 0/1 leaves this
// open so the pipeline can be exercised without auth wired up yet.
export const analyzePhoto = onCall<AnalyzePhotoRequest>(
  { secrets: [ANTHROPIC_API_KEY], region: "europe-west1", cpu: 1, memory: "512MiB" },
  async (request): Promise<AnalyzePhotoResult> => {
    const { imageBase64, mediaType } = request.data;
    if (!imageBase64 || !mediaType) {
      throw new HttpsError("invalid-argument", "imageBase64 and mediaType are required.");
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

    return toolUse.input as AnalyzePhotoResult;
  }
);
