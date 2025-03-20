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
            OverviewCard(
              title: "Lộ trình công việc",
              content: "5 công việc trong tuần",
              isVisible: overviewController.card1Visible,
              gradientColors: [Colors.blue.shade400, Colors.blue.shade900],
              onTap: () => context.push('/overview/career-path'),
            ),
            OverviewCard(
              title: "Hoa hồng",
              content: "12 triệu VNĐ tháng này",
              isVisible: overviewController.card2Visible,
              gradientColors: [Colors.amber.shade400, Colors.amber.shade900],
              onTap: () => context.push('/overview/commission'),
            ),
            OverviewCard(
              title: "Phúc lợi",
              content: "3 phúc lợi đang hưởng",
              isVisible: overviewController.card3Visible,
              gradientColors: [Colors.red.shade400, Colors.red.shade900],
              onTap: () => context.push('/overview/benefit'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     profileController.logout();
            //     context.go('/login');
            //   },
            //   child: const Text('Sign Out')
            // ),
          ],
        ),
      ),
    );
  }
}
