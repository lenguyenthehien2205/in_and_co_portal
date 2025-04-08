import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/overview/controllers/overview_controller.dart';
import 'package:in_and_co_portal/features/overview/widgets/overview_card.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';

class OverviewScreen extends StatelessWidget {
  OverviewScreen({super.key});
  final OverviewController overviewController = Get.put(OverviewController());
  final ProfileController profileController = Get.find<ProfileController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (overviewController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return CustomScrollView(
          slivers: [
            Obx((){
              if(profileController.userData['role'] == 'Admin'){
                return SliverToBoxAdapter(
                  child: OverviewCard(
                    title: 'pending_posts_title'.tr,
                    content: "${overviewController.pendingPosts.value} ${'pending_posts_post'.tr}",
                    isVisible: overviewController.card1Visible,
                    gradientColors: [Colors.green.shade400, Colors.green.shade900],
                    onTap: () => context.push('/overview/pending-posts'),
                  )
                );
              }
              return SliverToBoxAdapter(
                child: SizedBox(height: 0),
              );
            }),
            Obx((){
              if(profileController.userData['role'] != 'Admin'){
                return SliverToBoxAdapter(
                  child: OverviewCard(
                    title: "overview_work_schedule".tr,
                    content: "${overviewController.taskCount.value} ${'overview_weekly_tasks'.tr}",
                    isVisible: overviewController.card2Visible,
                    gradientColors: [Colors.blue.shade400, Colors.blue.shade900],
                    onTap: () => context.push('/overview/career-path'),
                  )
                );
              }
              return SliverToBoxAdapter(
                child: SizedBox(height: 0),
              );
            }),
            Obx((){
              if(profileController.userData['role'] != 'Admin'){
                return SliverToBoxAdapter(
                  child: OverviewCard(
                    title: "overview_benefit".tr,
                    content: "${overviewController.benefits.value} ${'overview_benefit_detail'.tr}",
                    isVisible: overviewController.card3Visible,
                    gradientColors: [Colors.red.shade400, Colors.red.shade900],
                    onTap: () => context.push('/overview/benefit'),
                  )
                );
              }
              return SliverToBoxAdapter(
                child: SizedBox(height: 0),
              );
            }),
            Obx((){
              if(profileController.userData['role'] != 'Admin'){
                return SliverToBoxAdapter(
                  child: OverviewCard(
                    title: 'overview_commission'.tr,
                    content: "${overviewController.commission.value} ${'overview_commission_detail'.tr}",
                    isVisible: overviewController.card4Visible,
                    gradientColors: [Colors.amber.shade400, Colors.amber.shade900],
                    onTap: () => context.push('/overview/commission'),
                  )
                );
              }
              return SliverToBoxAdapter(
                child: SizedBox(height: 0),
              );
            }),
            Obx((){
              if(profileController.userData['role'] != 'Admin'){
                return SliverToBoxAdapter(
                  child: OverviewCard(
                    title: 'business_itinerary_title'.tr,
                    content: '${overviewController.scheduleCount.value} ${'business_itinerary_this_month'.tr}', 
                    isVisible: overviewController.card5Visible,
                    gradientColors: [Colors.purple.shade400, Colors.purple.shade900],
                    onTap: () => context.push('/overview/business-itinerary'),
                  )
                );
              }
              return SliverToBoxAdapter(
                child: SizedBox(height: 0),
              );
            }),
            SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        );
      }),
    );
  }
}
