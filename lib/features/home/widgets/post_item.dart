import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/controllers/translation_controller.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/core/utils/string_utils.dart';
import 'package:in_and_co_portal/features/home/controllers/post_controller.dart';
import 'package:in_and_co_portal/features/home/widgets/comment_frame.dart';
import 'package:in_and_co_portal/features/home/widgets/like_button.dart';
import 'package:in_and_co_portal/features/home/widgets/post_options.dart';
import 'package:in_and_co_portal/features/home/widgets/save_button.dart';
import 'package:in_and_co_portal/features/post/controllers/comment_controller.dart';
import 'package:in_and_co_portal/features/post/controllers/download_image_controller.dart';
import 'package:in_and_co_portal/features/post/controllers/like_controller.dart';
import 'package:in_and_co_portal/features/post/controllers/save_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class PostItem extends StatefulWidget{
  final PostDetail post;
  const PostItem({super.key, required this.post});

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem>{
  final PostController postController = Get.put(PostController());
  final DownloadImageController downloadImageController = Get.put(DownloadImageController());
  final PageController pageController = PageController(
    initialPage: 0,
  );
  var currentPage = 1.obs;
 
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      if (pageController.hasClients) {
        currentPage.value = pageController.page!.round() + 1;
      }
    });
  }

  void openCommentsModal(context, String postId) {
    final CommentController commentController = Get.find<CommentController>();

    commentController.fetchComments(postId);

    var currentPath = GoRouterState.of(context).uri.toString() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface, 
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: CommentFrame(postId: postId, currentPath: currentPath),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(context){
    String labels = widget.post.getUniqueLabels()
        .map((label) => '#$label') 
        .join('  ');  
    Get.put(TranslationController(), tag: widget.post.id);
    return GetBuilder<TranslationController>(
      init: Get.put(TranslationController(), tag: widget.post.id),
      global: false,
      builder: (translationController) {
        return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('Author ID: ${widget.post.authorId}');
                          print('/profile/page/${widget.post.authorId}..................................................');
                          context.push('/profile/page/${widget.post.authorId}');
                        },
                        child: Container(
                          padding: EdgeInsets.all(0.8), 
                          decoration: BoxDecoration(
                            color: Colors.grey[300], 
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              widget.post.authorAvatar, 
                              width: 40, 
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/default_avatar.png', width: 40, height: 40);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          print('Author ID: ${widget.post.authorId}');
                          context.push('/profile/page/${widget.post.authorId}');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppText(text: widget.post.authorName, style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                )),
                                SizedBox(width: 5),
                                if (widget.post.isChecked)
                                  Icon(Icons.verified, color: Colors.blue, size: 16)
                              ],
                            ),
                            AppText(text: getTimeAgoByTimestamp(widget.post.createdAt), style: AppText.subtitle(context)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                  PostOptions(
                    onDownload: () {
                      print('Download image: ${widget.post.images[pageController.page!.round()]['url']}');
                      downloadImageController.downloadImage(context, widget.post.images[pageController.page!.round()]['url']);
                    },
                  )
                ],
              )
            ),
            SizedBox(height: 10),
            Obx(() => 
              Stack(
                children: [
                  SizedBox(
                    height: 350,
                    child: PageView(
                      controller: pageController,
                      children: widget.post.images.map((image) => Image.network(
                        image['url'] ?? '',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 130,
                          height: 130,
                          alignment: Alignment.center,
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, color: Colors.grey[600]),
                        ),
                      )).toList()
                    )
                  ),
                  Visibility(
                    visible: widget.post.images.length > 1, 
                      child: Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 84, 84, 84).withAlpha(150), 
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${currentPage.value}/${widget.post.images.length}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: widget.post.status == 'accepted',
                  replacement: SizedBox(width: 400), 
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GetBuilder<LikeController>(
                              init: Get.put(LikeController(widget.post.id), tag: widget.post.id), // Đảm bảo mỗi bài có controller riêng
                              builder: (controller) {
                                return LikeButton(postId: widget.post.id);
                              },
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                openCommentsModal(context, widget.post.id);
                              },
                              borderRadius: BorderRadius.circular(100), 
                              child: Padding( 
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.mode_comment_outlined, size: 20),
                              ),
                            ),
                            GetBuilder<CommentController>(
                              init: Get.put(CommentController(), tag: widget.post.id), 
                              builder: (controller) {
                                if (!controller.commentCounts.containsKey(widget.post.id)) {
                                  controller.fetchCommentCount(widget.post.id);
                                  return AppText(text: '0', style: AppText.subtitle(context)); 
                                }
                                return AppText(
                                  text: '${controller.commentCounts[widget.post.id] ?? 0}', 
                                  style: AppText.subtitle(context),
                                );
                              },
                            ),
                          ],
                        ),
                        GetBuilder<SaveController>(
                          init: Get.put(SaveController(widget.post.id), tag: widget.post.id), 
                          builder: (controller) {
                            return SaveButton(postId: widget.post.id, postOwnerId: widget.post.authorId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                if(widget.post.status == 'pending')
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        translationController.isTranslated.value
                            ? translationController.translatedText.value
                            : widget.post.title,
                        style: AppText.normal(context),
                      )),
                      Text(
                        labels,
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                      ),
                      Obx(() => TextButton(
                          onPressed: () {
                            if(translationController.isTranslated.value){
                              translationController.isTranslated.value = false;
                            } else {
                              translationController.translateText(widget.post.title, 'en');
                            }
                          },
                          child: Text(
                            translationController.isTranslated.value ? "hide_translation".tr : "view_translation".tr,
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            )
          ],
        ),
      );
    });
  }
}