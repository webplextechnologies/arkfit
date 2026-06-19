import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditFoodSheet extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final List<String> units;

  const EditFoodSheet({
    super.key,
    required this.controller,
    required this.onSave, 
    required this.units,
    
  });

  @override
  State<EditFoodSheet> createState() => _EditFoodSheetState();
}

class _EditFoodSheetState extends State<EditFoodSheet> {
  String selectedUnit = "g";

  final List<String> units = [
    "Gram",
    "Bowl",
    "Spoon",
    "Piece",
    "Cup",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20.w,
          12.w,
          20.w,
          MediaQuery.of(context).viewInsets.bottom + 20.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Drag Handle
            Container(
              height: 4.w,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),

            SizedBox(height: 16.w),

            /// Title
            Text(
              "Edit Food",
              style: TextStyle(
                fontSize: 22.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 20.w),

            /// 🔢 Value + Unit Row
            Container(
              padding: EdgeInsets.symmetric(vertical: 14.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Number Input
                  SizedBox(
                    width: 100.w,
                    child: TextField(
                      controller: widget.controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  /// Unit Dropdown
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: selectedUnit,
                    underline: const SizedBox(),
                    items: widget.units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(
                          unit,
                          style: TextStyle(
                            fontSize: 18.sp,
                             color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedUnit = value!;
                      });
                    },
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
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.w),
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

                SizedBox(width: 16.w),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSave();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.w),
                    ),
                    child: Text("Save", style: AppTextStyles.button),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}