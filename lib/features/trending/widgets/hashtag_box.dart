import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HashtagBox extends StatelessWidget{
  final String content;
  final String image;
  const HashtagBox({
    super.key,
    required this.content,
    required this.image,
  });

   @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // Ảnh nền full kích thước của box
          Positioned.fill(
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          ),
          // Lớp phủ đen mờ
          Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(40), // Lớp phủ mờ hơn
            ),
          ),
          // Chữ căn giữa hoàn toàn
          Positioned.fill(
            child: Center(
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 5,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}