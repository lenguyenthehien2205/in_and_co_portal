import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/theme/app_text.dart';
import 'package:in_and_co_portal/layouts/auth_layout.dart';
import 'package:in_and_co_portal/features/auth/widgets/auth_button.dart';
import 'package:in_and_co_portal/features/auth/widgets/auth_textfield.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>{
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose(); 
    _emailController.dispose();
    super.dispose();
  }

  var _email = '';  
  var _password = '';
  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final userCredentials = await _firebase.signInWithEmailAndPassword(email: _email, password: _password);
        print(userCredentials.toString());
        if (mounted) {
        context.go('/home');
      }
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Đã xảy ra lỗi!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print("Dữ liệu không hợp lệ!");
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
              text: 'login_title'.tr,
              style: AppText.title(context)
            ),
            const SizedBox(height: 50),
            Image.asset('assets/images/login_logo.png'),
            const SizedBox(height: 38),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AuthTextfield(
                    hintText: 'login_type_email'.tr, 
                    controller: _emailController,
                    onChanged: (value){
                      _email = value;
                    },
                    onSubmitted: (_) => _submitForm(),
                  ),
                  const SizedBox(height: 16),
                  AuthTextfield(
                    hintText: 'login_type_password'.tr, 
                    isPassword: true, 
                    controller: _passwordController,
                    onChanged: (value){
                      _password = value;
                    },
                    onSubmitted: (_) => _submitForm(),
                  ),
                  // quên mật khẩu
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){
                        context.push('/forgot-password');
                      },
                      child: AppText(
                        text: 'login_forgot_password'.tr,
                        style: AppText.subtitle(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 85),
            AuthButton(
              text: AppText(text: 'login_button'.tr, style: AppText.title(context)), 
              onPressed: (){
                _submitForm();
              }
            ),
            const SizedBox(height: 44),
          ],
        )
      )
    );
  }
}