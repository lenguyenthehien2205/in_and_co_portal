import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/services/save_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveController extends GetxController{
  final ProfileController profileController = Get.find();
  late String userId = FirebaseAuth.instance.currentUser!.uid;
  final SaveService saveService = SaveService();
  final String postId;
  SaveController(this.postId);
  var hasSaved = false.obs;
  var lastActionTime = DateTime.now();
  var isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPostSaveData();
    _listenAuthChanges();
  }

  void _listenAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user?.uid != userId) {
        userId = user!.uid;
        loadPostSaveData();
      }
    });
  }

  void toggleSave(BuildContext context, String postOwnerId) async {
    if(isProcessing.value) return;
    isProcessing.value = true;

    bool serverHasSaved = await saveService.hasSavedPost(postId, userId);

    if(serverHasSaved != hasSaved.value) {
      hasSaved.value = serverHasSaved;
    }

    hasSaved.value = !hasSaved.value;
    lastActionTime = DateTime.now();

    Future.delayed(Duration(seconds: 1), () {
      if(DateTime.now().difference(lastActionTime).inSeconds >= 1) {
        _syncSaveToServer(context, postOwnerId);
      }
    });
  }

  Future<void> _syncSaveToServer(BuildContext context, String postOwnerId) async {
    final bool expectedState = hasSaved.value;

    try {
      await saveService.toggleSave(userId, postId, postOwnerId);
      profileController.loadSavedPosts(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hasSaved.value ? 'Đã lưu bài viết' : 'Đã bỏ lưu bài viết',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: hasSaved.value ? Colors.green : Colors.grey,
        ),
      );
    } catch (e) {
      if(hasSaved.value != expectedState) {
        hasSaved.value = expectedState;
      }
    }
    isProcessing.value = false;
  }

  Future<void> loadPostSaveData() async {
    clearAllSaveStatus();
    hasSaved.value = await saveService.hasSavedPost(postId, userId);
  }

  Future<void> clearAllSaveStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (var key in keys) {
      if (key.startsWith('save_')) {
        await prefs.remove(key); 
      }
    }
  }
}