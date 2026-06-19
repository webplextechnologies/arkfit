/* import 'package:flutter/material.dart';

class WaterDropFill extends StatelessWidget {
  final double level;
  final double width;
  final double height;

  const WaterDropFill({
    super.key,
    required this.level,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    double fillHeight = height * level;

    if (level > 0 && fillHeight < height * 0.08) {
      fillHeight = height * 0.08;
    }
    return Transform.rotate(
      angle: 0.0,
      child: SizedBox(
        width: width,
        height: height,
        //width: 75,
        //height: 96,
        child: Stack(
          children: [
            CustomPaint(
              //size:  Size((width +15), (height+24)),
              size: Size(width, height),
              //90, 120
              painter: WaterDropBorderPainter(),
            ),
            ClipPath(
              clipper: WaterDropClipper(),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(color: Colors.grey.shade200),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    // height:  height* level, // 0.0 → 1.0
                    height: level == 0
                        ? 0.0
                        : (height * level).clamp(18.0, height),
                    
                    width: width,
                    color: const Color(0xff8EDBFF),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaterDropBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..isAntiAlias = true;

    final path = WaterDropClipper().getClip(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaterDropClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();

    // Top sharp point
    path.moveTo(w / 2, 0);

    // Right side curve (top → right-bottom)
    path.cubicTo(
      w * 0.95,
      h * 0.25, // control point 1
      w * 1.05,
      h * 0.55, // control point 2
      w * 0.75,
      h * 0.8, // right bottom edge
    );

    // Bottom curved arc (right → left)
    path.quadraticBezierTo(
      w / 2,
      h * 0.95, // bottom center (curve depth)
      w * 0.25,
      h * 0.8, // left bottom edge
    );

    // Left side curve (left-bottom → top)
    path.cubicTo(
      -w * 0.05,
      h * 0.55, // control point 1
      w * 0.05,
      h * 0.25, // control point 2
      w / 2,
      0, // back to top
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
 */

import 'dart:math';
import 'package:flutter/material.dart';

class WaterDropFill extends StatefulWidget {
  final double level; // 0.0 → 1.0
  final double width;
  final double height;

  const WaterDropFill({
    super.key,
    required this.level,
    required this.width,
    required this.height,
  });

  @override
  State<WaterDropFill> createState() => _WaterDropFillState();
}

class _WaterDropFillState extends State<WaterDropFill>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // infinite animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          /// Border
          CustomPaint(
            size: Size(widget.width, widget.height),
            painter: WaterDropBorderPainter(),
          ),

          /// Water Fill with Wave Animation
          ClipPath(
            clipper: WaterDropClipper(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(color: Colors.grey.shade200),

                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(widget.width, widget.height),
                      painter: WavePainter(
                        level: widget.level,
                        animationValue: _controller.value,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double level;
  final double animationValue;

  WavePainter({required this.level, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.shader = const LinearGradient(
      colors: [Color(0xff6FD3FF), Color(0xff3ABEFF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();

    double boostedLevel = pow(level, 0.6).toDouble();

    double safeLevel = boostedLevel < 0.08 && boostedLevel > 0
        ? 0.08
        : boostedLevel;

    double waterHeight = size.height * (1 - safeLevel);

    double waveHeight = size.height * 0.03; 

    path.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      double y =
          sin((i / size.width * 2 * pi) + (animationValue * 2 * pi)) *
          waveHeight;

      path.lineTo(i, waterHeight + y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}

class WaterDropBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..isAntiAlias = true;

    final path = WaterDropClipper().getClip(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WaterDropClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();

    /// Top point
    path.moveTo(w / 2, 0);

    /// Right curve
    path.cubicTo(w * 0.95, h * 0.25, w * 1.05, h * 0.55, w * 0.75, h * 0.8);

    /// Bottom curve
    path.quadraticBezierTo(w / 2, h * 0.95, w * 0.25, h * 0.8);

    /// Left curve
    path.cubicTo(-w * 0.05, h * 0.55, w * 0.05, h * 0.25, w / 2, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
