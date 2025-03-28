import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String title;
  final String message;
  final String postId;
  final Timestamp createdAt;
  final bool isRead;
  final String senderId;

  Notification({
    required this.title,
    required this.message,
    required this.postId,
    required this.createdAt,
    required this.isRead,
    required this.senderId,
  });

  factory Notification.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Notification(
      title: data['title'],
      message: data['message'],
      postId: data['post_id'],
      createdAt: data['created_at'],
      isRead: data['is_read'],
      senderId: data['sender_id'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "message": message,
      "post_id": postId,
      "created_at": createdAt,
      "is_read": isRead,
    };
  }
}

class NotificationDetail extends Notification {
  final String userName;
  final String userAvatar;

  NotificationDetail({
    required String title,
    required String message,
    required String postId,
    required Timestamp createdAt,
    required bool isRead,
    required String senderId,
    required this.userName,
    required this.userAvatar,
  }) : super(
          title: title,
          message: message,
          postId: postId,
          createdAt: createdAt,
          isRead: isRead,
          senderId: senderId,
        );

  factory NotificationDetail.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationDetail(
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      postId: data['post_id'] ?? '',
      createdAt: data['created_at'] ?? Timestamp.now(),
      isRead: data['is_read'] ?? false,
      senderId: data['sender_id'] ?? '',
      userName: data['fullname'] ?? '',
      userAvatar: data['avatar'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(), // Kế thừa toMap() từ class cha
      "user_name": userName,
      "user_avatar": userAvatar,
    };
  }
}