import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:in_and_co_portal/features/home/controllers/post_controller.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';

class AddPostController extends GetxController {
  final TextEditingController contentController = TextEditingController(); 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileController profileController = Get.find();
  final RxList<File> selectedImages = <File>[].obs;
  final ImagePicker picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isLoading = false.obs;

  final RxList<List<String>> imageLabels = <List<String>>[].obs;
  late ImageLabeler _labeler; 

  @override
  void onInit() {
    super.onInit();
    _labeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.6)); 
  }

  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
      analyzeImages();
    }
  }

  Future<void> analyzeImages() async {
    imageLabels.clear(); 
    for (var img in selectedImages) {
      imageLabels.add([]);
      final inputImage = InputImage.fromFile(img);
      final detectedLabels = await _labeler.processImage(inputImage);

      List<String> labelTexts = detectedLabels.map((e) => e.label).toList();
      imageLabels[selectedImages.indexOf(img)] = labelTexts;
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<String?> uploadToCloudinary(File imageFile) async {
    String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    String apiUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    var request = http.MultipartRequest("POST", Uri.parse(apiUrl));
    var fileBytes = await imageFile.readAsBytes();
    var multipartFile = http.MultipartFile.fromBytes(
      'file', fileBytes,
      filename: imageFile.path.split('/').last,
    );

    request.files.add(multipartFile);
    request.fields['upload_preset'] = 'preset-for-file-upload';
    request.fields['resource_type'] = 'image';

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);
      return jsonResponse['secure_url']; 
    } else {
      print("Upload thất bại: $responseBody");
      return null;
    }
  }

  Future<void> submitPost(BuildContext context) async {
    if (contentController.text.isEmpty || selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bạn chưa nhập nội dung bài viết hoặc chưa chọn ảnh',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }
    isLoading.value = true;

    List<Map<String, dynamic>> uploadedImages = [];
    for (var i = 0; i < selectedImages.length; i++) {
      String? imageUrl = await uploadToCloudinary(selectedImages[i]);
      if (imageUrl != null) {
        uploadedImages.add({
          'url': imageUrl,
          'labels': i < imageLabels.length ? imageLabels[i] : [],
        });
      }
    }
    await _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('posts')
      .add({
        'title': contentController.text,
        'post_images': uploadedImages,
        'post_type': profileController.userData['role'] != 'Admin' ? 'Cá nhân' : 'Công ty',
        'created_at': FieldValue.serverTimestamp(),
    });
    isLoading.value = false;

    Get.find<PostController>().refreshPosts(); 

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thêm bài viết thành công',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );

    context.go('/home');
    contentController.clear();
    selectedImages.clear();
    imageLabels.clear();
  }
}