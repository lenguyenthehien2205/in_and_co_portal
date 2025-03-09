import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/home/controllers/company_post_controller.dart';
import 'package:in_and_co_portal/widgets/header_title.dart';
import 'package:in_and_co_portal/features/home/widgets/company_post_item.dart';

class CompanyPosts extends StatefulWidget {
  const CompanyPosts({super.key});

  @override
  State<CompanyPosts> createState() => _CompanyPostsState();
}

class _CompanyPostsState extends State<CompanyPosts>{
  final CompanyPostController controller = Get.put(CompanyPostController());
  @override
  Widget build(context){
    return SizedBox(
      width: double.infinity, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 25)),
          HeaderTitle(content: 'Bản tin công ty'), 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              if (controller.posts.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  controller: controller.scrollController, // Gán ScrollController
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.posts.length + (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.posts.length) {
                      return Center(child: CircularProgressIndicator()); // Hiển thị loading khi tải thêm
                    }
                    return Padding(
                      padding: EdgeInsets.only(right: index == controller.posts.length - 1 ? 0 : 15),
                      child: CompanyPostItem(post: controller.posts[index]),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}