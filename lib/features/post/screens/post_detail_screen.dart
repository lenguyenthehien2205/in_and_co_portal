import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/features/home/controllers/post_controller.dart';
import 'package:in_and_co_portal/features/home/widgets/post_item.dart';

class PostDetailScreen extends StatelessWidget{
  final String postId;
  PostDetailScreen({
    super.key,
    required this.postId,
  });

  final PostController postController = Get.put(PostController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết bài viết")),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: FutureBuilder<PostDetail>(
            future: postController.getPostDetailById(postId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 300),
                    Center(child: CircularProgressIndicator()), 
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi khi tải bài viết')); 
              } else if (!snapshot.hasData) {
                return Center(child: Text('Không tìm thấy bài viết')); 
              } else {
                final post = snapshot.data!;
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: PostItem(post: post),
                );
              }
            },
          ),
        ),
    );
  }
}