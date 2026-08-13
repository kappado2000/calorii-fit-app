import 'package:flutter/material.dart';

/// Design tokens that go beyond what a Material 3 [ColorScheme] covers —
/// gradients for hero surfaces (daily gauge card, onboarding) and a fixed
/// palette for multi-series charts/macros, where colors need to stay
/// consistent and distinguishable rather than derived from the seed color.
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.heroGradient,
    required this.warningGradient,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.burned,
    required this.cardShadow,
  });

  final Gradient heroGradient;
  final Gradient warningGradient;
  final Color protein;
  final Color carbs;
  final Color fat;
  final Color burned;
  final Color cardShadow;

  static const _protein = Color(0xFFE0724A);
  static const _carbs = Color(0xFF3E8DDD);
  static const _fat = Color(0xFFE0B84A);

  factory AppColors.light() {
    return AppColors(
      heroGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF12805C), Color(0xFF1FAE7E)],
      ),
      warningGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFC65D3B), Color(0xFFE0844A)],
      ),
      protein: _protein,
      carbs: _carbs,
      fat: _fat,
      burned: const Color(0xFFB65CD1),
      cardShadow: const Color(0x1A0B3D2E),
    );
  }

  factory AppColors.dark() {
    return AppColors(
      heroGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0E5A40), Color(0xFF17835F)],
      ),
      warningGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF8A3F27), Color(0xFFB4602F)],
      ),
      protein: _protein,
      carbs: _carbs,
      fat: _fat,
      burned: const Color(0xFFB65CD1),
      cardShadow: const Color(0x40000000),
    );
  }

  @override
  AppColors copyWith({
    Gradient? heroGradient,
    Gradient? warningGradient,
    Color? protein,
    Color? carbs,
    Color? fat,
    Color? burned,
    Color? cardShadow,
  }) {
    return AppColors(
      heroGradient: heroGradient ?? this.heroGradient,
      warningGradient: warningGradient ?? this.warningGradient,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      burned: burned ?? this.burned,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      heroGradient: Gradient.lerp(heroGradient, other.heroGradient, t)!,
      warningGradient: Gradient.lerp(warningGradient, other.warningGradient, t)!,
      protein: Color.lerp(protein, other.protein, t)!,
      carbs: Color.lerp(carbs, other.carbs, t)!,
      fat: Color.lerp(fat, other.fat, t)!,
      burned: Color.lerp(burned, other.burned, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
