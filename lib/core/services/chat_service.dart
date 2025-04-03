import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('sended_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Message.fromFirestore(doc.data());
          }).toList();
        });
  }
  Future<void> sendMessage(String conversationId, String senderId, String text) async {
    final message = Message(
      senderId: senderId,
      text: text,
      sendedAt: Timestamp.now(),
    );
    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(message.toMap());
  }
}