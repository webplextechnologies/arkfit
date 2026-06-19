import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionChartPage extends StatefulWidget {
  const NutritionChartPage({Key? key}) : super(key: key);

  @override
  State<NutritionChartPage> createState() => _NutritionChartPageState();
}

class _NutritionChartPageState extends State<NutritionChartPage> {

  int? touchedIndex;

  final List<Map<String, int>> data = [
    {'carbs': 45, 'protein': 20, 'fat': 35},
    {'carbs': 40, 'protein': 25, 'fat': 35},
    {'carbs': 50, 'protein': 30, 'fat': 20},
    {'carbs': 35, 'protein': 20, 'fat': 45},
    {'carbs': 50, 'protein': 25, 'fat': 25},
    {'carbs': 45, 'protein': 20, 'fat': 35},
    {'carbs': 40, 'protein': 25, 'fat': 35},
  ];

  final List<String> days = ['16', '17', '18', '19', '20', '21', '22'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nutrition Chart")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _nutritionChart(),
      ),
    );
  }

  // -----------------------------
  // CHART WIDGET
  // -----------------------------
  Widget _nutritionChart() {
    return BarChart(
      BarChartData(
        maxY: 100,

        barGroups: List.generate(data.length, (i) {
          final item = data[i];
          final bool isTouched = i == touchedIndex;

          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: 100,
                width: 30,
                borderSide: BorderSide.none,
                backDrawRodData:
                    BackgroundBarChartRodData(show: false),

                rodStackItems: [
                  // CARBS
                  BarChartRodStackItem(
                    0,
                    item['carbs']!.toDouble(),
                    isTouched
                        ? Colors.red.shade800
                        : Colors.red.shade400,
                  ),

                  // PROTEIN
                  BarChartRodStackItem(
                    item['carbs']!.toDouble(),
                    item['carbs']! + item['protein']!.toDouble(),
                    isTouched
                        ? Colors.orange.shade800
                        : Colors.orange.shade400,
                  ),

                  // FAT
                  BarChartRodStackItem(
                    item['carbs']! + item['protein']!.toDouble(),
                    100,
                    isTouched
                        ? Colors.blue.shade800
                        : Colors.blue.shade400,
                  ),
                ],
              ),
            ],
          );
        }),

        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),

        // -----------------------------
        // TITLES
        // -----------------------------
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < 0 || value.toInt() >= days.length) {
                  return const SizedBox();
                }
                return Text(
                  days[value.toInt()],
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),

          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        // -----------------------------
        // TOUCH SETTINGS
        // -----------------------------
        barTouchData: BarTouchData(
          enabled: true,

          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.white,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipBorder: BorderSide(color: Colors.grey.shade300),

            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final item = data[groupIndex];

              return BarTooltipItem(
                'Carbs: ${item['carbs']}%\n'
                'Protein: ${item['protein']}%\n'
                'Fat: ${item['fat']}%',
                const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),

          touchCallback: (event, response) {

            // Reset when finger leaves
            if (event is FlTapUpEvent ||
                event is FlPanEndEvent ||
                event is FlLongPressEnd) {
              setState(() => touchedIndex = null);
              return;
            }

            // Activate on LONG PRESS
            if (event is FlLongPressStart &&
                response?.spot != null) {
              setState(() {
                touchedIndex =
                    response!.spot!.touchedBarGroupIndex;
              });
            }
          },
        ),
      ),
    );
  }
}
