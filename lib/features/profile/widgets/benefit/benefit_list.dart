import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/profile/controllers/benefit_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class BenefitList extends StatelessWidget{
  final List<Map<String, dynamic>> data;
  BenefitList({
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
              final benefit = benefitController.filteredBenefits[index];

              return ListTile(
                leading: Image.asset(benefit["icon"] ?? "assets/default_icon.png", width: 50),
                title: Text(benefit["name"] ?? "Không có tên", style: AppText.normal(context)),
                subtitle: Text(benefit["description"] ?? "", style: AppText.small(context)),
                trailing: Text(
                  benefit["status"] ?? "N/A",
                  style: TextStyle(
                    color: benefit["status"] == "Được hưởng"
                        ? Colors.green
                        : benefit["status"] == "Chưa áp dụng"
                            ? Colors.orange
                            : Colors.grey,
                    fontSize: 16,
                  ),
                )
              );
            },
            childCount: benefitController.filteredBenefits.length, 
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
        onChanged: (value) => benefitController.filterBenefits(value),
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