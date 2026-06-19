import 'dart:convert';
import 'dart:io';

import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateActivityController extends GetxController {
  var profileImage = Rx<File?>(null);
  var isLoading = false.obs;
  final ImagePicker picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController calController = TextEditingController();
  // final TextEditingController duration = TextEditingController();

  Future<void> pickImage() async {
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }

  Future<void> createActivity() async {
    // 🔹 Trim values
    final name = nameController.text.trim();
    final calories = calController.text.trim();

    // 🔹 Validation
    if (name.isEmpty) {
      AppSnackBar.showSnackBar("Please enter activity name");
      return;
    }

    if (calories.isEmpty) {
      AppSnackBar.showSnackBar("Please enter calories per minute");
      return;
    }

    // 🔹 Check valid number
    if (double.tryParse(calories) == null) {
      AppSnackBar.showSnackBar("Enter valid calories value");
      return;
    }

    var fields = {"name": name, "calories_per_min": calories};

    Map<String, File> files = {};
    if (profileImage.value != null) {
      files["image"] = profileImage.value!;
    }

    try {
      isLoading.value = true;

      print(ApiUrls.createCustomActivity);
      print(fields);
      print(files);

      final response = await ApiServices.multipartRequest(
        ApiUrls.createCustomActivity,
        fields: fields,
        files: files,
      );

      final body = await response.stream.bytesToString();
      print(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        AppSnackBar.showSuccess("Activity created successfully");
      } else {
        AppSnackBar.showSnackBar("Failed to create activity");
      }
    } catch (e) {
      AppSnackBar.showSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
