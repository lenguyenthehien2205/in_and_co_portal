import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/services/firebase_service.dart';
import 'package:in_and_co_portal/controllers/language_controller.dart';
import 'package:in_and_co_portal/controllers/theme_controller.dart';
import 'package:in_and_co_portal/config/lang/localization_service.dart';
import 'package:in_and_co_portal/controllers/translation_controller.dart';
import 'package:in_and_co_portal/features/chat/controllers/chat_controller.dart';
import 'package:in_and_co_portal/features/chat/controllers/conversation_controller.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';
import 'config/app_routes.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'config/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> globalScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  await FCMService().initNotifications(); // Khởi tạo FCM
  // Tắt cache của Firestore để tránh lấy dữ liệu cũ 
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
  Get.put(ThemeController(), permanent: true); 
  Get.put(LanguageController(), permanent: true);
  Get.put(ProfileController(), permanent: true);
  Get.put(TranslationController(), permanent: true);  
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
  final TranslationController translationController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp.router( 
      routerDelegate: router.routerDelegate, // dùng để điều hướng
      routeInformationParser: router.routeInformationParser,  // dùng để mở trang từ url
      routeInformationProvider: router.routeInformationProvider, // dùng để cập nhật url
      // routerConfig: router,
      translations: LocalizationService(),
      scaffoldMessengerKey: globalScaffoldMessengerKey,
      locale: Locale(languageController.selectedLanguage.value), // Ngôn ngữ mặc định
      fallbackLocale: LocalizationService.locale,
      debugShowCheckedModeBanner: false,
      theme: themeController.themeData,
    ));

    // return Obx(() => GetMaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: themeController.themeData,
    //   translations: LocalizationService(),
    //   locale: Locale(languageController.selectedLanguage.value),
    //   fallbackLocale: LocalizationService.locale,
    //   initialRoute: '/', // Route mặc định
    //   getPages: AppRoutes.routes, // Danh sách route của GetX
    // ));
  }
}
