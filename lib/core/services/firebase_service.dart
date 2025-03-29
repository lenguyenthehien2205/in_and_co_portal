import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/main.dart';

class FCMService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.getToken();
    // initPushNotifications();
  }

  // void handleMessage(RemoteMessage? message) {
  //   final context = navigatorKey.currentContext;
  //   if (context != null) {
  //       context.go('/home/notification'); 
  //     }
  //   }
  // }

  Future initPushNotifications() async {
    final context = navigatorKey.currentContext;
    // Handle notification when app is in background
    FirebaseMessaging.instance.getInitialMessage().then((message) { // bấm vào thông báo khi app đóng
      if (message != null && context != null) {
        context.go('/home/notification'); 
      }
    });
    // // Handle notification when app is in foreground
    // FirebaseMessaging.onMessage.listen((message) { // nghe app đang mở và có thông báo mới
    //   print('Message received: ${message.notification?.title}');
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) { // bấm vào thông báo khi app đang nền
    //   if (message != null && context != null) {
    //     context.go('/home/notification'); 
    //   }
    // });
  }

  void subscribeToUserNotifications() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseMessaging.instance.subscribeToTopic(userId);
    FirebaseMessaging.instance.subscribeToTopic('all_users');
  }

  void unsubscribeFromUserNotifications() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseMessaging.instance.unsubscribeFromTopic(userId);
    FirebaseMessaging.instance.unsubscribeFromTopic('all_users');
  }
}