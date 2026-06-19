import 'dart:convert';
import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/tracker/model/step_history_model.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class StepController extends GetxController with WidgetsBindingObserver {
  final Health health = Health();

  RxInt steps = 0.obs;
  RxBool isLoading = false.obs;
  RxList<StepHistoryList> stepHistoryList = <StepHistoryList>[].obs;
  RxString date = ''.obs;
  RxBool isPermissionDenied = false.obs;
  var selectedDate = DateTime.now().obs;

  //Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);
    Future.delayed(const Duration(seconds: 1), () {
      initHealth();
    });

    /*   _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchTodayStepsFromHealth();
    }); */
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint(" App resumed → fetching steps");
      fetchTodayStepsFromHealth();
    }
  }

  // ==========================
  // INITIALIZATION & PERMISSIONS
  // ==========================

  Future<void> initHealth() async {
    try {
      debugPrint("🚀 Initializing Health Flow...");

      // 1. MUST CHECK PHYSICAL ACTIVITY FIRST
      // This allows the app to access the phone's pedometer hardware.
      bool activityPermission = await _checkAndRequestActivity();
      if (!activityPermission) {
        isPermissionDenied.value = true;
        // Note: _checkAndRequestActivity already shows the dialog if denied
        return;
      }

      // 2. Check SDK Status
      HealthConnectSdkStatus? status = await health.getHealthConnectSdkStatus();

      if (status == HealthConnectSdkStatus.sdkUnavailable) {
        debugPrint("❌ This device does not support Health Connect.");
        return;
      }

      if (status ==
          HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired) {
        debugPrint("⚠️ Health Connect needs an update.");
        await health.installHealthConnect();
        return;
      }

      // 3. Request Health Connect Data Permissions (Steps)
      if (status == HealthConnectSdkStatus.sdkAvailable) {
        bool healthPermission = await requestHealthPermission();

        if (!healthPermission) {
          isPermissionDenied.value = true;
          _showPermissionDialog("Health Connect Permissions");
          return;
        }

        // Everything granted!
        isPermissionDenied.value = false;
        await fetchTodayStepsFromHealth();
        await fetchStepsHistory();
      }
    } catch (e) {
      debugPrint("❌ initHealth error: $e");
    }
  }

  // Helper to handle Activity Permission and "Permanently Denied" status
  Future<bool> _checkAndRequestActivity() async {
    var status = await Permission.activityRecognition.status;

    if (status.isPermanentlyDenied) {
      _showSettingsDialog("Physical Activity");
      return false;
    }

    if (!status.isGranted) {
      status = await Permission.activityRecognition.request();
    }

    return status.isGranted;
  }

  // Shows a dialog if they deny it
  void _showPermissionDialog(String type) {
    Get.defaultDialog(
      title: "Permission Required",
      titleStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black, // Or your preferred title color
      ),
      middleText:
          "ARKfit needs $type permission to track your daily steps accurately.",
      middleTextStyle: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700),
      backgroundColor: Colors.white,
      radius: 12.r,
      contentPadding: EdgeInsets.all(20.w),

      // Customize the "Grant" Button
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          initHealth();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        ),
        child: Text(
          "Grant",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primary), // Border matches primary
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        ),
        child: Text(
          "Cancel",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Shows a dialog if they clicked "Don't ask again"
  void _showSettingsDialog(String type) {
    Get.defaultDialog(
      title: "Permission Locked",
      middleText:
          "You have denied $type permission. Please enable it in Settings to use the step counter.",
      textConfirm: "Open Settings",
      textCancel: "Later",
      confirmTextColor: Colors.white,
      onConfirm: () {
        openAppSettings();
        Get.back();
      },
    );
  }

  Future<bool> requestHealthPermission() async {
    try {
      final types = [HealthDataType.STEPS];
      final permissions = [HealthDataAccess.READ];

      // This triggers the Health Connect UI overlay
      bool granted = await health.requestAuthorization(
        types,
        permissions: permissions,
      );

      return granted;
    } catch (e) {
      debugPrint("❌ Health Authorization error: $e");
      return false;
    }
  }

  Future<void> fetchStepsHistory({DateTime? selectedDate}) async {
    try {
      isLoading.value = true;

      String url;

      if (selectedDate != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        url = "${ApiUrls.stepsHistory}?date=$formattedDate";
      } else {
        url = ApiUrls.stepsHistory; // ✅ No query param
      }

      final response = await ApiServices.getRequest(url);

      print(url);

      // final response = await ApiServices.getRequest(ApiUrls.stepsHistory);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        StepHistoryModel model = StepHistoryModel.fromJson(jsonResponse);

        stepHistoryList.value = model.data ?? [];
        date.value = model.date ?? '';
        if (selectedDate != null) {
          if (model.data != null && model.data!.isNotEmpty) {
            steps.value = int.tryParse(model.data!.first.steps ?? '0') ?? 0;
          } else {
            steps.value = 0;
          }
        }
        print(response.body);
        debugPrint("📊 History loaded successfully");
      }
    } catch (e) {
      print(e.toString());
      debugPrint("❌ History error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  int lastSyncedSteps = -1;

  Future<void> fetchTodayStepsFromHealth() async {
    try {
      DateTime now = DateTime.now();
      DateTime midnight = DateTime(now.year, now.month, now.day);

      int? fetchedSteps = await health.getTotalStepsInInterval(midnight, now);

      if (fetchedSteps != null) {
        steps.value = fetchedSteps;

        if (fetchedSteps != lastSyncedSteps) {
          debugPrint("🆕 New steps detected ($fetchedSteps). Syncing...");
          if (fetchedSteps != 0) {
            await sendStepsToApi(fetchedSteps);
          }
        } else {
          debugPrint(
            "😴 Steps haven't changed ($fetchedSteps). Skipping API sync.",
          );
        }
      }
    } catch (e) {
      debugPrint("❌ fetchTodaySteps error: $e");
    }
  }

  Future<void> sendStepsToApi(int currentSteps) async {
    try {
      var body = {
        "steps": currentSteps,
        // "date": "2026-03-19", // Ensure your API uses this date as a Unique Key
      };

      var response = await ApiServices.postRequest(
        ApiUrls.addSteps,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ Record that this specific number was synced
        lastSyncedSteps = currentSteps;
        debugPrint("✅ Steps synced to Server: $currentSteps");
      }
    } catch (e) {
      debugPrint("❌ API Sync error: $e");
    }
  }

  Future<bool> removeSteps(String stepsId) async {
    try {
      final response = await ApiServices.deleteRequest(
        "${ApiUrls.deleteSteps}$stepsId",
      );

      if (response.statusCode == 200) {
        await fetchStepsHistory();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("❌ Delete error: $e");
      return false;
    }
  }

  /*  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  } */
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}

/* class StepController extends GetxController {
  RxInt steps = 0.obs;
  int _apiSteps = 0;
  RxString status = 'unknown'.obs;
  var stepHistoryList = <StepHistoryList>[].obs;
  var date = ''.obs;

  StreamSubscription<StepCount>? _stepSub;
  StreamSubscription<PedestrianStatus>? _statusSub;

  int _initialSteps = 0;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initPedometer();
  }

  Future<void> todayStepsSummary() async {
    print("todayStepsSummary");
    try {
      isLoading.value = true;

      final response = await ApiServices.getRequest(ApiUrls.todaySteps);

      final jsonResponse = jsonDecode(response.body);
      print(ApiUrls.todaySteps);

      if (response.statusCode == 200) {
        // steps.value = jsonResponse["steps"] ?? 0;
        _apiSteps = jsonResponse["steps"] ?? 0;
        steps.value = _apiSteps;
        print(response.body);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch steps");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initPedometer() async {
    await _requestPermission();

    _statusSub = Pedometer.pedestrianStatusStream.listen(
      (PedestrianStatus event) {
        String previousStatus = status.value;
        status.value = event.status;

        print('🚶 Pedestrian status: ${event.status}');

        /// When walking stops → send steps to API
        if (previousStatus == "walking" && event.status == "stopped") {
          print("🛑 Walking stopped → sending steps to API");
          sendStepsToApi(steps.value);
        }
      },
      onError: (e) {
        status.value = 'error';
        print('❌ Status error: $e');
      },
    );

    _stepSub = Pedometer.stepCountStream.listen(
      (StepCount event) {
        if (_initialSteps == 0) {
          _initialSteps = event.steps;
          print('🔹 Initial system steps: $_initialSteps');
          return;
        }

        // steps.value = event.steps - _initialSteps;
        int newSteps = event.steps - _initialSteps;

        steps.value = _apiSteps + newSteps;

        print('👣 System steps: ${event.steps}');
        print('📊 App steps: ${steps.value}');
      },
      onError: (e) {
        steps.value = 0;
        print('❌ Step count error: $e');
      },
    );
  }

 
  Future<void> _requestPermission() async {
    final status = await Permission.activityRecognition.status;

    if (status.isDenied) {
      await Permission.activityRecognition.request();
    }
  }

  Future<void> sendStepsToApi(int steps) async {
    try {
      var body = {"steps": steps};

      print(body);
      print(ApiUrls.addSteps);

      var response = await ApiServices.postRequest(
        ApiUrls.addSteps,
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        //AppSnackBar.showSuccess(" $steps steps updated successfully");
        print(response.body);
      }

      print("✅ Steps sent to API: $response");
    } catch (e) {
      print("❌ Error sending steps: $e");
    }
  }

  Future<void> fetchStepsHistory() async {
    print("fetchStepsHistory");
    try {
      isLoading.value = true;
      final response = await ApiServices.getRequest(ApiUrls.stepsHistory);
      final jsonResponse = jsonDecode(response.body);
      print(ApiUrls.stepsHistory);

      if (response.statusCode == 200) {
        StepHistoryModel model = StepHistoryModel.fromJson(jsonResponse);
        stepHistoryList.value = model.data ?? [];
        date.value = model.date ?? '';
        print(response.body);
      }
    } catch (e) {
      print("Failed to fetch steps history: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> removeSteps(stepsId) async {
    try {
      final response = await ApiServices.deleteRequest(
        "${ApiUrls.deleteSteps}$stepsId",
      );
      print("${ApiUrls.deleteSteps}$stepsId");

      if (response.statusCode == 200) {
        print(response.body);
        fetchStepsHistory();
        AppSnackBar.showSuccess("Steps successfully deleted!");
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("delete step error: $e");
      return false;
    }
  }

  @override
  void onClose() {
    _stepSub?.cancel();
    _statusSub?.cancel();
    super.onClose();
  }
}
 */
