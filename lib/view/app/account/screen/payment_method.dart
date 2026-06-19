import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_text_style.dart';
import 'package:ark_fit_gym/common/custom_button.dart';
import 'package:ark_fit_gym/view/app/account/screen/add_payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Payment Methods",style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
           SizedBox(height: 10),
          socialTile(
            "assets/icons/paypal.png",
            "PayPal",
            "andrew.ainsley@yourdomain.com",
            "Linked",
          ),
          SizedBox(height: 12),
          socialTile(
            "assets/icons/googlepay.png",
            "Google Pay",
            "andrew.ainsley@yourdomain.com",
            "Linked",
          ),
           SizedBox(height: 12),
          socialTile(
            "assets/icons/applepay.png",
            "Apple Pay",
            "andrew.ainsley@yourdomain.com",
            "Linked",
          ),
         
          SizedBox(height: 10),
          socialTile(
            "assets/icons/mastercard.png",
            "Mastercard",
            "•••• •••• •••• •••• 4679",
            "Linked",
          ),
          SizedBox(height: 10),
          socialTile(
            "assets/icons/visa.png",
            "Visa",
            "•••• •••• •••• •••• 4679",
            "Linked",
          ),
        ],
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
            icon: Icons.add,
            title: " Add New Payment",
            onPressed: () {
              Get.to(() =>  AddPaymentMethod());
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, ),
      child:  Container(
        padding: const EdgeInsets.symmetric( vertical: 10),
        decoration: BoxDecoration(
           color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: Image.asset(icon, width: 60, height: 60,fit: BoxFit.cover,
                
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
                     // color: AppColors.text,
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
                //color: AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
