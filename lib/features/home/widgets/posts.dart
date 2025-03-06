import 'package:flutter/material.dart';
import 'package:in_and_co_portal/theme/app_text.dart';
import 'package:in_and_co_portal/theme/app_theme.dart';

class Posts extends StatefulWidget{
  const Posts({super.key});

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts>{
  final List<String> items = [
    '1', '2', '3', '4'
  ];

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(), // Hiệu ứng cuộn mượt mà
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AppText(
                text: 'Bài viết mới',
                style: AppTheme.title,
              ),
            ),
            // Column(
            //   children: List.generate(items.length, (index) => SizedBox(
            //     height: MediaQuery.of(context).size.height * 0.5,
            //     child: PageView.builder(
            //       scrollDirection: Axis.horizontal, // Cuộn ngang
            //       itemCount: items.length,
            //       itemBuilder: (context, index) {
            //         return SizedBox(
            //           width: MediaQuery.of(context).size.width, // Full màn hình
            //           child: AspectRatio(
            //             aspectRatio: 16 / 9, // Giữ nguyên tỷ lệ ảnh (thay đổi nếu cần)
            //             child: PostItem(),
            //           ),
            //         );
            //       },
            //     ),
            //   )),
            // ),
            // SizedBox(height: 20), // Tạo khoảng trống cuối cùng để cuộn thoải mái
          ],
        ),
      ),
    );
  }
}