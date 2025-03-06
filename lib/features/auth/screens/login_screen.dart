import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/theme/app_text.dart';
import 'package:in_and_co_portal/theme/app_theme.dart';
import 'package:in_and_co_portal/layouts/auth_layout.dart';
import 'package:in_and_co_portal/widgets/custom_button.dart';
import 'package:in_and_co_portal/widgets/custom_textfield.dart';

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
    _passwordController.dispose(); // Giải phóng bộ nhớ khi không dùng nữa
    _emailController.dispose();
    super.dispose();
  }

  var _email = '';  
  var _password = '';
  final _formKey = GlobalKey<FormState>();

  // Future<void> _signInWithGoogle() async {
  //   try {
  //     // 🔹 1. Hiển thị hộp thoại chọn tài khoản Google
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) return; // Người dùng hủy đăng nhập

  //     // 🔹 2. Lấy thông tin xác thực từ Google
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final OAuthCredential googleCredential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     try {
  //       // 🔹 3. Đăng nhập với Google (nếu chưa có tài khoản, Firebase sẽ tạo mới)
  //       final UserCredential userCredential =
  //           await FirebaseAuth.instance.signInWithCredential(googleCredential);

  //       print("🟢 Đăng nhập thành công: ${userCredential.user?.displayName}");

  //       if (mounted) {
  //         context.go('/home'); // Điều hướng đến trang chủ
  //       }
  //     } on FirebaseAuthException catch (error) {
  //       // 🔴 4. Xử lý lỗi "email đã tồn tại"
  //       if (error.code == 'account-exists-with-different-credential') {
  //         print("⚠️ Email này đã có tài khoản!");

  //         final email = googleUser.email;
  //         List<String> signInMethods =
  //             await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

  //         // 🔹 5. Nếu tài khoản này có đăng ký bằng Email/Password
  //         if (signInMethods.contains('password')) {
  //           // 👉 Thay vì yêu cầu mật khẩu, ta đăng nhập bằng email trước rồi tự động liên kết Google
  //           await _linkGoogleToExistingAccount(email, googleCredential);
  //         }
  //       } else {
  //         print("🔴 Lỗi đăng nhập Google: ${error.message}");
  //       }
  //     }
  //   } catch (e) {
  //     print("🔴 Lỗi đăng nhập Google: $e");
  //   }
  // }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final userCredentials = await _firebase.signInWithEmailAndPassword(email: _email, password: _password);
        print(userCredentials.toString()+"🟢");
        if (mounted) {
        context.go('/home'); // Điều hướng đến trang chủ
      }
      } on FirebaseAuthException catch (error) {
        // if(error.code == 'email-already-in-use'){
        //   print('Không tìm thấy người dùng! 🔴');
        // } 
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Đã xảy ra lỗi! 🔴'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print("Dữ liệu không hợp lệ! 🔴");
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
              text: 'Chào mừng bạn!',
              style: AppTheme.title
            ),
            const SizedBox(height: 50),
            Image.asset('assets/images/login_logo.png'),
            const SizedBox(height: 38),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextfield(
                    hintText: 'Nhập email', 
                    controller: _emailController,
                    onChanged: (value){
                      _email = value;
                    },
                    onSubmitted: (_) => _submitForm(),
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    hintText: 'Nhập mật khẩu', 
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
                        text: 'Quên mật khẩu?',
                        style: AppTheme.subtitle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 85),
            CustomButton(
              text: AppText(text: 'Đăng nhập', style: AppTheme.title), 
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