import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/features/profile/widgets/info_row.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class PersonalInfoScreen extends StatelessWidget{
  const PersonalInfoScreen({super.key});

  @override
  Widget build(context){
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: 'profile_personal_information'.tr, style: AppText.headerTitle(context)),
        centerTitle: true,
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
                  InfoRow(title: 'personal_info_full_name'.tr, content: 'Lê Nguyễn Thế Hiển'),
                  InfoRow(title: 'personal_info_date_of_birth'.tr, content: '22/05/2003'),
                  InfoRow(title: 'personal_info_employee_code'.tr, content: '3121560030'),
                  InfoRow(title: 'personal_info_gender'.tr, content: 'Nam'),
                  InfoRow(title: 'personal_info_ethnicity'.tr, content: 'Kinh'),
                  InfoRow(title: 'personal_info_hometown'.tr, content: 'An Lợi, An Hòa, Trảng Bàng, Tây Ninh'),

                  SizedBox(height: 30),

                  AppText(text: 'personal_info_contact_info'.tr, style: AppText.title(context)),
                  SizedBox(height: 10),
                  InfoRow(title: 'personal_info_phone_number'.tr, content: '0778689851'),
                  InfoRow(title: 'personal_info_email'.tr, content: 'lenguyenthehien2205@gmail.com'),
                  InfoRow(
                    title: 'personal_info_social_network'.tr, 
                    icons: [
                      {
                        'icon': 'assets/images/facebook.png',
                        'url': 'https://www.facebook.com/thehienn08/',
                      },
                      {
                        'icon': 'assets/images/instagram.png',
                        'url': 'https://www.instagram.com/thehienn08/'
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