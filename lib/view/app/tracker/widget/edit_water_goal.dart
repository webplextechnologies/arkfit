import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/water_tracker_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditWaterGoal extends StatefulWidget {
  final WaterTrackerController waterTrackerController;
  const EditWaterGoal({super.key, required this.waterTrackerController});

  @override
  State<EditWaterGoal> createState() => _EditWaterGoalState();
}

class _EditWaterGoalState extends State<EditWaterGoal> {
 
  @override
  void initState() {
    super.initState();
   // waterController = TextEditingController(text: "250");
  }

  @override
  void dispose() {
   // waterController.dispose();
    super.dispose();
  }

 
  @override
  Widget build(BuildContext context) {
   

    return Padding(
      padding: EdgeInsets.fromLTRB(
        10,
        12,
        10,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Drag Handle
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const SizedBox(height: 16),

          /// Title
          const Text(
            "Edit Water Goal",
            style: TextStyle(
              fontSize: 24,
              //color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

        

          /// Weight Field
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120.w,
                  child: Theme(
                    data: ThemeData(
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: AppColors.secondary,
                        selectionColor: AppColors.secondary.withOpacity(0.3),
                        selectionHandleColor: AppColors.secondary,
                      ),
                    ),
                    child: TextField(
                      cursorColor: AppColors.secondary,
                      controller: widget.waterTrackerController.waterGoalController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  "ml",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 30.w),

          /// Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                      widget.waterTrackerController.addWater();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text("Save", style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
