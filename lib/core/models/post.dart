import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String thumbnailUrl;
  final String postType;

  Post({required this.title, required this.thumbnailUrl, required this.postType});

    // Convert từ Firestore document sang Post model
  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(
      title: data['title'] ?? '', 
      thumbnailUrl: data['thumbnail_url'] ?? '', // Chuyển từ snake_case -> camelCase
      postType: data['post_type'] ?? '',
    );
  }

  // Chuyển Post -> Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'postType': postType,
    };
  }
}
