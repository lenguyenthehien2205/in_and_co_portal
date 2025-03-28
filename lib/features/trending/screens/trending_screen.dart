import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/search/controllers/search_data_controller.dart';
import 'package:in_and_co_portal/features/trending/controllers/trending_controller.dart';
import 'package:in_and_co_portal/features/trending/widgets/hashtag_box.dart';
import 'package:in_and_co_portal/widgets/header_title.dart';

class TrendingScreen extends StatelessWidget {
  TrendingScreen({super.key});

  final TrendingController trendingController = Get.put(TrendingController());
  final SearchDataController searchDataController = Get.put(SearchDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: 10)),
          SliverToBoxAdapter(
            child: HeaderTitle(content: 'trending_subtitle'.tr),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 100),
            sliver: Obx(() {
              if (trendingController.trendingData.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return SliverMasonryGrid.count(
                crossAxisCount: 2, // 2 cột
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                childCount: trendingController.trendingData.length,
                itemBuilder: (context, index) {
                  double height = (index == 0 || index == trendingController.trendingData.length - 1) ? 130 : 260;
                  String label = trendingController.trendingData[index]['label']?.toString().capitalizeFirst ?? '';
                  String imageUrl = trendingController.trendingData[index]['url'] ?? '';
                  return GestureDetector(
                    onTap: () => searchDataController.searchAndNavigate(context, label), // Bắt sự kiện click
                    child: SizedBox(
                      height: height,
                      child: HashtagBox(
                        content: label,
                        image: imageUrl,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
