import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/config/firebase_api.dart';
import 'package:in_and_co_portal/core/models/notification.dart' as model;
import 'package:in_and_co_portal/core/services/notification_service.dart';
import 'package:in_and_co_portal/core/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final FirebaseApi _firebaseApi = FirebaseApi();
  final NotificationService _notificationService = NotificationService();

  Future<void> toggleLike(String userId, String postId) async {
    final prefs = await SharedPreferences.getInstance();

    final likeQuery = await _firestore
        .collection('post_likes')
        .where('post_id', isEqualTo: postId)
        .where('user_id', isEqualTo: userId)
        .get();

    bool serverHasLiked = likeQuery.docs.isNotEmpty;
    bool localLikeState = prefs.getBool('like_$postId') ?? false;

    if (serverHasLiked != localLikeState) {
      await prefs.setBool('like_$postId', serverHasLiked);
    }

    bool newLikeState = !serverHasLiked;
    await prefs.setBool('like_$postId', newLikeState);

    if (newLikeState) {
      await _firestore.collection('post_likes').add({
        'post_id': postId,
        'user_id': userId,
        'liked_at': FieldValue.serverTimestamp()
      });
      var author = await _userService.getUserByPostId(postId);
      var userLiked = await _userService.getUserById(userId);
      if(author['id'] != userId){        
        String title = 'Thông báo về lượt thích 💕';
        String message = '${userLiked['fullname']} đã thích bài viết của bạn';
        await _firebaseApi.sendNotificationToAuthor(author['id'], title, message);
        model.Notification notification = model.Notification(
          title: title,
          message: message,
          postId: postId,
          type: 'like',
          createdAt: Timestamp.now(),
          isRead: false,
          senderId: userId,
        ); 
        await _notificationService.addNotification(author['id'], notification);
      }
    } else {
      if (likeQuery.docs.isNotEmpty) {
        await likeQuery.docs.first.reference.delete();
      }
    }
  }

  Future<bool> hasLikedPost(String postId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    bool? localLike = prefs.getBool('like_$postId');

    if (localLike != null) {
      return localLike;
    }
    final like = await _firestore
        .collection('post_likes')
        .where('post_id', isEqualTo: postId)
        .where('user_id', isEqualTo: userId)
        .get();
    bool hasLiked = like.docs.isNotEmpty;
    await prefs.setBool('like_$postId', hasLiked); 
    return hasLiked;
  }

  Future<int> getLikeCount(String postId) {
    return _firestore
        .collection('post_likes')
        .where('post_id', isEqualTo: postId)
        .get()
        .then((value) => value.docs.length); 
  }

  // Future<List<Like>> getLikesForPost(String postId) {
  //   return _firestore
  //       .collection('post_likes')
  //       .where('post_id', isEqualTo: postId)
  //       .get()
  //       .then((value) => value.docs.map((doc) => Like.fromFirestore(doc)).toList());
  // }
}