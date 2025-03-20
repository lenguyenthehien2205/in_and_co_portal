import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class ResultSearchScreen extends StatelessWidget {
  const ResultSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final data = state.extra as Map<String, dynamic>?;
    final List<Map<String, dynamic>> posts =
        List<Map<String, dynamic>>.from(data?["posts"] ?? []);


    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả tìm kiếm', style: AppText.headerTitle(context)),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: _StickyHeaderDelegate(),
            floating: true,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: Text(
                'Tài khoản',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                title: Text(
                  'Thế Hiển $index',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                leading: CircleAvatar(
                  radius: 23,
                  backgroundImage: AssetImage('assets/images/sontung.jpeg'),
                ),
                onTap: () {},
              );
            }, childCount: 2),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
              child: Text(
                'Bài viết',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GridView.builder(
              shrinkWrap: true, // Giúp GridView không chiếm toàn bộ chiều cao
              physics:
                  NeverScrollableScrollPhysics(), // Tắt cuộn riêng của GridView
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Image.network(posts[index]["post_images"][0]['url'], fit: BoxFit.cover);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: Text(''),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
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
            hintText: 'Tìm kiếm...',
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
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
