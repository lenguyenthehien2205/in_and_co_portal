import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/services/like_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeController extends GetxController {
  late String userId = FirebaseAuth.instance.currentUser!.uid;
  final LikeService likeService = LikeService();
  final String postId; 
  LikeController(this.postId);
  var likeCount = 0.obs;
  var hasLiked = false.obs;
  var lastActionTime = DateTime.now();
  var isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPostLikeData();
    _listenAuthChanges();
  }

  void _listenAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user?.uid != userId) {
        userId = user!.uid;
        loadPostLikeData();
      }
    });
  }

  void toggleLike() async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    bool serverHasLiked = await likeService.hasLikedPost(postId, userId);

    if (serverHasLiked != hasLiked.value) {
      hasLiked.value = serverHasLiked;
      likeCount.value += hasLiked.value ? 1 : -1;
    }

    hasLiked.value = !hasLiked.value;
    likeCount.value += hasLiked.value ? 1 : -1;
    lastActionTime = DateTime.now();

    Future.delayed(Duration(seconds: 1), () {
      if (DateTime.now().difference(lastActionTime!).inSeconds >= 1) {
        _syncLikeToServer();
      }
    });
  }

  Future<void> _syncLikeToServer() async {
    final bool expectedState = hasLiked.value;

    try {
      await likeService.toggleLike(userId, postId);
    } catch (e) {
      if (hasLiked.value != expectedState) {
        hasLiked.value = expectedState;
        likeCount.value += hasLiked.value ? 1 : -1;
      }
    } finally {
      isProcessing.value = false; 
    }
  }


  Future<void> loadPostLikeData() async {
    clearAllLikeStatus();
    likeCount.value = await likeService.getLikeCount(postId);
    hasLiked.value = await likeService.hasLikedPost(postId, userId);
  }

  Future<void> clearAllLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (var key in keys) {
      if (key.startsWith('like_')) {
        await prefs.remove(key); 
      }
    }
  }
}