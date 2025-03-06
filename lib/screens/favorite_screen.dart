import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class FavoriteScreen extends StatelessWidget{
  const FavoriteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Favorite Screen!'),
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