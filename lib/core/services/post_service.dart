import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/post.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Post>> getCompanyPosts({int limit = 3, List<String> excludeIds = const []}) {
    return _firestore
        .collection('posts')
        .where('post_type', isEqualTo: 'Công ty')
        .snapshots()
        .map((snapshot) => snapshot.docs 
            .map((doc) => Post.fromFirestore(doc)) 
            .where((post) => !excludeIds.contains(post.id)) 
            .take(limit) 
            .toList());
  }
  
  Stream<List<Post>> getPosts({int limit = 3, List<String> excludeIds = const []}) {
    return _firestore.collection('posts').snapshots().asyncMap((snapshot) async {
      List<Post> posts = snapshot.docs
          .map((doc) => Post.fromFirestore(doc))
          .where((post) => !excludeIds.contains(post.id))
          .take(limit)
          .toList();

      // Lấy danh sách author_id duy nhất
      Set<String> authorIds = posts.map((post) => post.authorId).toSet();

      // Lấy thông tin users từ Firestore
      Map<String, Map<String, String>> authorMap = {};
      for (String id in authorIds) {
        var userDoc = await _firestore.collection('users').doc(id).get();
        if (userDoc.exists) {
          var userData = userDoc.data();
          authorMap[id] = {
            'name': userData?['fullname'] ?? 'Unknown',
            'avatar': userData?['avatar'] ?? '', // ✅ Lấy avatar từ Firestore
          };
        } else {
          authorMap[id] = {
            'name': 'Unknown',
            'avatar': '',
          };
        }
      }

      // Cập nhật author_name vào mỗi bài viết
      for (var post in posts) {
        post.authorName = authorMap[post.authorId]?['name'] ?? 'Unknown';
        post.authorAvatar = authorMap[post.authorId]?['avatar'] ?? '';
      }
      return posts;
    });
  }


  Future<List<Map<String, dynamic>>> searchPostsByLabel(String keyword) async {
    if (keyword.isEmpty) return [];

    var snapshot = await FirebaseFirestore.instance.collection("posts").get();

    return snapshot.docs
      .map((doc) => doc.data())
      .where((post) {
        var images = post["post_images"];
        if (images == null || images is! List) return false;
        return images.any((image) {
          var labels = image["labels"];
          if (labels == null || labels is! List) return false;
          return labels
              .map((label) => label.toString().toLowerCase())
              .contains(keyword.toLowerCase());
        });
      })
      .toList();
  }
}