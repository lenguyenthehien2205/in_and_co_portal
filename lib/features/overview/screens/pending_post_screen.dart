import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/home/controllers/post_controller.dart';
import 'package:in_and_co_portal/features/overview/controllers/overview_controller.dart';
import 'package:in_and_co_portal/features/overview/controllers/pending_post_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class PendingPostScreen extends StatelessWidget{
  PendingPostScreen({super.key});
  final PendingPostController pendingPostController = Get.put(PendingPostController());
  final OverviewController overviewController = Get.put(OverviewController());
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Duyệt bài viết"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (pendingPostController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (pendingPostController.pendingPosts.isEmpty) {
          return Center(child: Text("Không có bài viết nào chờ duyệt"));
        }

        return ListView.builder(
          itemCount: pendingPostController.pendingPosts.length,
          itemBuilder: (context, index) {
            var post = pendingPostController.pendingPosts[index];
            return GestureDetector(
              onTap: () {
                context.push('/post-detail/${post.id}'); // Chuyển đến trang chi tiết bài viết
              } ,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Khoảng cách giữa các card
                padding: EdgeInsets.all(10), // Padding bên trong card
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), // Bo góc
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        post.authorAvatar, 
                        width: 60,
                        height: 60, 
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 50),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            post.authorName,
                            style: AppText.subtitle(context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () async {
                                  await pendingPostController.approvePost(post.id, post.authorId); 
                                  overviewController.loadData();
                                  postController.refreshPosts();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () async { 
                                  await pendingPostController.rejectPost(post.id, post.authorId);
                                  overviewController.loadData();
                                  postController.refreshPosts();                    
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        post.images.isNotEmpty ? post.images[0]['url'] : '',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 80),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}