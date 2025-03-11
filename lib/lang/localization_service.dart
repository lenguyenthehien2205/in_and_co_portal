import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'en.dart';
import 'vi.dart';

class LocalizationService extends Translations {
  // Danh sách ngôn ngữ hỗ trợ
  static final locales = [
    const Locale('en', 'US'),
    const Locale('vi', 'VN'),
  ];

  // Ngôn ngữ mặc định
  // static const locale = Locale('en', 'US');
  static const locale = Locale('vi', 'VN');

  // Map chứa các bản dịch
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': en,
    'vi_VN': vi,
  };

  // Đổi ngôn ngữ
  static void changeLocale(String langCode) {
    final locale = locales.firstWhere((element) => element.languageCode == langCode);
    Get.updateLocale(locale);
  }
}
