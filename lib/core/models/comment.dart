import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String userId;
  final String postId;
  final String content;
  final Timestamp createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.content,
    required this.createdAt,
  });  

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      userId: data['user_id'] ?? '',
      postId: data['post_id'] ?? '',
      content: data['content'] ?? '',
      createdAt: data['created_at'] ?? Timestamp.now()
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'post_id': postId,
      'content': content,
      'created_at': createdAt
    };
  }
}

class CommentDetail {
  final String id;
  final String userId;
  final String postId;
  final String content;
  final Timestamp createdAt;
  final String userName;
  final String userAvatar;
  final bool isChecked;

  CommentDetail({
    required this.id,
    required this.userId,
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.userName,
    required this.userAvatar,
    required this.isChecked,
  });

  factory CommentDetail.fromJson(Map<String, dynamic> json) {
    return CommentDetail(
      id: json['id'],
      userId: json['userId'],
      postId: json['postId'],
      content: json['content'],
      createdAt: Timestamp.fromMillisecondsSinceEpoch(json['createdAt']),
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      isChecked: json['isChecked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postId': postId,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userName': userName,
      'userAvatar': userAvatar,
      'isChecked': isChecked,
    };
  }
}