import 'package:flutter/material.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;   
  final String imagePath;
  const AuthBackground({
    super.key, 
    this.imagePath = 'assets/images/shape.png', 
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Thêm dòng này để khi bàn phím hiện lên thì không bị che phần input
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView( 
        reverse: true,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(imagePath, width: 200, height: 183),
              ),
              Center(child: child),
            ],
          ),
        ),
      )
    );
  }
}