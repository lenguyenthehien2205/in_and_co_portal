import 'package:flutter/widgets.dart';

class HeaderBar extends StatelessWidget{
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('In & Co', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          // Icon(Icons.menu),
        ],
      ),
    );
  }
}