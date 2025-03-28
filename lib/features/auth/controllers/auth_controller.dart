import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs; 

  Future<void> login(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Vui lòng nhập đầy đủ thông tin.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed('/home'); 
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đăng nhập thất bại',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
