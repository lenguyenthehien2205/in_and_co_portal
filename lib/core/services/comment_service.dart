import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/config/firebase_api.dart';
import 'package:in_and_co_portal/core/models/comment.dart';
import 'package:in_and_co_portal/core/models/notification.dart' as model;
import 'package:in_and_co_portal/core/services/notification_service.dart';
import 'package:in_and_co_portal/core/services/user_service.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  final FirebaseApi _firebaseApi = FirebaseApi();
  final NotificationService _notificationService = NotificationService();
  Future<List<CommentDetail>> getCommentsByPost(String postId) async {
    QuerySnapshot commentSnapshot = await _firestore
        .collection('post_comments')
        .where('post_id', isEqualTo: postId)
        .orderBy('created_at', descending: true)
        .get();

    List<CommentDetail> commentDetails = [];

    for (var doc in commentSnapshot.docs) {
      Comment comment = Comment.fromFirestore(doc);
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(comment.userId).get();

      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>?;
        commentDetails.add(CommentDetail(
          id: comment.id,
          userId: comment.userId,
          postId: comment.postId,
          content: comment.content,
          createdAt: comment.createdAt,
          userName: userData?['fullname'] ?? '',
          userAvatar: userData?['avatar'] ?? '',
          isChecked: userData?['is_checked'] ?? false,
        ));
      }
    }
    print('${commentDetails.length} comments');
    return commentDetails;
  }

  Future<void> addComment(Comment comment) async {
    DocumentReference docRef = await _firestore.collection('post_comments').add(comment.toMap());
    var author = await _userService.getUserByPostId(comment.postId);
    var userCommented = await _userService.getUserById(comment.userId);
    if (author['id'] != comment.userId) {
      String title = '${'notification_about_new_comment'.tr} 💭';
      String message = '${userCommented['fullname']} ${'notification_has_commented'.tr}';
      await _firebaseApi.sendNotificationToAuthor(author['id'], title, message);
      model.Notification notification = model.Notification(
        title: title,
        message: message,
        postId: comment.postId,
        type: 'comment',
        createdAt: comment.createdAt,
        isRead: false,
        senderId: comment.userId,
      );
      await _notificationService.addNotification(author['id'], notification);
    }
  }

  Future<int> getCommentCount(String postId) {
    return _firestore
        .collection('post_comments')
        .where('post_id', isEqualTo: postId)
        .get()
        .then((value) => value.docs.length); 
  }
}
