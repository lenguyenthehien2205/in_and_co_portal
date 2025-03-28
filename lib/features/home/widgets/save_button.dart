import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/post/controllers/save_controller.dart';

class SaveButton extends StatelessWidget {
  final String postId;
  final String postOwnerId;

  SaveButton({super.key, required this.postId, required this.postOwnerId});

  @override
  Widget build(BuildContext context) {
    final SaveController saveController = Get.put(SaveController(postId), tag: postId);

    return Obx(() => Row(
      children: [
        InkWell(
          onTap: (){
            saveController.toggleSave(context, postOwnerId);
          },
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              saveController.hasSaved.value
                  ? Icons.bookmark 
                  : Icons.bookmark_border,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    )
    );
  }
}