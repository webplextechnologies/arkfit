import 'package:ark_fit_gym/common/app_colors.dart';
import 'package:ark_fit_gym/view/app/insights/controller/insights_controller.dart';
import 'package:ark_fit_gym/view/app/insights/widget/bmi_card.dart';
import 'package:ark_fit_gym/view/app/insights/widget/health%20charts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late InsightsController insightsController;
  var selectedTab = 0;
  var selectedChart = 0;
  int? touchedIndex;
  int? touchedCalIndex;

  @override
  void initState() {
    insightsController = Get.put(InsightsController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/icons/icon.png",
                color: Theme.of(context).iconTheme.color,
              ),
              Text(
                tr('insights'),
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                              ),
                              title: Text(tr("export_pdf")),
                              onTap: () {
                                Navigator.pop(context);
                                insightsController.exportPremiumPDF();
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.table_chart,
                                color: Colors.blue,
                              ),
                              title: Text(tr("export_csv")),
                              onTap: () {
                                Navigator.pop(context);
                                insightsController.exportCSV();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
        ),

        body: RefreshIndicator(
          color: Theme.of(context).iconTheme.color,
          onRefresh: () async {
            await insightsController.getAnalyticsData();
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: Get.height * 0.21,
                  color: Theme.of(context).colorScheme.primary,
                  //color: Colors.white,
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Obx(() => _tabBar()),
                      SizedBox(height: 12),
                      //  DateSelector(),
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              insightsController.getDateRange(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            insightsController.selectedTab.value == 0
                                ? GestureDetector(
                                    onTap: () async {
                                      final result = await insightsController
                                          .showDateRangeDialog(context);
                                      //print(result);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 15.w,
                                        right: 15.w,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/calendar.svg',
                                        colorFilter: ColorFilter.mode(
                                          Theme.of(context).iconTheme.color!,
                                          BlendMode.srcIn,
                                        ),
                                        height: 24.w,
                                        width: 24.w,
                                      ),
                                    ),
                                  )
                                : SizedBox(),

                            // Icon(Icons.chevron_right),
                          ],
                        );
                      }),
                      SizedBox(height: 10.w),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Obx(() {
                              if (insightsController.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return Column(
                                children: [
                                  if (insightsController.caloriesMetric != null)
                                    /*  HealthMetricCard(
                                      metric: insightsController.caloriesMetric!,
                                    ), */
                                    HealthMetricCard(
                                    /*   key: ValueKey(
                                        "${insightsController.caloriesMetric!.title}_${insightsController.selectedTab.value}",
                                      ), */
                                      metric:
                                          insightsController.caloriesMetric!,
                                    ),
                                  SizedBox(height: 20.w),

                                  _nutritionCard(
                                    child: SizedBox(
                                      height: 260.w,

                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        clipBehavior: Clip.none,
                                        child: _nutritionChart(),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20.w),

                                  if (insightsController.stepsMetric != null)
                                    /*  HealthMetricCard(
                                      metric: insightsController.stepsMetric!,
                                    ), */
                                    HealthMetricCard(
                                     /*  key: ValueKey(
                                        "${insightsController.stepsMetric!.title}_${insightsController.selectedTab.value}",
                                      ), */
                                      metric: insightsController.stepsMetric!,
                                    ),

                                  SizedBox(height: 20.w),

                                  if (insightsController.waterMetric != null)
                                    /*  HealthMetricCard(
                                      metric: insightsController.waterMetric!,
                                    ), */
                                    HealthMetricCard(
                                    /*   key: ValueKey(
                                        "${insightsController.waterMetric!.title}_${insightsController.selectedTab.value}",
                                      ), */
                                      metric: insightsController.waterMetric!,
                                    ),

                                  SizedBox(height: 20.w),

                                  if (insightsController.weightMetric != null)
                                    /*  HealthMetricCard(
                                      metric: insightsController.weightMetric!,
                                    ), */
                                    HealthMetricCard(
                                    /*   key: ValueKey(
                                        "${insightsController.weightMetric!.title}_${insightsController.selectedTab.value}",
                                      ), */
                                      metric: insightsController.weightMetric!,
                                    ),
                                  SizedBox(height: 20.w),
                                  BmiGauge(
                                    bmi:
                                        insightsController.bmiGauge.value.value
                                            ?.toDouble() ??
                                        0.0,
                                    title:
                                        insightsController
                                            .bmiGauge
                                            .value
                                            .category ??
                                        '',
                                  ),

                                  SizedBox(height: 20.w),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_tabItem(tr('weekly'), 0), _tabItem(tr('monthly'), 1)],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final selected = insightsController.selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => insightsController.changeTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.w),
          decoration: BoxDecoration(
            color: selected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Theme.of(context).iconTheme.color,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _nutritionCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1.w),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${tr("nutrition")} (%)",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              // color: AppColors.textPrimary,
            ),
          ),
          Divider(thickness: 0.3),

          SizedBox(height: 8.w),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 12.w,
                    width: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "  ${tr("carbs")} ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      //color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.w),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 12.w,
                    width: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                  ),
                  Text(
                    "  ${tr("protein")} ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      //color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 12.w,
                    width: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "  ${tr("fat")} ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      // color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 15.w),
          child,
        ],
      ),
    );
  }

  Widget _iconBox({required String icon, required bool selected}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.secondary : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SvgPicture.asset(
        icon,
        height: 20,
        width: 20,
        colorFilter: ColorFilter.mode(
          selected ? Colors.white : Colors.grey,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _nutritionChart() {
    return Obx(() {
      final data = insightsController.nutritionChartData;
      final days = insightsController.nutritionLabels;

      /// 👇 dynamic width (same as your other chart)
      double chartWidth = data.length * 40.w;

      return SizedBox(
        height: 200.w,
        child: SizedBox(
          width: chartWidth < Get.width ? Get.width : chartWidth,

          child: BarChart(
            BarChartData(
              barGroups: List.generate(data.length, (i) {
                final item = data[i];
                final isTouched = i == touchedIndex;

                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: 100,
                      width: 30.w,
                      borderSide: BorderSide.none,
                      backDrawRodData: BackgroundBarChartRodData(show: false),

                      rodStackItems: [
                        /// CARBS
                        BarChartRodStackItem(
                          0,
                          item['carbs']!,
                          isTouched ? AppColors.red : AppColors.lightred,
                        ),

                        /// PROTEIN
                        BarChartRodStackItem(
                          item['carbs']!,
                          item['carbs']! + item['protein']!,
                          isTouched ? AppColors.orange : AppColors.lightorange,
                        ),

                        /// FAT
                        BarChartRodStackItem(
                          item['carbs']! + item['protein']!,
                          100,
                          isTouched ? AppColors.blue : AppColors.lightblue,
                        ),
                      ],
                    ),
                  ],
                );
              }),

              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),

              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 25,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= data.length) return SizedBox();
                      return Text(
                        days[value.toInt()],
                        style: TextStyle(fontSize: 12.sp),
                      );
                    },
                  ),
                ),

                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),

              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => Colors.white,
                  tooltipBorder: BorderSide(color: Colors.grey.shade300),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final item = data[groupIndex];

                    return BarTooltipItem(
                      '${tr("carbs")}: ${item['carbs']!.toStringAsFixed(0)}%\n'
                      '${tr("protein")}: ${item['protein']!.toStringAsFixed(0)}%\n'
                      '${tr("fat")}: ${item['fat']!.toStringAsFixed(0)}%',
                      TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),

                touchCallback: (event, response) {
                  setState(() {
                    if (response != null && response.spot != null) {
                      touchedIndex = response.spot!.touchedBarGroupIndex;
                    } else {
                      touchedIndex = null;
                    }
                  });
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  /*   Widget _nutritionChart() {
    final data = [
      {'carbs': 45, 'protein': 20, 'fat': 35},
      {'carbs': 40, 'protein': 25, 'fat': 35},
      {'carbs': 50, 'protein': 30, 'fat': 20},
      {'carbs': 35, 'protein': 20, 'fat': 45},
      {'carbs': 50, 'protein': 25, 'fat': 25},
      {'carbs': 45, 'protein': 20, 'fat': 35},
      {'carbs': 40, 'protein': 25, 'fat': 35},
    ];

    const days = ['16', '17', '18', '19', '20', '21', '22'];

    return BarChart(
      BarChartData(
        // maxY: 100,
        barGroups: List.generate(data.length, (i) {
          final item = data[i];
          final isTouched = i == touchedIndex;
          return BarChartGroupData(
            x: i,

            barRods: [
              BarChartRodData(
                toY: 100,
                width: 30.w,
                borderSide: BorderSide.none, // ✅ IMPORTANT
                backDrawRodData: BackgroundBarChartRodData(
                  show: false, // ✅ disable background rod
                ),

                rodStackItems: [
                  BarChartRodStackItem(
                    0,
                    item['carbs']!.toDouble(),
                    isTouched ? AppColors.red : AppColors.lightred,
                  ),
                  BarChartRodStackItem(
                    item['carbs']!.toDouble(),
                    item['carbs']!.toDouble() + item['protein']!.toDouble(),
                    isTouched
                        ? AppColors.orange
                        : AppColors.lightorange, // Protein
                  ),
                  BarChartRodStackItem(
                    item['carbs']!.toDouble() + item['protein']!.toDouble(),
                    100,
                    isTouched ? AppColors.blue : AppColors.lightblue, // Fat
                  ),
                ],
              ),
            ],
          );
        }),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < 0 || value.toInt() > 6) return SizedBox();
                return Text(
                  days[value.toInt()],
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          allowTouchBarBackDraw: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.white,
            //tooltipBgColor: Colors.white,
            tooltipPadding: EdgeInsets.all(8),
            tooltipBorder: BorderSide(color: Colors.grey.shade300),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final item = data[groupIndex];
              return BarTooltipItem(
                '${tr("carbs")}: ${item['carbs']}%\n${tr("protein")}: ${item['protein']}%\n${tr("fat")}: ${item['fat']}%',
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              );
            },
          ),
          touchCallback: (event, response) {
            setState(() {
              if (response != null && response.spot != null) {
                touchedIndex = response.spot!.touchedBarGroupIndex;
              } else {
                touchedIndex = null; // reset when touch ends
              }
            });
          },
        ),
      ),
    );
  } */
}

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Icon(Icons.chevron_left),

        Text(
          "Dec 16 - Dec 22, 2024",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            //  color: AppColors.textPrimary,
          ),
        ),

        Icon(Icons.chevron_right),
      ],
    );
  }
}
