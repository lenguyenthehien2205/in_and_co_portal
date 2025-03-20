import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final List<Map<String, dynamic>> images;
  final String postType;
  final String authorId;
  String authorName;
  String authorAvatar;

  Post({
    required this.id,
    required this.title, 
    required this.images, 
    required this.postType,
    required this.authorId,
    this.authorName = '',
    this.authorAvatar = '',
  });

    // Convert từ Firestore document sang Post model
  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      title: data['title'] ?? '',
      images: (data['post_images'] as List<dynamic>?)
          ?.map((item) => {
                'url': item['url'] as String,
                'labels': (item['labels'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
              })
          .toList() ?? [],
      postType: data['post_type'] ?? '',
      authorId: data['author_id'] ?? '',
    );
  }

  // Chuyển Post -> Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'post_images': images.map((item) => {
        'url': item['url'],
        'labels': item['labels'],
      }).toList(),
      'post_type': postType,
    };
  }
}
