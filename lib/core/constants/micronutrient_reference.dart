/// The six micronutrients tracked across the app — a deliberately small,
/// commonly-referenced set (vitamin C/D, calcium, iron, magnesium,
/// potassium) rather than the full 20+ vitamins/minerals nutrition science
/// tracks, so every value shown has real data behind it instead of being
/// diluted across nutrients most foods have no data for at all.
enum Micronutrient { vitaminC, vitaminD, calcium, iron, magnesium, potassium }

extension MicronutrientInfo on Micronutrient {
  String get label {
    switch (this) {
      case Micronutrient.vitaminC:
        return 'Vitamina C';
      case Micronutrient.vitaminD:
        return 'Vitamina D';
      case Micronutrient.calcium:
        return 'Calciu';
      case Micronutrient.iron:
        return 'Fier';
      case Micronutrient.magnesium:
        return 'Magneziu';
      case Micronutrient.potassium:
        return 'Potasiu';
    }
  }

  String get unit {
    switch (this) {
      case Micronutrient.vitaminD:
        return 'µg';
      default:
        return 'mg';
    }
  }

  /// EU Nutrient Reference Values (NRV) — the same standardized daily
  /// values used on European nutrition labels ("% din doza zilnică"),
  /// rather than US RDA figures, since the app targets a Romanian/EU user.
  double get dailyReferenceValue {
    switch (this) {
      case Micronutrient.vitaminC:
        return 80;
      case Micronutrient.vitaminD:
        return 5;
      case Micronutrient.calcium:
        return 800;
      case Micronutrient.iron:
        return 14;
      case Micronutrient.magnesium:
        return 375;
      case Micronutrient.potassium:
        return 2000;
    }
  }
}

/// Per-100g micronutrient values for one food — every field nullable,
/// since real coverage is inherently partial (see project notes: only
/// Open Food Facts branded products and a curated set of ~35 whole foods
/// carry this data; composite home-cooked dishes deliberately don't,
/// because a single "true" micronutrient value for a recipe that varies by
/// household isn't honest the way an average calorie count already is).
class MicronutrientProfile {
  const MicronutrientProfile({
    this.vitaminCMg,
    this.vitaminDMcg,
    this.calciumMg,
    this.ironMg,
    this.magnesiumMg,
    this.potassiumMg,
  });

  final double? vitaminCMg;
  final double? vitaminDMcg;
  final double? calciumMg;
  final double? ironMg;
  final double? magnesiumMg;
  final double? potassiumMg;

  double? valueFor(Micronutrient nutrient) {
    switch (nutrient) {
      case Micronutrient.vitaminC:
        return vitaminCMg;
      case Micronutrient.vitaminD:
        return vitaminDMcg;
      case Micronutrient.calcium:
        return calciumMg;
      case Micronutrient.iron:
        return ironMg;
      case Micronutrient.magnesium:
        return magnesiumMg;
      case Micronutrient.potassium:
        return potassiumMg;
    }
  }

  bool get hasAnyValue =>
      vitaminCMg != null ||
      vitaminDMcg != null ||
      calciumMg != null ||
      ironMg != null ||
      magnesiumMg != null ||
      potassiumMg != null;

  Map<String, dynamic> toJson() => {
    'vitaminCMg': vitaminCMg,
    'vitaminDMcg': vitaminDMcg,
    'calciumMg': calciumMg,
    'ironMg': ironMg,
    'magnesiumMg': magnesiumMg,
    'potassiumMg': potassiumMg,
  };

  factory MicronutrientProfile.fromJson(Map<String, dynamic> json) {
    return MicronutrientProfile(
      vitaminCMg: (json['vitaminCMg'] as num?)?.toDouble(),
      vitaminDMcg: (json['vitaminDMcg'] as num?)?.toDouble(),
      calciumMg: (json['calciumMg'] as num?)?.toDouble(),
      ironMg: (json['ironMg'] as num?)?.toDouble(),
      magnesiumMg: (json['magnesiumMg'] as num?)?.toDouble(),
      potassiumMg: (json['potassiumMg'] as num?)?.toDouble(),
    );
  }
}

enum MacroNutrient { protein, carbs, fat }

extension MacroNutrientInfo on MacroNutrient {
  String get label {
    switch (this) {
      case MacroNutrient.protein:
        return 'Proteine';
      case MacroNutrient.carbs:
        return 'Carbohidrați';
      case MacroNutrient.fat:
        return 'Grăsimi';
    }
  }

  /// Calories per gram — used to convert a gram total into "% of today's
  /// calories" so it can be compared against [recommendedShareRange].
  double get kcalPerGram {
    switch (this) {
      case MacroNutrient.protein:
      case MacroNutrient.carbs:
        return 4;
      case MacroNutrient.fat:
        return 9;
    }
  }

  /// Acceptable Macronutrient Distribution Range — the standard EFSA/WHO
  /// band for share of daily calories, the same reference mainstream
  /// trackers use for a "balanced macros" indicator.
  (double min, double max) get recommendedShareRange {
    switch (this) {
      case MacroNutrient.protein:
        return (0.10, 0.35);
      case MacroNutrient.carbs:
        return (0.45, 0.60);
      case MacroNutrient.fat:
        return (0.20, 0.35);
    }
  }
}
