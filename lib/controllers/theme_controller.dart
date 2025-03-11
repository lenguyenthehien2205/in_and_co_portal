import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController{
  var isDarkMode = false.obs;

  ThemeData get themeData => isDarkMode.value ? AppTheme.darkMode : AppTheme.lightMode;

  @override
  void onInit() {
    super.onInit();
    loadTheme(); // Tải theme khi app khởi động
  }

  void toggleTheme(){
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(themeData);
    saveTheme(isDarkMode.value);
  }

  void saveTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDarkMode", isDark);
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool("isDarkMode") ?? false; // Mặc định là Light Mode
    Get.changeTheme(isDarkMode.value ? AppTheme.darkMode : AppTheme.lightMode);
  }
}