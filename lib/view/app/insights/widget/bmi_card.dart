import 'dart:math';
import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BmiGauge extends StatelessWidget {
  final double bmi;
  final String title;

  const BmiGauge({super.key, required this.bmi, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1.w),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8.r)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr("bmi"),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  //color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                decoration: BoxDecoration(
                  color: getBmiIndicatorColor(bmi),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 0.3.w),

          SizedBox(height: 20.w),

          Center(
            child: SizedBox(
              height: 200.w,
              width: 200.w,
              child: CustomPaint(
                painter: _BmiGaugePainter(bmi),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 80.w),
                      Text(
                        bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 42.sp,
                          fontWeight: FontWeight.bold,
                          // color: AppColors.textPrimary
                        ),
                      ),
                      Text(
                        tr("bmi"),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          //color: AppColors.textSecondary
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.w),

          _legend(tr("very_severely_underweight"), "${tr("BMI")} < 16.0", Colors.blue),
          _legend(tr("severely_underweight"), "${tr("BMI")} 16.0 - 16.9", Colors.lightBlue),
          _legend(tr("underweight"), "${tr("BMI")} 17.0 - 18.4", Colors.cyan),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.w),
            child: Row(
              children: [
                CircleAvatar(radius: 5.w, backgroundColor: Colors.green),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    tr("normal"),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      // color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  "${tr("BMI")} 18.5 - 24.9",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    // color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // _legend("Normal", "BMI 18.5 - 24.9", Colors.green),
          _legend(tr("overweight"), "${tr("BMI")} 25.0 - 29.9", Colors.amber),
          _legend(tr("obese_class_1"), "${tr("BMI")} 30.0 - 34.9", Colors.orange),
          _legend(tr("obese_class_2"), "${tr("BMI")} 35.0 - 39.9", Colors.deepOrange),
          _legend(tr("obese_class_3"), "${tr("BMI")} ≥ 40.0", Colors.red),

          SizedBox(height: 15.w),
        ],
      ),
    );
  }

  Color getBmiIndicatorColor(double bmi) {
    if (bmi < 16) return Colors.blue;
    if (bmi < 16.9) return Colors.lightBlue;
    if (bmi < 18.4) return Colors.cyan;
    if (bmi < 25) return Colors.green;
    if (bmi < 27.5) return Colors.yellow;
    if (bmi < 30) return Colors.orange;
    if (bmi < 35) return Colors.deepOrange;
    return Colors.red;
  }

  Widget _legend(String text, String range, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.w),
      child: Row(
        children: [
          CircleAvatar(radius: 5.w, backgroundColor: color),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            ),
          ),
          Text(
            range,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class _BmiGaugePainter extends CustomPainter {
  final double bmi;

  _BmiGaugePainter(this.bmi);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.square;

    // Start angle = 135 deg
    double start = 3 * pi / 4;
    double sweep = 3 * pi / 2;

    final ranges = [
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.green,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.red,
    ];

    for (int i = 0; i < ranges.length; i++) {
      stroke.color = ranges[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start + (sweep / ranges.length) * i,
        sweep / ranges.length,
        false,
        stroke,
      );
    }

    // NEEDLE
    /*  double angle = start + (bmi / 50) * sweep;
    final needlePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + cos(angle) * radius * 0.7,
      center.dy + sin(angle) * radius * 0.7,
    );

    canvas.drawLine(center, needleEnd, needlePaint);

    // Center circle
    canvas.drawCircle(center, 10, Paint()..color = Colors.green); */
    // --- NEW BREAKOUT NEEDLE LOGIC ---

    // 1. Breakpoints based on your Legend categories
    final breakpoints = [16.0, 17.0, 18.5, 25.0, 30.0, 35.0, 40.0, 50.0];

    double needlePosition = 0; // Represents which segment (0.0 to 8.0)

    if (bmi < breakpoints[0]) {
      // Very severely underweight (Segment 0-1)
      needlePosition = (bmi / breakpoints[0]).clamp(0.0, 1.0);
    } else if (bmi >= breakpoints[6]) {
      // Obese Class III (Final segment 7-8)
      double progress =
          (bmi - breakpoints[6]) / (breakpoints[7] - breakpoints[6]);
      needlePosition = 7.0 + progress.clamp(0.0, 1.0);
    } else {
      // Middle segments (1 to 7)
      for (int i = 0; i < breakpoints.length - 1; i++) {
        if (bmi >= breakpoints[i] && bmi < breakpoints[i + 1]) {
          double segmentProgress =
              (bmi - breakpoints[i]) / (breakpoints[i + 1] - breakpoints[i]);
          needlePosition = (i + 1) + segmentProgress;
          break;
        }
      }
    }

    // 2. Final Angle Calculation
    // We divide sweep by 8 because there are 8 color arcs drawn
    double angle = start + (needlePosition / 8) * sweep;

    final needlePaint = Paint()
      ..color = Colors
          .green // Using a dark neutral for the needle
      ..strokeWidth = 5.w
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + cos(angle) * radius * 0.75,
      center.dy + sin(angle) * radius * 0.75,
    );

    canvas.drawLine(center, needleEnd, needlePaint);

    // Center pivot point
    canvas.drawCircle(center, 8.r, Paint()..color = Colors.green);
    canvas.drawCircle(center, 4.r, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
