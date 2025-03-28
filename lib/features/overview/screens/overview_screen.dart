import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/overview/controllers/overview_controller.dart';
import 'package:in_and_co_portal/features/overview/widgets/overview_card.dart';

class OverviewScreen extends StatelessWidget {
  OverviewScreen({super.key});
  final OverviewController overviewController = Get.put(OverviewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Obx((){
              return OverviewCard(
                title: "overview_work_schedule".tr,
                content: "${overviewController.taskCount.value} ${'overview_weekly_tasks'.tr}",
                isVisible: overviewController.card1Visible,
                gradientColors: [Colors.blue.shade400, Colors.blue.shade900],
                onTap: () => context.push('/overview/career-path'),
              );
            }),
            Obx((){
              return OverviewCard(
                title: 'overview_commission'.tr,
                content: "${overviewController.commission.value} ${'overview_commission_detail'.tr}",
                isVisible: overviewController.card2Visible,
                gradientColors: [Colors.amber.shade400, Colors.amber.shade900],
                onTap: () => context.push('/overview/commission'),
              );
            }),
            Obx((){
              return OverviewCard(
                title: "overview_benefit".tr,
                content: "${overviewController.benefits.value} ${'overview_benefit_detail'.tr}",
                isVisible: overviewController.card3Visible,
                gradientColors: [Colors.red.shade400, Colors.red.shade900],
                onTap: () => context.push('/overview/benefit'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
