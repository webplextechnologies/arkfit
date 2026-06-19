import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/account/controller/add_payment_controller.dart';
import 'package:ark_fit_gym/view/app/account/screen/review_summary.dart';
import 'package:ark_fit_gym/view/widgets/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChoosePaymentMethod extends StatefulWidget {
  final String amount;
  const ChoosePaymentMethod({super.key, required this.amount});

  @override
  State<ChoosePaymentMethod> createState() => _ChoosePaymentMethodState();
}

class _ChoosePaymentMethodState extends State<ChoosePaymentMethod> {
  late AddPaymentController addPaymentController;
 
 @override
  void initState() {
    addPaymentController = Get.put(AddPaymentController());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          tr("add_payment_method"),
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add, color: Theme.of(context).iconTheme.color!),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
          /*   SizedBox(height: 20.w),
            SizedBox(
              height: 75.w,
              child: ListView(
                scrollDirection: Axis.horizontal,

                children: [
                  // SizedBox(width: 10.w),
                  socialTile(
                    "assets/icons/paypal.png",
                    "PayPal",
                    "andrew.ainsley@yourdomain.com",
                    "Linked",
                  ),
                  
                  SizedBox(width: 12.w),
               
                  socialTile(
                    "assets/icons/mastercard.png",
                    "Mastercard",
                    "•••• •••• •••• •••• 4679",
                    "Linked",
                  ),
                  SizedBox(width: 12.w),
                  socialTile(
                    "assets/icons/visa.png",
                    "Visa",
                    "•••• •••• •••• •••• 4679",
                    "Linked",
                  ),
                  SizedBox(width: 12.w),
                  socialTile(
                    "assets/icons/googlepay.png",
                    "Google Pay",
                    "andrew.ainsley@yourdomain.com",
                    "Linked",
                  ),
                   SizedBox(width: 12.w),
                     socialTile(
                    "assets/icons/applepay.png",
                    "Apple Pay",
                    "andrew.ainsley@yourdomain.com",
                    "Linked",
                  ),

                 
                ],
              ),
            ), */
            SizedBox(height: 20.w),
            CustomTextField(
               controller: addPaymentController.cardNumberController,
              label: tr("card_number"),
              hintText: "1234567890123456",
              //keyboardType: TextInputType.number,
              fillColor: Theme.of(context).colorScheme.primary,
              maxLength: 16,
            ),
            SizedBox(height: 20.w),
            CustomTextField(
               controller: addPaymentController.cardHolderNameController,
              label: tr("card_holder_name"),
              hintText: tr("enter_card_holder_name"),

             fillColor: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 20.w),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Expanded(
                  child: CustomTextField(
                    controller: addPaymentController.dateController,
                    label: tr("expiry_date"),
                    hintText: "10",
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    showFocusBorder: false,
                    fillColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 16.w),
                Transform.translate(
                  offset: const Offset(0, 8),
                  child: Text(
                    "/",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomTextField(
                    controller: addPaymentController.yearController,
                    maxLength: 2,
                    
                    label: "",
                    keyboardType: TextInputType.number,
                    hintText: "25",
                    showFocusBorder: false,
                    fillColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomTextField(
                    controller: addPaymentController.cvvController,
                    label: tr("cvv"),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    hintText: "***",
                    showFocusBorder: false,
                    fillColor: Theme.of(context).colorScheme.primary,
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
            title: tr("continue"),
            onPressed: () {
             addPaymentController.createPayment(widget.amount);
            // Get.to(() => ReviewSummary()); // Navigate to
            },
          ),
        ),
      ),
    );
  }
  //andrew.ainsley@yourdomain.com

  Widget socialTile(
    String icon,
    String title,
    String subtitle,
    String trailing,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        //padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: ClipOval(
            child: Image.asset(
              icon,
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
            ),
          ),
        ) /*  Row(
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
                      // color: AppColors.text,
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
          ],
        ), */,
      ),
    );
  }
}
