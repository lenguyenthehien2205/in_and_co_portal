import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/core/services/post_service.dart';
class CompanyPostController extends GetxController{
  final PostService _postService = PostService();
  var posts = <Post>[].obs;
  var isLoadingMore = false.obs;
  var hasMorePosts = true.obs; // tránh chạy hàm load khi hết dữ liệu
  final int pageSize = 4; 
  var loadPostIds = <String>{}.obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadMorePosts();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore.value) {
      loadMorePosts();
    }
  }

  void loadMorePosts() async {
    if (isLoadingMore.value || !hasMorePosts.value) return;

    try {
      isLoadingMore.value = true;

      final data = await _postService.getCompanyPosts(
        limit: pageSize, 
        excludeIds: loadPostIds.toList()
      ).first;
      print('Data: $data');

      if(data.isNotEmpty) {
        loadPostIds.addAll(data.map((post) => post.id));
        posts.addAll(data);
      }else{
        hasMorePosts.value = false;
      }
    } catch (e) {
      print('Error loading posts: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}