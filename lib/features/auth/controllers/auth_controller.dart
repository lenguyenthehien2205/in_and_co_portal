import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs; // Để kiểm soát trạng thái loading

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập đầy đủ thông tin",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed('/home'); // Điều hướng sau khi đăng nhập thành công
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Lỗi", e.message ?? "Đăng nhập thất bại",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Get.theme.colorScheme.error);
    } finally {
      isLoading.value = false;
    }
  }
}
