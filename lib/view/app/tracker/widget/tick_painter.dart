import 'dart:math';
import 'package:flutter/material.dart';

class ArcTickPainter extends CustomPainter {
  final int tickCount;
  final double radius;
  final double startAngle; // in degrees
  final double sweepAngle; // in degrees

  ArcTickPainter({
    this.tickCount = 30,
    this.radius = 70,
    this.startAngle = 140,
    this.sweepAngle = 260, // major arc
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final startRad = startAngle * pi / 180;
    final sweepRad = sweepAngle * pi / 180;

    for (int i = 0; i < tickCount; i++) {
      double angle =
          startRad + (sweepRad / (tickCount - 1)) * i;

      final start = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      final end = Offset(
        center.dx + (radius + 6) * cos(angle),
        center.dy + (radius + 6) * sin(angle),
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
