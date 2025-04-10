import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/post/controllers/add_post_controller.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';
import 'package:in_and_co_portal/theme/app_text.dart';


class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key});

  final AddPostController addPostController = Get.put(AddPostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_post_title'.tr, style: AppText.headerTitle(context)),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: addPostController.contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline, // 
              decoration: InputDecoration(
                hintText: "add_post_placeholder".tr,
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
                  height: 330, 
                  child: PageView.builder(
                    itemCount: addPostController.selectedImages.length,
                    itemBuilder: (context, index) { 
                      return Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  addPostController.selectedImages[index],
                                  width: double.infinity,
                                  height: 220,
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
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 5.0,
                                  children: addPostController.imageLabels[index]
                                    .map((label) => GestureDetector(
                                          onTap: () {
                                            addPostController.editLabel(index, label, context);
                                          },
                                          child: Chip(
                                            label: Text(label),
                                            onDeleted: () => addPostController.removeLabel(index, label),
                                          ),
                                        ))
                                    .toList(),
                                ),
                              )
                            );
                          }),
                          TextButton(
                            onPressed: () => addPostController.addNewLabel(index, context),
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : SizedBox()),

            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.add_photo_alternate, size: 40, color: Colors.green),
                    onPressed: () => addPostController.pickImages(),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.camera, size: 40, color: Colors.green),
                    onPressed: () => addPostController.captureImage(),
                  ),
                ],
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
                  return Text("add_post_submit".tr);
                })
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 