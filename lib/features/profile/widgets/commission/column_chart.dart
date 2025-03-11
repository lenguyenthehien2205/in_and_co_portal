import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class ColumnChart extends StatelessWidget{
  ColumnChart({super.key});

  final List<double> quarterlyCommissions = [
    12, 15, 18, 10
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
            Center(
              child: Text('commission_quarterly'.tr, style: AppText.title(context)),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(4, (index) => BarChartGroupData(
                    x: index + 1, // Tháng
                    barRods: [
                      BarChartRodData(
                        toY: quarterlyCommissions[index], // Giá trị
                        color: Colors.blue,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  )),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        getTitlesWidget: (value, meta) => Text(
                          "${value.toInt()}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface, // Dùng màu từ theme
                          ),
                        ),
                      ),
                    ),
                    topTitles: AxisTitles( // Thêm tiêu đề phía trên
                      sideTitles: SideTitles(
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()} ${'commission_million'.tr}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground, 
                          ),
                        ),
                      ),
                    ),
                    rightTitles: AxisTitles( // Thêm tiêu đề bên phải
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          "${value.toInt()}",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground, 
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          "${'commission_month'.tr} ${value.toInt()}",
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}