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
export interface GenericFoodItem {
  name: string;
  kcalPer100g: number;
  proteinPer100g: number;
  carbsPer100g: number;
  fatPer100g: number;
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
  { name: "Ou fiert", kcalPer100g: 155, proteinPer100g: 13, carbsPer100g: 1.1, fatPer100g: 11 },
  { name: "Ou moale", kcalPer100g: 148, proteinPer100g: 12.5, carbsPer100g: 0.8, fatPer100g: 10.5 },
  { name: "Ou ochi / Ochiuri", kcalPer100g: 196, proteinPer100g: 13.6, carbsPer100g: 0.8, fatPer100g: 15.3 },
  { name: "Omletă simplă", kcalPer100g: 165, proteinPer100g: 11, carbsPer100g: 1.5, fatPer100g: 12.5 },
  { name: "Omletă cu cașcaval", kcalPer100g: 220, proteinPer100g: 14, carbsPer100g: 1.5, fatPer100g: 17.5 },
  { name: "Ou jumări / Scrob", kcalPer100g: 180, proteinPer100g: 12, carbsPer100g: 1.5, fatPer100g: 14 },

  // --- Carne la grătar / cuptor ---
  { name: "Ceafă de porc la grătar", kcalPer100g: 280, proteinPer100g: 22, carbsPer100g: 0, fatPer100g: 21 },
  { name: "Piept de porc la grătar", kcalPer100g: 260, proteinPer100g: 21, carbsPer100g: 0, fatPer100g: 19 },
  { name: "Cârnați la grătar", kcalPer100g: 300, proteinPer100g: 14, carbsPer100g: 3, fatPer100g: 26 },
  { name: "Mititei / Mici", kcalPer100g: 260, proteinPer100g: 18, carbsPer100g: 2, fatPer100g: 20 },
  { name: "Piept de pui la grătar", kcalPer100g: 165, proteinPer100g: 31, carbsPer100g: 0, fatPer100g: 3.6 },
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
  { name: "Măr", kcalPer100g: 52, proteinPer100g: 0.3, carbsPer100g: 14, fatPer100g: 0.2 },
  { name: "Banană", kcalPer100g: 89, proteinPer100g: 1.1, carbsPer100g: 23, fatPer100g: 0.3 },
  { name: "Portocală", kcalPer100g: 47, proteinPer100g: 0.9, carbsPer100g: 12, fatPer100g: 0.1 },
  { name: "Pară", kcalPer100g: 57, proteinPer100g: 0.4, carbsPer100g: 15, fatPer100g: 0.1 },
  { name: "Struguri", kcalPer100g: 69, proteinPer100g: 0.7, carbsPer100g: 18, fatPer100g: 0.2 },
  { name: "Căpșuni", kcalPer100g: 32, proteinPer100g: 0.7, carbsPer100g: 7.7, fatPer100g: 0.3 },
  { name: "Pepene roșu", kcalPer100g: 30, proteinPer100g: 0.6, carbsPer100g: 8, fatPer100g: 0.2 },
  { name: "Pepene galben", kcalPer100g: 34, proteinPer100g: 0.8, carbsPer100g: 8, fatPer100g: 0.2 },
  { name: "Kiwi", kcalPer100g: 61, proteinPer100g: 1.1, carbsPer100g: 15, fatPer100g: 0.5 },
  { name: "Piersică", kcalPer100g: 39, proteinPer100g: 0.9, carbsPer100g: 10, fatPer100g: 0.3 },
  { name: "Prună", kcalPer100g: 46, proteinPer100g: 0.7, carbsPer100g: 11, fatPer100g: 0.3 },
  { name: "Cireșe", kcalPer100g: 63, proteinPer100g: 1.1, carbsPer100g: 16, fatPer100g: 0.2 },
  { name: "Mandarine", kcalPer100g: 53, proteinPer100g: 0.8, carbsPer100g: 13, fatPer100g: 0.3 },
  { name: "Lămâie", kcalPer100g: 29, proteinPer100g: 1.1, carbsPer100g: 9, fatPer100g: 0.3 },
  { name: "Ananas", kcalPer100g: 50, proteinPer100g: 0.5, carbsPer100g: 13, fatPer100g: 0.1 },
  { name: "Roșii", kcalPer100g: 18, proteinPer100g: 0.9, carbsPer100g: 3.9, fatPer100g: 0.2 },
  { name: "Castraveți", kcalPer100g: 15, proteinPer100g: 0.7, carbsPer100g: 3.6, fatPer100g: 0.1 },
  { name: "Morcovi", kcalPer100g: 41, proteinPer100g: 0.9, carbsPer100g: 10, fatPer100g: 0.2 },
  { name: "Ceapă", kcalPer100g: 40, proteinPer100g: 1.1, carbsPer100g: 9, fatPer100g: 0.1 },
  { name: "Usturoi", kcalPer100g: 149, proteinPer100g: 6.4, carbsPer100g: 33, fatPer100g: 0.5 },
  { name: "Varză albă", kcalPer100g: 25, proteinPer100g: 1.3, carbsPer100g: 6, fatPer100g: 0.1 },
  { name: "Ardei gras", kcalPer100g: 20, proteinPer100g: 1, carbsPer100g: 4.6, fatPer100g: 0.2 },
  { name: "Vinete", kcalPer100g: 25, proteinPer100g: 1, carbsPer100g: 6, fatPer100g: 0.2 },
  { name: "Dovlecei", kcalPer100g: 17, proteinPer100g: 1.2, carbsPer100g: 3.1, fatPer100g: 0.3 },
  { name: "Broccoli", kcalPer100g: 34, proteinPer100g: 2.8, carbsPer100g: 7, fatPer100g: 0.4 },
  { name: "Conopidă", kcalPer100g: 25, proteinPer100g: 1.9, carbsPer100g: 5, fatPer100g: 0.3 },
  { name: "Fasole verde", kcalPer100g: 31, proteinPer100g: 1.8, carbsPer100g: 7, fatPer100g: 0.1 },
  { name: "Mazăre verde", kcalPer100g: 81, proteinPer100g: 5.4, carbsPer100g: 14, fatPer100g: 0.4 },
  { name: "Sfeclă roșie", kcalPer100g: 43, proteinPer100g: 1.6, carbsPer100g: 10, fatPer100g: 0.2 },
  { name: "Ridichi", kcalPer100g: 16, proteinPer100g: 0.7, carbsPer100g: 3.4, fatPer100g: 0.1 },
  { name: "Salată verde", kcalPer100g: 15, proteinPer100g: 1.4, carbsPer100g: 2.9, fatPer100g: 0.2 },
  { name: "Ciuperci champignon", kcalPer100g: 22, proteinPer100g: 3.1, carbsPer100g: 3.3, fatPer100g: 0.3 },
];
