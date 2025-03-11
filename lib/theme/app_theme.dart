import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';

class AppTheme {
  // static final lightTheme = ThemeData(
  //   brightness: Brightness.light,
  //   primaryColor: AppColors.primary,
  //   scaffoldBackgroundColor: Colors.white,
  //   appBarTheme: AppBarTheme(
  //     color: Colors.white,
  //     foregroundColor: AppColors.black
  //   ),
  //   textTheme: TextTheme(
  //     titleLarge: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w700),
  //     headlineLarge: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700),
  //     bodyLarge: GoogleFonts.nunito(fontSize: 16),
  //     bodyMedium: GoogleFonts.nunito(fontSize: 14),
  //   ),
  // );
  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.aBeeZeeTextTheme(),
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
    textTheme: GoogleFonts.aBeeZeeTextTheme(),
    colorScheme: ColorScheme.dark(
      surface: Colors.grey[800]!,
      surfaceBright: Colors.grey[700]!,
      primary: AppColors.primary,
      secondary: Colors.grey[400]!,
      onSurface: Colors.white
    ),
  );
}