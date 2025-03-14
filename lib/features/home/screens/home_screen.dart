import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/home/controllers/post_controller.dart';
import 'package:in_and_co_portal/features/home/widgets/company_posts.dart';
import 'package:in_and_co_portal/features/home/widgets/posts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostController postController = Get.put(PostController());
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 &&
        !postController.isLoadingMore.value) {
      postController.loadMorePosts();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: CompanyPosts(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Posts();
              },
              childCount: 1, // Chỉ có 1 danh sách Posts
            ),
          ),
        ],
      ),
    );
  }
}
class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return CompanyPosts();
  }

  @override
  double get maxExtent => 60; // Chiều cao tối đa của header
  @override
  double get minExtent => 60; // Chiều cao tối thiểu khi cuộn
  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}