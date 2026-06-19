import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:flutter/material.dart';

class StaticListItem extends StatelessWidget {
  //final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const StaticListItem({
    super.key,
    //required this.icon,
    required this.title,
    this.isSelected = false, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
      color: Colors.white,
         // color: isSelected ? AppColors.primary,.shade50 : Colors.white,
      
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : Colors.black,
                ),
              ),
            ),
            Spacer(),
             isSelected ?
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Icon(
                Icons.check,
                color: AppColors.primary, 
                         ),
             ):SizedBox(),
          ],
        ),
      ),
    );
  }
}
