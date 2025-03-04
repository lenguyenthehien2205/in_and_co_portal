import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Profile Screen!'),
            ElevatedButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                context.go('/login');
              }, 
              child: const Text('Sign Out')
            ),
          ],
        ),
      ),
    );
  }
}