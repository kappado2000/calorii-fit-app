import 'package:flutter/material.dart';

/// The color a day's calorie deficit should be shown in — dark green for a
/// deficit well beyond the daily target, green right at the target, amber
/// for a smaller-than-planned (but still positive) deficit, and red the
/// moment the day crosses into surplus (consumed more than burned). Used
/// both for the daily gauge card's border and for the intake chart's bars,
/// so a given deficit always reads as the same color everywhere.
Color deficitStatusColor(double trueDeficit, double goalDeficit) {
  const red = Color(0xFFE0503C);
  const amber = Color(0xFFE8A23C);
  const green = Color(0xFF3FAE5C);
  const darkGreen = Color(0xFF1B6B34);

  if (trueDeficit < 0) return red;
  if (goalDeficit <= 0) return green;

  if (trueDeficit < goalDeficit) {
    final t = (trueDeficit / goalDeficit).clamp(0.0, 1.0);
    return Color.lerp(amber, green, t)!;
  }

  // Beyond the target: green deepens toward dark green, capped at 2x the
  // goal so an exceptional day doesn't need an unbounded scale to look
  // meaningfully "darker" than a day that just barely met the target.
  final t = ((trueDeficit - goalDeficit) / goalDeficit).clamp(0.0, 1.0);
  return Color.lerp(green, darkGreen, t)!;
}
