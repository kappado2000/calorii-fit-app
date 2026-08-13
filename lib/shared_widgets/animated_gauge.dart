import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A circular progress ring that animates its fill whenever [value]
/// changes — used for per-meal and daily calorie indicators. `value` is
/// clamped 0-1; values above 1 (over target) still render a full ring, the
/// color is expected to be chosen by the caller to reflect that. The arc is
/// painted with a subtle gradient sweep rather than a flat color for a
/// livelier, less "raw" look.
class AnimatedGauge extends StatelessWidget {
  const AnimatedGauge({
    super.key,
    required this.value,
    required this.centerText,
    this.centerSubtext,
    this.size = 96,
    this.strokeWidth = 10,
    this.color,
  });

  final double value;
  final String centerText;
  final String? centerSubtext;
  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0, 1.2)),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, child) {
          return CustomPaint(
            painter: _GaugePainter(
              value: animatedValue,
              color: baseColor,
              trackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              strokeWidth: strokeWidth,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    centerText,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  if (centerSubtext != null)
                    Text(
                      centerSubtext!,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.value, required this.color, required this.trackColor, required this.strokeWidth});

  final double value;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  static const _startAngle = -math.pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);

    final sweep = math.pi * 2 * value.clamp(0, 1.0);
    if (sweep <= 0) return;

    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      transform: const GradientRotation(_startAngle),
      colors: [color.withValues(alpha: 0.55), color],
      stops: const [0, 1],
    );
    final valuePaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _startAngle, sweep, false, valuePaint);

    // A soft glow at the leading edge of the arc gives the fill a sense of
    // motion/energy rather than looking like a static pie-chart slice.
    final tipAngle = _startAngle + sweep;
    final tipCenter = Offset(
      center.dx + radius * math.cos(tipAngle),
      center.dy + radius * math.sin(tipAngle),
    );
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth * 0.6);
    canvas.drawCircle(tipCenter, strokeWidth * 0.4, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
