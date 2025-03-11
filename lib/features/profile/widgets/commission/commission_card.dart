import 'package:flutter/material.dart';

class CommissionCard extends StatelessWidget{
  final String title;
  final String amount;
  final String image;
  const CommissionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.image,
  });

  @override
  Widget build(context){
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade100,
            Colors.blue.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(amount, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Image.asset(image, width: 100, height: 100),
        ],
      ),
    );
  }
}