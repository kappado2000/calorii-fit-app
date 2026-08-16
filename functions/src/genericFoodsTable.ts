/**
 * Open Food Facts is a barcode-scan-driven database — anything without
 * packaging (home-cooked dishes, loose alcohol) is structurally absent, not
 * just poorly ranked. Confirmed live for two categories: alcoholic
 * beverages (a well-known wine producer had one entry with zero nutrition
 * fields) and eggs ("omleta" returned zero results; "ou fiert" returned 35
 * results, none of them actually a boiled egg).
 *
 * Eggs and beverages below are standardized enough that one generic value
 * is meaningfully accurate regardless of who made it. Grilled meats and
 * soups are recipe-variable by nature — there's no single truly "correct"
 * ciorbă de burtă — but the user explicitly asked for these covered anyway,
 * so they're included as reasonable Romanian-average estimates rather than
 * omitted; the portion-adjustment step downstream already assumes every
 * value is a starting estimate to correct, not a lab measurement.
 *
 * Values are commonly-cited per-100g figures for each category — the same
 * "reasonable estimate, user corrects portion" model the rest of the app
 * already uses, not lab-measured figures for one specific preparation.
 */
/** Mirrors MicronutrientProfile on the Dart side — same six nutrients, same field names. */
export interface GenericMicronutrients {
  vitaminCMg?: number;
  vitaminDMcg?: number;
  calciumMg?: number;
  ironMg?: number;
  magnesiumMg?: number;
  potassiumMg?: number;
}

export interface GenericFoodItem {
  name: string;
  kcalPer100g: number;
  proteinPer100g: number;
  carbsPer100g: number;
  fatPer100g: number;
  /** Only populated for ~35 whole foods with well-documented values (see
   * micronutrients section below) — composite dishes deliberately don't
   * carry this, for the same reason their macros are rough averages: no
   * single "true" vitamin/mineral value exists for a recipe that varies
   * by household. */
  micronutrients?: GenericMicronutrients;
}

export const genericFoodsTable: GenericFoodItem[] = [
  // --- Alcoholic beverages ---
  { name: "Vin alb sec", kcalPer100g: 66, proteinPer100g: 0.1, carbsPer100g: 0.6, fatPer100g: 0 },
  { name: "Vin alb demisec", kcalPer100g: 75, proteinPer100g: 0.1, carbsPer100g: 4, fatPer100g: 0 },
  { name: "Vin alb dulce", kcalPer100g: 90, proteinPer100g: 0.1, carbsPer100g: 10, fatPer100g: 0 },
  { name: "Vin roșu sec", kcalPer100g: 68, proteinPer100g: 0.1, carbsPer100g: 0.6, fatPer100g: 0 },
  { name: "Vin roșu demisec", kcalPer100g: 78, proteinPer100g: 0.1, carbsPer100g: 4, fatPer100g: 0 },
  { name: "Vin roșu dulce", kcalPer100g: 92, proteinPer100g: 0.1, carbsPer100g: 10, fatPer100g: 0 },
  { name: "Vin rose sec", kcalPer100g: 67, proteinPer100g: 0.1, carbsPer100g: 1, fatPer100g: 0 },
  { name: "Vin rose demisec", kcalPer100g: 76, proteinPer100g: 0.1, carbsPer100g: 4, fatPer100g: 0 },
  { name: "Șampanie / Prosecco brut", kcalPer100g: 65, proteinPer100g: 0.1, carbsPer100g: 1.5, fatPer100g: 0 },
  { name: "Vin fiert", kcalPer100g: 100, proteinPer100g: 0.1, carbsPer100g: 12, fatPer100g: 0 },
  { name: "Bere blondă", kcalPer100g: 43, proteinPer100g: 0.5, carbsPer100g: 3.6, fatPer100g: 0 },
  { name: "Bere neagră", kcalPer100g: 55, proteinPer100g: 0.5, carbsPer100g: 4.5, fatPer100g: 0 },
  { name: "Bere fără alcool", kcalPer100g: 25, proteinPer100g: 0.3, carbsPer100g: 5, fatPer100g: 0 },
  { name: "Vodcă", kcalPer100g: 231, proteinPer100g: 0, carbsPer100g: 0, fatPer100g: 0 },
  { name: "Whisky", kcalPer100g: 250, proteinPer100g: 0, carbsPer100g: 0, fatPer100g: 0 },
  { name: "Rom", kcalPer100g: 220, proteinPer100g: 0, carbsPer100g: 0, fatPer100g: 0 },
  { name: "Gin", kcalPer100g: 235, proteinPer100g: 0, carbsPer100g: 0, fatPer100g: 0 },
  { name: "Țuică / Palincă", kcalPer100g: 290, proteinPer100g: 0, carbsPer100g: 0, fatPer100g: 0 },
  { name: "Coniac / Brandy", kcalPer100g: 240, proteinPer100g: 0, carbsPer100g: 0, fatPer100g: 0 },
  { name: "Lichior", kcalPer100g: 300, proteinPer100g: 0, carbsPer100g: 30, fatPer100g: 0 },

  // --- Eggs (standardized preparations) ---
  {
    name: "Ou fiert",
    kcalPer100g: 155,
    proteinPer100g: 13,
    carbsPer100g: 1.1,
    fatPer100g: 11,
    micronutrients: { vitaminDMcg: 2, calciumMg: 50, ironMg: 1.2, magnesiumMg: 10, potassiumMg: 126 },
  },
  {
    name: "Ou moale",
    kcalPer100g: 148,
    proteinPer100g: 12.5,
    carbsPer100g: 0.8,
    fatPer100g: 10.5,
    micronutrients: { vitaminDMcg: 1.9, calciumMg: 48, ironMg: 1.15, magnesiumMg: 10, potassiumMg: 122 },
  },
  {
    name: "Ou ochi / Ochiuri",
    kcalPer100g: 196,
    proteinPer100g: 13.6,
    carbsPer100g: 0.8,
    fatPer100g: 15.3,
    micronutrients: { vitaminDMcg: 2.2, calciumMg: 52, ironMg: 1.3, magnesiumMg: 11, potassiumMg: 130 },
  },
  {
    name: "Omletă simplă",
    kcalPer100g: 165,
    proteinPer100g: 11,
    carbsPer100g: 1.5,
    fatPer100g: 12.5,
    micronutrients: { vitaminDMcg: 1.8, calciumMg: 55, ironMg: 1.1, magnesiumMg: 10, potassiumMg: 128 },
  },
  { name: "Omletă cu cașcaval", kcalPer100g: 220, proteinPer100g: 14, carbsPer100g: 1.5, fatPer100g: 17.5 },
  { name: "Ou jumări / Scrob", kcalPer100g: 180, proteinPer100g: 12, carbsPer100g: 1.5, fatPer100g: 14 },

  // --- Carne la grătar / cuptor ---
  { name: "Ceafă de porc la grătar", kcalPer100g: 280, proteinPer100g: 22, carbsPer100g: 0, fatPer100g: 21 },
  { name: "Piept de porc la grătar", kcalPer100g: 260, proteinPer100g: 21, carbsPer100g: 0, fatPer100g: 19 },
  { name: "Cârnați la grătar", kcalPer100g: 300, proteinPer100g: 14, carbsPer100g: 3, fatPer100g: 26 },
  { name: "Mititei / Mici", kcalPer100g: 260, proteinPer100g: 18, carbsPer100g: 2, fatPer100g: 20 },
  {
    name: "Piept de pui la grătar",
    kcalPer100g: 165,
    proteinPer100g: 31,
    carbsPer100g: 0,
    fatPer100g: 3.6,
    micronutrients: { calciumMg: 5, ironMg: 0.7, magnesiumMg: 25, potassiumMg: 220 },
  },
  { name: "Pui la cuptor", kcalPer100g: 215, proteinPer100g: 27, carbsPer100g: 0, fatPer100g: 11 },

  // --- Ciorbe / supe ---
  { name: "Ciorbă de burtă", kcalPer100g: 90, proteinPer100g: 6, carbsPer100g: 4, fatPer100g: 6 },
  { name: "Ciorbă țărănească", kcalPer100g: 55, proteinPer100g: 4, carbsPer100g: 6, fatPer100g: 2 },
  { name: "Ciorbă de perișoare", kcalPer100g: 70, proteinPer100g: 5, carbsPer100g: 6, fatPer100g: 3 },
  { name: "Supă cremă de legume", kcalPer100g: 60, proteinPer100g: 1.5, carbsPer100g: 8, fatPer100g: 2.5 },
  { name: "Ciorbă de fasole", kcalPer100g: 85, proteinPer100g: 4.5, carbsPer100g: 12, fatPer100g: 2 },

  // --- Cartofi ---
  { name: "Cartofi prăjiți", kcalPer100g: 312, proteinPer100g: 3.4, carbsPer100g: 41, fatPer100g: 15 },
  { name: "Cartofi copți", kcalPer100g: 93, proteinPer100g: 2.5, carbsPer100g: 21, fatPer100g: 0.1 },
  { name: "Cartofi fierți", kcalPer100g: 87, proteinPer100g: 1.9, carbsPer100g: 20, fatPer100g: 0.1 },

  // --- Paste / Pizza ---
  { name: "Paste fierte simple", kcalPer100g: 131, proteinPer100g: 5, carbsPer100g: 25, fatPer100g: 1.1 },
  { name: "Pizza cu brânză", kcalPer100g: 266, proteinPer100g: 11, carbsPer100g: 33, fatPer100g: 10 },

  // --- Mâncare de casă tradițională (subset comun, din Lista de mâncăruri
  // românești de pe Wikipedia — preparatele foarte regionale/de nișă din
  // acea listă nu sunt incluse aici, pentru ca nu exista o valoare de
  // referinta in care sa am incredere reala pentru ele) ---
  { name: "Mămăligă simplă", kcalPer100g: 70, proteinPer100g: 1.5, carbsPer100g: 15, fatPer100g: 0.5 },
  {
    name: "Mămăligă cu brânză și smântână",
    kcalPer100g: 180,
    proteinPer100g: 7,
    carbsPer100g: 16,
    fatPer100g: 10,
  },
  { name: "Musaca", kcalPer100g: 160, proteinPer100g: 8, carbsPer100g: 12, fatPer100g: 9 },
  { name: "Chiftele", kcalPer100g: 250, proteinPer100g: 15, carbsPer100g: 10, fatPer100g: 17 },
  { name: "Chiftele de pește", kcalPer100g: 200, proteinPer100g: 14, carbsPer100g: 8, fatPer100g: 12 },
  { name: "Papanași", kcalPer100g: 280, proteinPer100g: 8, carbsPer100g: 35, fatPer100g: 12 },
  { name: "Fasole bătută", kcalPer100g: 140, proteinPer100g: 7, carbsPer100g: 20, fatPer100g: 4 },
  { name: "Drob de miel", kcalPer100g: 250, proteinPer100g: 16, carbsPer100g: 4, fatPer100g: 19 },
  { name: "Piftie / Răcitură", kcalPer100g: 150, proteinPer100g: 14, carbsPer100g: 1, fatPer100g: 10 },
  { name: "Ardei umpluți", kcalPer100g: 120, proteinPer100g: 7, carbsPer100g: 12, fatPer100g: 5 },
  { name: "Colțunași cu brânză", kcalPer100g: 210, proteinPer100g: 9, carbsPer100g: 32, fatPer100g: 5 },
  { name: "Tochitură", kcalPer100g: 280, proteinPer100g: 18, carbsPer100g: 5, fatPer100g: 21 },
  { name: "Ghiveci de legume", kcalPer100g: 70, proteinPer100g: 2, carbsPer100g: 10, fatPer100g: 3 },
  { name: "Tocăniță de cartofi", kcalPer100g: 110, proteinPer100g: 3, carbsPer100g: 15, fatPer100g: 4.5 },
  { name: "Tocană / Tocăniță de carne", kcalPer100g: 180, proteinPer100g: 12, carbsPer100g: 8, fatPer100g: 11 },
  { name: "Papricaș de pui", kcalPer100g: 190, proteinPer100g: 16, carbsPer100g: 6, fatPer100g: 11 },
  { name: "Ciulama de pui", kcalPer100g: 160, proteinPer100g: 12, carbsPer100g: 8, fatPer100g: 9 },
  { name: "Rasol de vită", kcalPer100g: 220, proteinPer100g: 26, carbsPer100g: 0, fatPer100g: 12 },
  { name: "Salată de boeuf", kcalPer100g: 260, proteinPer100g: 6, carbsPer100g: 14, fatPer100g: 21 },
  { name: "Zacuscă", kcalPer100g: 140, proteinPer100g: 2, carbsPer100g: 12, fatPer100g: 9 },
  { name: "Bulz", kcalPer100g: 230, proteinPer100g: 9, carbsPer100g: 20, fatPer100g: 13 },
  { name: "Gogoși", kcalPer100g: 330, proteinPer100g: 6, carbsPer100g: 40, fatPer100g: 16 },
  { name: "Plăcintă cu brânză", kcalPer100g: 290, proteinPer100g: 8, carbsPer100g: 35, fatPer100g: 13 },
  { name: "Plăcintă cu mere", kcalPer100g: 250, proteinPer100g: 4, carbsPer100g: 40, fatPer100g: 8 },
  { name: "Frigărui", kcalPer100g: 200, proteinPer100g: 22, carbsPer100g: 2, fatPer100g: 11 },
  { name: "Iahnie de fasole", kcalPer100g: 130, proteinPer100g: 6, carbsPer100g: 18, fatPer100g: 4 },
  { name: "Salată de icre", kcalPer100g: 350, proteinPer100g: 4, carbsPer100g: 6, fatPer100g: 35 },
  { name: "Salată de icre de crap", kcalPer100g: 350, proteinPer100g: 4, carbsPer100g: 6, fatPer100g: 35 },

  // --- Fructe și legume proaspete — spre deosebire de mancarea de casa,
  // valorile nutritionale pentru un fruct/leguma cruda sunt standardizate
  // universal (aceleasi cifre in orice sursa), deci incredere mare aici.
  // Adaugate pentru ca produsele procesate/ambalate domina rezultatele OFF
  // pentru multe dintre ele (ex. "banana" scotea chipsuri, nu fructul). ---
  {
    name: "Măr",
    kcalPer100g: 52,
    proteinPer100g: 0.3,
    carbsPer100g: 14,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 4.6, calciumMg: 6, ironMg: 0.1, magnesiumMg: 5, potassiumMg: 107 },
  },
  {
    name: "Banană",
    kcalPer100g: 89,
    proteinPer100g: 1.1,
    carbsPer100g: 23,
    fatPer100g: 0.3,
    micronutrients: { vitaminCMg: 8.7, calciumMg: 5, ironMg: 0.26, magnesiumMg: 27, potassiumMg: 358 },
  },
  {
    name: "Portocală",
    kcalPer100g: 47,
    proteinPer100g: 0.9,
    carbsPer100g: 12,
    fatPer100g: 0.1,
    micronutrients: { vitaminCMg: 53.2, calciumMg: 40, ironMg: 0.1, magnesiumMg: 10, potassiumMg: 181 },
  },
  {
    name: "Pară",
    kcalPer100g: 57,
    proteinPer100g: 0.4,
    carbsPer100g: 15,
    fatPer100g: 0.1,
    micronutrients: { vitaminCMg: 4.3, calciumMg: 9, ironMg: 0.18, magnesiumMg: 7, potassiumMg: 116 },
  },
  {
    name: "Struguri",
    kcalPer100g: 69,
    proteinPer100g: 0.7,
    carbsPer100g: 18,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 3.2, calciumMg: 10, ironMg: 0.36, magnesiumMg: 7, potassiumMg: 191 },
  },
  {
    name: "Căpșuni",
    kcalPer100g: 32,
    proteinPer100g: 0.7,
    carbsPer100g: 7.7,
    fatPer100g: 0.3,
    micronutrients: { vitaminCMg: 58.8, calciumMg: 16, ironMg: 0.41, magnesiumMg: 13, potassiumMg: 153 },
  },
  {
    name: "Pepene roșu",
    kcalPer100g: 30,
    proteinPer100g: 0.6,
    carbsPer100g: 8,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 8.1, calciumMg: 7, ironMg: 0.24, magnesiumMg: 10, potassiumMg: 112 },
  },
  {
    name: "Pepene galben",
    kcalPer100g: 34,
    proteinPer100g: 0.8,
    carbsPer100g: 8,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 36.7, calciumMg: 9, ironMg: 0.21, magnesiumMg: 12, potassiumMg: 267 },
  },
  {
    name: "Kiwi",
    kcalPer100g: 61,
    proteinPer100g: 1.1,
    carbsPer100g: 15,
    fatPer100g: 0.5,
    micronutrients: { vitaminCMg: 92.7, calciumMg: 34, ironMg: 0.31, magnesiumMg: 17, potassiumMg: 312 },
  },
  {
    name: "Piersică",
    kcalPer100g: 39,
    proteinPer100g: 0.9,
    carbsPer100g: 10,
    fatPer100g: 0.3,
    micronutrients: { vitaminCMg: 6.6, calciumMg: 6, ironMg: 0.25, magnesiumMg: 9, potassiumMg: 190 },
  },
  {
    name: "Prună",
    kcalPer100g: 46,
    proteinPer100g: 0.7,
    carbsPer100g: 11,
    fatPer100g: 0.3,
    micronutrients: { vitaminCMg: 9.5, calciumMg: 6, ironMg: 0.17, magnesiumMg: 7, potassiumMg: 157 },
  },
  {
    name: "Cireșe",
    kcalPer100g: 63,
    proteinPer100g: 1.1,
    carbsPer100g: 16,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 7, calciumMg: 13, ironMg: 0.36, magnesiumMg: 11, potassiumMg: 222 },
  },
  {
    name: "Mandarine",
    kcalPer100g: 53,
    proteinPer100g: 0.8,
    carbsPer100g: 13,
    fatPer100g: 0.3,
    micronutrients: { vitaminCMg: 26.7, calciumMg: 37, ironMg: 0.15, magnesiumMg: 12, potassiumMg: 166 },
  },
  {
    name: "Lămâie",
    kcalPer100g: 29,
    proteinPer100g: 1.1,
    carbsPer100g: 9,
    fatPer100g: 0.3,
    micronutrients: { vitaminCMg: 53, calciumMg: 26, ironMg: 0.6, magnesiumMg: 8, potassiumMg: 138 },
  },
  {
    name: "Ananas",
    kcalPer100g: 50,
    proteinPer100g: 0.5,
    carbsPer100g: 13,
    fatPer100g: 0.1,
    micronutrients: { vitaminCMg: 47.8, calciumMg: 13, ironMg: 0.29, magnesiumMg: 12, potassiumMg: 109 },
  },
  {
    name: "Roșii",
    kcalPer100g: 18,
    proteinPer100g: 0.9,
    carbsPer100g: 3.9,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 13.7, calciumMg: 10, ironMg: 0.27, magnesiumMg: 11, potassiumMg: 237 },
  },
  {
    name: "Castraveți",
    kcalPer100g: 15,
    proteinPer100g: 0.7,
    carbsPer100g: 3.6,
    fatPer100g: 0.1,
    micronutrients: { vitaminCMg: 2.8, calciumMg: 16, ironMg: 0.28, magnesiumMg: 13, potassiumMg: 147 },
  },
  {
    name: "Morcovi",
    kcalPer100g: 41,
    proteinPer100g: 0.9,
    carbsPer100g: 10,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 5.9, calciumMg: 33, ironMg: 0.3, magnesiumMg: 12, potassiumMg: 320 },
  },
  {
    name: "Ceapă",
    kcalPer100g: 40,
    proteinPer100g: 1.1,
    carbsPer100g: 9,
    fatPer100g: 0.1,
    micronutrients: { vitaminCMg: 7.4, calciumMg: 23, ironMg: 0.21, magnesiumMg: 10, potassiumMg: 146 },
  },
  {
    name: "Usturoi",
    kcalPer100g: 149,
    proteinPer100g: 6.4,
    carbsPer100g: 33,
    fatPer100g: 0.5,
    micronutrients: { vitaminCMg: 31.2, calciumMg: 181, ironMg: 1.7, magnesiumMg: 25, potassiumMg: 401 },
  },
  {
    name: "Varză albă",
    kcalPer100g: 25,
    proteinPer100g: 1.3,
    carbsPer100g: 6,
    fatPer100g: 0.1,
    micronutrients: { vitaminCMg: 36.6, calciumMg: 40, ironMg: 0.47, magnesiumMg: 12, potassiumMg: 170 },
  },
  {
    name: "Ardei gras",
    kcalPer100g: 20,
    proteinPer100g: 1,
    carbsPer100g: 4.6,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 127.7, calciumMg: 7, ironMg: 0.34, magnesiumMg: 10, potassiumMg: 175 },
  },
  {
    name: "Vinete",
    kcalPer100g: 25,
    proteinPer100g: 1,
    carbsPer100g: 6,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 2.2, calciumMg: 9, ironMg: 0.23, magnesiumMg: 14, potassiumMg: 229 },
  },
  {
    name: "Dovlecei",
    kcalPer100g: 17,
    proteinPer100g: 1.2,
    carbsPer100g: 3.1,
    fatPer100g: 0.3,
    micronutrients: { vitaminCMg: 17.9, calciumMg: 16, ironMg: 0.37, magnesiumMg: 18, potassiumMg: 261 },
  },
  {
    name: "Broccoli",
    kcalPer100g: 34,
    proteinPer100g: 2.8,
    carbsPer100g: 7,
    fatPer100g: 0.4,
    micronutrients: { vitaminCMg: 89.2, calciumMg: 47, ironMg: 0.73, magnesiumMg: 21, potassiumMg: 316 },
  },
  {
    name: "Conopidă",
    kcalPer100g: 25,
    proteinPer100g: 1.9,
    carbsPer100g: 5,
    fatPer100g: 0.3,
    micronutrients: { vitaminCMg: 48.2, calciumMg: 22, ironMg: 0.42, magnesiumMg: 15, potassiumMg: 299 },
  },
  {
    name: "Fasole verde",
    kcalPer100g: 31,
    proteinPer100g: 1.8,
    carbsPer100g: 7,
    fatPer100g: 0.1,
    micronutrients: { vitaminCMg: 12.2, calciumMg: 37, ironMg: 1.03, magnesiumMg: 25, potassiumMg: 211 },
  },
  {
    name: "Mazăre verde",
    kcalPer100g: 81,
    proteinPer100g: 5.4,
    carbsPer100g: 14,
    fatPer100g: 0.4,
    micronutrients: { vitaminCMg: 40, calciumMg: 25, ironMg: 1.47, magnesiumMg: 33, potassiumMg: 244 },
  },
  {
    name: "Sfeclă roșie",
    kcalPer100g: 43,
    proteinPer100g: 1.6,
    carbsPer100g: 10,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 4.9, calciumMg: 16, ironMg: 0.8, magnesiumMg: 23, potassiumMg: 325 },
  },
  {
    name: "Ridichi",
    kcalPer100g: 16,
    proteinPer100g: 0.7,
    carbsPer100g: 3.4,
    fatPer100g: 0.1,
    micronutrients: { vitaminCMg: 14.8, calciumMg: 25, ironMg: 0.34, magnesiumMg: 10, potassiumMg: 233 },
  },
  {
    name: "Salată verde",
    kcalPer100g: 15,
    proteinPer100g: 1.4,
    carbsPer100g: 2.9,
    fatPer100g: 0.2,
    micronutrients: { vitaminCMg: 9.2, calciumMg: 36, ironMg: 0.86, magnesiumMg: 13, potassiumMg: 194 },
  },
  {
    name: "Ciuperci champignon",
    kcalPer100g: 22,
    proteinPer100g: 3.1,
    carbsPer100g: 3.3,
    fatPer100g: 0.3,
    micronutrients: { vitaminDMcg: 0.2, calciumMg: 3, ironMg: 0.5, magnesiumMg: 9, potassiumMg: 318 },
  },

  // --- A doua trecere prin Lista de mancaruri romanesti (Wikipedia) —
  // categoriile feluri principale/gustari/salate/sosuri/deserturi/street
  // food acoperite mai complet acum. Raman excluse doar preparatele cu
  // adevarat regionale/de nisa (Storceag, Malasolca, Ceapa de Campina,
  // Palanet, Lichiu cu ceapa, Scordolea, placinta armaneasca/macedoneana,
  // preparate funerare/de Paste ca Colinda, Pasca) — nu am o valoare de
  // referinta credibila pentru ele. ---
  { name: "Brașovence", kcalPer100g: 220, proteinPer100g: 12, carbsPer100g: 8, fatPer100g: 16 },
  { name: "Cașcaval pané", kcalPer100g: 320, proteinPer100g: 20, carbsPer100g: 15, fatPer100g: 20 },
  { name: "Dovlecei pané", kcalPer100g: 180, proteinPer100g: 6, carbsPer100g: 15, fatPer100g: 11 },
  { name: "Dovlecei umpluți", kcalPer100g: 100, proteinPer100g: 6, carbsPer100g: 8, fatPer100g: 5 },
  { name: "Gulii umplute", kcalPer100g: 110, proteinPer100g: 6, carbsPer100g: 10, fatPer100g: 5 },
  { name: "Limbă cu măsline", kcalPer100g: 220, proteinPer100g: 18, carbsPer100g: 2, fatPer100g: 15 },
  { name: "Momițe", kcalPer100g: 130, proteinPer100g: 15, carbsPer100g: 0, fatPer100g: 8 },
  { name: "Ostropel de pui", kcalPer100g: 200, proteinPer100g: 18, carbsPer100g: 4, fatPer100g: 12 },
  { name: "Pastramă de berbecuț", kcalPer100g: 250, proteinPer100g: 24, carbsPer100g: 0, fatPer100g: 17 },
  { name: "Pârjoale moldovenești", kcalPer100g: 250, proteinPer100g: 15, carbsPer100g: 10, fatPer100g: 17 },
  { name: "Plachie de pește", kcalPer100g: 140, proteinPer100g: 14, carbsPer100g: 6, fatPer100g: 6 },
  { name: "Rață pe varză", kcalPer100g: 230, proteinPer100g: 16, carbsPer100g: 6, fatPer100g: 16 },
  { name: "Saramură de pește", kcalPer100g: 150, proteinPer100g: 18, carbsPer100g: 1, fatPer100g: 8 },
  { name: "Sarmale în foi de viță", kcalPer100g: 150, proteinPer100g: 8, carbsPer100g: 12, fatPer100g: 8 },
  { name: "Stufat de miel", kcalPer100g: 220, proteinPer100g: 16, carbsPer100g: 6, fatPer100g: 14 },
  { name: "Tocăniță de mazăre", kcalPer100g: 90, proteinPer100g: 4, carbsPer100g: 12, fatPer100g: 3 },
  { name: "Tocăniță de praz", kcalPer100g: 80, proteinPer100g: 2, carbsPer100g: 10, fatPer100g: 4 },
  { name: "Urzici cu usturoi", kcalPer100g: 45, proteinPer100g: 3, carbsPer100g: 5, fatPer100g: 1.5 },
  { name: "Varză à la Cluj", kcalPer100g: 180, proteinPer100g: 10, carbsPer100g: 8, fatPer100g: 12 },
  { name: "Vinete umplute", kcalPer100g: 110, proteinPer100g: 5, carbsPer100g: 10, fatPer100g: 6 },
  { name: "Jumări", kcalPer100g: 450, proteinPer100g: 25, carbsPer100g: 0, fatPer100g: 38 },
  { name: "Mere cu șuncă", kcalPer100g: 150, proteinPer100g: 8, carbsPer100g: 12, fatPer100g: 8 },
  { name: "Plăcintă cu cartofi", kcalPer100g: 220, proteinPer100g: 5, carbsPer100g: 30, fatPer100g: 9 },
  { name: "Ardei copți", kcalPer100g: 40, proteinPer100g: 1, carbsPer100g: 7, fatPer100g: 1 },
  { name: "Salată de castraveți", kcalPer100g: 25, proteinPer100g: 0.8, carbsPer100g: 4, fatPer100g: 0.5 },
  { name: "Salată orientală", kcalPer100g: 140, proteinPer100g: 2, carbsPer100g: 20, fatPer100g: 6 },
  { name: "Salată de roșii", kcalPer100g: 22, proteinPer100g: 1, carbsPer100g: 4, fatPer100g: 0.3 },
  { name: "Salată de sfeclă", kcalPer100g: 60, proteinPer100g: 1.8, carbsPer100g: 12, fatPer100g: 0.5 },
  { name: "Salată de varză albă", kcalPer100g: 35, proteinPer100g: 1.3, carbsPer100g: 7, fatPer100g: 0.5 },
  { name: "Salată de varză roșie", kcalPer100g: 35, proteinPer100g: 1.3, carbsPer100g: 7, fatPer100g: 0.5 },
  { name: "Mujdei", kcalPer100g: 250, proteinPer100g: 3, carbsPer100g: 8, fatPer100g: 24 },
  { name: "Sos de hrean", kcalPer100g: 150, proteinPer100g: 2, carbsPer100g: 10, fatPer100g: 11 },
  { name: "Amandină", kcalPer100g: 380, proteinPer100g: 5, carbsPer100g: 45, fatPer100g: 20 },
  { name: "Cremșnit / Cremeș", kcalPer100g: 300, proteinPer100g: 5, carbsPer100g: 32, fatPer100g: 17 },
  { name: "Savarină", kcalPer100g: 290, proteinPer100g: 5, carbsPer100g: 38, fatPer100g: 12 },
  { name: "Vargabeleș", kcalPer100g: 250, proteinPer100g: 8, carbsPer100g: 30, fatPer100g: 11 },
  { name: "Șaorma", kcalPer100g: 220, proteinPer100g: 12, carbsPer100g: 20, fatPer100g: 10 },
  { name: "Scovergi", kcalPer100g: 320, proteinPer100g: 6, carbsPer100g: 38, fatPer100g: 15 },

  // --- Bucătărie mediteraneană (greacă, italiană, orientală) — aceeași
  // logică: valori medii uzuale, nu masuratori de laborator pentru o
  // reteta anume. ---
  { name: "Hummus", kcalPer100g: 166, proteinPer100g: 8, carbsPer100g: 14, fatPer100g: 10 },
  { name: "Falafel", kcalPer100g: 333, proteinPer100g: 13, carbsPer100g: 32, fatPer100g: 18 },
  { name: "Tzatziki", kcalPer100g: 65, proteinPer100g: 4, carbsPer100g: 4, fatPer100g: 4 },
  { name: "Salată grecească", kcalPer100g: 110, proteinPer100g: 4, carbsPer100g: 6, fatPer100g: 8 },
  { name: "Tabbouleh", kcalPer100g: 120, proteinPer100g: 3, carbsPer100g: 15, fatPer100g: 6 },
  { name: "Gyros", kcalPer100g: 220, proteinPer100g: 15, carbsPer100g: 12, fatPer100g: 13 },
  { name: "Souvlaki", kcalPer100g: 200, proteinPer100g: 22, carbsPer100g: 3, fatPer100g: 11 },
  { name: "Paella", kcalPer100g: 170, proteinPer100g: 8, carbsPer100g: 22, fatPer100g: 5 },
  { name: "Risotto", kcalPer100g: 175, proteinPer100g: 4, carbsPer100g: 25, fatPer100g: 6 },
  { name: "Lasagna", kcalPer100g: 135, proteinPer100g: 8, carbsPer100g: 12, fatPer100g: 6 },
  { name: "Ratatouille", kcalPer100g: 55, proteinPer100g: 1.5, carbsPer100g: 8, fatPer100g: 2 },
  { name: "Salată Caprese", kcalPer100g: 180, proteinPer100g: 10, carbsPer100g: 4, fatPer100g: 14 },
  { name: "Bruschetta", kcalPer100g: 200, proteinPer100g: 5, carbsPer100g: 25, fatPer100g: 8 },
  { name: "Tiramisu", kcalPer100g: 290, proteinPer100g: 5, carbsPer100g: 28, fatPer100g: 18 },
  { name: "Moussaka grecească", kcalPer100g: 190, proteinPer100g: 9, carbsPer100g: 10, fatPer100g: 13 },
  { name: "Paste Carbonara", kcalPer100g: 195, proteinPer100g: 8, carbsPer100g: 20, fatPer100g: 9 },
  { name: "Paste Bolognese", kcalPer100g: 130, proteinPer100g: 7, carbsPer100g: 15, fatPer100g: 5 },
  { name: "Pesto", kcalPer100g: 450, proteinPer100g: 4, carbsPer100g: 6, fatPer100g: 46 },
  { name: "Minestrone", kcalPer100g: 60, proteinPer100g: 2.5, carbsPer100g: 9, fatPer100g: 1.8 },
  { name: "Tapenade", kcalPer100g: 300, proteinPer100g: 2, carbsPer100g: 6, fatPer100g: 30 },
  { name: "Focaccia", kcalPer100g: 280, proteinPer100g: 7, carbsPer100g: 45, fatPer100g: 8 },

  // --- Pește și fructe de mare (crude/gătite simplu) — aceeași problemă
  // ca la fructe/legume: valorile sunt standardizate universal, dar
  // produsele procesate/ambalate domina rezultatele OFF (confirmat live:
  // "somon"/"creveti" scoteau paste si produse semipreparate). ---
  {
    name: "Somon",
    kcalPer100g: 208,
    proteinPer100g: 20,
    carbsPer100g: 0,
    fatPer100g: 13,
    micronutrients: { vitaminDMcg: 11, calciumMg: 9, ironMg: 0.34, magnesiumMg: 27, potassiumMg: 384 },
  },
  { name: "Ton", kcalPer100g: 132, proteinPer100g: 28, carbsPer100g: 0, fatPer100g: 1.3 },
  { name: "Păstrăv", kcalPer100g: 148, proteinPer100g: 20, carbsPer100g: 0, fatPer100g: 6.6 },
  { name: "Crap", kcalPer100g: 127, proteinPer100g: 17.8, carbsPer100g: 0, fatPer100g: 5.6 },
  { name: "Șalău", kcalPer100g: 92, proteinPer100g: 19, carbsPer100g: 0, fatPer100g: 1 },
  { name: "Cod / Merluciu", kcalPer100g: 82, proteinPer100g: 18, carbsPer100g: 0, fatPer100g: 0.7 },
  { name: "Sardine", kcalPer100g: 208, proteinPer100g: 25, carbsPer100g: 0, fatPer100g: 11 },
  { name: "Macrou", kcalPer100g: 205, proteinPer100g: 19, carbsPer100g: 0, fatPer100g: 14 },
  { name: "Creveți", kcalPer100g: 99, proteinPer100g: 24, carbsPer100g: 0.2, fatPer100g: 0.3 },
  { name: "Calamar", kcalPer100g: 92, proteinPer100g: 15.6, carbsPer100g: 3.1, fatPer100g: 1.4 },
  { name: "Midii", kcalPer100g: 86, proteinPer100g: 12, carbsPer100g: 3.7, fatPer100g: 2.2 },
  { name: "Scoici", kcalPer100g: 77, proteinPer100g: 13, carbsPer100g: 3, fatPer100g: 0.9 },
  { name: "Icre negre / Caviar", kcalPer100g: 264, proteinPer100g: 25, carbsPer100g: 4, fatPer100g: 18 },
  { name: "Fructe de mare (mix)", kcalPer100g: 100, proteinPer100g: 18, carbsPer100g: 3, fatPer100g: 1.5 },
];
