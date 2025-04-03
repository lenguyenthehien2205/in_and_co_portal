import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class PageScreen extends StatelessWidget {
  final String userId;
  PageScreen({super.key, required this.userId});
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    print('${profileController.currentUID.value} - $userId');
    profileController.fetchUserData(userId: userId);
    return Scaffold(
      appBar: AppBar(
        title: Text('page_title'.tr, style: AppText.headerTitle(context)),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: Obx((){
        if (profileController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        final displayData = profileController.isViewingOtherUser.value
          ? profileController.otherUserData
          : profileController.userData;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        displayData["avatar"] ?? '',
                        width: 95,
                        height: 95,
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(displayData["post_count"].toString(), style: AppText.title(context)),
                        Text('page_post'.tr, style: AppText.small(context)), 
                      ],
                    ),
                    SizedBox(width: 5),
                    Column( 
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(displayData["save_count"].toString(), style: AppText.title(context)),
                        Text("Bài viết đã lưu", style: AppText.small(context)),
                      ],
                    ),
                    SizedBox(width: 5),
                  ],
                )
              )
            ),
            Obx((){
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded( 
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(displayData["fullname"], style: AppText.title(context)),
                                SizedBox(width: 5),
                                if (displayData["is_checked"] == true)
                                  Icon(Icons.verified, color: Colors.blue, size: 18),
                              ],
                            ),
                            Text(displayData["role"], style: AppText.subtitle(context)),
                            SizedBox(height: 10),
                            Text(
                              displayData["bio"],
                              style: AppText.normal(context),
                              softWrap: true, // Đảm bảo xuống hàng
                            ),
                          ],
                        ),
                      ),
                      if (profileController.isViewingOtherUser.value && FirebaseAuth.instance.currentUser?.uid != userId)
                        IconButton(
                          onPressed: () {
                            context.push('/conversations/chat/${profileController.conversationId.value}', extra: {
                              "otherUserInfo": {
                                "fullname": displayData["fullname"],
                                "avatar": displayData["avatar"],
                                "is_checked": displayData["is_checked"],
                                "role": displayData["role"],
                              },
                            });
                          },
                          icon: Icon(Icons.question_answer, color: AppColors.primary),
                        ),
                    ],
                  )
                ),
              );
            }),
            
            // SliverToBoxAdapter(
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //       child: Row(
            //         children: [
            //           Column(
            //             children: [
            //               TextButton(
            //                 onPressed: () {
            //                   print('Button pressed');
            //                 },
            //                 style: TextButton.styleFrom(
            //                   side: BorderSide(color: Colors.grey), 
            //                   shape: CircleBorder(), 
            //                   minimumSize: Size(98, 98), 
            //                   backgroundColor: const Color.fromARGB(255, 237, 237, 237), 
            //                 ),
            //                 child: Text(
            //                   '+',
            //                   style: TextStyle(
            //                     fontSize: 50,
            //                     color: Colors.grey,
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(height: 5),
            //               Text('page_new_story'.tr, style: AppText.normal(context)),
            //             ],
            //           ),
            //           SizedBox(width: 10),
            //           StoryButton(text: 'Du lịch', url: 'assets/images/travel.png'),
            //           SizedBox(width: 10),
            //           StoryButton(text: 'Thể thao', url: 'assets/images/sport.png'),
            //           SizedBox(width: 10),
            //           StoryButton(text: 'Hoạt động', url: 'assets/images/food.png'),
            //         ],
            //       ),
            //     )
            //   ),
            // ),
            SliverToBoxAdapter(
              child: DefaultTabController(
                length: 2, 
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Theme.of(context).colorScheme.onSurface, 
                      unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                      indicator: BoxDecoration(
                        color: AppColors.primary.withAlpha(35), 
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: AppText.title(context), 
                      unselectedLabelStyle: AppText.normal(context), 
                      tabs: [
                        Tab(
                          icon: Icon(Icons.grid_view),
                        ),
                        Tab(
                          icon: Icon(Icons.bookmark_border_outlined)
                        ),
                      ],
                    ),
                    Obx((){
                      return SizedBox(
                        height: 600, 
                        child: TabBarView(
                          children: [
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                childAspectRatio: 1,
                              ),
                              itemCount: profileController.posts.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    context.push('/post-detail/${profileController.posts[index].id}');
                                  },
                                  child: ClipRRect(
                                    child: Image.network(
                                      profileController.posts[index].url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                childAspectRatio: 1,
                              ),
                              itemCount: profileController.posts_saved.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    context.push('/post-detail/${profileController.posts_saved[index].id}');
                                  },
                                  child: ClipRRect(
                                    child: Image.network(
                                      profileController.posts_saved[index].url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        );
      })
    );
  }
}