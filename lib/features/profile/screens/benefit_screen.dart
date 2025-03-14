import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/profile/controllers/benefit_controller.dart';
import 'package:in_and_co_portal/features/profile/widgets/benefit/benefit_history_list.dart';
import 'package:in_and_co_portal/features/profile/widgets/benefit/benefit_list.dart';
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
          title: Text("Phúc lợi", style: AppText.headerTitle(context)),
          centerTitle: true,
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), 
            tabs: [
              Tab(text: "Phúc lợi hiện tại"),
              Tab(text: "Lịch sử nhận"),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: TabBarView(
            children: [
              Obx(() => benefitController.benefits.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : BenefitList(data: benefitController.benefits)
              ),
              Obx(() => benefitController.benefitHistory.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : BenefitHistoryList(data: benefitController.benefitHistory)),
            ],
          ),
        ),
      ),
    );
  }
}