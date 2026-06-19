import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CircularLoader extends StatefulWidget {
  const CircularLoader({super.key});

  @override
  State<CircularLoader> createState() => _CircularLoaderState();
}

class _CircularLoaderState extends State<CircularLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CustomPaint(
        size: const Size(45, 45), 
        painter: GradientRotationPainter(),
      ),
    );
  }
}

class GradientRotationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 7.0;
    Rect rect = Offset.zero & size;
    
    Paint backgroundPaint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, backgroundPaint);

    Paint paint = Paint()
      ..shader = SweepGradient(
        colors: [
           AppColors.primary.withOpacity(0.0), 
           AppColors.primary,                   
        ],
        stops: const [0.0, 1.0],
        transform: GradientRotation(-pi/4)
      ).createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, 0, 1.5 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}