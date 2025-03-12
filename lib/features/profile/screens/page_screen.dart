import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/profile/widgets/page/story_button.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class PageScreen extends StatelessWidget {
  const PageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('page_title'.tr, style: AppText.headerTitle(context)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu), // Đổi thành icon hoặc widget khác nếu muốn
            onPressed: () {
              context.push('/profile/options');
            },
          ),
        ],
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
                    child: Image.asset(
                      'assets/images/sontung.jpeg',
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thế Hiển', style: AppText.title(context)),
                  Text('Đây là trang cá nhân của tôi', style: AppText.normal(context)),
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
                            side: BorderSide(color: Colors.grey), // Viền màu xám
                            shape: CircleBorder(), // Làm button tròn
                            minimumSize: Size(98, 98), // Đặt kích thước tối thiểu là 90x90
                            backgroundColor: const Color.fromARGB(255, 237, 237, 237), // Màu nền trắng
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
                length: 2, // Có 2 biểu đồ
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Theme.of(context).colorScheme.onSurface, // Màu khi chọn
                      unselectedLabelColor: Theme.of(context).colorScheme.onSurface, // Màu khi chưa chọn
                      indicator: BoxDecoration(
                        color: AppColors.primary.withAlpha(35), // Màu nền khi chọn
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: AppText.title(context), // 🔹 Tăng size chữ tab được chọn
                      unselectedLabelStyle: AppText.normal(context), // 🔹 Tăng size chữ tab không được chọn
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
                      height: 600, // Chiều cao cho biểu đồ
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
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Image.asset(
                                'assets/images/food.png',
                                fit: BoxFit.cover,
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
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return Image.asset(
                                'assets/images/sport.png',
                                fit: BoxFit.cover,
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