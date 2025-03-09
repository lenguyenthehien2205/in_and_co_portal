import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class ProfileButton extends StatelessWidget{
  final String text;
  final IconData icon;

  const ProfileButton({
    super.key,
    required this.text,
    required this.icon
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 60,
      child: TextButton(
        onPressed: () {
          
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primary.withAlpha(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10), // Khoảng cách giữa 2 đầu (trái phải
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Cách đều 2 đầu
            children: [
              Icon(icon, color: AppColors.primary, size: 30), // Icon trái
              AppText(
                text: text, 
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 16, 
                  fontWeight: FontWeight.w500
                ),
              ), // Nội dung nút
              Icon(Icons.arrow_forward_ios, color: AppColors.primary), // Icon phải
            ],
          ),
        )
      ),
    );
  }
}