import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/services/conversation_service.dart';
import 'package:in_and_co_portal/core/services/firebase_service.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/core/models/save.dart';
import 'package:in_and_co_portal/core/services/commission_service.dart';
import 'package:in_and_co_portal/core/services/post_service.dart';
import 'package:in_and_co_portal/core/services/save_service.dart';
import 'package:in_and_co_portal/core/services/user_service.dart';

class ProfileController extends GetxController{
  var userData = {}.obs;
  var otherUserData = {}.obs;
  var isViewingOtherUser = false.obs;
  var isLoading = true.obs;
  var myUID = ''.obs;         // luôn là uid của mình
  var viewedUID = ''.obs;
  var posts = <PostOnlyImage>[].obs;
  var posts_saved = <PostOnlyImage>[].obs;
  var conversationId = ''.obs;

  final UserService userService = UserService();
  final CommissionService commissionService = CommissionService();
  final PostService postService = PostService();
  final SaveService saveService = SaveService();
  final ConversationService conversationService = ConversationService();
  final FCMService fcmService = FCMService();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    _listenAuthChanges(); 
  }

  // void _listenAuthChanges() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user?.uid != currentUID) {
  //       fetchUserData();
  //     }
  //   });
  // }
  void _listenAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        userData.value = {};
        posts.clear();
        posts_saved.clear();
        myUID.value = '';
        isViewingOtherUser.value = false;
      } else if (user.uid != myUID.value) {
        fetchCurrentUserData();
      }
    });
  }

  // void fetchUserData({String? userId}) async {
  //   if(userId == null){
  //     isViewingOtherUser.value = false;
  //     String? newUID = FirebaseAuth.instance.currentUser?.uid;
  //     if (newUID == null) {
  //       userData.value = {}; // Xóa dữ liệu nếu không có người dùng
  //       currentUID.value = '';
  //       return;
  //     }

  //     isLoading.value = true;
  //     await userService.fetchUserData();
  //     userData.value = userService.userData;
  //     currentUID.value = newUID; // Cập nhật UID mới
  //     // postService.getPostsByUserId(currentUID.value).listen((postList) {
  //     //   posts.assignAll(postList);
  //     // });
  //     posts.assignAll(await postService.getPostsByUserId(currentUID.value));
  //     loadSavedPosts(newUID);
  //     fcmService.subscribeToUserNotifications();
  //     isLoading.value = false;
  //   } else {
  //     isViewingOtherUser.value = true;
  //     isLoading.value = true;
  //     await userService.fetchUserData(userId: userId);
  //     otherUserData.value = userService.otherUserData;
  //     currentUID.value = userId;
  //     // postService.getPostsByUserId(currentUID.value).listen((postList) {
  //     //   posts.assignAll(postList);
  //     // });
  //     posts.assignAll(await postService.getPostsByUserId(currentUID.value));
  //     print('${otherUserData["id"]} ${FirebaseAuth.instance.currentUser?.uid ?? ''}');
  //     conversationId.value = await conversationService.getConversationId(otherUserData["id"], FirebaseAuth.instance.currentUser?.uid ?? '');
  //     loadSavedPosts(userId);
  //     isLoading.value = false;  
  //   }
  // }
  Future<void> fetchCurrentUserData() async {
    isViewingOtherUser.value = false;
    String? newUID = FirebaseAuth.instance.currentUser?.uid;

    if (newUID == null) {
      userData.value = {};
      viewedUID.value = '';
      return;
    }

    isLoading.value = true;
    await userService.fetchUserData();
    userData.value = userService.userData;
    myUID.value = newUID;
    viewedUID.value = newUID;

    posts.assignAll(await postService.getPostsByUserId(viewedUID.value));
    loadSavedPosts(viewedUID.value);
    fcmService.subscribeToUserNotifications();

    isLoading.value = false;
  }

  // 🔹 Fetch người dùng khác (khi xem hồ sơ người khác)
  Future<void> fetchOtherUserData(String userId) async {
    isViewingOtherUser.value = true;
    isLoading.value = true;

    await userService.fetchUserData(userId: userId);
    otherUserData.value = userService.otherUserData;
    viewedUID.value = userId;

    posts.assignAll(await postService.getPostsByUserId(viewedUID.value));

    conversationId.value = await conversationService.getConversationId(
      viewedUID.value,
      myUID.value,
    );

    loadSavedPosts(viewedUID.value);
    isLoading.value = false;
  }

  void fetchUserData({String? userId}) {
    if (userId == null) {
      fetchCurrentUserData();
    } else {
      fetchOtherUserData(userId);
    }
  }


  void loadSavedPosts(String userId) async{
    List<Save> saveList = await saveService.getAllSavedPosts(userId);
    if (saveList == null || saveList.isEmpty) { 
      posts_saved.clear(); 
      return;
    }
    List<PostOnlyImage> savedPosts = await postService.getPostsByUserAndIds(saveList);
    posts_saved.clear();
    posts_saved.assignAll(savedPosts);
  }

  void logout() {
    fcmService.unsubscribeFromUserNotifications();
    FirebaseAuth.instance.signOut();
    userData.value = {};  // Xóa dữ liệu khi đăng xuất
    myUID.value = '';
  }

  void updateAllUsersWithKeywords() async {
    await userService.updateAllUsersWithKeywords();
  }

  
}