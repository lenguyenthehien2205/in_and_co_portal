import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/services/user_service.dart';

class ProfileController extends GetxController{
  var userData = {}.obs;
  var isLoading = true.obs;
  String? currentUID;

  final UserService userService = UserService();

  @override
  void onInit() {
    super.onInit();
    _listenAuthChanges(); // Lắng nghe sự thay đổi đăng nhập
  }

  void _listenAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user?.uid != currentUID) {
        fetchUserData();
      }
    });
  }

  void fetchUserData() async {
    String? newUID = FirebaseAuth.instance.currentUser?.uid;
    if (newUID == null) {
      userData.value = {}; // Xóa dữ liệu nếu không có người dùng
      currentUID = null;
      return;
    }

    isLoading.value = true;
    await userService.fetchUserData();
    userData.value = userService.userData ?? {};
    currentUID = newUID; // Cập nhật UID mới
    isLoading.value = false;
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    userData.value = {};  // Xóa dữ liệu khi đăng xuất
    currentUID = null;
  }
}