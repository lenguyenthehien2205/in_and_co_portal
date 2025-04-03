import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/utils/string_utils.dart';
import 'package:in_and_co_portal/features/chat/controllers/chat_controller.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class ChatScreen extends StatelessWidget{
  final String conversationId;

  ChatScreen({
    super.key,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController(conversationId: conversationId));
    final ProfileController profileController = Get.find();
    final state = GoRouterState.of(context);
    final data = state.extra as Map<String, dynamic>?;
    final otherUserInfo = data?["otherUserInfo"] as Map<String, dynamic>?;
    chatController.clearMessages();
    chatController.conversationId.value = conversationId;
    chatController.fetchMessages();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        title: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  otherUserInfo?["avatar"] ?? "", 
                ),
                radius: 22,
              ),
              title: Text(
                otherUserInfo?["fullname"] ?? "Ten nguoi dung",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              trailing: Icon(Icons.more_vert, color: Colors.grey, size: 20),
            ),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverPersistentHeader(
              delegate: MyHeaderDelegate(),
              floating: true,
              pinned: true,
            ),
            Obx((){
              if (chatController.isLoading.value) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final message = chatController.messages[index];
                    return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: message.senderId == profileController.currentUID.value
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (message.senderId != profileController.currentUID.value) 
                                CircleAvatar(
                                  backgroundImage: NetworkImage(otherUserInfo?["avatar"] ?? ""),
                                  radius: 22,
                                ),
                                SizedBox(width: 7),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7, 
                                ),
                                decoration: BoxDecoration(
                                  color: message.senderId == profileController.currentUID.value
                                      ? Colors.blue[100]
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.text,
                                      style: AppText.normal(context),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      formatTimestampToTime(message.sendedAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: chatController.messages.length,
                ),
              );
            }),
        
            SliverToBoxAdapter(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      otherUserInfo?["avatar"] ?? "", 
                    ),
                    radius: 65,
                  ),
                  SizedBox(height: 10),
                  Text(otherUserInfo?["fullname"] ?? "Ten nguoi dung", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(height: 50),
                ],
              ), 
            ),
          ],
        )
      ),
    );
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final ChatController chatController = Get.find<ChatController>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(170),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 20, 
      ), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9, 
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30), 
            ),
            child: TextField(
              controller: chatController.messageController.value,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                border: InputBorder.none, 
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Colors.blue), 
                  onPressed: () {
                    chatController.sendMessage();
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  chatController.sendMessage();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  

  @override
  double get maxExtent => 100;
  @override
  double get minExtent => 100;
  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}