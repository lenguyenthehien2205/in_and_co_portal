import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverviewCard extends StatelessWidget {
  final String title;
  final String content;
  final RxBool isVisible; 
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  final RxDouble scale = 1.0.obs; 

  OverviewCard({
    super.key,
    required this.title,
    required this.content,
    required this.isVisible,
    required this.gradientColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTapDown: (_) => scale.value = 0.95, 
      onTapUp: (_) {
        scale.value = 1.0; 
        Future.delayed(const Duration(milliseconds: 100), () {
          onTap?.call(); 
        });
      },
      child: AnimatedScale(
        scale: scale.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: isVisible.value ? 1.0 : 0.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(
              isVisible.value ? 0 : 300, // Hiệu ứng trượt từ phải vào
              0,
              0,
            ),
            width: MediaQuery.of(context).size.width - 40, // Cách mép 20px mỗi bên
            height: 200,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(70),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 21,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 17, color: Colors.white70),
                  ),
                  const SizedBox(height: 75),
                  Text(
                    'Nhấn để xem chi tiết',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
