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
    }
  }
}