import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalorieTrackerCard extends StatelessWidget {
  const CalorieTrackerCard({super.key});

  Widget circleStat({
    required String value,
    required String label,
    String? subLabel,
    double size = 90,
  }) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 4),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style:  TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subLabel != null)
                  Text(
                    subLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Date Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Icon(Icons.arrow_back_ios, size: 16),
              SizedBox(width: 8),
              Text(
                "Today, Dec 22",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 8),
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),

          const SizedBox(height: 24),

          /// Top Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children:  [
                  Text("🍽 Eaten"),
                 SizedBox(height: 4.h),
                  Text("0 kcal",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "2560",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "kcal left",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                children:  [
                  Text("🔥 Burned"),
                 SizedBox(height: 4.h),
                  Text("0 kcal",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          /// Macros
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Eaten",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              circleStat(value: "0", label: "Carbs", subLabel: "/ 224 g"),
              circleStat(value: "0", label: "Protein", subLabel: "/ 128 g"),
              circleStat(value: "0", label: "Fat", subLabel: "/ 128 g"),
            ],
          ),

          const SizedBox(height: 32),

          /// Burned
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Burned",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.directions_walk),
                    SizedBox(width: 8),
                    Text("Walking"),
                    Spacer(),
                    Text(
                      "0 kcal",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.fitness_center),
                    SizedBox(width: 8),
                    Text("Activity"),
                    Spacer(),
                    Text(
                      "0 kcal",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.orange,
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
