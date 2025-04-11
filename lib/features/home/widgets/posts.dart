import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/home/controllers/post_controller.dart';
import 'package:in_and_co_portal/features/home/widgets/post_item.dart';
import 'package:in_and_co_portal/core/widgets/header_title.dart';

class Posts extends StatelessWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderTitle(content: 'home_lastest_newsfeed'.tr),
        Obx(() {
          if (postController.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              ...postController.posts.map((post) => PostItem(post: post)),
              SizedBox(height: 30),
              if (postController.isLoadingMore.value)
                  CircularProgressIndicator(),
              SizedBox(height: 100),
            ],
          );
        }),
      ],
    );
  }
}