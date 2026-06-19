import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/circular_loader.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/account/screen/confirm_subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ReviewSummary extends StatefulWidget {
  const ReviewSummary({super.key});

  @override
  State<ReviewSummary> createState() => _ReviewSummaryState();
}

class _ReviewSummaryState extends State<ReviewSummary> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text("Review Summary",style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _premiumCard(),
                SizedBox(height: 10),
                Text(
                  "Selected Payment Method",
                  style: TextStyle(
                  //  color: AppColors.textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                socialTile(
                  "assets/icons/mastercard.png",
                  "Mastercard",
                  "•••• •••• •••• •••• 4679",
                  "Change",
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding:  EdgeInsets.fromLTRB(20.w, 22.w, 20.w, 30.w),
              decoration:  BoxDecoration(
               color:
                Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
                Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
         
              ),
              child: CustomButton(
                title: "Continue",
                onPressed: () {
                  print("Continue");
                  onChangePaymentMethod();
                },
              ),
            ),
          ),
        ), //Processing Payment...

        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.1),
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),

                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //CircularProgressIndicator(color: AppColors.primary),
                       CircularLoader(),
                        const SizedBox(height: 12),
                        Text(
                          "Processing Payment...",
                          style: TextStyle(
                           // color: AppColors.text,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void onChangePaymentMethod() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isLoading = false;
    });

    Get.to(() => ConfirmSubscription());
  }

  Widget socialTile(
    String icon,
    String title,
    String subtitle,
    String trailing,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.asset(
                icon,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    //color: AppColors.text,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    //color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),

          //
          Text(
            trailing,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _premiumCard() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),

              const Text(
                "ARKfit Premium",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  //color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              RichText(
                text:  TextSpan(
                  children: [
                    TextSpan(
                      text: "\$49.99",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                       // color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: " / year",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        //color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              _feature("Barcode scanner"),
              _feature("Export analytic report PDF"),
              _feature("Micro-nutrient tracker"),
              _feature("Smart AI nutritional suggestions"),
              _feature("Remove ads forever"),
              _feature("Snap Meel calorie detection"),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Text(
              "Save 16%",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
           Icon(Icons.check, size: 20, color: Theme.of(context).iconTheme.color!),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style:  TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
               // color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
