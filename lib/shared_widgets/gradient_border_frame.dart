import 'package:flutter/material.dart';

/// Wraps [child] in a border that fades from a dark shade of [statusColor]
/// at the outer edge to the surrounding card's own background color at the
/// inner edge — a true perpendicular gradient, which `BorderSide` can't do
/// on its own, approximated with a handful of thin concentric rounded-rect
/// layers (each a flat color, but close enough in number/step-size to read
/// as smooth). Shared between the daily gauge card and the progress-screen
/// chart cards so the same status color always looks the same everywhere.
Widget gradientBorderFrame(
  BuildContext context, {
  required Color statusColor,
  required Widget child,
  double radius = 28,
  int steps = 6,
  double stepThickness = 1.5,
  Color? innerColor,
  Color? outerColor,
}) {
  final darkColor = outerColor ?? Color.lerp(statusColor, Colors.black, 0.35)!;
  final surfaceColor = innerColor ?? Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface;

  var framed = child;
  for (var i = 0; i < steps; i++) {
    final t = i / (steps - 1); // 0 = innermost ring (surface color) .. 1 = outermost ring (dark)
    framed = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Color.lerp(surfaceColor, darkColor, t),
      ),
      padding: EdgeInsets.all(stepThickness),
      child: framed,
    );
  }
  return framed;
}
