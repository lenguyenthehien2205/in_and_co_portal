import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/core/models/save.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Post>> getCompanyPosts({
    int limit = 3,
    List<String> excludeIds = const [],
  }) {
    return _firestore.collection('users').snapshots().asyncMap((
      usersSnapshot,
    ) async {
      List<Post> allPosts = [];
      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;
        var postsSnapshot =
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('posts')
                .where('post_type', isEqualTo: 'Công ty')
                .get();
        List<Post> userPosts =
            postsSnapshot.docs
                .map((doc) => Post.fromFirestore(doc))
                .where((post) => !excludeIds.contains(post.id))
                .toList();
        allPosts.addAll(userPosts);
      }
      allPosts = allPosts.take(limit).toList();
      return allPosts;
    });
  }

  Stream<List<PostDetail>> getPosts({
    int limit = 3,
    List<String> excludeIds = const [],
  }) {
    return _firestore.collection('users').snapshots().asyncMap((
      usersSnapshot,
    ) async {
      List<PostDetail> allPosts = [];

      // Duyệt qua từng user để lấy posts
      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;

        var postsSnapshot =
            await _firestore
                .collection('users')
                .doc(userId)
                .collection('posts')
                .get();

        List<PostDetail> userPosts =
            postsSnapshot.docs
                .map((doc) => PostDetail.fromFirestore(doc))
                .where((post) => !excludeIds.contains(post.id))
                .toList();

        var userData = userDoc.data();
        String authorName = userData['fullname'] ?? 'Unknown';
        String authorAvatar = userData['avatar'] ?? '';
        bool isChecked = userData['is_checked'] ?? false;

        for (var post in userPosts) {
          post.authorName = authorName;
          post.authorAvatar = authorAvatar;
          post.isChecked = isChecked;
          post.authorId = userId;
        }

        allPosts.addAll(userPosts);
      }
      allPosts = allPosts.take(limit).toList();
      return allPosts;
    });
  }

  Future<List<Map<String, dynamic>>> searchPostsByLabelAndTitle(
    String keyword,
  ) async {
    if (keyword.isEmpty) return [];
    List<Map<String, dynamic>> results = [];
    // Lấy danh sách tất cả users
    var userSnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (var userDoc in userSnapshot.docs) {
      var postSnapshot =
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userDoc.id)
              .collection("posts")
              .get();
      var posts =
          postSnapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).where((
            post,
          ) {
            String title = post["title"]?.toString().toLowerCase() ?? "";
            var images = post["post_images"];

            bool matchesTitle = title.contains(keyword.toLowerCase());
            bool matchesLabel = false;

            if (images != null && images is List) {
              matchesLabel = images.any((image) {
                var labels = image["labels"];
                if (labels == null || labels is! List) return false;
                return labels
                    .map((label) => label.toString().toLowerCase())
                    .contains(keyword.toLowerCase());
              });
            }
            return matchesTitle || matchesLabel;
          }).toList();
      results.addAll(posts);
    }
    return results;
  }

  Stream<List<PostOnlyImage>> getPostsByUserId(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('posts')
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => PostOnlyImage.fromFirestore(doc))
              .toList();
        });
  }

  Future<PostDetail> getPostById(String userId, String postId) async {
    var postSnapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('posts')
            .doc(postId)
            .get();
    
    return PostDetail.fromFirestore(postSnapshot);
  }

  Future<List<Map<String, String>>> getTopLabelsWithImage({
    int top = 10,
  }) async {
    Map<String, List<String>> labelToImages = {};
    Map<String, int> labelCount = {};
    Set<String> usedImages = {};

    var userSnapshot = await _firestore.collection("users").get();

    for (var userDoc in userSnapshot.docs) {
      var postSnapshot =
          await _firestore
              .collection("users")
              .doc(userDoc.id)
              .collection("posts")
              .get();

      for (var doc in postSnapshot.docs) {
        var data = doc.data();
        var images = data["post_images"];

        if (images != null && images is List) {
          for (var image in images) {
            var labels = image["labels"];
            String? imageUrl = image["url"];

            if (labels != null && labels is List && imageUrl != null) {
              for (var label in labels) {
                String labelText = label.toString().toLowerCase();
                labelCount[labelText] = (labelCount[labelText] ?? 0) + 1;
                labelToImages.putIfAbsent(labelText, () => []).add(imageUrl);
              }
            }
          }
        }
      }
    }
    var sortedLabels =
        labelCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    List<Map<String, String>> topLabelsWithImages = [];

    for (var entry in sortedLabels.take(top)) {
      String label = entry.key;
      List<String> images = labelToImages[label] ?? [];

      String selectedImage = images.firstWhere(
        (img) => !usedImages.contains(img),
        orElse: () => images.last,
      );
      usedImages.add(selectedImage);
      topLabelsWithImages.add({"label": label, "url": selectedImage});
    }

    return topLabelsWithImages;
  }

  // Future<List<PostOnlyImage>> getPostsByIds(List<String> postIds) async {
  //   if (postIds.isEmpty) return [];

  //   QuerySnapshot querySnapshot = await _firestore
  //       .collection('users')
  //       .doc()
  //       .collection('posts')
  //       .where(FieldPath.documentId, whereIn: postIds)
  //       .get();

  //   List<PostOnlyImage> posts = querySnapshot.docs.map((doc) {
  //     print('Post id: ${doc.id}');
  //     return PostOnlyImage.fromFirestore(doc);
  //   }).toList();
  //   print('Posts: ${posts.length}');

  //   return posts;
  // }
  Future<List<PostOnlyImage>> getPostsByUserAndIds(List<Save> savedPosts) async {
    if (savedPosts.isEmpty) return [];
    List<PostOnlyImage> posts = [];
    for (Save saved in savedPosts) {
      DocumentSnapshot docSnapshot = await _firestore
          .collection('users')
          .doc(saved.postOwnerId)  // 🔹 Truy vấn đúng user
          .collection('posts')
          .doc(saved.postId)  // 🔹 Truy vấn đúng bài viết
          .get();
      print(saved.postId);
      if (docSnapshot.exists) {
        posts.add(PostOnlyImage.fromFirestore(docSnapshot));
      }
    }
    print('Posts: ${posts.length}');
    return posts;
  }
}
