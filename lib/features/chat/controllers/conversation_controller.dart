import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/conversation.dart';
import 'package:in_and_co_portal/core/services/conversation_service.dart';

class ConversationController extends GetxController {
  RxBool isLoading = false.obs;
  var userId = FirebaseAuth.instance.currentUser?.uid;
  var conversations = <ConversationDetail>[].obs;
  Map<String, Map<String, dynamic>> userCache = {};
  final ConversationService conversationService = ConversationService();
  StreamSubscription<List<ConversationDetail>>? _conversationSubscription;
  
  @override
  void onInit() {
    super.onInit();
    fetchConversations(); 
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user?.uid != userId) {
        userId = user!.uid;
        fetchConversations();
      }
    });
  }

  void fetchConversations() {
    isLoading.value = true;
    _conversationSubscription?.cancel(); // Hủy bỏ subscription cũ nếu có
    _conversationSubscription = conversationService.getConversations(FirebaseAuth.instance.currentUser?.uid ?? "").listen(
      (data) {
        conversations.assignAll(data);
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        print("Lỗi khi tải cuộc trò chuyện: $error");
      },
    );
  }
}