import 'dart:convert';
import 'dart:io';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/dashboard/scanner_screen.dart';
import 'package:ark_fit_gym/view/app/home/model/scanned_food_model.dart';
import 'package:ark_fit_gym/view/app/scanner/product_details_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  void changeTab(int index) {
    currentIndex.value = index;
  }

  RxBool isPremiumUser = false.obs;
  late SharedPreferences prefs;

 
  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    super.onInit();
    loadPremiumStatus();
  }

  void loadPremiumStatus() {
    isPremiumUser.value = prefs.getBool('isPremium') ?? false;
  }

  Future<void> scanFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      String path = pickedFile.path.toLowerCase();

      if (!(path.endsWith('.jpg') ||
          path.endsWith('.jpeg') ||
          path.endsWith('.png') ||
          path.endsWith('.webp'))) {
        Get.snackbar("Invalid Image", "Only JPG, JPEG, PNG, WEBP supported");
        return;
      }

      isLoading.value = true;

      File imageFile = File(pickedFile.path);

      await uploadFoodImage(imageFile);
    } catch (e) {
      debugPrint("Camera error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadFoodImage(File imageFile) async {
    var files = {"image": imageFile};

    final response = await ApiServices.multipartRequest(
      ApiUrls.scanFood,
      files: files,
    );
    print(files);

    var responseData = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseData);

    if (jsonResponse["status"] == true) {
      ScannedFoodModel model = ScannedFoodModel.fromJson(jsonResponse);
      print(jsonResponse);
      Get.to(() => ProductDetailScreen(scannedFood: model.data!));
    } else {
      Get.snackbar(
        "Scan Failed",
        jsonResponse["message"] ?? "Image is not a food item",
      );
    }
  }

  void showScanOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              border: Border(top: BorderSide(color: Colors.white, width: 1)),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                scanOptionTile(
                  icon: Icons.qr_code_scanner,
                  title: tr("scan_barcode"),
                  onTap: () {
                    print("Scan Barcode tapped");
                    Get.back();
                    Get.to (() => ScannerScreen());
                  },
                ),
                scanOptionTile(
                  icon: Icons.camera_alt,
                  title: tr("scan_food"),
                  onTap: () {
                    print("Scan Food tapped");
                    Get.back();
                    scanFromCamera();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget scanOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.w),
        padding: EdgeInsets.all(16.w),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 30.w,
              // color: Colors.white,
            ),
            SizedBox(height: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                //color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
