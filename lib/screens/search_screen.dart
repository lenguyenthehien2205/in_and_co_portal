import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class SearchScreen extends StatelessWidget{
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Search Screen!'),
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