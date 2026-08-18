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
    Color(0xFFEF6F63),
    Color(0xFFF3AE5D),
    Color(0xFFF0D869),
    Color(0xFFA3D677),
    Color(0xFF4CB674),
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

    final trackPaint = Paint()
      ..color = trackColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _startAngle, _sweepAngle, false, trackPaint);

    final glowPaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.35)
      ..shader = SweepGradient(
        startAngle: _startAngle,
        endAngle: _startAngle + _sweepAngle,
        colors: _gaugeColors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawArc(rect, _startAngle, _sweepAngle, false, glowPaint);

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

    _drawIndicator(canvas, center, radius, angle: _angleFor(value));
  }

  void _drawTicks(Canvas canvas, Offset center, double radius, double strokeWidth) {
    // Minor ticks every 1/4 of a major step (matching the reference watch
    // face's denser scale) — short, unlabeled, just for a sense of scale.
    final majorCount = 8;
    final majorStep = (maxValue - minValue) / majorCount;
    final minorStep = majorStep / 4;
    final minorPaint = Paint()
      ..color = labelColor.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i <= majorCount * 4; i++) {
      if (i % 4 == 0) continue; // majors are drawn (with labels) below
      final v = minValue + minorStep * i;
      final angle = _angleFor(v);
      final dir = Offset(math.cos(angle), math.sin(angle));
      final inner = center + dir * (radius + strokeWidth / 2 - 1);
      final outer = center + dir * (radius + strokeWidth / 2 + 5);
      canvas.drawLine(inner, outer, minorPaint);
    }

    final textStyle = TextStyle(color: labelColor, fontSize: 10);
    for (var i = 0; i <= majorCount; i++) {
      final v = minValue + majorStep * i;
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

  /// The goal marker — a bright white pill straddling the track at the
  /// minimum-deficit target, matching the reference gauge's white "Goal"
  /// highlight, with a soft glow so it reads as the standout marker on the
  /// otherwise flat-colored arc.
  void _drawGoalMarker(Canvas canvas, Offset center, double radius, double strokeWidth, double goal) {
    final angle = _angleFor(goal);
    final dir = Offset(math.cos(angle), math.sin(angle));
    final inner = center + dir * (radius - strokeWidth / 2 - 3);
    final outer = center + dir * (radius + strokeWidth / 2 + 3);

    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.butt
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawLine(inner, outer, glowPaint);

    final markerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(inner, outer, markerPaint);
  }

  /// A puck that slides along the arc's own centerline, rather than a
  /// needle reaching down to the pivot — keeps the indicator confined to
  /// the track itself so it never crosses the calorie number underneath.
  /// Dark-on-white (inverse of the white goal marker) so the two can never
  /// be confused for each other on the arc.
  void _drawIndicator(Canvas canvas, Offset center, double radius, {required double angle}) {
    final dir = Offset(math.cos(angle), math.sin(angle));
    final pos = center + dir * radius;

    final glowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(pos, 12, glowPaint);

    canvas.drawCircle(pos, 10.5, Paint()..color = const Color(0xFF2B2B2B));
    canvas.drawCircle(pos, 10.5, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(pos, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.goalValue != goalValue;
}
