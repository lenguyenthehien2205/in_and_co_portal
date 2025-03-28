import 'package:cloud_firestore/cloud_firestore.dart';

class Save {
  final String id;
  final String userId;
  final String postId;
  final String postOwnerId;

  Save({
    required this.id,
    required this.userId,
    required this.postId,
    required this.postOwnerId
  });

  factory Save.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Save(
      id: doc.id,
      userId: data['user_id'] ?? '',
      postId: data['post_id'] ?? '',
      postOwnerId: data['post_owner_id'] ?? ''
    );
  }
}