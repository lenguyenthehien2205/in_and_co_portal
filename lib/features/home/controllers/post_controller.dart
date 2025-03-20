import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/core/services/post_service.dart';

class PostController extends GetxController {
  final PostService _postService = PostService();
  // var posts =
  //     [
  //       Post(
  //         id: '1',
  //         title: 'Bài viết 1',
  //         postType: 'Nội dung bài viết 1',
  //         images: [
  //           {'url': 'assets/images/thu_hoi_pin_cu.png'},
  //         ],
  //       ),
  //       Post(
  //         id: '2',
  //         title: 'Bài viết 2',
  //         postType: 'Nội dung bài viết 2',
  //         images: [
  //           {'url': 'assets/images/thu_hoi_pin_cu.png'},
  //         ],
  //       ),
  //       Post(
  //         id: '3',
  //         title: 'Bài viết 3',
  //         postType: 'Nội dung bài viết 3',
  //         images: [
  //           {'url': 'assets/images/thu_hoi_pin_cu.png'},
  //         ],
  //       ),
  //       Post(
  //         id: '4',
  //         title: 'Bài viết 4',
  //         postType: 'Nội dung bài viết 4',
  //         images: [
  //           {'url': 'assets/images/thu_hoi_pin_cu.png'},
  //         ],
  //       ),
  //     ].obs;
  var posts = <Post>[].obs;
  var isLoadingMore = false.obs;
  var hasMorePosts = true.obs; // tránh chạy hàm load khi hết dữ liệu
  final int pageSize = 3;
  var loadPostIds = <String>{}.obs;
  var currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    loadMorePosts();
  }

  void loadMorePosts() async {
    print('Load more posts');
    if (isLoadingMore.value || !hasMorePosts.value) return;

    try {
      isLoadingMore.value = true;

      final data =
          await _postService
              .getPosts(
                limit: pageSize,
                excludeIds: loadPostIds.toList(),
              )
              .first;
      print('Data: $data');

      if (data.isNotEmpty) {
        loadPostIds.addAll(data.map((post) => post.id));
        posts.addAll(data);
      } else {
        hasMorePosts.value = false;
      }
    } catch (e) {
      print('Error loading posts: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }
  Future<void> refreshPosts() async {
    posts.clear();
    loadPostIds.clear();
    hasMorePosts.value = true;
    loadMorePosts();
  }
}
