import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final List<Map<String, dynamic>> images;
  final String postType;

  Post({
    required this.id,
    required this.title, 
    required this.images, 
    required this.postType,
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

class PostDetail{
  final String id;
  final String title;
  final List<Map<String, dynamic>> images;
  final String postType;
  late String authorId;
  late String authorName;
  late String authorAvatar;
  late bool isChecked;
  late Timestamp createdAt;
  late int likes;

  PostDetail({
    required this.id,
    required this.title, 
    required this.images, 
    required this.postType,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.isChecked,
    required this.createdAt,
    this.likes = 0,
  });

  factory PostDetail.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostDetail(
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
      authorName: data['author_name'] ?? '',
      authorAvatar: data['author_avatar'] ?? '',
      isChecked: data['is_checked'] ?? false,
      createdAt: data['created_at'] ?? Timestamp.now(),
      likes: data['likes'] ?? 0,
    );
  }
}

class PostOnlyImage{
  final String id;
  final String url;
  final String authorId;

  PostOnlyImage({
    required this.id,
    required this.url,
    required this.authorId,
  });

  factory PostOnlyImage.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostOnlyImage(
      id: doc.id,
      url: data['post_images'][0]['url'] ?? '',
      authorId: data['author_id'] ?? '',
    );
  }
}