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
    this.minValue = -1500,
    this.maxValue = 1500,
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
    // The extra 34px isn't decorative — the thick band pushes the "0" tick
    // label above the semicircle's nominal top edge (radius + half the
    // band width + label offset), so without this margin it gets clipped
    // by the card around the gauge. The bottom anchor (size.height - 24 in
    // the painter) stays put; this only grows the room above.
    final height = width / 2 + 24 + 34;
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
    Color(0xFFE8392E),
    Color(0xFFF6862B),
    Color(0xFFFCD535),
    Color(0xFF8BC53F),
    Color(0xFF2FA84F),
    Color(0xFF1B6B34),
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
    const strokeWidth = 28.0;

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

    // A fine dark-grey contour traced right on the band's own inner and
    // outer edges, drawn on top of the gradient so it reads crisply
    // instead of being softened by the glow layer underneath.
    final borderPaint = Paint()
      ..color = const Color(0xFF5A5A5A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius + strokeWidth / 2), _startAngle, _sweepAngle, false, borderPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - strokeWidth / 2), _startAngle, _sweepAngle, false, borderPaint);

    _drawTicks(canvas, center, radius, strokeWidth);

    if (goalValue != null) {
      _drawGoalMarker(canvas, center, radius, strokeWidth, goalValue!);
    }

    _drawIndicator(canvas, center, radius, strokeWidth, angle: _angleFor(value));
  }

  void _drawTicks(Canvas canvas, Offset center, double radius, double strokeWidth) {
    // 6 major divisions over -1500..1500 gives clean 500-kcal labels;
    // minor ticks split each major segment into 5 (every 100 kcal) —
    // short, unlabeled, just for a sense of scale.
    final majorCount = 6;
    final minorPerMajor = 5;
    final majorStep = (maxValue - minValue) / majorCount;
    final minorStep = majorStep / minorPerMajor;
    final minorPaint = Paint()
      ..color = labelColor.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i <= majorCount * minorPerMajor; i++) {
      if (i % minorPerMajor == 0) continue; // majors are drawn (with labels) below
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

  /// A thin marker at the minimum-deficit target — the scale itself is a
  /// single continuous gradient (red -> dark green) with no separate
  /// "goal zone" tint; this is just a slim white tick crossing the band so
  /// the target position still reads at a glance. The "Ținta: X kcal" text
  /// in the card below the gauge already spells out the number.
  void _drawGoalMarker(Canvas canvas, Offset center, double radius, double strokeWidth, double goal) {
    final angle = _angleFor(goal);
    final dir = Offset(math.cos(angle), math.sin(angle));
    final inner = center + dir * (radius - strokeWidth / 2 - 1);
    final outer = center + dir * (radius + strokeWidth / 2 + 1);

    final glowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(inner, outer, glowPaint);

    final markerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(inner, outer, markerPaint);
  }

  /// A knob that slides along the band's inner border, rather than a
  /// needle reaching down to the pivot — keeps the indicator confined to
  /// the track itself so it never crosses the calorie number underneath.
  /// Its pointed tip reaches exactly to the band's outer edge (the visible
  /// edge of the scale). Dark-on-white (inverse of the white goal marker)
  /// so the two can never be confused for each other on the arc.
  void _drawIndicator(Canvas canvas, Offset center, double radius, double strokeWidth, {required double angle}) {
    final dir = Offset(math.cos(angle), math.sin(angle));
    // Circle rides the band's inner border; the point spans the full band
    // width so its tip lands exactly on the band's outer edge, regardless
    // of strokeWidth.
    final pos = center + dir * (radius - strokeWidth / 2);
    const bodyRadius = 6.5;
    final pointLength = strokeWidth - bodyRadius;
    const pointHalfWidth = 4.0;
    final perp = Offset(-dir.dy, dir.dx);
    final baseCenter = pos + dir * bodyRadius;
    final tip = pos + dir * (bodyRadius + pointLength);
    final point = Path()
      ..moveTo((baseCenter + perp * pointHalfWidth).dx, (baseCenter + perp * pointHalfWidth).dy)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo((baseCenter - perp * pointHalfWidth).dx, (baseCenter - perp * pointHalfWidth).dy)
      ..close();

    final glowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(pos, 9, glowPaint);

    final darkPaint = Paint()..color = const Color(0xFF2B2B2B);
    canvas.drawPath(point, darkPaint);
    canvas.drawCircle(pos, bodyRadius, darkPaint);

    final whiteStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(point, whiteStroke);
    canvas.drawCircle(pos, bodyRadius, whiteStroke);

    canvas.drawCircle(pos, 3.0, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.goalValue != goalValue;
}
