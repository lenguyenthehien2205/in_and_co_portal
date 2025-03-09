import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:in_and_co_portal/core/models/post.dart';
import 'package:in_and_co_portal/features/home/controllers/post_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class PostItem extends StatefulWidget{
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem>{
  final PostController postController = Get.put(PostController());
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

  List<Widget> posts = [
    Image.asset(
      "assets/images/thu_hoi_pin_cu.png",
      fit: BoxFit.cover,
    ),
    Image.asset(
      "assets/images/MTAC_avatar.jpeg",
      fit: BoxFit.cover,
    ),
    Image.asset(
      "assets/images/chuong_trinh_thu_gom.png",
      fit: BoxFit.cover,
    ),
    Image.asset(
      "assets/images/thu_hoi_pin_cu.png",
      fit: BoxFit.cover,
    ),
    Image.asset(
      "assets/images/chuong_trinh_thu_gom.png",
      fit: BoxFit.cover,
    ),
  ];
  @override
  Widget build(context){
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
                    Container(
                      padding: EdgeInsets.all(0.8), // Độ dày của viền
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Màu bạc
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/MTAC_avatar.jpeg",
                          width: 40, // Kích thước ảnh
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AppText(text: 'Môi trường Á Châu', style: AppText.semiBoldTitle),
                            SizedBox(width: 5),
                            Icon(Icons.verified, color: Colors.blue, size: 16),
                          ],
                        ),
                        AppText(text: '1 giờ trước', style: AppText.subtitle),
                      ],
                    ),
                    SizedBox(height: 20)
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: (){},
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
                    children: posts,
                  )
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 84, 84, 84).withAlpha(150), // Màu đen đục
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${currentPage.value}/${posts.length}', // Hiển thị số trang
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            )
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {}, // Xử lý sự kiện nhấn
                          borderRadius: BorderRadius.circular(100), // Bo góc hiệu ứng
                          child: Padding( // Thêm padding để dễ bấm hơn
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.favorite_border, size: 20),
                          ),
                        ),
                        Text('200', 
                          style: AppText.subtitle,
                        ), 
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {}, // Xử lý sự kiện nhấn
                          borderRadius: BorderRadius.circular(100), // Bo góc hiệu ứng
                          child: Padding( // Thêm padding để dễ bấm hơn
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.mode_comment_outlined, size: 20),
                          ),
                        ),
                        AppText(text: '32', style: AppText.subtitle),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.bookmark_border),
                      onPressed: (){},
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chương trình thu gom pin cũ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Text('#MTAC #MôiTrườngÁChâu', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}