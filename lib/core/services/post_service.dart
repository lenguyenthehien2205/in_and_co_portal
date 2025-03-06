import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/post.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm một bài viết mới vào Firestore
  Future<void> addPost(Post post) async {
    await _firestore.collection('posts').add(post.toMap());
  }

  // Lấy tất cả bài viết có postType = "Công ty"
  Stream<List<Post>> getCompanyPosts() {
    return _firestore
        .collection('posts')
        .where('post_type', isEqualTo: 'Công ty')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Post.fromFirestore(doc))
            .toList());
  }
}