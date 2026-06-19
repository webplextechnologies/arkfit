import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color!),
        ),
        centerTitle: true,
        title: Text("Add New Payment",style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
        actions: [
          SizedBox(
            height: 30,
            width: 30,
            child: SvgPicture.asset(
              'assets/icons/Scan.svg',
              colorFilter: ColorFilter.mode(
                Theme.of(context).iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            CustomTextField(
              label: "Card Number",
              hintText: "Enter card number",

              fillColor: Colors.grey.shade100,
            ),

            const SizedBox(height: 20),
            CustomTextField(
              label: "Account Holder Name",
              hintText: "Enter account holder name",

              fillColor: Colors.grey.shade100,
            ),

            const SizedBox(height: 20),

            /// Serving & Unit
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: "Expiry Date",
                    hintText: "e.g. 12/25",

                    fillColor: Colors.grey.shade100,
                    suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    label: "CVV",
                    hintText: "e.g. 123",

                    fillColor: Colors.grey.shade100,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(thickness: 0.5),
            SizedBox(height: 20),

            Text(
              "Supported Payments:",
              style: TextStyle(
                //color: AppColors.text,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: SvgPicture.asset('assets/icons/Mastercard Icon.svg'),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: SvgPicture.asset('assets/icons/visa_icon.svg'),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: SvgPicture.asset('assets/icons/amazon_icon.svg'),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/american.svg',
                      height: 25,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/jcb_icon.svg',
                      height: 25,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
          decoration: BoxDecoration(
            color:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: CustomButton(
            title: "Save",
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ),
    );
  }
}
