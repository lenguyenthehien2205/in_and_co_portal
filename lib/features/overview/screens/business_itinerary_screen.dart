import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/utils/string_utils.dart';
import 'package:in_and_co_portal/features/overview/controllers/business_itinerary_controller.dart';

class BusinessItineraryScreen extends StatelessWidget {
  const BusinessItineraryScreen({super.key});

  IconData getIconByVehicle(String vehicle) {
    switch (vehicle) {
      case 'Xe công ty':
        return Icons.directions_car;
      case 'Xe cá nhân':
        return Icons.directions_bike;
      case 'Máy bay':
        return Icons.airplanemode_active;
      default:
        return Icons.help_outline;
    }
  }

  Color getColorByVehicle(String vehicle) {
    switch (vehicle) {
      case 'Xe cá nhân':
        return Colors.green;
      case 'Máy bay':
        return Colors.blue;
      case 'Xe công ty':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final BusinessItineraryController controller = Get.put(BusinessItineraryController());
    return Scaffold(
      appBar: AppBar(
        title: Text('business_itinerary_schedule'.tr),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(controller: controller),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: Obx(() {
              if (controller.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if(controller.filteredItineraryData.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('business_itinerary_no_job'.tr),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final item = controller.filteredItineraryData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(getIconByVehicle(item.vehicle), size: 40, color: getColorByVehicle(item.vehicle)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${'bussiness_itinerary_purpose'.tr}: ${item.purpose}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${'bussiness_itinerary_vehicle'.tr}: ${item.vehicle}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${'bussiness_itinerary_time'.tr}: ${formatTimestampToDate(item.startDate)} - ${formatTimestampToDate(item.endDate)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${'bussiness_itinerary_status'.tr}: ${item.status}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: controller.filteredItineraryData.length,
                ),
              );
            })
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 50),
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final BusinessItineraryController controller;

  _StickyHeaderDelegate({required this.controller});
  @override
  double get minExtent => 65;
  @override
  double get maxExtent => 65;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 1.5),
              ),
              child: TextField(
                onChanged: controller.filterBySearch,
                decoration: InputDecoration(
                  hintText: '${'search_placeholder'.tr}...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  suffixIcon: Icon(Icons.search, color: Colors.blue),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(() => DropdownButton<String>(
            value: controller.selectedVehicle.value,
            items: ['bussiness_itinerary_vehicle'.tr, 'bussiness_itinerary_vehicle_plane'.tr, 'bussiness_itinerary_vehicle_company'.tr, 'bussiness_itinerary_vehicle_personal'.tr]
                .map(
                  (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                  ),
                )
                .toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.filterByVehicle(newValue);
              }
            },
          )),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.blue),
            iconSize: 30,
            onPressed: () {
              context.push('/overview/business-itinerary/add-schedule'); 
            },
            color: Colors.blue,
          )
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
