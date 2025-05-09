import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/controllers/language_controller.dart';
import 'package:in_and_co_portal/core/services/db_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';
import 'package:in_and_co_portal/features/profile/widgets/profile_button.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  FilePickerResult? _filePickerResult;
  DbService dbService = DbService();
  final ProfileController profileController = Get.find();
  @override
  void initState() {
    super.initState();
  }
  final languageController = Get.find<LanguageController>();

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ["jpg", "jpeg", "png", "mp4"],
        type: FileType.custom);
    setState(() {
      _filePickerResult = result;
    });

    if (_filePickerResult != null) {
      print(_filePickerResult!.files.first.name);
      context.push("/upload", extra: _filePickerResult);
    }
  }

  List<Map<String, dynamic>> buttons = [
    {'text': 'profile_your_page', 'icon': Icons.my_library_books, 'url': 'page'},
    {'text': 'profile_personal_information', 'icon': Icons.person, 'url': 'personal-info'},
    {'text': 'profile_settings', 'icon': Icons.settings, 'url': 'settings'},
    {'text': 'profile_logout', 'icon': Icons.logout, 'url': 'logout'},
  ];
  

@override
Widget build(BuildContext context) {
  profileController.fetchUserData();
  return Scaffold(
    key: ValueKey(languageController.selectedLanguage.value), 
    body: Obx((){
      if (profileController.isLoading.value && profileController.userData.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none, 
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/shape_profile.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(height: 80), 
                  ],
                ),
                Positioned(
                  top: 120, 
                  left: MediaQuery.of(context).size.width / 2 - 77, 
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          profileController.userData["avatar"] ?? '',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/default_avatar.png', width: 150, height: 150, fit: BoxFit.cover),
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  profileController.userData["fullname"] ?? '',
                  style: AppText.headerTitle(context)
                ),
                Text(
                  // 'profile_role'.tr, 
                  profileController.userData["role"] ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              buttons.map((btn) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ProfileButton(
                  text: btn['text'], 
                  icon: btn['icon'],
                  onPressed: () {
                    if(btn['url'] == 'logout'){
                      profileController.logout();
                      context.go('/login');
                      return;
                    }
                    if(btn['url'] == 'page'){
                      // print('${profileController.myUID}..................................................');
                      context.push('/profile/page/${profileController.myUID}');
                      return;
                    }
                    context.push('/profile/${btn['url']}');
                  },
                ),
              )).toList(),
            ),
          ),
        ],
      );
    })
  );
}
}











//  CircleAvatar(
//                     radius: 75, // Kích thước ảnh
//                     backgroundImage: AssetImage('assets/images/music.png'),
//                   ),

//             Text('Welcome to Profile Screen!'),
//             ElevatedButton(
//               onPressed: () async{
//                 await FirebaseAuth.instance.signOut();
//                 context.go('/login');
//               }, 
//               child: const Text('Sign Out')
//             ),
//             const SizedBox(height: 100),
//             StreamBuilder<DocumentSnapshot>(
//               stream: dbService.readLatestUploadedFile(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
//                   return Center(child: Text("Chưa có ảnh nào được tải lên"));
//                 }

//                 var data = snapshot.data!.data() as Map<String, dynamic>?;

//                 if (data == null || !data.containsKey("imageUrl")) {
//                   return Center(child: Text("Không tìm thấy ảnh"));
//                 }

//                 String imageUrl = data["imageUrl"];
//                 return ClipRRect(
//                   borderRadius: BorderRadius.circular(100),
//                   child: Image.network(
//                     imageUrl,
//                     width: 200,
//                     height: 200,
//                     fit: BoxFit.cover, 
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(child: CircularProgressIndicator());
//                     },
//                     errorBuilder: (context, error, stackTrace) => Center(child: Text("Lỗi khi tải ảnh")),
//                   )
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             IconButton(
//               onPressed: _openFilePicker, 
//               icon: const Icon(Icons.upload_file)
//             ),
//             const SizedBox(height: 20),