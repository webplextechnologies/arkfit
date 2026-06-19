import 'dart:convert';
import 'dart:developer';

import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account/screen/payment_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPaymentController extends GetxController {
  var cardNumberController = TextEditingController();
  var dateController = TextEditingController();
  var yearController = TextEditingController();
  var cvvController = TextEditingController();
  var cardHolderNameController = TextEditingController();
  var isLoading = false.obs;

  Future<void> createPayment(String amount) async {
    if (cardHolderNameController.text.trim().isEmpty ||
        cardNumberController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        yearController.text.trim().isEmpty ||
        cvvController.text.trim().isEmpty) {
      AppSnackBar.showSnackBar("All fields are required");
      return;
    }

    var body = {
      "amount": amount,
      "name": cardHolderNameController.text,
      "card": cardNumberController.text,
      "cvv": cvvController.text,
      "expiry": "${yearController.text}${dateController.text}",
    };
    print(body);

    try {
      isLoading.value = true;

      final response = await ApiServices.postRequest(
        ApiUrls.createPayment,
       // body: body,
      );

      final json = jsonDecode(response.body);
      log(response.body);
     print(response.statusCode);
        if (json["status"] == true) {
      String html = json["html"];

      final result = await Get.to(() => PaymentWebView(html));

      if (result == true) {
        AppSnackBar.showSuccess("Payment Successful ✅");
      } else {
        AppSnackBar.showSnackBar("Payment Failed ❌");
      }
    } else {
      AppSnackBar.showSnackBar(json["message"] ?? "Payment failed");
    }
    } catch (e) {
      debugPrint("Create payment error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
