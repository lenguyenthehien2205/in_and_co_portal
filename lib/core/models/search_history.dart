import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistory {
  final String? id;
  final String content;
  final Timestamp searchedAt;

  SearchHistory({
    this.id,
    required this.content,
    required this.searchedAt,
  });

  factory SearchHistory.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SearchHistory(
      id: doc.id,
      content: data['content'] ?? '',
      searchedAt: data['searched_at'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'content': content,
      'searched_at': searchedAt,
    };
  }
}