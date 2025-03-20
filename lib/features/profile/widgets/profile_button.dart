import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/controllers/theme_controller.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class ProfileButton extends StatelessWidget{
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  final ThemeController themeController = Get.find();

  ProfileButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: 60,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: themeController.isDarkMode.value
             ? AppColors.primary.withAlpha(90) 
             : AppColors.primary.withAlpha(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Icon(icon, color: AppColors.primary, size: 30), 
              AppText(
                text: text.tr, 
                style: AppText.normal(context)
              ), 
              Icon(Icons.arrow_forward_ios, color: AppColors.primary), 
            ],
          ),
        )
      ),
    );
  }
}