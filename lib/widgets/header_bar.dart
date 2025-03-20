import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderBar extends StatelessWidget{
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 45, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/MTAC.png', width: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add_box_outlined),
                onPressed: () {
                  context.push('/add-post');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}