import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/config/firebase_api.dart';

class HeaderBar extends StatelessWidget{
  HeaderBar({super.key});
  final FirebaseApi firebaseApi = FirebaseApi();

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
                onPressed: () {
                  // firebaseApi.sendNotificationToAuthor('AMS2M3AL9Dc27IRK9ogeaz6ZDXG3', 'Huy chó', 'Huy chó');
                  context.push('/home/notification');
                },
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