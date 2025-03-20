import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/benefit.dart';
import 'package:in_and_co_portal/features/overview/controllers/benefit_controller.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class BenefitList extends StatelessWidget{
  ProfileController _profileController = Get.find();
  final List<Benefit> data;
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
                leading: Image.network(benefit.icon, width: 50),
                title: Text(benefit.title, style: AppText.normal(context)),
                subtitle: Text(benefit.description, style: AppText.small(context)),
                trailing: Text(
                  (benefit.employeeIds.contains(_profileController.userData["employee_id"]))
                      ? 'benefit_active'.tr
                      : 'benefit_unactive'.tr,
                  style: TextStyle(
                    color: (benefit.employeeIds.contains(_profileController.userData["employee_id"]))
                        ? Colors.green
                        : Colors.orange, 
                    fontSize: 16,
                  ),
                ),
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
          hintText: 'benefit_search'.tr,
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