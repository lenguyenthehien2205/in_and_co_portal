import 'package:cloud_firestore/cloud_firestore.dart';

class Like {
  final String id;
  final String userId;
  final String postId;
  final Timestamp likedAt;

  Like({
    required this.id,
    required this.userId,
    required this.postId,
    required this.likedAt
  });

  factory Like.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Like(
      id: doc.id,
      userId: data['user_id'] ?? '',
      postId: data['post_id'] ?? '',
      likedAt: data['liked_at'] ?? Timestamp.now()
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'post_id': postId,
      'liked_at': likedAt
    };
  }
}