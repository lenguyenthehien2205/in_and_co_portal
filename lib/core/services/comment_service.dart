import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/config/firebase_api.dart';
import 'package:in_and_co_portal/core/models/comment.dart';
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
      String title = 'Thông báo về bình luận 💭';
      String message = '${userCommented['fullname']} đã bình luận về bài viết của bạn';
      await _firebaseApi.sendNotificationToAuthor(author['id'], title, message);
      await _notificationService.addNotification(author['id'], comment.userId, comment.postId, title, message);
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
