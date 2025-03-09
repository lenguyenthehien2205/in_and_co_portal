import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/app_routes.dart'; // Import file cấu hình router
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.aBeeZeeTextTheme(),
      )
    );
  }
}
