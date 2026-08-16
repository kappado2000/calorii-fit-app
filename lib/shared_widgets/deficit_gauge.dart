import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A semi-circular "speedometer" gauge for today's calorie deficit —
/// red on the left (surplus / over-eating), yellow at the top-center
/// (roughly break-even), green on the right (a healthy deficit). The
/// needle swings toward red the moment consumption pushes the day into
/// surplus, which is the whole point: a glance should tell you which side
/// of the line you're on, not just a number.
class DeficitGauge extends StatelessWidget {
  const DeficitGauge({
    super.key,
    required this.deficit,
    this.goalDeficit,
    this.minValue = -800,
    this.maxValue = 800,
    this.width = 280,
  });

  /// Positive = in deficit (good), negative = in surplus (over target).
  final double deficit;

  /// Where the user's daily target deficit sits — shown as a small marker
  /// on the arc, if known.
  final double? goalDeficit;

  final double minValue;
  final double maxValue;
  final double width;

  @override
  Widget build(BuildContext context) {
    final height = width / 2 + 24;
    return SizedBox(
      width: width,
      height: height,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: deficit),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, animatedDeficit, child) {
          return CustomPaint(
            painter: _GaugePainter(
              value: animatedDeficit,
              minValue: minValue,
              maxValue: maxValue,
              goalValue: goalDeficit,
              trackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              labelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.goalValue,
    required this.trackColor,
    required this.labelColor,
  });

  final double value;
  final double minValue;
  final double maxValue;
  final double? goalValue;
  final Color trackColor;
  final Color labelColor;

  static const _startAngle = math.pi; // pointing left
  static const _sweepAngle = math.pi; // sweeps over the top to pointing right

  static const _gaugeColors = [
    Color(0xFFE0503C),
    Color(0xFFE8A23C),
    Color(0xFFE8D23C),
    Color(0xFF8FCB5C),
    Color(0xFF3FAE5C),
  ];

  double _angleFor(double v) {
    final t = ((v - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
    return _startAngle + t * _sweepAngle;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 24);
    final radius = math.min(size.width / 2, size.height - 24) - 12;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const strokeWidth = 16.0;

    final arcPaint = Paint()
      ..shader = SweepGradient(
        startAngle: _startAngle,
        endAngle: _startAngle + _sweepAngle,
        colors: _gaugeColors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _startAngle, _sweepAngle, false, arcPaint);

    _drawTicks(canvas, center, radius, strokeWidth);

    if (goalValue != null) {
      _drawGoalMarker(canvas, center, radius, strokeWidth, goalValue!);
    }

    _drawNeedle(canvas, center, radius - strokeWidth / 2 - 6);
  }

  void _drawTicks(Canvas canvas, Offset center, double radius, double strokeWidth) {
    final tickCount = 8;
    final step = (maxValue - minValue) / tickCount;
    final textStyle = TextStyle(color: labelColor, fontSize: 10);

    for (var i = 0; i <= tickCount; i++) {
      final v = minValue + step * i;
      final angle = _angleFor(v);
      final outer = center + Offset(math.cos(angle), math.sin(angle)) * (radius + strokeWidth / 2 + 2);
      final labelPos = center + Offset(math.cos(angle), math.sin(angle)) * (radius + strokeWidth / 2 + 14);

      final label = v == 0 ? '0' : (v > 0 ? '+${v.round()}' : '${v.round()}');
      final painter = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, outer.translate(-painter.width / 2, 0) + (labelPos - outer) - Offset(0, painter.height / 2));
    }
  }

  void _drawGoalMarker(Canvas canvas, Offset center, double radius, double strokeWidth, double goal) {
    final angle = _angleFor(goal);
    final markerPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final inner = center + Offset(math.cos(angle), math.sin(angle)) * (radius - strokeWidth / 2 - 2);
    final outer = center + Offset(math.cos(angle), math.sin(angle)) * (radius + strokeWidth / 2 + 2);
    canvas.drawLine(inner, outer, markerPaint);
  }

  void _drawNeedle(Canvas canvas, Offset center, double length) {
    final angle = _angleFor(value);
    final tip = center + Offset(math.cos(angle), math.sin(angle)) * length;

    final needlePaint = Paint()
      ..color = const Color(0xFF2B2B2B)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, tip, needlePaint);

    canvas.drawCircle(center, 7, Paint()..color = const Color(0xFF2B2B2B));
    canvas.drawCircle(center, 3.5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.goalValue != goalValue;
}
