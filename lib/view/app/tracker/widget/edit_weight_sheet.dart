import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditWeightSheet extends StatefulWidget {
  const EditWeightSheet({super.key});

  @override
  State<EditWeightSheet> createState() => _EditWeightSheetState();
}

class _EditWeightSheetState extends State<EditWeightSheet> {
  DateTime currentMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  late TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    weightController = TextEditingController(text: "78.4");
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

 

  List<DateTime> getDays() {
    final first = DateTime(currentMonth.year, currentMonth.month, 1);
    return List.generate(
      31,
      (i) => first.add(Duration(days: i)),
    ).where((d) => d.month == currentMonth.month).toList();
  }

  String monthYear(DateTime d) => "${_months[d.month - 1]} ${d.year}";

  final _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  String weekday(DateTime d) =>
      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][d.weekday - 1];

  @override
  Widget build(BuildContext context) {
    final days = getDays();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
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
             Text(
              tr('edit_weight'),
              style: TextStyle(
                fontSize: 24,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
      
            const SizedBox(height: 20),
      
            /// Month Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      currentMonth = DateTime(
                        currentMonth.year,
                        currentMonth.month - 1,
                      );
                    });
                  },
                ),
      
                Text(
                  monthYear(currentMonth),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary
                  ),
                ),
      
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      currentMonth = DateTime(
                        currentMonth.year,
                        currentMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
      
            const SizedBox(height: 14),
      
            /// Calendar Row
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final date = days[index];
                  final isSelected = sameDay(date, selectedDate);
      
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedDate = date);
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weekday(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                        controller: weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
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
                    "kg",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
      
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
                      padding:  EdgeInsets.symmetric(vertical: 14),
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
                    onPressed: () {
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
      ),
    );
  }

  bool sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
