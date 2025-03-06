import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/services/db_service.dart';

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

  @override
  Widget build(BuildContext context) {
    DbService dbService = DbService();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Profile Screen!'),
            ElevatedButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                context.go('/login');
              }, 
              child: const Text('Sign Out')
            ),
            const SizedBox(height: 100),
            StreamBuilder<DocumentSnapshot>(
              stream: dbService.readLatestUploadedFile(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                  return Center(child: Text("Chưa có ảnh nào được tải lên"));
                }

                var data = snapshot.data!.data() as Map<String, dynamic>?;

                if (data == null || !data.containsKey("imageUrl")) {
                  return Center(child: Text("Không tìm thấy ảnh"));
                }

                String imageUrl = data["imageUrl"];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover, 
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) => Center(child: Text("Lỗi khi tải ảnh")),
                  )
                );
              },
            ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: _openFilePicker, 
              icon: const Icon(Icons.upload_file)
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}