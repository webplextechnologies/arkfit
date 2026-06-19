import 'dart:math';
import 'package:flutter/material.dart';


class SpeedometerWidget extends StatelessWidget {
  const SpeedometerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 6),
      child: Transform.rotate(
        angle: 80.1,
        child: CustomPaint(
          size: const Size(140, 80),
          painter: GaugePainter(),
        ),
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;

    // Arc angles
    final startAngle = 5 * pi / 4; // 225°
    final sweepAngle = 3 * pi / 2; // 270°

    // Arc paint
    final arcPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Draw major arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Tick marks
    final tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    const tickCount = 24;
    for (int i = 0; i <= tickCount; i++) {
      final angle = startAngle + (sweepAngle / tickCount) * i;

      final start = Offset(
        center.dx + (radius - 12) * cos(angle),
        center.dy + (radius - 12) * sin(angle),
      );
      final end = Offset(
        center.dx + (radius - 2) * cos(angle),
        center.dy + (radius - 2) * sin(angle),
      );

      canvas.drawLine(start, end, tickPaint);
    }

    // Center orange dot
    final dotPaint = Paint()..color = Colors.orange;
    canvas.drawCircle(center, 8, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
