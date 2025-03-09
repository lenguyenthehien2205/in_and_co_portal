import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:in_and_co_portal/features/trending/widgets/hashtag_box.dart';
import 'package:in_and_co_portal/widgets/header_title.dart';

class TrendingScreen extends StatelessWidget{
  TrendingScreen({super.key});

  final List trendingData = [
    {
      'image': 'assets/images/moitruongachau.png',
      'content': '#MTAC',
    },
    {
      'image': 'assets/images/food.png',
      'content': '#Food',
    },
    {
      'image': 'assets/images/drink.png',
      'content': '#Drink',
    },
    {
      'image': 'assets/images/flower.png',
      'content': '#Flower',
    },
    {
      'image': 'assets/images/travel.png',
      'content': '#Travel',
    },
    {
      'image': 'assets/images/taiche.jpg',
      'content': '#TaiChe',
    },
    {
      'image': 'assets/images/entertainment.jpg',
      'content': '#GiaiTri',
    },
    {
      'image': 'assets/images/sport.png',
      'content': '#TheThao',
    },
    {
      'image': 'assets/images/answer.png',
      'content': '#HoiDap',
    },
    {
      'image': 'assets/images/music.png',
      'content': '#Music',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(padding: const EdgeInsets.only(top: 10)),
          SliverToBoxAdapter(
            child: HeaderTitle(content: 'Chủ đề được quan tâm'),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 0, bottom: 100),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2, // 2 cột
              mainAxisSpacing: 25,
              crossAxisSpacing: 25,
              childCount: trendingData.length,
              itemBuilder: (context, index) {
                double height = 
                    (index == 0 || index == trendingData.length - 1) ? 130 : 260;
                return SizedBox(
                  height: height,
                  child: HashtagBox(
                    content: trendingData[index]['content'],
                    image: trendingData[index]['image'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const SizedBox(height: 85),
  //         HeaderTitle(content: 'Thịnh hành'),
  //         Expanded(
  //         child: Padding( 
  //           padding: const EdgeInsets.symmetric(horizontal: 20),
  //           child: GridView.builder(
  //             itemCount: trendingData.length,
  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2, // Chia thành 2 cột
  //               crossAxisSpacing: 20, 
  //               mainAxisSpacing: 20, 
  //               childAspectRatio: 2 / 3, // Tỉ lệ mặc định là 2:3
  //             ),
  //             itemBuilder: (context, index) {
  //               return AspectRatio(
  //                 aspectRatio: (index == 0 || index == trendingData.length - 1) ? 1 / 1 : 2 / 3,
  //                 child: HashtagBox(
  //                   content: trendingData[index]['content'],
  //                   image: trendingData[index]['image'],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //       ],
  //     ),
  //   );
  // }
}