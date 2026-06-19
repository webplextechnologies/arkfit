import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/account/model/onboarding_data_model.dart'
    hide Profile;
import 'package:ark_fit_gym/view/app/account/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PersonalInfoController extends GetxController {
  Rx<File?> localImage = Rx<File?>(null);
  RxString networkImage = ''.obs;
  var isLoading = false.obs;
  var profile = Profile().obs;
  var onboardingData = OnboardingData().obs;

  final ImagePicker _picker = ImagePicker();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // User (readonly)
  final genderController = TextEditingController();
  final dobController = TextEditingController();

  // Profile (readonly)
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final targetWeightController = TextEditingController();
  final goalController = TextEditingController();
  final activityController = TextEditingController();
  final dietController = TextEditingController();
  final bmiController = TextEditingController();
  final calorieController = TextEditingController();
  // Meal Times
  final breakfastController = TextEditingController();
  final lunchController = TextEditingController();
  final snackController = TextEditingController();
  final dinnerController = TextEditingController();
  @override
  void onInit() {
    fetchOnboardingData();
    fetchProfile();
    super.onInit();
  }

  Future<void> pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      localImage.value = File(picked.path);
    }
  }

  Future<void> fetchOnboardingData() async {
    print("fetchOnboarding");
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.getOnboardingData);
      final jsonResponse = jsonDecode(response.body);
      print(ApiUrls.getOnboardingData);
      if (response.statusCode == 200) {
        OnboardingDataModel model = OnboardingDataModel.fromJson(jsonResponse);
        onboardingData.value = model.data!;
        _bindDataToFields(model.data!);
        print(response.body);
      }
    } catch (e) {
      AppSnackBar.showSnackBar("Failed to fetch profile");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final response = await ApiServices.getRequest(ApiUrls.getProfile);
      final jsonResponse = jsonDecode(response.body);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        ProfileModel model = ProfileModel.fromJson(jsonResponse);
        profile.value = model.data!;
        bindProfileImage(model.data!);
      }
    } catch (e) {
      print("fetchProfile : $e");
      Get.snackbar("Error", "Failed to fetch profile");
    } finally {
      isLoading.value = false;
    }
  }

  void _bindDataToFields(OnboardingData data) {
    final user = data.user;
    final profile = data.profile;

    // Editable
    firstNameController.text = user?.firstName ?? '';
    lastNameController.text = user?.lastName ?? '';
    emailController.text = user?.email ?? '';

    // Readonly - User
    genderController.text = user?.gender ?? '';
    dobController.text = formatDate(user?.dateOfBirth ?? '');

    // Readonly - Profile
    heightController.text = "${profile?.heightCm ?? ''} cm";
    weightController.text = "${profile?.weightKg ?? ''} kg";
    targetWeightController.text = "${profile?.targetWeightKg ?? ''} kg";
    goalController.text = profile?.goal ?? '';
    activityController.text = profile?.activityLevel ?? '';
    dietController.text = profile?.dietType ?? '';
    bmiController.text = profile?.bmi ?? '';
    calorieController.text = profile?.dailyCalorieTarget ?? '';

    breakfastController.text = profile?.breakfastTime ?? '';
    lunchController.text = profile?.lunchTime ?? '';
    snackController.text = profile?.snackTime ?? '';
    dinnerController.text = profile?.dinnerTime ?? '';
  }

  void bindProfileImage(Profile profile) {
    phoneController.text = profile.phone ?? '';
    networkImage.value = profile.profileImage ?? '';
  }

  String formatDate(String? inputDate) {
    if (inputDate == null || inputDate.trim().isEmpty) {
      return "-:-";
    }

    try {
      DateTime parsedDate = DateTime.parse(inputDate);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return "-:-";
    }
  }

  Future<void> updateProfile() async {

    print("updateProfile");
    String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateFormat('dd/MM/yyyy').parse(dobController.text.trim()));
    var fields = {
      "first_name": firstNameController.text.trim(),
      "last_name": lastNameController.text.trim(),
      //"email": emailController.text.trim(),
      "date_of_birth": "$formattedDate",
      "phone": phoneController.text.trim(),
      "gender": genderController.text.trim(),
    };
    Map<String, File> files = {};

    if (localImage.value != null) {
      files["profile"] = localImage.value!;
    }
    try {
      isLoading.value = true;
      print(ApiUrls.getProfile);

      final response = await ApiServices.multipartRequest(
        ApiUrls.getProfile,
        fields: fields,
        files: files,
      );
      log(fields.toString());
      log(files.toString());

      final body = await response.stream.bytesToString();
      print(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        AppSnackBar.showSuccess("Profile updated successfully");
      } else {
        print("error");
        AppSnackBar.showSnackBar("Failed to update profile");
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
      AppSnackBar.showSnackBar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
