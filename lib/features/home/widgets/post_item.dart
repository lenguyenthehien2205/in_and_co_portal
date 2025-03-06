import 'package:flutter/material.dart';

class PostItem extends StatelessWidget{
  const PostItem({super.key});

  @override
  Widget build(context){
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Image.asset(
            'assets/images/chuong_trinh_thu_gom.png',
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}