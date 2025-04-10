import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/config/firebase_api.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/core/models/notification.dart' as model;
import 'package:in_and_co_portal/core/services/notification_service.dart';
import 'package:in_and_co_portal/core/services/post_service.dart';
import 'package:in_and_co_portal/core/services/user_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';

class PendingPostController extends GetxController{
  RxList<PostDetail> pendingPosts = <PostDetail>[].obs;
  RxBool isLoading = false.obs;
  final PostService postService = PostService();
  final UserService userService = UserService();
  final NotificationService notificationService = NotificationService();
  final FirebaseApi firebaseApi = FirebaseApi();
  final ProfileController profileController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchData(); 
  }

  void fetchData() {
    isLoading.value = true;
    postService.getAllPendingPostsStream().listen((posts) {
      pendingPosts.assignAll(posts);
      isLoading.value = false;
    }, onError: (error) {
      print("Error fetching posts: $error");
      isLoading.value = false; 
    });
  }

  Future<void> approvePost(String postId, String userId) async {
    await postService.acceptPost(postId, 'accepted');
    var title = '${'notification_about_new_post'.tr} 📝';
    var body = '${'notification_about_approve_post'.tr} ✅';
    model.Notification notification = model.Notification(
      title: title,
      message: body,
      postId: postId, 
      type: 'post',
      createdAt: Timestamp.now(),
      isRead: false,
      senderId: profileController.myUID.value,
    );
    notificationService.addNotification(userId, notification);
    firebaseApi.sendNotificationToAuthor(userId, title, body);
  }

  Future<void> rejectPost(String postId, String userId) async {
    await postService.rejectPost(postId);
    var title = '${'notification_about_new_post'.tr} 📝';
    var body = '${'notification_about_reject_post'.tr} ❌';
    model.Notification notification = model.Notification(
      title: title,
      message: body,
      postId: postId, 
      type: 'post',
      createdAt: Timestamp.now(),
      isRead: false,
      senderId: profileController.myUID.value,
    );
    notificationService.addNotification(userId, notification);
    firebaseApi.sendNotificationToAuthor(userId, title, body);
  }
}