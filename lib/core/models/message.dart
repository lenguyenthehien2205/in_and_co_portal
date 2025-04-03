import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String text;
  final Timestamp sendedAt;

  Message({
    required this.senderId,
    required this.text,
    required this.sendedAt,
  });

  factory Message.fromFirestore(Map<String, dynamic> data) {
    return Message(
      senderId: data['sender_id'],
      text: data['text'],
      sendedAt: data['sended_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'text': text,
      'sended_at': sendedAt,
    };
  }
}