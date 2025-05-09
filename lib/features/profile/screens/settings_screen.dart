import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/controllers/language_controller.dart';
import 'package:in_and_co_portal/core/controllers/theme_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class SettingsScreen extends StatelessWidget{
  SettingsScreen({super.key});
  final ThemeController themeController = Get.find();
  final LanguageController languageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: 'setting_title'.tr, style: AppText.headerTitle(context)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: 'setting_dark_mode'.tr, style: AppText.title(context)),
                Obx(() => Switch(
                  value: themeController.isDarkMode.value,
                  onChanged: (value) => themeController.toggleTheme(),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: 'setting_language'.tr, style: AppText.title(context)),
                Obx(() => DropdownButton(
                  value: languageController.selectedLanguage.value,
                  items: [
                    DropdownMenuItem(
                      value: 'vi', 
                      child: SizedBox(
                        child: Row(
                          children: [
                            Image.asset('assets/images/vietnam.png', width: 30, height: 30),
                            SizedBox(width: 10),
                            Text(
                              'Tiếng Việt', 
                              style: AppText.normal(context)
                            )
                          ],
                        )
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'en', 
                      child: SizedBox(
                        child: Row(
                          children: [
                            Image.asset('assets/images/united-kingdom.png', width: 30, height: 30),
                            SizedBox(width: 10),
                            Text(
                              'English',  
                              style: AppText.normal(context)
                            )
                          ],
                        )
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'ko', 
                      child: SizedBox(
                        child: Row(
                          children: [
                            Image.asset('assets/images/south-korea.png', width: 30, height: 30),
                            SizedBox(width: 10),
                            Text(
                              '한국어',  
                              style: AppText.normal(context)
                            )
                          ],
                        )
                      ),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    languageController.changeLanguage(newValue!);
                  },
                ))
              ],
            )
          ],
        )
      ),
    );
  }
}
