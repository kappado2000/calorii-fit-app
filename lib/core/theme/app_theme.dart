import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFF1B9C6E);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);
    // A neutral grey rather than the seed-tinted surfaceContainerLow — the
    // green tint on every card read as washed-out/off, a plain grey card
    // reads as intentional "raised surface" instead.
    final neutralCardColor = isDark ? const Color(0xFF25272B) : const Color(0xFFF1F2F4);
    // Page background (everywhere that isn't a card) — a soft yellow in
    // light mode, matching the app icon's palette. Dark mode keeps the
    // normal dark surface; inverting that to yellow-on-dark isn't what was
    // asked and would clash with dark mode's whole point.
    final pageBackgroundColor = isDark ? colorScheme.surface : const Color(0xFFFFF6DF);
    final baseTextTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).copyWith(
      headlineSmall: GoogleFonts.plusJakartaSans(
        textStyle: baseTextTheme.headlineSmall,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        textStyle: baseTextTheme.titleLarge,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        textStyle: baseTextTheme.titleMedium,
        fontWeight: FontWeight.w600,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: pageBackgroundColor,
      textTheme: textTheme,
      extensions: [isDark ? AppColors.dark() : AppColors.light()],

      appBarTheme: AppBarTheme(
        backgroundColor: pageBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: neutralCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide(color: colorScheme.outlineVariant),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: colorScheme.onPrimaryContainer,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide.none,
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          selectedBackgroundColor: colorScheme.primaryContainer,
          selectedForegroundColor: colorScheme.onPrimaryContainer,
        ),
      ),

      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        trackHeight: 5,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        showDragHandle: true,
      ),

      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant.withValues(alpha: 0.5), space: 1),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.primary),

      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
