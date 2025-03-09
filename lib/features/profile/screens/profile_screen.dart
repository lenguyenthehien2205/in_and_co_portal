import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/services/db_service.dart';
import 'package:in_and_co_portal/features/profile/widgets/profile_button.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  String userId = FirebaseAuth.instance.currentUser!.uid;
  User? user = FirebaseAuth.instance.currentUser;
  FilePickerResult? _filePickerResult;

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
    {'text': 'Thông tin cá nhân', 'icon': Icons.person},
    {'text': 'Bài viết của bạn', 'icon': Icons.my_library_books},
    {'text': 'Lộ trình công tác', 'icon': Icons.route},
    {'text': 'Phúc lợi', 'icon': Icons.shield_outlined},
    {'text': 'Hoa hồng', 'icon': Icons.percent},
  ];

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: CustomScrollView(
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
                  SizedBox(height: 80), // Tạo khoảng trống cho avatar
                ],
              ),
              Positioned(
                top: 120, // Điều chỉnh vị trí
                left: MediaQuery.of(context).size.width / 2 - 77, // Trừ đi (radius + border)
                child: Container(
                  padding: EdgeInsets.all(5), // Độ dày viền trắng
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu viền
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 75, // Kích thước ảnh
                    backgroundImage: AssetImage('assets/images/music.png'),
                  ),
                ),
              ),
              Positioned(
                top: 40, // Điều chỉnh vị trí
                right: 10, // Trừ đi (radius + border)
                child: IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.menu),
                  iconSize: 30,
                  color: Colors.white,
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
                'Lê Nguyễn Thế Hiển',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Thực tập sinh IT', 
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
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
              ),
            )).toList(),
          ),
        ),
      ],
    ),
  );
}
}

            // Text('Welcome to Profile Screen!'),
            // ElevatedButton(
            //   onPressed: () async{
            //     await FirebaseAuth.instance.signOut();
            //     context.go('/login');
            //   }, 
            //   child: const Text('Sign Out')
            // ),
            // const SizedBox(height: 100),
            // StreamBuilder<DocumentSnapshot>(
            //   stream: dbService.readLatestUploadedFile(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            //       return Center(child: Text("Chưa có ảnh nào được tải lên"));
            //     }

            //     var data = snapshot.data!.data() as Map<String, dynamic>?;

            //     if (data == null || !data.containsKey("imageUrl")) {
            //       return Center(child: Text("Không tìm thấy ảnh"));
            //     }

            //     String imageUrl = data["imageUrl"];
            //     return ClipRRect(
            //       borderRadius: BorderRadius.circular(100),
            //       child: Image.network(
            //         imageUrl,
            //         width: 200,
            //         height: 200,
            //         fit: BoxFit.cover, 
            //         loadingBuilder: (context, child, loadingProgress) {
            //           if (loadingProgress == null) return child;
            //           return Center(child: CircularProgressIndicator());
            //         },
            //         errorBuilder: (context, error, stackTrace) => Center(child: Text("Lỗi khi tải ảnh")),
            //       )
            //     );
            //   },
            // ),
            // const SizedBox(height: 20),
            // IconButton(
            //   onPressed: _openFilePicker, 
            //   icon: const Icon(Icons.upload_file)
            // ),
            // const SizedBox(height: 20),