import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/home/controllers/company_post_controller.dart';
import 'package:in_and_co_portal/core/widgets/header_title.dart';
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
    return Container(
      width: double.infinity, 
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
          HeaderTitle(content: 'home_company_newsfeed'.tr), 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              if (controller.posts.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  controller: controller.scrollController, 
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.posts.length + (controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.posts.length) {
                      return Center(child: CircularProgressIndicator()); 
                    }
                    return GestureDetector(
                      onTap: () {
                        context.push('/post-detail/${controller.posts[index].id}'); 
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: index == controller.posts.length - 1 ? 0 : 15),
                        child: CompanyPostItem(post: controller.posts[index]),
                      ),
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
