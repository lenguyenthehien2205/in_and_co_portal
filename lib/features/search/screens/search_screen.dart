import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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
              return SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
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
                  ...searchController.searchHistory.map((history) {
                    return ListTile(
                      title: Text(
                        history.content,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface, 
                        ),
                      ),
                      leading: Icon(Icons.history),
                      trailing: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          searchController.deleteSearchHistory(history.id!);
                        },
                      ),
                      onTap: () {
                        searchController.searchAndNavigate(context, history.content);
                      },
                    );
                  }),
                ]),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.only(top: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var user = searchController.searchResults[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          user["fullname"] ?? "Không có tên",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(width: 5),
                        if (user["is_checked"] == true)
                          Icon(Icons.verified, color: Colors.blue, size: 16),
                      ],
                    ),
                    leading: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(
                        user["avatar"] ?? "https://via.placeholder.com/150",
                      ),
                    ),
                    onTap: () {
                      context.push('/profile/page/${user["id"]}');
                    },
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
          autofocus: true,
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
            searchController.addSearchHistory(value);
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
