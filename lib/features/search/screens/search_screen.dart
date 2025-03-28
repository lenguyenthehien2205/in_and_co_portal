import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/search/controllers/search_data_controller.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final SearchDataController searchController = Get.put(SearchDataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: _StickyHeaderDelegate(),
            floating: true,
            pinned: true,
          ),
          Obx(() {
            if (searchController.searchQuery.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15),
                  child: Text(
                    'search_recent'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.only(top: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var user = searchController.searchResults[index];
                  return ListTile(
                    title: Text(
                      user["fullname"] ?? "Không có tên",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(
                        user["avatar"] ?? "https://via.placeholder.com/150",
                      ),
                    ),
                    onTap: () {},
                  );
                }, childCount: searchController.searchResults.length),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final SearchDataController searchController = Get.put(SearchDataController());
  @override
  double get minExtent => 55;
  @override
  double get maxExtent => 55;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
        child: TextField(
          decoration: InputDecoration(
            hintText: '${'search_placeholder'.tr}...',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: const Color.fromARGB(255, 232, 232, 232),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
          onChanged: (value) {
            searchController.searchUsers(value);
          },
          onSubmitted: (value) {
            searchController.searchAndNavigate(context, value);
          },
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
