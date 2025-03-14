import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/profile/controllers/commission_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class QuarterlyBarChart extends StatelessWidget{
  QuarterlyBarChart({super.key});
  final CommissionController commissionController = Get.put(CommissionController());

  final List<String> months = [
    'commission_january'.tr,
    'commission_february'.tr,
    'commission_march'.tr,
    'commission_april'.tr,
    'commission_may'.tr,
    'commission_june'.tr,
    'commission_july'.tr,
    'commission_august'.tr,
    'commission_september'.tr,
    'commission_october'.tr,
    'commission_november'.tr,
    'commission_december'.tr,
  ];

  @override
  Widget build(context){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Center(
              child: Text(
                '${'commission_quarterly_title'.tr} Q${commissionController.selectedQuarter.value}-${commissionController.selectedYear.value}',
                style: AppText.title(context),
              ),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => DropdownButton<int>(
                  value: commissionController.selectedQuarter.value,
                  items: [1, 2, 3, 4].map((q) {
                    return DropdownMenuItem(
                      value: q,
                      child: Text("Q$q"),
                    );
                  }).toList(),
                  onChanged: (value) => commissionController.selectedQuarter.value = value!,
                  style: AppText.normal(context),
                )),
                SizedBox(width: 10),
                Obx(() => DropdownButton<int>(
                  value: commissionController.selectedYear.value,
                  items: [2024, 2025].map((year){
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString())
                    );
                  }).toList(),
                  onChanged: (value) => commissionController.selectedYear.value = value!,
                  style: AppText.normal(context),
                )),
              ],
            ),
            SizedBox(height: 30),
            Obx(() => SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(
                    commissionController.currentQuarterlyData.length, (index) => BarChartGroupData(
                    x: index + 1, // Tháng
                    barRods: [
                      BarChartRodData(
                        toY: commissionController.currentQuarterlyData[index].toDouble(),
                        color: Colors.blue,
                        width: 30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  )),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBorder: null, 
                      tooltipPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 0), 
                      tooltipMargin: 3,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toInt()} triệu', 
                          TextStyle(
                            color: Colors.white,
                            fontSize: 14, 
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: Padding(
                        padding: EdgeInsets.only(right: 0), 
                        child: Text(
                          'commission_bar_chart_title'.tr,
                          style: AppText.normal(context)
                        ),
                      ),
                      axisNameSize: 30,
                      sideTitles: SideTitles(
                        getTitlesWidget: (value, meta) => Text(
                          "${value.toInt()}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                    topTitles: AxisTitles( 
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles: AxisTitles( 
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          "${value.toInt()}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface 
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          commissionController.currentMonths[value.toInt() - 1],
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            )
            )
          ],
        )
      ),
    );
  }
}