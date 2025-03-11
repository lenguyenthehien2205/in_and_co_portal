import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/profile/widgets/commission/column_chart.dart';
import 'package:in_and_co_portal/features/profile/widgets/commission/commission_card.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class CommissionScreen extends StatelessWidget {
  CommissionScreen({super.key});
  final List<Map<String, dynamic>> commissions = [
    {"title": "commission_this_month".tr, "amount": "15,500,000 VNĐ", "image": 'assets/images/commission.png'},
    {"title": "commission_compare_last_month".tr, "amount": "+3,000,000 VNĐ", "image": 'assets/images/compare.png'},
    {"title": "commission_this_year".tr, "amount": "140,000,000 VNĐ", "image": 'assets/images/annual-report.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile_commission'.tr, style: AppText.headerTitle(context)),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            sliver: SliverToBoxAdapter(
              child: Text('commission_overview'.tr, style: AppText.title(context))
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 200, 
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // 🔥 Cuộn ngang
                  itemCount: commissions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8), // 🔥 Khoảng cách giữa các card
                      child: CommissionCard(
                        title: commissions[index]['title'],
                        amount: commissions[index]['amount'],
                        image: commissions[index]['image'],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 20),
            sliver: SliverToBoxAdapter(
              child: ColumnChart(),
            ),
          ),
        ],
      ),
    );
  }
}