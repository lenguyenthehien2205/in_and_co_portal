import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/post/controllers/like_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class LikeButton extends StatelessWidget {
  final String postId;

  LikeButton({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final LikeController likeController = Get.put(LikeController(postId), tag: postId);

    return Obx(() => Row(
      children: [
        InkWell(
          onTap: () => likeController.toggleLike(),
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              likeController.hasLiked.value
                  ? Icons.favorite 
                  : Icons.favorite_border,
              color:
                  likeController.hasLiked.value ? Colors.red : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Text('${likeController.likeCount.value}', style: AppText.subtitle(context)),
      ],
    )
    );
  }
}