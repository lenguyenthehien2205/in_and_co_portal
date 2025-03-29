import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';
import 'package:in_and_co_portal/features/profile/widgets/page/story_button.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class PageScreen extends StatelessWidget {
  PageScreen({super.key});
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page_title'.tr, style: AppText.headerTitle(context)),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: CustomScrollView(
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
                      profileController.userData["avatar"] ?? '',
                      width: 95,
                      height: 95,
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('2', style: AppText.title(context)),
                      Text('page_post'.tr, style: AppText.small(context)), 
                    ],
                  ),
                  SizedBox(width: 5),
                  Column( 
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('10', style: AppText.title(context)),
                      Text('page_follower'.tr, style: AppText.small(context)),
                    ],
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('9', style: AppText.title(context)),
                      Text('page_following'.tr, style: AppText.small(context)),
                    ],
                  ),
                ],
              )
            )
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profileController.userData["fullname"], style: AppText.title(context)),
                  Text(profileController.userData["bio"], style: AppText.normal(context)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            print('Button pressed');
                          },
                          style: TextButton.styleFrom(
                            side: BorderSide(color: Colors.grey), 
                            shape: CircleBorder(), 
                            minimumSize: Size(98, 98), 
                            backgroundColor: const Color.fromARGB(255, 237, 237, 237), 
                          ),
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('page_new_story'.tr, style: AppText.normal(context)),
                      ],
                    ),
                    SizedBox(width: 10),
                    StoryButton(text: 'Du lịch', url: 'assets/images/travel.png'),
                    SizedBox(width: 10),
                    StoryButton(text: 'Thể thao', url: 'assets/images/sport.png'),
                    SizedBox(width: 10),
                    StoryButton(text: 'Hoạt động', url: 'assets/images/food.png'),
                  ],
                ),
              )
            ),
          ),
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
                  SizedBox(
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
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}