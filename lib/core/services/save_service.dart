import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/save.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleSave(String userId, String postId, String postOwnerId) async {
    final prefs = await SharedPreferences.getInstance();

    final saveQuery = await _firestore
        .collection('post_saves')
        .where('post_id', isEqualTo: postId)
        .where('user_id', isEqualTo: userId)
        .where('post_owner_id', isEqualTo: postOwnerId)
        .get();

    bool serverHasSaved = saveQuery.docs.isNotEmpty;
    bool localSaveState = prefs.getBool('save_$postId') ?? false;

    if(serverHasSaved != localSaveState) {
      await prefs.setBool('save_$postId', serverHasSaved);
    }

    bool newSaveState = !serverHasSaved;
    await prefs.setBool('save_$postId', newSaveState);

    if(newSaveState) {
      await _firestore.collection('post_saves').add({
        'post_id': postId,
        'user_id': userId,
        'post_owner_id': postOwnerId,
      });
    } else {
      if(saveQuery.docs.isNotEmpty) {
        await saveQuery.docs.first.reference.delete();
      }
    }
  }
  Future<bool> hasSavedPost(String postId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    bool? localSave = prefs.getBool('save_$postId');

    if(localSave != null) {
      return localSave;
    }
    final save = await _firestore
        .collection('post_saves')
        .where('post_id', isEqualTo: postId)
        .where('user_id', isEqualTo: userId)
        .where('post_owner_id', isEqualTo: userId)
        .get();
    bool hasSaved = save.docs.isNotEmpty;
    await prefs.setBool('save_$postId', hasSaved);
    return hasSaved;
  }

  Future<List<Save>> getAllSavedPosts(String userId) async {
    final saves = await _firestore
        .collection('post_saves')
        .where('user_id', isEqualTo: userId)
        .get();

    return saves.docs.map((doc) => Save.fromFirestore(doc)).toList();
  }

  
}