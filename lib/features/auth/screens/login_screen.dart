import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/auth/controllers/auth_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';
import 'package:in_and_co_portal/layouts/auth_layout.dart';
import 'package:in_and_co_portal/features/auth/widgets/auth_button.dart';
import 'package:in_and_co_portal/features/auth/widgets/auth_textfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController = Get.put(AuthController()); // Khởi tạo Controller
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppText(
              text: 'login_title'.tr,
              style: AppText.title(context),
            ),
            const SizedBox(height: 50),
            Image.asset('assets/images/login_logo.png'),
            const SizedBox(height: 38),
            Column(
              children: [
                AuthTextfield(
                  hintText: 'login_type_email'.tr,
                  controller: _emailController,
                  onSubmitted: (_) => authController.login(context, _emailController.text, _passwordController.text),
                ),
                const SizedBox(height: 16),
                AuthTextfield(
                  hintText: 'login_type_password'.tr,
                  isPassword: true,
                  controller: _passwordController,
                  onSubmitted: (_) => authController.login(context, _emailController.text, _passwordController.text),
                ),
                // Quên mật khẩu
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    child: AppText(
                      text: 'login_forgot_password'.tr,
                      style: AppText.subtitle(context),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => authController.signInWithGoogle(context),
                  icon: Image.asset('assets/images/gg_icon.png', width: 24, height: 24),
                ),
              ],
            ),
            const SizedBox(height: 85),
            Obx(() => authController.isLoading.value
                ? const CircularProgressIndicator()
                : AuthButton(
                    text: AppText(
                        text: 'login_button'.tr, style: AppText.title(context)),
                    onPressed: () {
                      authController.login(context, _emailController.text, _passwordController.text);
                    },
                  )),
            const SizedBox(height: 44),
          ],
        ),
      ),
    );
  }
}
