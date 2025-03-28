import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/core/services/post_service.dart';

class PostDetailController extends GetxController {
  final String userId;
  final String postId;
  final PostService postService = PostService();
  Rx<PostDetail> post = PostDetail(
    id: '',
    title: '',
    images: [],
    postType: '',
    authorId: '',
    authorName: '',
    authorAvatar: '',
    isChecked: false,
    createdAt: Timestamp.now(),
    likes: 0,
  ).obs;
  
  RxBool isLoading = true.obs;

  PostDetailController(this.userId, this.postId);

  @override
  void onInit() {
    super.onInit();
    fetchPost();
  }

  void fetchPost() async {
    try {
      isLoading.value = true;
      PostDetail postDetail = await postService.getPostById(userId, postId);
      post.value = postDetail;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

}