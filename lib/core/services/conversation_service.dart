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
            bool isChecked = userDoc.exists ? (userDoc['is_checked'] ?? false) as bool : false;
            String role = userDoc.exists ? userDoc['role'] ?? '' : '';
            print("${userDoc['fullname']} - ${userDoc['avatar']} - ${userDoc['is_checked']} - ${userDoc['role']}");
            conversations.add(ConversationDetail(
              id: conversation.id,
              users: conversation.users,
              lastMessage: conversation.lastMessage,
              lastMessageTime: conversation.lastMessageTime,
              lastMessageSenderId: conversation.lastMessageSenderId,
              fullname: fullname,  
              avatar: avatar,  
              otherUserId: otherUserId,
              isChecked: isChecked,
              role: role,
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

  Future<String> getConversationId(String userId1, String userId2) async {
    var querySnapshot = await _firestore
        .collection('conversations')
        .where('users', arrayContains: userId1) 
        .get();
    for (var doc in querySnapshot.docs) {
      List<String> users = List<String>.from(doc['users']);
      if (users.contains(userId2)) {
        return doc.id;
      }
    }
    return '';
  }
}