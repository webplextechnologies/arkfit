import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditDeleteMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EditDeleteMenu({super.key, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      
      color: Theme.of(context).colorScheme.primary,

      icon: const Icon(Icons.more_vert),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).dividerColor, 
          width: 1,
        ),
      ),

      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/Edit.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),

                height: 20,
                width: 20,
              ),
              SizedBox(width: 10),
              Text("Edit"),
            ],
          ),
        ),
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

                height: 20,
                width: 20,
              ),
              SizedBox(width: 10),
              Text("Delete", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}
