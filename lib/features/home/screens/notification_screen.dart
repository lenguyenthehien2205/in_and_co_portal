import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/home/controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget{
  NotificationScreen({super.key});

  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (notificationController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (notificationController.notifications.isEmpty) {
          return Center(child: Text('Không có thông báo nào'));
        }
        return ListView.builder(
          itemCount: notificationController.notifications.length,
          itemBuilder: (context, index) {
            var notification = notificationController.notifications[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(notification.userAvatar),
              ),
              title: Text(notification.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(notification.message),
              trailing: notification.isRead
                  ? SizedBox()
                  : Icon(Icons.circle, color: Theme.of(context).primaryColor, size: 10),
              onTap: () {
                // Xử lý khi nhấn vào thông báo (có thể chuyển đến bài post liên quan)
              },
            );
          },
        );
      }),
    );
  }
}