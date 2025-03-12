import 'package:flutter/material.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class StoryButton extends StatelessWidget{
  final String text;
  final String url;
  const StoryButton({
    super.key,
    required this.text,
    required this.url,
  });

  @override
  Widget build(context){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2), // Tạo khoảng cách giữa viền và hình ảnh bên trong
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Đảm bảo là hình tròn
            border: Border.all(
              color: Colors.blue, // Màu viền (có thể đổi sang gradient)
              width: 2, // Độ dày của viền
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              url,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 5),
        SizedBox(
          width: 90, // Giới hạn chiều rộng của text
          child: Text(
            text, // Đổi thành tên dài để kiểm tra
            style: AppText.normal(context),
            overflow: TextOverflow.ellipsis, // Nếu dài quá, hiển thị "..."
            maxLines: 1, // Chỉ hiển thị 1 dòng
            textAlign: TextAlign.center, // Căn giữa text
            softWrap: false, // Ngăn xuống dòng
          ),
        ),
      ],
    );
  }
}