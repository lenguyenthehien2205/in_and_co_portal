import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/post/controllers/add_post_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';


class AddPostScreen extends StatelessWidget {
  final AddPostController addPostController = Get.put(AddPostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm bài viết", style: AppText.headerTitle(context)),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: addPostController.contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline, // 
              decoration: InputDecoration(
                hintText: "Nhập nội dung bài viết...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey)), 
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey), 
                ),
              ),
            ),
            SizedBox(height: 20),

            Obx(() => addPostController.selectedImages.isNotEmpty
                ? SizedBox(
                    height: 250,
                    child: PageView.builder(
                      itemCount: addPostController.selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                addPostController.selectedImages[index],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.cancel, color: Colors.white),
                                onPressed: () => addPostController.removeImage(index),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : SizedBox()),


            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.add_photo_alternate, size: 40, color: Colors.green),
                onPressed: () => addPostController.pickImages(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => addPostController.submitPost(context),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, 
                  foregroundColor: Colors.white, 
                  minimumSize: Size(100, 40), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), 
                  ),
                ),
                child: Obx((){
                  if (addPostController.isLoading.value) {
                    return SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  }
                  return Text("Đăng bài");
                })
              ),
            ),
          ],
        ),
      ),
    );
  }
}
