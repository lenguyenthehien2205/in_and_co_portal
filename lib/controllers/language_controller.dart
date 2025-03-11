import 'package:get/get.dart';
import 'package:in_and_co_portal/lang/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'vi'.obs;

  @override
  void onInit() async {
    super.onInit();
    selectedLanguage.value = Get.locale?.languageCode ?? 'vi';
    await loadLanguage();
  }

  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLang = prefs.getString('language');
    if (savedLang != null) {
      selectedLanguage.value = savedLang;
      LocalizationService.changeLocale(savedLang);
    }
  }

  void changeLanguage(String langCode) async {
    selectedLanguage.value = langCode;
    LocalizationService.changeLocale(langCode);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode); // Lưu vào SharedPreferences
  }
}