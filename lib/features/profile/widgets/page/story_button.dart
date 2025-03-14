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
          padding: EdgeInsets.all(2), // Tạo khoảng cách giữa viền và ảnh bên trong
          decoration: BoxDecoration(
            shape: BoxShape.circle, 
            border: Border.all(
              color: Colors.blue, 
              width: 2,
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
          width: 90, 
          child: Text(
            text, 
            style: AppText.normal(context),
            overflow: TextOverflow.ellipsis, 
            maxLines: 1, 
            textAlign: TextAlign.center, 
            softWrap: false,
          ),
        ),
      ],
    );
  }
}