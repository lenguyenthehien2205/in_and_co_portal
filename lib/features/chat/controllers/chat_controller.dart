import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/message.dart';
import 'package:in_and_co_portal/core/services/chat_service.dart';
import 'package:in_and_co_portal/core/services/conversation_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';

class ChatController extends GetxController {
  var otherUserInfo = <String, dynamic>{}.obs;
  RxBool isLoading = true.obs;
  final ProfileController profileController = Get.find<ProfileController>();

  var conversationId = ''.obs; // Dùng obs để có thể cập nhật
  var messages = <Message>[].obs;
  var messageController = TextEditingController().obs;
  final ChatService chatService = ChatService();
  final ConversationService conversationService = ConversationService();

  ChatController({required String conversationId}) {
    this.conversationId.value = conversationId;
    print("Conversation ID: $conversationId");
  }

  @override
  void onInit() {
    super.onInit();
    fetchMessages(); 
  }

  void clearMessages() {
    messages.clear();
  }

  void fetchMessages() async {
    isLoading.value = true;
    try {
      chatService.getMessages(conversationId.value).listen((data) {
        messages.assignAll(data);
        isLoading.value = false;
      });
    } catch (error) {
      print("Lỗi khi tải tin nhắn: $error");
    } finally {
      isLoading.value = false;
    }
  }

  void sendMessage() async {
    if (messageController.value.text.isNotEmpty) {
      try {
        await chatService.sendMessage(
          conversationId.value,
          profileController.currentUID.value,
          messageController.value.text,
        );
        await conversationService.updateConversation( 
          conversationId.value,
          messageController.value.text,
          profileController.currentUID.value,
        );
        messageController.value.clear();
      } catch (error) {
        print("Lỗi khi gửi tin nhắn: $error");
      }
    }
  }
}