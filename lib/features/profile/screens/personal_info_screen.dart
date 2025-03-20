import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/utils/string_utils.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';
import 'package:in_and_co_portal/features/profile/widgets/info_row.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class PersonalInfoScreen extends StatelessWidget{
  PersonalInfoScreen({super.key});
  final ProfileController profileController = Get.find();

  @override
  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: 'profile_personal_information'.tr, style: AppText.headerTitle(context)),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: 
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 19),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: 'personal_info_general_info'.tr, style: AppText.title(context)),
                  SizedBox(height: 10),
                  InfoRow(title: 'personal_info_full_name'.tr, content: profileController.userData['fullname']),
                  InfoRow(title: 'personal_info_date_of_birth'.tr, content: formatTimestamp(profileController.userData['birthdate'])),
                  InfoRow(title: 'personal_info_employee_code'.tr, content: profileController.userData['employee_id']),
                  InfoRow(title: 'personal_info_gender'.tr, content: profileController.userData["gender"]),
                  InfoRow(title: 'personal_info_ethnicity'.tr, content: profileController.userData["ethnic"]),
                  InfoRow(title: 'personal_info_hometown'.tr, content: profileController.userData["hometown"]),

                  SizedBox(height: 30),

                  AppText(text: 'personal_info_contact_info'.tr, style: AppText.title(context)),
                  SizedBox(height: 10),
                  InfoRow(title: 'personal_info_phone_number'.tr, content: profileController.userData["phone"]),
                  InfoRow(title: 'personal_info_email'.tr, content: profileController.userData["email"]),
                  InfoRow(
                    title: 'personal_info_social_network'.tr, 
                    icons: [
                      {
                        'icon': 'assets/images/facebook.png',
                        'url': profileController.userData["social"]["facebook"],
                      },
                      {
                        'icon': 'assets/images/instagram.png',
                        'url': profileController.userData["social"]["instagram"],
                      }
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}