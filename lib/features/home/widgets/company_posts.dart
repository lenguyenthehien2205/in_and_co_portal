import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/core/services/post_service.dart';
import 'package:in_and_co_portal/theme/app_text.dart';
import 'package:in_and_co_portal/theme/app_theme.dart';
import 'package:in_and_co_portal/features/home/widgets/company_post_item.dart';

class CompanyPosts extends StatefulWidget {
  const CompanyPosts({super.key});

  @override
  State<CompanyPosts> createState() => _CompanyPostsState();
}


class _CompanyPostsState extends State<CompanyPosts>{
  final List<String> items = [
    '1', '2', '3', '4'
  ];
  final PostService _postService = PostService();

  @override
  Widget build(context){
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Công ty',
              style: AppTheme.title,
            ),
            SizedBox(height: 8),
            StreamBuilder<List<Post>>(
              stream: _postService.getCompanyPosts(), 
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("Không có bài viết nào"));
                }
                List<Post> posts = snapshot.data!;
                return SizedBox(
                  height: 200, // Điều chỉnh chiều cao của danh sách
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: posts.map((post) => Padding(
                        padding: const EdgeInsets.only(right: 10), // Khoảng cách giữa các item
                        child: CompanyPostItem(post: post),
                      )).toList(),
                    ),
                  ),
                );
              }
            )
            // SizedBox(
            //   height: 200, // Đặt chiều cao phù hợp cho danh sách ngang
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     // child: Row(
            //     //   children: List.generate(items.length, (index) => Padding(
            //     //     padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 10), // Khoảng cách giữa các item
            //     //     child: CompanyPostItem(),
            //     //   )),
            //     // ),
            //   ),
            // ),
          ],
        ),
      )
    );
  }
}