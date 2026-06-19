import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditSheet extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final VoidCallback onSave; 
  const EditSheet({super.key, required this.controller, required this.title, required this.onSave});

  @override
  State<EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<EditSheet> {
 

  
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
              "Edit ${widget.title}",
              style: TextStyle(
                fontSize: 22.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
      
             SizedBox(height: 20.w),
      
          
            /// Weight Field
            Container(
              width: double.infinity,
             // padding:  EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14.r),
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
                        controller: widget.controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Colors.transparent,
                        ),
                      ),
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
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding:  EdgeInsets.symmetric(vertical: 14.w),
                    ),
                    child:  Text(
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
