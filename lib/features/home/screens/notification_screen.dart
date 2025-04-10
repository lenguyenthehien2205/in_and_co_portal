import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/utils/string_utils.dart';
import 'package:in_and_co_portal/features/home/controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget{
  NotificationScreen({super.key});

  final NotificationController notificationController = Get.put(NotificationController());

  Widget _buildNotificationIcon(String type) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'comment':
        iconData = Icons.comment;
        color = Colors.blue;
        break;
      case 'like':
        iconData = Icons.favorite;
        color = Colors.red;
        break;
      case 'post':
        iconData = Icons.post_add;
        color = Colors.green;
        break;
      default:
        return SizedBox();
    }

    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(150), 
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1), 
          ),
        ],
      ),
      child: Icon(iconData, color: color, size: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, 
      onPopInvokedWithResult: (didPop, result) {
        notificationController.readAllNotifications();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('notification_title'.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Obx(() {
          if (notificationController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (notificationController.notifications.isEmpty) {
            return Center(child: Text('notification_empty'.tr, style: TextStyle(fontSize: 16, color: Colors.grey)));
          }
          return ListView.builder(
            itemCount: notificationController.notifications.length,
            itemBuilder: (context, index) {
              var notification = notificationController.notifications[index];

              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(notification.userAvatar),
                      radius: 28, 
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: _buildNotificationIcon(notification.type),
                    ),
                  ],
                ),
                title: Text(notification.title, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.message),
                    SizedBox(height: 5),
                    Text(getTimeAgoByTimestamp(notification.createdAt), style: TextStyle(color: Colors.grey)),
                  ],
                ),
                trailing: notification.isRead
                    ? SizedBox()
                    : Icon(Icons.circle, color: Theme.of(context).primaryColor, size: 10),
                onTap: () {
                  context.push('/post-detail/${notification.postId}');
                },
              );
            },
          );
        }),
      )
    );
    
  }
}