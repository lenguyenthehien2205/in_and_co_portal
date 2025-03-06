import 'package:flutter/material.dart';
import 'package:in_and_co_portal/features/home/widgets/company_posts.dart';
import 'package:in_and_co_portal/features/home/widgets/posts.dart';
import 'package:in_and_co_portal/widgets/header_bar.dart';


class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HeaderBar(),
            CompanyPosts(),
            Posts()
          ],
        ),
      ),
    );
  }
}