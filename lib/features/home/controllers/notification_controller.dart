import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/notification.dart';
import 'package:in_and_co_portal/core/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();
  RxList<NotificationDetail> notifications = <NotificationDetail>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    isLoading.value = true;
    _notificationService.getNotifications(_auth.currentUser!.uid).listen((newNotifications) {
      notifications.assignAll(newNotifications);
      isLoading.value = false; 
    }, onError: (error) {
      isLoading.value = false; 
    });
  }
}