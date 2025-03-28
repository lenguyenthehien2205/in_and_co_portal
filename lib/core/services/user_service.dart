import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/utils/string_utils.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var userData = {}.obs;

  Future<void> updateAllUsersWithKeywords() async {
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      String name = doc["fullname"]; // Lấy tên từ Firestore
      List<String> keywords = generateKeywords(name); // Tạo keywords
      await _firestore.collection("users").doc(doc.id).update({
        "keywords": keywords,
      });
    }
  }

  
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.isEmpty) return [];
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("keywords", arrayContains: query)
        .limit(4)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }



  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
      userData.value = userDoc.data() as Map<String, dynamic>;
      print(userData);
    }
  }

  Future<Map<String, dynamic>> getUserByPostId(String postId) async {
    var userSnapshot = await FirebaseFirestore.instance.collection("users").get();

    for (var userDoc in userSnapshot.docs) {
      var postSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userDoc.id)
          .collection("posts")
          .doc(postId)
          .get();
      if (postSnapshot.exists) {
        Map<String, dynamic> userData = userDoc.data(); 
        userData["id"] = userDoc.id; 
        return userData; 
      }
    }
    return {}; 
  }
  Future<Map<String, dynamic>> getUserById(String userId) async {
    var userDoc = await FirebaseFirestore.instance.collection("users").doc(userId).get();

    if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() ?? {}; 
        userData["id"] = userDoc.id; 
        return userData; 
    }
    return {}; 
  }
}