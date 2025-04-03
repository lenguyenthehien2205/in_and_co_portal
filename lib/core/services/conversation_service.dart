import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/conversation.dart';

class ConversationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ConversationDetail>> getConversations(String userId) {
    return _firestore
        .collection('conversations')
        .where('users', arrayContains: userId)
        .orderBy('last_message_time', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<ConversationDetail> conversations = [];
          for (var doc in snapshot.docs) {
            var conversation = Conversation.fromFirestore(doc.data());
            conversation.id = doc.id; 
            // Lấy id của người còn lại trong cuộc trò chuyện
            String otherUserId = conversation.users.firstWhere(
              (id) => id != userId,
              orElse: () => '', 
            );
            if (otherUserId.isEmpty) continue;
            var userDoc = await _firestore.collection('users').doc(otherUserId).get();
            String fullname = userDoc.exists ? userDoc['fullname'] ?? 'Unknown' : 'Unknown';
            String avatar = userDoc.exists ? userDoc['avatar'] ?? '' : '';
            conversations.add(ConversationDetail(
              id: conversation.id,
              users: conversation.users,
              lastMessage: conversation.lastMessage,
              lastMessageTime: conversation.lastMessageTime,
              lastMessageSenderId: conversation.lastMessageSenderId,
              fullname: fullname,  
              avatar: avatar,  
              otherUserId: otherUserId,
            ));
          }
          return conversations;
        });
  }
  Future<void> updateConversation(String conversationId, String lastMessage, String lastMessageSenderId) async {
    await _firestore.collection('conversations').doc(conversationId).update({
      'last_message': lastMessage,
      'last_message_sender_id': lastMessageSenderId,
      'last_message_time': Timestamp.now(),
    });
  } 
}