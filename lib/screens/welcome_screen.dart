import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/theme/app_text.dart';
import 'package:in_and_co_portal/theme/app_theme.dart';
import 'package:in_and_co_portal/widgets/auth_background.dart';
import 'package:in_and_co_portal/widgets/custom_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/images/welcome_logo.png'),
            const SizedBox(height: 48),
            SizedBox(
              child: AppText(
                text: 'Khám phá tin tức và kết nối với đồng nghiệp ngay hôm nay!',
                style: AppTheme.title,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              child: Center(
                child: AppText(
                  text: 'Khám phá tin tức công ty, cập nhật các thông báo quan trọng và chia sẻ câu chuyện của bạn ngay hôm nay',
                  style: AppTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 85),
            CustomButton(
              text: AppText(
                text: 'Bắt đầu',
              ),
              onPressed: () {
                context.go('/login');
                // FirebaseAuth.instance.signOut();
                // context.push('/login');
              },
            ),
            const SizedBox(height: 44),
          ],
        )
      )
    );
  }
}