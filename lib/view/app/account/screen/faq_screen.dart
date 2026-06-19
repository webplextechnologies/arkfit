import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key}); 

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int selectedCategory = 0;

  final List<String> categories = [
    tr("general"),
    tr("account"),
    tr("services"),
    tr("calories"),
  ];

  final List<Map<String, String>> faqList = [
    {
      "q": tr('q1'),
      "a":
          tr("a1"),
    },
    {
      "q": tr('q2'),
      "a": tr('a2'),
    },
    {
      "q": tr('q3'),
      "a": tr('a3'),
    },
    {"q": tr('q4'), "a": tr('a4')},
    {
      "q": tr('q5'),
      "a": tr('a5'),
    },
    {
      "q": tr('q6'),
      "a": tr('a6'),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          tr("faqs"),
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          children: [
            CustomTextField(
              fillColor: Theme.of(context).colorScheme.primary,

              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
              hintText: tr("search"),
              showFocusBorder: false,
            ),
            SizedBox(height: 20.w),
            
            _categoryTabs(),
             SizedBox(height: 16.w),
            Expanded(child: _faqList()),
          ],
        ),
      ),
    );
  }

  // 🏷 Category Chips
  Widget _categoryTabs() {
    return SizedBox(
      height: 42.w,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategory == index;
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: ChoiceChip(
              showCheckmark: false,

              label: Text(categories[index]),
              selected: isSelected,
              selectedColor: AppColors.secondary,
              backgroundColor: Theme.of(context).colorScheme.primary,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),

              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).iconTheme.color,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
              onSelected: (_) {
                setState(() => selectedCategory = index);
              },
            ),
          );
        },
      ),
    );
  }

  // 📚 FAQ List
  Widget _faqList() {
    return ListView.builder(
      itemCount: faqList.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            border: Border.all(color: Colors.white, width: 1.w),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: Theme.of(context).iconTheme.color,
              textColor: Theme.of(context).iconTheme.color,
              collapsedTextColor: Theme.of(context).iconTheme.color,

              title: Text(
                faqList[index]["q"] ?? '',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              childrenPadding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.w),
              children: [
                Text(
                  textAlign: TextAlign.start,
                  faqList[index]["a"]!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
