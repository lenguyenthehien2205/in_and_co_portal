import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/overview/controllers/benefit_controller.dart';
import 'package:in_and_co_portal/features/overview/widgets/benefit/benefit_history_list.dart';
import 'package:in_and_co_portal/features/overview/widgets/benefit/benefit_list.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class BenefitScreen extends StatelessWidget{
  BenefitScreen({super.key});
  final BenefitController benefitController = Get.put(BenefitController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('benefit_title'.tr, style: AppText.headerTitle(context)),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), 
            tabs: [
              Tab(text: 'benefit_current'.tr),
              Tab(text: "benefit_history".tr),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: TabBarView(
            children: [
              Obx(() {
                if (benefitController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return BenefitList(data: benefitController.filteredBenefits);
              }),
              Obx(() {
                if (benefitController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return benefitController.benefitHistory.isEmpty
                    ? const Center(child: Text("Chưa có dữ liệu"))
                    : BenefitHistoryList(data: benefitController.filteredBenefitHistory);
              }),
            ],
          ),
        ),
      ),
    );
  }
}