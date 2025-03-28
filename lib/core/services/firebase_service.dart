import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/main.dart';

class FCMService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.getToken();
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.go('/home/notification', extra: message);
    }
  }

  Future initPushNotifications() async {
    // Handle notification when app is in background
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        handleMessage(message);
      }
    });
    // Handle notification when app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });
  }

  void subscribeToUserNotifications() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseMessaging.instance.subscribeToTopic(userId);
  }

  void unsubscribeFromUserNotifications() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseMessaging.instance.unsubscribeFromTopic(userId);
  }
}