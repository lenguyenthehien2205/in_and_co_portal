import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/config/firebase_api.dart';
import 'package:in_and_co_portal/features/home/controllers/notification_controller.dart';

class HeaderBar extends StatelessWidget{
  HeaderBar({super.key});
  final FirebaseApi firebaseApi = FirebaseApi();
  final NotificationController notificationController = Get.put(NotificationController());

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
              // IconButton(
              //   icon: const Icon(Icons.notifications_none),
              //   onPressed: () {
              //     context.push('/home/notification');
              //   },
              // ),
              Obx(() {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {
                        context.push('/home/notification');
                      },
                    ),
                    if (notificationController.notificationCount.value > 0) 
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '${notificationController.notificationCount.value}',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              }),

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