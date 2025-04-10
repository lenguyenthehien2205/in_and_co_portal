import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/models/conversation.dart';
import 'package:in_and_co_portal/core/utils/string_utils.dart';
import 'package:in_and_co_portal/features/chat/controllers/conversation_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ConversationController conversationController = Get.put(ConversationController());


    return Scaffold(
      appBar: AppBar(
        title: Text("conversation_title".tr, style: AppText.headerTitle(context)),
        centerTitle: true,
      ),
      body: Center(
        child: CustomScrollView(
          slivers: [
            Obx(() {
              if (conversationController.isLoading.value) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (conversationController.conversations.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text("Không có cuộc trò chuyện nào")),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    ConversationDetail conversation = conversationController.conversations[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(conversation.avatar),
                        radius: 25, 
                      ),
                      title: Text(conversation.fullname, 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      subtitle: SizedBox(
                        width: 100,  
                        child: Row(
                          children: [
                            if(conversation.lastMessageSenderId == conversationController.userId) 
                              Text("${'chat_you'.tr}: ", style: AppText.subtitle(context))
                            else 
                              Text("${conversation.fullname}: ", style: AppText.subtitle(context)),
                            Expanded(
                              child: Text(
                                conversation.lastMessage,
                                style: AppText.subtitle(context),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        )
                      ),
                      trailing: Text(getTimeAgoByTimestamp(conversation.lastMessageTime), style: AppText.subtitle(context)),
                      onTap: () {
                        context.push('/conversations/chat/${conversation.id}', extra: {
                          "otherUserInfo": {
                            "fullname": conversation.fullname,
                            "avatar": conversation.avatar,
                            "is_checked": conversation.isChecked,
                            "role": conversation.role,
                          },
                        });
                      },
                      style: ListTileStyle.list, 
                    );
                  },
                  childCount: conversationController.conversations.length, 
                ),
              );
            }),
          ],
        )
      ),
    );
  }
}