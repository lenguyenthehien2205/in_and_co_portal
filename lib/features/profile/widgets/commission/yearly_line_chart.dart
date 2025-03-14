import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/profile/controllers/commission_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class YearlyLineChart extends StatelessWidget{
  YearlyLineChart({super.key});
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
                '${'commission_yearly_title'.tr} ${commissionController.fromYear}-${commissionController.toYear}',
                style: AppText.title(context),
              ),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() => DropdownButton<int>(
                  value: commissionController.fromYear.value,
                  items: commissionController.availableYears
                      .where((year) => year < commissionController.toYear.value) 
                      .map((year) {
                        return DropdownMenuItem(value: year, child: Text("${'commission_from'.tr}: $year"));
                      }).toList(),
                  onChanged: (value) => commissionController.updateFromYear(value!),
                  style: AppText.normal(context),
                )),
                SizedBox(width: 20),
                Obx(() => DropdownButton<int>(
                  value: commissionController.toYear.value,
                  items: commissionController.availableYears
                      .where((year) => year > commissionController.fromYear.value) 
                      .map((year) {
                        return DropdownMenuItem(value: year, child: Text("${'commission_to'.tr}: $year"));
                      }).toList(),
                  onChanged: (value) => commissionController.updateToYear(value!),
                  style: AppText.normal(context),
                ))
              ],
            ),
            SizedBox(height: 30),
            Obx(() => SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.y}',
                            TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: commissionController.currentYearlyData.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 5,
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text('commission_bar_chart_title'.tr, style: AppText.normal(context)),
                      ),
                      axisNameSize: 40,
                    ),
                    rightTitles: AxisTitles( 
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
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
                        interval: 1,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                        ),
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            )),
          ],
        )
      ),
    );
  }
}