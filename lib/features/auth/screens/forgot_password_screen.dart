import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/theme/app_text.dart';
import 'package:in_and_co_portal/layouts/auth_layout.dart';
import 'package:in_and_co_portal/widgets/auth_button.dart';
import 'package:in_and_co_portal/widgets/auth_textfield.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ForgotPasswordScreen extends StatefulWidget{
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>{
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: _emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email đặt lại mật khẩu đã được gửi! 📩'),
          backgroundColor: Colors.green,
        ),
      );
      // Quay lại màn hình đăng nhập
      // Future.delayed(const Duration(seconds: 2), () {
      //   if (mounted) context.pop();
      // });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Đã xảy ra lỗi! 🔴'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(context){
    return AuthBackground(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppText(
              text: 'Lấy lại mật khẩu',
              style: AppText.title
            ),
            const SizedBox(height: 50),
            SvgPicture.asset(
              'assets/images/forgot_password.svg',
              width: 245,
              height: 162,
            ),
            const SizedBox(height: 38),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AuthTextfield(
                    hintText: 'Nhập email', 
                    controller: _emailController,
                    onSubmitted: (_) => _resetPassword(),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: (){
                  context.pop();
                },
                child: AppText(
                  text: 'Quay lại đăng nhập',
                ),
              ),
            ),
            const SizedBox(height: 85),
            AuthButton(
              text: AppText(text: 'Gửi yêu cầu', style: AppText.title), 
              onPressed: (){
                _resetPassword();
              }
            ),
            const SizedBox(height: 44),
          ],
        )
      )
    );
  }
} 