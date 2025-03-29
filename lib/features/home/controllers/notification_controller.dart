import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/notification.dart';
import 'package:in_and_co_portal/core/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();
  RxList<NotificationDetail> notifications = <NotificationDetail>[].obs;
  RxInt notificationCount = 0.obs;
  var userId = FirebaseAuth.instance.currentUser?.uid;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    getNotificationCount().listen((count) {
      notificationCount.value = count;
    });
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user?.uid != userId) {
        userId = user!.uid;
        fetchNotifications();
        getNotificationCount().listen((count) {
          notificationCount.value = count;
        });
      }
    });
  }
  void readAllNotifications() {
    _notificationService.markAllAsRead(userId ?? '');
  }

  Stream<int> getNotificationCount() {
    return _notificationService.getCountNotifications(userId ?? ''); 
  }

  void fetchNotifications() {
    isLoading.value = true;
    _notificationService.getNotifications(userId ?? '').listen((newNotifications) {
      notifications.assignAll(newNotifications);
      isLoading.value = false; 
    }, onError: (error) {
      isLoading.value = false; 
    });
  }
}