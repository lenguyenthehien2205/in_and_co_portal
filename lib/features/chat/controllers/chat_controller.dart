import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';
import 'package:in_and_co_portal/core/controllers/translation_controller.dart';
import 'package:in_and_co_portal/core/models/message.dart' as model;
import 'package:in_and_co_portal/core/services/chat_service.dart';
import 'package:in_and_co_portal/core/services/conversation_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';

class ChatController extends GetxController {
  var otherUserInfo = <String, dynamic>{}.obs;
  RxBool isLoading = true.obs;
  final ProfileController profileController = Get.find<ProfileController>();
  final TranslationController translationController = Get.find<TranslationController>();
  final SmartReply smartReply = SmartReply(); 
  final RxList<String> suggestions = <String>[].obs;

  var conversationId = ''.obs; // Dùng obs để có thể cập nhật
  var messages = <model.Message>[].obs;
  var messageController = TextEditingController().obs;
  final ChatService chatService = ChatService();
  final ConversationService conversationService = ConversationService();
  StreamSubscription<List<model.Message>>? _messageSubscription; 

  ChatController({required String conversationId}) {
    this.conversationId.value = conversationId;
    print("Conversation ID: $conversationId");
  }

  @override
  void onInit() {
    super.onInit();
    fetchMessages(); 
  }

  @override
  void onClose() {
    _messageSubscription?.cancel(); 
    super.onClose();
  }

  void clearMessages() {
    messages.clear();
    suggestions.clear();
  }

  void fetchMessages() {
    isLoading.value = true;

    _messageSubscription?.cancel(); 
    clearMessages(); 

    _messageSubscription = chatService.getMessages(conversationId.value).listen((data) async {
      messages.assignAll(data);
      await buildSmartReply();
      isLoading.value = false;
    }, onError: (error) {
      print("Lỗi khi tải tin nhắn: $error");
      isLoading.value = false;
    });
  }


  void sendMessage() async {
    if (messageController.value.text.isNotEmpty) {
      try {
        var messageText = messageController.value.text.trim();
        messageController.value.clear();
        await chatService.sendMessage(
          conversationId.value,
          profileController.myUID.value,
          messageText,
        );
        await conversationService.updateConversation( 
          conversationId.value,
          messageText,
          profileController.myUID.value,
        );
      } catch (error) {
        print("Lỗi khi gửi tin nhắn: $error");
      }
    }
  }

  Future<void> buildSmartReply() async {
    final smartReply = SmartReply();
    final sortedMessages = messages.toList()
        ..sort((a, b) => a.sendedAt.compareTo(b.sendedAt));
    final recentMessages = sortedMessages.length > 5
        ? sortedMessages.sublist(sortedMessages.length - 5)
        : sortedMessages;

    for (final message in recentMessages) {
      final translatedText = await translationController.translateTextString(message.text, 'en');
      if (message.senderId == profileController.myUID.value) {
        smartReply.addMessageToConversationFromLocalUser(
          translatedText,
          message.sendedAt.microsecondsSinceEpoch, 
        );
      } else {
        smartReply.addMessageToConversationFromRemoteUser(
          translatedText,
          message.sendedAt.microsecondsSinceEpoch, 
          message.senderId,
        );
      }
    }
    try {
      final result = await smartReply.suggestReplies();
      final translatedSuggestions = <String>[];
      for (final suggestion in result.suggestions) {
        final translated = await translationController.translateTextString(suggestion, 'en');
        translatedSuggestions.add(translated);
      }
      suggestions.assignAll(translatedSuggestions); 
    } catch (e) {
      print("SmartReply Error: $e");
    }
  }
}
