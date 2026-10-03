import 'dart:math';
import 'package:flutter/material.dart';

class SunArcPainter extends CustomPainter {
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime currentTime;

  SunArcPainter({
    required this.sunrise,
    required this.sunset,
    required this.currentTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = size.width / 2 - 20;

    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Draw the full half-circle dashed line (below horizon)
    _drawDashedArc(canvas, arcRect, pi, pi, bgPaint);

    final totalMinutes = sunset.difference(sunrise).inMinutes;
    final currentMinutes = currentTime.difference(sunrise).inMinutes;
    double progress = totalMinutes > 0 ? currentMinutes / totalMinutes : 0.0;
    progress = progress.clamp(0.0, 1.0);

    final sweepAngle = pi * progress;

    final arcGradient = SweepGradient(
      startAngle: pi,
      endAngle: 2 * pi,
      colors: [Colors.orange[300]!, Colors.yellow[400]!, Colors.orange[300]!],
    );

    final arcPaint = Paint()
      ..shader = arcGradient.createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    if (progress > 0) {
      canvas.drawArc(arcRect, pi, sweepAngle, false, arcPaint);
    }

    final sunAngle = pi + sweepAngle;
    final sunX = center.dx + radius * cos(sunAngle);
    final sunY = center.dy + radius * sin(sunAngle);

    final sunPaint = Paint()
      ..color = Colors.yellow[600]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(sunX, sunY), 8, sunPaint);
    canvas.drawCircle(Offset(sunX, sunY), 14, sunPaint..color = Colors.yellow.withOpacity(0.4));
  }

  void _drawDashedArc(Canvas canvas, Rect rect, double startAngle, double sweepAngle, Paint paint) {
    const double dashWidth = 0.05;
    const double dashSpace = 0.05;
    double currentAngle = startAngle;

    while (currentAngle < startAngle + sweepAngle) {
      canvas.drawArc(rect, currentAngle, dashWidth, false, paint);
      currentAngle += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant SunArcPainter oldDelegate) {
    return oldDelegate.sunrise != sunrise ||
           oldDelegate.sunset != sunset ||
           oldDelegate.currentTime != currentTime;
  }
}
