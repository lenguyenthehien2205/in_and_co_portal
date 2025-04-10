import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/search_history.dart';

class SearchHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<SearchHistory>> getSearchHistory(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('search-history')
          .orderBy('searched_at', descending: true)
          .get();
      List<SearchHistory> allHistories =
          snapshot.docs.map((doc) => SearchHistory.fromFirestore(doc)).toList();
      final uniqueMap = <String, SearchHistory>{};
      for (var history in allHistories) {
        if (!uniqueMap.containsKey(history.content)) {
          uniqueMap[history.content] = history;
        }
      }
      return uniqueMap.values.take(4).toList();
    } catch (e) {
      print("Error fetching search history: $e");
      return [];
    }
  }
  Future<void> addSearchHistory(String userId, String content) async {
    try {
      await _firestore.collection('users').doc(userId).collection('search-history').add({
        'content': content,
        'searched_at': Timestamp.now(),
      });
    } catch (e) {
      print("Error adding search history: $e");
    }
  }

  Future<void> deleteSearchHistory(String userId, String id) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('search-history')
          .doc(id)
          .get();
      if (snapshot.exists) {
        await snapshot.reference.delete();
      }
    } catch (e) {
      print("Error deleting search history: $e");
    }
  }
}