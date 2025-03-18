import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/theme/app_text.dart';
import 'package:in_and_co_portal/layouts/auth_layout.dart';
import 'package:in_and_co_portal/features/auth/widgets/auth_button.dart';

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
                text: 'welcome_title'.tr,
                style: AppText.title(context),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              child: Center(
                child: AppText(
                  text: 'welcome_subtitle'.tr,
                  style: AppText.subtitle(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 85),
            AuthButton(
              text: AppText(
                text: 'welcome_button'.tr,
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