import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbService {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  // Lưu đường dẫn file vào firestore
  Future<void> saveUploadedFile(String imageUrl) async {
    String userId = currentUser!.uid;
    Map<String, String> data = {
      "imageUrl": imageUrl,
      "uploadedAt": DateTime.now().toIso8601String()
    };

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Lưu ảnh mới vào "latest" (ghi đè ảnh cũ)
    await firestore
        .collection('user-files')
        .doc(userId)
        .collection('latest')
        .doc('latest_image') // Dùng doc cố định để ghi đè ảnh cũ
        .set(data);

    // Lưu ảnh vào "uploads" (lưu tất cả ảnh)
    await firestore
        .collection('user-files')
        .doc(userId)
        .collection('uploads')
        .add(data); 
  }

  // lấy ra ảnh mới nhất
  Stream<DocumentSnapshot> readLatestUploadedFile(){
    return FirebaseFirestore.instance
          .collection('user-files')
          .doc(currentUser!.uid)
          .collection('latest')
          .doc('latest_image')
          .snapshots();
  }
}