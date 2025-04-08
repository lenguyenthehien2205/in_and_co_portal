import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/utils/string_utils.dart';
import 'package:in_and_co_portal/features/post/controllers/comment_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class CommentFrame extends StatelessWidget{
  final String postId;
  final String currentPath;
  final CommentController commentController = Get.put(CommentController());
  CommentFrame({super.key, required this.postId, required this.currentPath});
  @override
  Widget build(BuildContext context) {
    
    return CustomScrollView(
      reverse: true,
      slivers: [
        SliverPersistentHeader(
          delegate: MyHeaderDelegate(postId: postId, currentPath: currentPath),
          floating: true,
          pinned: true,
        ),
        Obx(() {
          if (commentController.isLoading.value) {
            return SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: CircularProgressIndicator(), 
                  ),
                  SizedBox(height: 150),
                ],
              ),
            );
          } else if (commentController.comments.isEmpty) {
            return SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Icon(Icons.comment, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text('post_no_comment'.tr, style: AppText.subtitle(context)),
                  SizedBox(height: 100),
                ],
              ),
            );
          } else {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var comment = commentController.comments[index];
                  return ListTile(
                    leading: ClipOval(
                      child: Image.network(
                        comment.userAvatar,
                        width: 40, 
                        height: 40,
                        fit: BoxFit.cover, 
                      )
                    ),
                    title: Row(
                      children: [
                        Text(comment.userName, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                        SizedBox(width: 5),
                        if (comment.isChecked) Icon(Icons.verified, color: Colors.blue, size: 16),
                        SizedBox(width: 5),
                        Text(getTimeAgoByTimestamp(comment.createdAt), style: AppText.subtitle(context)),
                      ],
                    ),
                    subtitle: Text(comment.content),
                  );
                },
                childCount: commentController.comments.length,
              ),
            );
          }
        }),
      ],
    );
  }
}
class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String postId;
  final String currentPath;
  final CommentController commentController = Get.find<CommentController>();

  MyHeaderDelegate({required this.postId, required this.currentPath});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    
    return Container(
      padding: EdgeInsets.only(
        bottom: currentPath == '/home' ? 100 : 22, 
      ),
      color: Theme.of(context).colorScheme.surface, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9, 
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30), 
              border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 1.5), 
            ),
            child: TextField(
              controller: commentController.textCommentController,
              decoration: InputDecoration(
                hintText: '${'post_comment'.tr}...',
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                border: InputBorder.none, 
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Colors.blue), 
                  onPressed: () {
                    commentController.addComment(postId);
                  },
                ),
              ),
              onSubmitted: (value) {
                commentController.addComment(postId);
              },
            ),
          ),
        ],
      ),
    );
  }
  

  @override
  double get maxExtent => currentPath == '/home' ? 150 : 100; // Chiều cao tối đa của header
  @override
  double get minExtent => currentPath == '/home' ? 150 : 100; // Chiều cao tối thiểu khi cuộn
  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}