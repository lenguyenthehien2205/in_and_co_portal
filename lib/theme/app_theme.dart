import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';

class AppTheme {
  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.robotoTextTheme(),
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      surfaceBright: AppColors.backgroundColor,
      primary: AppColors.primary,
      secondary: Colors.grey[600]!,
      onSurface: Colors.black
    ),
  );

  static ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    textTheme: GoogleFonts.robotoTextTheme(),
    colorScheme: ColorScheme.dark(
      surface: Colors.grey[800]!,
      surfaceBright: Colors.grey[700]!,
      primary: AppColors.primary,
      secondary: Colors.grey[400]!,
      onSurface: Colors.white
    ),
  );
}