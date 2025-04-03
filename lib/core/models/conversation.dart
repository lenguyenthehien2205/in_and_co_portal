import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  late String id;
  final List<String> users;
  final String lastMessage;
  final Timestamp lastMessageTime;
  final String lastMessageSenderId;
  
  Conversation({
    required this.id,
    required this.users,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSenderId,
  });

  factory Conversation.fromFirestore(Map<String, dynamic> data) {
    return Conversation(
      id: data['id'] ?? '', 
      users: List<String>.from(data['users']) ?? [],
      lastMessage: data['last_message'] ?? '',
      lastMessageTime: data['last_message_time'] ?? Timestamp.now(),
      lastMessageSenderId: data['last_message_sender_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'users': users,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'last_message_sender_id': lastMessageSenderId,
    };
  }
}

class ConversationDetail extends Conversation {
  final String fullname;
  final String avatar;
  final String otherUserId;

  ConversationDetail({
    required String id,
    required List<String> users,
    required String lastMessage,
    required Timestamp lastMessageTime,
    required String lastMessageSenderId,
    required this.fullname,
    required this.avatar,
    required this.otherUserId,
  }) : super(
          id: id,
          users: users,
          lastMessage: lastMessage,
          lastMessageTime: lastMessageTime,
          lastMessageSenderId: lastMessageSenderId,
        );

  factory ConversationDetail.fromFirestore(Map<String, dynamic> data, String id) {
    return ConversationDetail(
      id: id,
      users: List<String>.from(data['users'] ?? []),
      lastMessage: data['last_message'] ?? '',
      lastMessageTime: data['last_message_time'] ?? Timestamp.now(),
      lastMessageSenderId: data['last_message_sender_id'] ?? '',
      fullname: data['fullname'] ?? 'Unknown',
      avatar: data['avatar'] ?? '',
      otherUserId: data['users'].firstWhere(
        (userId) => userId != id,
        orElse: () => '', 
      ),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'fullname': fullname,
        'avatar': avatar,
      });
  }
}