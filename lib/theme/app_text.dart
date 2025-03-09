import 'package:flutter/material.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';

class AppText extends StatelessWidget{
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const AppText({
    super.key,
    required this.text,
    this.style = const TextStyle(),
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
  static TextStyle headerTitle = TextStyle(
    fontSize: 23, 
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
  static TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
  static TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  static TextStyle buttonTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle semiBoldTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
}