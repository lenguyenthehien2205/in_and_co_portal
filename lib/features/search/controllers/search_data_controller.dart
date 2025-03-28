import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/services/post_service.dart';
import 'package:in_and_co_portal/core/services/user_service.dart';

class SearchDataController extends GetxController{
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  var searchResults = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;
  Timer? _debounce; 
  void searchAndNavigate(BuildContext context, String query) async {
    if(query.isEmpty) return;
    var postResults = await _postService.searchPostsByLabelAndTitle(query);
    context.push(
      '/search/result',
      extra: {
        "query": query,
        "users": '',
        "posts": postResults,
      },
    );
  }

  Future<void> searchUsers(String query) async {
    searchQuery.value = query;
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 200), () async {
      if (query.isNotEmpty) {
        var result = await _userService.searchUsers(query);
        searchResults.assignAll(result);
      } else {
        searchResults.clear();
      }
    });
  } 
}