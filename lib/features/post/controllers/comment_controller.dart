import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/comment.dart';
import 'package:in_and_co_portal/core/services/comment_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  late String userId = FirebaseAuth.instance.currentUser!.uid;
  final comments = <CommentDetail>[].obs;
  final textCommentController = TextEditingController();
  var isLoading = true.obs;
  final CommentService commentService = CommentService();
  var commentCounts = <String, int>{}.obs;

  Future<void> fetchComments(String postId) async {
    isLoading(true);
    comments.value = await commentService.getCommentsByPost(postId);
    commentCounts[postId] = comments.length;
    isLoading(false);
  }

  Future<void> addComment(String postId) async {
    String content = textCommentController.text.trim();
    if (content.isEmpty) return;

    Comment comment = Comment(
      id: '',
      userId: profileController.myUID.value,
      postId: postId,
      content: content,
      createdAt: Timestamp.now(),
    );
    CommentDetail commentDetail = CommentDetail(
      id: comment.id,
      userId: comment.userId,
      postId: comment.postId,
      content: comment.content,
      createdAt: comment.createdAt,
      userName: profileController.userData['fullname'],
      userAvatar: profileController.userData['avatar'],
      isChecked: profileController.userData['is_checked'],
    );
    comments.insert(0, commentDetail);
    textCommentController.clear();
    await commentService.addComment(comment);
    commentCounts[comment.postId] = (commentCounts[comment.postId] ?? 0) + 1; 
    fetchCommentCount(comment.postId);
  }

  Future<void> fetchCommentCount(String postId) async {
    int count = await commentService.getCommentCount(postId);
    commentCounts[postId] = count;
    update(); // Cập nhật UI
  }
}