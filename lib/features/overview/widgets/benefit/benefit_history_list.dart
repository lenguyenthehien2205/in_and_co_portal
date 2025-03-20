import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/benefit-history.dart';
import 'package:in_and_co_portal/core/utils/string_utils.dart';
import 'package:in_and_co_portal/features/overview/controllers/benefit_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class BenefitHistoryList extends StatelessWidget{
  final List<BenefitHistory> data;
  BenefitHistoryList({
    super.key, 
    required this.data
  });
  final benefitController = Get.find<BenefitController>();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView( 
      scrollDirection: Axis.vertical,
      slivers: [
        SliverPersistentHeader(
          delegate: _StickyHeaderDelegate(benefitController),
          floating: true,
          pinned: true,
        ),
        Obx(() => SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final benefitHistory = benefitController.filteredBenefitHistory[index];

              return ListTile(
                leading: Image.network(benefitHistory.icon, width: 50),
                title: Text(benefitHistory.title, style: AppText.normal(context)),
                subtitle: Text(benefitHistory.description, style: AppText.small(context)),
                trailing: Text(formatTimestamp(benefitHistory.receivedDate), style: AppText.small(context)),
              );
            },
            childCount: benefitController.filteredBenefitHistory.length, 
          ),
        )),
      ]
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final BenefitController benefitController;
  _StickyHeaderDelegate(this.benefitController);

  @override
  double get minExtent => 55;
  @override
  double get maxExtent => 55;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: TextField(
        textAlign: TextAlign.start,
        onChanged: (value) => benefitController.filterBenefitHistory(value),
        decoration: InputDecoration(
          hintText: "Tìm kiếm phúc lợi...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );  
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}