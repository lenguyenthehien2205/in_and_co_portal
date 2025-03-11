import 'package:get/get.dart';
import 'package:in_and_co_portal/core/services/db_service.dart';

class ProfileController extends GetxController{
  var imageUrl = "".obs;
  final DbService dbService = DbService();

  @override
  void onInit() {
    super.onInit();
    loadProfileImage();
  }

  void loadProfileImage() {
    dbService.readLatestUploadedFile().listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey("imageUrl")) {
          imageUrl.value = data["imageUrl"];
        }
      }
    });
  }
}