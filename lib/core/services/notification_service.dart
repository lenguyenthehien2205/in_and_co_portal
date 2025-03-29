import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/notification.dart' as model;

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNotification(String userId, model.Notification notification) async{
        await FirebaseFirestore.instance
      .collection('users') 
      .doc(userId) 
      .collection('notifications') 
      .add(notification.toMap()); 
  }

  Future<void> addNotificationToAllUser(model.Notification notification) async{
    final usersCollection = await FirebaseFirestore.instance.collection('users').get();
    for (var userDoc in usersCollection.docs){
      String userId = userDoc.id;
      await FirebaseFirestore.instance
        .collection('users') 
        .doc(userId) 
        .collection('notifications') 
        .add(notification.toMap());
    }
  }

  Future<void> markAllAsRead(String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference notificationsRef = firestore
        .collection('users')
        .doc(userId)
        .collection('notifications');

    final QuerySnapshot snapshot = await notificationsRef.get();

    // dùng batch để update nhiều document cùng lúc
    WriteBatch batch = firestore.batch();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'is_read': true});
    }

    await batch.commit();
  }

  Stream<int> getCountNotifications(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('is_read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<model.NotificationDetail>> getNotifications(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<model.NotificationDetail> notifications = [];

          for (var doc in snapshot.docs) {
            var data = doc.data();
            String senderId = data['sender_id']; 
            DocumentSnapshot userDoc = await _firestore.collection('users').doc(senderId).get();
            var userData = userDoc.data() as Map<String, dynamic>;

            notifications.add(model.NotificationDetail(
              title: data['title'] ?? '',
              message: data['message'] ?? '',
              postId: data['post_id'] ?? '',
              type: data['type'] ?? '',
              createdAt: data['created_at'] ?? Timestamp.now(),
              isRead: data['is_read'] ?? false,
              senderId: data['sender_id'] ?? '',
              userName: userData['name'] ?? 'Unknown',
              userAvatar: userData['avatar'] ?? '',
            ));
          }
          return notifications;
        });
  }
}