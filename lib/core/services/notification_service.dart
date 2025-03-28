import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_and_co_portal/core/models/notification.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNotification(String userId, String senderId, String postId, String title, String message) async{
    await FirebaseFirestore.instance
      .collection('users') 
      .doc(userId) 
      .collection('notifications') 
      .add({
        'sender_id': senderId,
        'post_id': postId,
        'title': title,
        'message': message,
        'is_read': false,
        'created_at': FieldValue.serverTimestamp(),
      });
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
  Stream<List<NotificationDetail>> getNotifications(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<NotificationDetail> notifications = [];

          for (var doc in snapshot.docs) {
            var data = doc.data();
            String senderId = data['sender_id']; 
            DocumentSnapshot userDoc = await _firestore.collection('users').doc(senderId).get();
            var userData = userDoc.data() as Map<String, dynamic>;

            notifications.add(NotificationDetail(
              title: data['title'] ?? '',
              message: data['message'] ?? '',
              postId: data['post_id'] ?? '',
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