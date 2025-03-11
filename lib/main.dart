import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/controllers/language_controller.dart';
import 'package:in_and_co_portal/controllers/theme_controller.dart';
import 'package:in_and_co_portal/lang/localization_service.dart';
import 'config/app_routes.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'config/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  // Tắt cache của Firestore để tránh lấy dữ liệu cũ 
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
  Get.put(ThemeController()); 
  Get.put(LanguageController());
  runApp(
    ScreenUtilInit( 
      designSize: Size(375, 812),
      minTextAdapt: true, 
      splitScreenMode: true, // Hỗ trợ màn hình chia đôi
      builder: (context, child) {
        return MyApp();
      }
    )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeController themeController = Get.find();
  final LanguageController languageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp.router( // 🔥 Thay MaterialApp.router thành GetMaterialApp.router
      routerDelegate: router.routerDelegate, // dùng 
      routeInformationParser: router.routeInformationParser, // ⚡️ Thêm routeInformationParser
      routeInformationProvider: router.routeInformationProvider, // ⚡️ Thêm routeInformationProvider
      // routerConfig: router,
      translations: LocalizationService(),
      locale: Locale(languageController.selectedLanguage.value), // Ngôn ngữ mặc định
      fallbackLocale: LocalizationService.locale, // Dự phòng nếu không tìm thấy ngôn ngữ
      debugShowCheckedModeBanner: false,
      theme: themeController.themeData,
    ));
  }
}
