import 'package:flutter/material.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class ResultSearchScreen extends StatelessWidget {
  const ResultSearchScreen({super.key});
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: Text('Tài khoản', style: AppText.semiBoldTitle),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                title: Text('Thế Hiển $index', style: AppText.semiBoldTitle),
                leading: CircleAvatar(
                  radius: 23,
                  backgroundImage: AssetImage('assets/images/sontung.jpeg'),
                ),
                onTap: () {
                  
                },
              );
            }, childCount: 2),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 15, bottom: 10),
              child: Text('Bài viết', style: AppText.semiBoldTitle),
            ),
          ),
          SliverToBoxAdapter(
            child: GridView.builder(
              shrinkWrap: true, // Giúp GridView không chiếm toàn bộ chiều cao
              physics: NeverScrollableScrollPhysics(), // Tắt cuộn riêng của GridView
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemCount: 15,
              itemBuilder: (context, index) {
                return Image.asset(
                  'assets/images/food.png',
                  fit: BoxFit.cover,
                );
              },
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
      )
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
