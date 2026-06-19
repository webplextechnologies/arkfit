import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteMenu extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteMenu({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Theme.of(context).colorScheme.primary,
      icon: const Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(
          color: Theme.of(context).dividerColor,
          width: 1.w,
        ),
      ),
      onSelected: (value) {
        if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/Delete.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.red,
                  BlendMode.srcIn,
                ),
                height: 20.w,
                width: 20.w,
              ),
               SizedBox(width: 10.w),
               Text(
                "Delete",
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}