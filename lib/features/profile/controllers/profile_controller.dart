import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/services/firebase_service.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/core/models/save.dart';
import 'package:in_and_co_portal/core/services/commission_service.dart';
import 'package:in_and_co_portal/core/services/post_service.dart';
import 'package:in_and_co_portal/core/services/save_service.dart';
import 'package:in_and_co_portal/core/services/user_service.dart';

class ProfileController extends GetxController{
  var userData = {}.obs;
  var isLoading = true.obs;
  var currentUID = ''.obs;
  var posts = <PostOnlyImage>[].obs;
  var posts_saved = <PostOnlyImage>[].obs;

  final UserService userService = UserService();
  final CommissionService commissionService = CommissionService();
  final PostService postService = PostService();
  final SaveService saveService = SaveService();
  final FCMService fcmService = FCMService();

  @override
  void onInit() {
    super.onInit();
    _listenAuthChanges(); 
  }

  void _listenAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user?.uid != currentUID) {
        fetchUserData();
      }
    });
  }

  void fetchUserData() async {
    String? newUID = FirebaseAuth.instance.currentUser?.uid;
    if (newUID == null) {
      userData.value = {}; // Xóa dữ liệu nếu không có người dùng
      currentUID.value = '';
      return;
    }

    isLoading.value = true;
    await userService.fetchUserData();
    userData.value = userService.userData;
    currentUID.value = newUID; // Cập nhật UID mới
    isLoading.value = false;
    postService.getPostsByUserId(currentUID.value).listen((postList) {
      posts.assignAll(postList);
    });
    loadSavedPosts();
    fcmService.subscribeToUserNotifications();
  }

  void loadSavedPosts() async{
    List<Save> saveList = await saveService.getAllSavedPosts(currentUID.value);
    if (saveList.isEmpty) return;
    List<PostOnlyImage> savedPosts = await postService.getPostsByUserAndIds(saveList);
    posts_saved.assignAll(savedPosts);
  }

  void logout() {
    fcmService.unsubscribeFromUserNotifications();
    FirebaseAuth.instance.signOut();
    userData.value = {};  // Xóa dữ liệu khi đăng xuất
    currentUID.value = '';
  }

  void updateAllUsersWithKeywords() async {
    await userService.updateAllUsersWithKeywords();
  }
}