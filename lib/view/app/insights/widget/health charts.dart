import 'package:ark_fit_gym/common/enums/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HealthMetric {
  final String title;
  final String unit;
  final Color color;
  final List<double> barValues;
  final List<double> lineValues;
  final List<String> labels;
  final double maxY;
  final double goal;
  final double interval;

  HealthMetric({
    required this.title,
    required this.unit,
    required this.color,
    required this.barValues,
    required this.lineValues,
    required this.labels,
    required this.maxY,
    required this.goal,
    required this.interval,
  });
}

class HealthMetricCard extends StatefulWidget {
  final HealthMetric metric;

  const HealthMetricCard({super.key, required this.metric});

  @override
  State<HealthMetricCard> createState() => _HealthMetricCardState();
}

class _HealthMetricCardState extends State<HealthMetricCard> {
  ChartType selectedChart = ChartType.bar;
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final item = widget.metric;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.white, width: 1.w),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8.r)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE + TOGGLE
          Row(
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  // color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),

              _iconBtn(
                item.color,
                selectedChart == ChartType.bar,
                'assets/icons/Chart.svg',
                () {
                  setState(() => selectedChart = ChartType.bar);
                },
              ),

              _iconBtn(
                item.color,
                selectedChart == ChartType.line,
                'assets/icons/Activity_colored.svg',
                () {
                  setState(() => selectedChart = ChartType.line);
                },
              ),
            ],
          ),
          Divider(thickness: 0.3.w),

          SizedBox(height: 10.w),
          Row(
            children: [
              Container(
                height: 12.w,
                width: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.color,
                ),
              ),
              SizedBox(width: 6.w),
              Text("${tr("selected")}   ", style: TextStyle(fontSize: 14.sp)),
              Text("-----   ", style: TextStyle(fontSize: 14.sp)),
              Text("${item.title} ${tr("goal")}", style: TextStyle(fontSize: 14.sp)),
            ],
          ),

          SizedBox(height: 18.w),

          SizedBox(
            height: 200.w,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: SizedBox(
                width: item.barValues.length * 40.w,
                child: selectedChart == ChartType.bar
                    ? _barChart(item)
                    : _lineChart(item),
              ),
            ),
          ),
        
        ],
      ),
    );
  }

  Widget _barChart(HealthMetric item) {
    return BarChart(
      BarChartData(
        maxY: item.maxY,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),

        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(y: item.goal, dashArray: [6, 6], color: item.color),
          ],
        ),

        titlesData: _titles(item),
        barTouchData: BarTouchData(
          enabled: true,

          touchCallback: (event, response) {
            if (response == null ||
                response.spot == null ||
                !event.isInterestedForInteractions) {
              setState(() => touchedIndex = null);
              return;
            }

            setState(() {
              touchedIndex = response.spot!.touchedBarGroupIndex;
            });
          },

          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.white,
            tooltipBorderRadius: BorderRadius.all(Radius.circular(70.r)),
            tooltipPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.w,
            ),
            tooltipBorder: BorderSide(color: item.color, width: 5.w),

            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                "${rod.toY.toInt()}\n",
                TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
                children: [
                  TextSpan(
                    text: item.unit,
                    style: TextStyle(
                      fontSize: 8.w,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        barGroups: List.generate(item.barValues.length, (i) {
          final bool isTouched = i == touchedIndex;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: item.barValues[i],
                width: 30.w,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r),
                ),
                color:
                    //i == 1 ?
                    isTouched ? item.color : item.color.withOpacity(0.4),
              ),
            ],
          );
        }),
      ),
    );
  }

  

  Widget _lineChart(HealthMetric item) {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: item.maxY,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),

        /// GOAL LINE
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(y: item.goal, dashArray: [6, 6], color: item.color),
          ],
        ),

        titlesData: _titles(item),

        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,

          touchCallback: (event, response) {
            if (response == null ||
                response.lineBarSpots == null ||
                !event.isInterestedForInteractions) {
              setState(() => touchedIndex = null);
              return;
            }

            setState(() {
              touchedIndex = response.lineBarSpots!.first.spotIndex;
            });
          },

          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.white,
            tooltipBorderRadius: BorderRadius.all(Radius.circular(70)),
            tooltipPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.w,
            ),
            tooltipBorder: BorderSide(color: item.color, width: 5.w),
            tooltipMargin: 12,
            getTooltipItems: (touchedSpots) {
              // must return empty to use tooltipBuilder
              return touchedSpots
                  .map(
                    (spot) => LineTooltipItem(
                      '${spot.y.toInt().toString()}\n',
                      TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp, // number size
                      ),
                      children: [
                        TextSpan(
                          text: "${item.unit}",
                          style: TextStyle(
                            fontSize: 8.sp, // smaller kcal
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList();
            },
          ),
        ),

        showingTooltipIndicators: touchedIndex != null
            ? [
                ShowingTooltipIndicators([
                  LineBarSpot(
                    LineChartBarData(
                      spots: List.generate(
                        item.lineValues.length,
                        (i) => FlSpot(i.toDouble(), item.lineValues[i]),
                      ),
                    ),
                    0,
                    FlSpot(
                      touchedIndex!.toDouble(),
                      item.lineValues[touchedIndex!],
                    ),
                  ),
                ]),
              ]
            : [],

        /// LINE DATA
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: item.color,
            barWidth: 3,

            spots: List.generate(
              item.lineValues.length,
              (i) => FlSpot(i.toDouble(), item.lineValues[i]),
            ),

            /// 🔥 DOT STYLE (dynamic highlight)
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) {
                final isTouched = index == touchedIndex;

                return FlDotCirclePainter(
                  radius: isTouched ? 8 : 5,
                  color: isTouched ? item.color : Colors.white,
                  strokeWidth: 3,
                  strokeColor: item.color,
                );
              },
            ),

            /// AREA GRADIENT
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  item.color.withOpacity(0.4),
                  item.color.withOpacity(0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlTitlesData _titles(HealthMetric item) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: item.interval,
          getTitlesWidget: (v, m) =>
              Text(v.toInt().toString(), style: TextStyle(fontSize: 8.sp)),
        ),
      ),

      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (v, m) {
            int index = v.toInt();

            if (index < 0 || index >= item.labels.length) {
              return const SizedBox();
            }

            return Text(item.labels[index], style: TextStyle(fontSize: 10.sp));
          },
        ),
      ),

      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget _iconBtn(Color color, bool selected, String svg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: const EdgeInsets.only(left: 8),
        padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.w),
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: SvgPicture.asset(
          svg,
          height: 20.w,
          width: 20.w,
          colorFilter: ColorFilter.mode(
            selected ? Colors.white : Colors.grey,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
