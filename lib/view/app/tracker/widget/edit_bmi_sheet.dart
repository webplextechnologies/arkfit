import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/view/app/tracker/controller/tracker_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditBMIBottomSheet extends StatefulWidget {
  final String initialHeight;
  final String initialWeight;
  final TrackerController trackerController;
  const EditBMIBottomSheet({super.key, required this.initialHeight, required this.initialWeight, required this.trackerController});

  @override
  State<EditBMIBottomSheet> createState() => _EditBMIBottomSheetState();
}

class _EditBMIBottomSheetState extends State<EditBMIBottomSheet> {
  late TextEditingController heightController;
  late TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    heightController = TextEditingController(text: widget.initialHeight);
    weightController = TextEditingController(text: widget.initialWeight);
  }

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
           Text(
            tr('edit_bmi'),
            style: TextStyle(
              fontSize: 24,
             // color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 24),

          valueCard(title: "${tr("height")}", controller: heightController, unit: "cm"),

          const SizedBox(height: 16),

          valueCard(title: "${tr("weight")}", controller: weightController, unit: "kg"),

          const SizedBox(height: 30),

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
                  child:  Text(
                    tr('cancel'),
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
                  onPressed: () async{
                  await  widget.trackerController.updateBmi(heightController.text, weightController.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(tr('save'), style: AppTextStyles.button),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- VALUE CARD ----------------

  Widget valueCard({
    required String title,
    required TextEditingController controller,
    required String unit,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Editable Value
              SizedBox(
                width: 120,
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
                    controller: controller,
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
                      isDense: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 6),

              Text(
                unit,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
