import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/models/search_history.dart';
import 'package:in_and_co_portal/core/services/post_service.dart';
import 'package:in_and_co_portal/core/services/search_history_service.dart';
import 'package:in_and_co_portal/core/services/user_service.dart';

class SearchDataController extends GetxController{
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  final SearchHistoryService _searchHistoryService = SearchHistoryService();
  var searchResults = <Map<String, dynamic>>[].obs;
  var searchHistory = <SearchHistory>[].obs;
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

  @override
  void onInit() {
    super.onInit();
    fetchSearchHistory();
  }

  void fetchSearchHistory() async {
    var result = await _searchHistoryService.getSearchHistory(FirebaseAuth.instance.currentUser!.uid);
    searchHistory.assignAll(result);
    print("Search history: $searchHistory");
  }

  void addSearchHistory(String content) async {
    await _searchHistoryService.addSearchHistory(FirebaseAuth.instance.currentUser!.uid, content);
    fetchSearchHistory(); 
  }

  void deleteSearchHistory(String searchedId) async {
    await _searchHistoryService.deleteSearchHistory(FirebaseAuth.instance.currentUser!.uid, searchedId);
    fetchSearchHistory(); 
  }

  Future<void> searchUsers(String query) async {
    searchQuery.value = query;
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 200), () async {
      if (query.isNotEmpty) {
        var result = await _userService.searchUsers(query.toLowerCase());
        searchResults.assignAll(result);
      } else {
        searchResults.clear();
      }
    });
  } 
}