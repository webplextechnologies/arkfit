import 'dart:convert';
import 'dart:io';
import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/common/custom_date_picker.dart';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/insights/model/insights_data_model.dart';
import 'package:ark_fit_gym/view/app/insights/widget/health%20charts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class InsightsController extends GetxController {
  RxInt selectedTab = 0.obs;
  RxBool isLoading = false.obs;
  RxList<InsightsData> analyticsDays = <InsightsData>[].obs;
  HealthMetric? stepsMetric;
  HealthMetric? waterMetric;
  HealthMetric? weightMetric;
  HealthMetric? caloriesMetric;
  var date = ''.obs;
  var bmiGauge = BmiGauge().obs;
  var nutrition = Nutrition().obs;

  final List<String> types = ["weekly", "monthly", "yearly"];
  RxList<Map<String, double>> nutritionChartData = <Map<String, double>>[].obs;
  RxList<String> nutritionLabels = <String>[].obs;

  RxString startDate = ''.obs;
  RxString endDate = ''.obs;
  RxBool isCustomRange = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAnalyticsData();
  }

  double safeInterval(double goal, List<double> values) {
    double maxValue = values.isEmpty
        ? 0
        : values.reduce((a, b) => a > b ? a : b);

    double reference = goal > 0 ? goal : maxValue;

    if (reference <= 0) return 1;

   return (reference / 5).ceilToDouble();
   //return reference + (reference * 0.15);
    
  }

  double safeMaxY(double goal, List<double> values) {
    double maxValue = values.isEmpty
        ? 0
        : values.reduce((a, b) => a > b ? a : b);

    if (goal > 0) return goal;

    if (maxValue > 0) return maxValue + (maxValue * 0.2);

    return 10; // fallback default
  }

  double safeWeightInterval(double goal, List<double> values) {
  double maxValue = values.isEmpty
      ? 0
      : values.reduce((a, b) => a > b ? a : b);

  double reference = maxValue > goal ? maxValue : goal;

  if (reference <= 10) return 1;
  if (reference <= 50) return 5;
  if (reference <= 100) return 10;
  if (reference <= 200) return 20;

  return 50;
}

double safeWeightMaxY(double goal, List<double> values) {
  double maxValue = values.isEmpty
      ? 0
      : values.reduce((a, b) => a > b ? a : b);

  double reference = maxValue > goal ? maxValue : goal;

  if (reference <= 0) return 10;

  return reference + 10; // add headroom
}

  Future<void> getAnalyticsData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      isLoading.value = true;

      String url = ApiUrls.getAnalytics;

      String formatDate(DateTime date) {
        return DateFormat('yyyy-MM-dd').format(date);
      }

      /// ✅ Custom Range (ONLY if dates are NOT null)
      if (isCustomRange.value && startDate != null && endDate != null) {
        String date1 = formatDate(startDate);
        String date2 = formatDate(endDate);

        url = "${ApiUrls.getAnalytics}?start_date=$date1&end_date=$date2";
      } else {
        String type = types[selectedTab.value];

        if (type != "weekly") {
          url = "${ApiUrls.getAnalytics}?type=$type";
        }
      }

      print("API URL: $url");

      var response = await ApiServices.getRequest(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print(response.body);

        InsightsDataModel model = InsightsDataModel.fromJson(jsonResponse);

        analyticsDays.value = model.data ?? [];
        bmiGauge.value = model.bmiGauge ?? bmiGauge.value;

        prepareCharts();
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
    isCustomRange.value = false;
    getAnalyticsData();
  }

  void prepareCharts() {
    if (analyticsDays.isEmpty) return;

    /// CREATE LABELS FROM DATE
    List<String> labels = analyticsDays.map((e) {
      if (e.date == null) return "";

      if (selectedTab.value != 2) {
        if (e.date!.length >= 10) {
          return e.date!.substring(8, 10); // 04,05,06
        }
        return "";
      }

      if (e.date!.length >= 7) {
        int month = int.parse(e.date!.substring(5, 7));
        return _monthName(month);
      }

      return "";
    }).toList();

    /// ---------------- Calories ----------------
    List<double> c = analyticsDays
        .map((e) => (e.calories?.taken ?? 0).toDouble())
        .toList();

    double caloriesGoal = (analyticsDays.first.calories?.goal ?? 0).toDouble();

    caloriesMetric = HealthMetric(
      title: tr("calories"),
      unit: tr("calories"),
      color: AppColors.primary,
      barValues: c,
      lineValues: c,
      labels: labels,
      maxY: safeMaxY(caloriesGoal, c),
      goal: caloriesGoal,
      interval: safeInterval(caloriesGoal, c),
    );

    List<double> steps = analyticsDays
        .map((e) => (e.steps?.count ?? 0).toDouble())
        .toList();

    double stepsGoal = (analyticsDays.first.steps?.goal ?? 0).toDouble();

    stepsMetric = HealthMetric(
      title: tr("steps"),
      unit: tr("steps"),
      color: Colors.orangeAccent,
      barValues: steps,
      lineValues: steps,
      labels: labels,
      maxY: safeMaxY(stepsGoal, steps),
      goal: stepsGoal,
      interval: safeInterval(stepsGoal, steps),
    );

    /// ---------------- WATER ----------------
    List<double> water = analyticsDays
        .map((e) => (e.water?.takenMl ?? 0).toDouble())
        .toList();

    double waterGoal =
        double.tryParse((analyticsDays.first.water?.goalMl ?? 0).toString()) ??
        0;

    waterMetric = HealthMetric(
      title: tr("water"),
      unit: "ml",
      color: Colors.blue,
      barValues: water,
      lineValues: water,
      labels: labels,
      maxY: safeMaxY(waterGoal, water),
      goal: waterGoal,
      interval: safeInterval(waterGoal, water),
    );

    /// ---------------- WEIGHT ----------------
    List<double> weight = analyticsDays
        .map((e) => (e.weight?.value ?? 0).toDouble())
        .toList();

    double weightGoal =
        double.tryParse((analyticsDays.first.weight?.goal ?? 0).toString()) ??
        0;

    weightMetric = HealthMetric(
      title: tr("weight"),
      unit: "kg",
      color: Colors.red,
      barValues: weight,
      lineValues: weight,
      labels: labels,
      maxY: safeWeightMaxY(weightGoal, weight),
      goal: weightGoal,
      interval: safeWeightInterval(weightGoal, weight),
    );

    nutritionChartData.value = analyticsDays.map((e) {
      final carbs = (e.nutrition?.carbs?.takenG ?? 0).toDouble();
      final protein = (e.nutrition?.protein?.takenG ?? 0).toDouble();
      final fat = (e.nutrition?.fat?.takenG ?? 0).toDouble();

      double total = carbs + protein + fat;

      // Avoid divide by zero
      if (total == 0) {
        return {"carbs": 0.0, "protein": 0.0, "fat": 0.0};
      }

      return {
        "carbs": (carbs / total) * 100,
        "protein": (protein / total) * 100,
        "fat": (fat / total) * 100,
      };
    }).toList();

    /// labels (same as your other charts)
    nutritionLabels.value = analyticsDays.map((e) {
      if (e.date == null) return "";

      if (selectedTab.value != 2) {
        return e.date!.substring(8, 10); // 04,05
      } else {
        int month = int.parse(e.date!.substring(5, 7));
        return _monthName(month);
      }
    }).toList();

    update();
  }

  String getDateRange() {
    if (analyticsDays.isEmpty) return "";

    String firstDate = analyticsDays.first.date!;
    String lastDate = analyticsDays.last.date!;

    if (selectedTab.value == 2) {
      int year = int.parse(firstDate.substring(0, 4));
      return year.toString();
    }

    DateTime first = DateTime.parse(firstDate);
    DateTime last = DateTime.parse(lastDate);

    String start = "${_month(first.month)} ${first.day}, ${first.year}";
    String end = "${_month(last.month)} ${last.day}, ${last.year}";

    if (selectedTab.value == 0) {
      /// Weekly
      return "$start - $end";
    } else {
      /// Monthly
      return "${_month(first.month)} ${first.year}";
    }
  }

  String _month(int m) {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[m];
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  Future<void> exportPremiumPDF() async {
    final regularFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/urbanist-latin-400-normal.ttf"),
    );

    final boldFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/urbanist-latin-700-normal.ttf"),
    );
    try {
      isLoading.value = true;

      final pdf = pw.Document();
      final now = DateFormat("dd MMM yyyy").format(DateTime.now());

      /// 🔹 Latest Values (from chart data)
      final calories = caloriesMetric?.barValues.last ?? 0;
      final steps = stepsMetric?.barValues.last ?? 0;
      final water = waterMetric?.barValues.last ?? 0;
      final weight = weightMetric?.barValues.last ?? 0;

      final bmiValue = bmiGauge.value.value?.toString() ?? "0";
      final bmiCategory = bmiGauge.value.category ?? "";

      pdf.addPage(
        pw.MultiPage(
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            /// 🔷 HEADER
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.green,
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Fitness Insights Report",
                    style: pw.TextStyle(font: boldFont, fontSize: 22.sp),
                  ),

                  pw.SizedBox(height: 8),

                  pw.Text(
                    "Date: $now",
                    style: pw.TextStyle(color: PdfColors.white),
                  ),

                  pw.Text(
                    getDateRange(),
                    style: pw.TextStyle(color: PdfColors.white),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              "Summary",
              style: pw.TextStyle(font: boldFont, fontSize: 18.sp),
            ),

            pw.SizedBox(height: 10),

            pw.Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _summaryBox(tr("calories"), "${calories.toInt()} kcal"),
                _summaryBox(tr("steps"), "${steps.toInt()}"),
                _summaryBox(tr("water"), "${water.toInt()} ml"),
                _summaryBox(tr("weight"), "${weight.toStringAsFixed(1)} kg"),
                _summaryBox(tr("bmi"), "$bmiValue ($bmiCategory)"),
              ],
            ),

            pw.SizedBox(height: 20),

            /// 🔵 TABLE
            pw.Text(
              "Detailed Data",
              style: pw.TextStyle(font: boldFont, fontSize: 18.sp),
            ),

            pw.SizedBox(height: 10),

            pw.Table.fromTextArray(
              headers: ["Date", "Calories", "Steps", "Water", "Weight"],
              data: analyticsDays.map((e) {
                return [
                  e.date ?? "",
                  "${(e.calories?.taken ?? 0)} kcal",

                  (e.steps?.count ?? 0).toString(),
                  "${(e.water?.takenMl ?? 0)} ml",
                  "${(e.weight?.value ?? 0)} kg",
                ];
              }).toList(),
            ),

            pw.SizedBox(height: 20),

            /// 💡 SMART INSIGHT
            pw.Text(
              _generateInsight(),
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
            ),

            pw.SizedBox(height: 20),

            /// ⚫ FOOTER
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated by Ark Fit Gym",
                style: pw.TextStyle(font: regularFont, fontSize: 12.sp),
              ),
            ),
          ],
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: "insights_report.pdf",
      );
    } catch (e) {
      debugPrint("PDF Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  pw.Widget _summaryBox(String title, String value) {
    return pw.Container(
      width: 120,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 5),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _generateInsight() {
    if (analyticsDays.length < 2) {
      return "Start tracking your fitness to see insights.";
    }

    final first = analyticsDays.first;
    final last = analyticsDays.last;

    int stepDiff = (last.steps?.count ?? 0) - (first.steps?.count ?? 0);

    if (stepDiff > 0) {
      return "Great job! Your steps increased by $stepDiff in this period.";
    } else if (stepDiff < 0) {
      return "Your activity dropped slightly. Try to stay consistent!";
    } else {
      return "Your activity remained consistent. Keep it up!";
    }
  }

  Future<void> shareFile([String? path]) async {
    if (path != null) {
      await Share.shareXFiles([XFile(path)]);
    } else {
      await Share.share("Check out my fitness insights!");
    }
  }

  Future<void> exportCSV() async {
    try {
      isLoading.value = true;

      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/insights.csv");

      String csv = "Date,Calories,Steps,Water,Weight\n";

      for (var e in analyticsDays) {
        csv +=
            "${e.date ?? ""},"
            "${e.calories?.taken ?? 0},"
            "${e.steps?.count ?? 0},"
            "${e.water?.takenMl ?? 0},"
            "${e.weight?.value ?? 0}\n";
      }

      await file.writeAsString(csv);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      debugPrint("CSV Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> showDateRangeDialog(BuildContext context) async {
    DateTime? startDate;
    DateTime? endDate;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Select Date Range",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Start Date
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.r,
                      ), // Set your radius here
                    ),
                    tileColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      startDate == null
                          ? "Start Date"
                          : DateFormat('dd/MM/yyyy').format(startDate!),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
                      height: 22.w,
                      width: 22.w,
                    ),
                    onTap: () async {
                      DateTime? picked = await CustomDatePicker.pickDate(
                        context,
                      );
                      if (picked != null) {
                        setState(() => startDate = picked);
                      }
                    },
                  ),
                  SizedBox(height: 10.w),
                  // End Date
                  ListTile(
                    tileColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.r,
                      ), // Set your radius here
                    ),
                    title: Text(
                      endDate == null
                          ? "End Date"
                          : DateFormat('dd/MM/yyyy').format(endDate!),
                      // "${endDate!.day}/${endDate!.month}/${endDate!.year}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!,
                        BlendMode.srcIn,
                      ),
                      height: 22.w,
                      width: 22.w,
                    ),
                    onTap: () async {
                      DateTime? picked = await CustomDatePicker.pickDate(
                        context,
                      );
                      if (picked != null) {
                        setState(() => endDate = picked);
                      }
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Theme.of(context).iconTheme.color),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                  ),
                  onPressed: () {
                    if (startDate != null && endDate != null) {
                      print("Start: $startDate, End: $endDate");
                      Navigator.pop(context, {
                        "start": startDate,
                        "end": endDate,
                      });
                      isCustomRange.value = true;
                      getAnalyticsData(endDate: endDate, startDate: startDate);
                    }
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
