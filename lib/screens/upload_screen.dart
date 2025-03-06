import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/services/cloudinary_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedFile = GoRouterState.of(context).extra as FilePickerResult?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              initialValue: selectedFile?.files.first.name ?? '',
              decoration: InputDecoration(label: Text("Name")),
            ),
            TextFormField(
              readOnly: true,
              initialValue: selectedFile?.files.first.extension ?? '',
              decoration: InputDecoration(label: Text("Extension")),
            ),
            TextFormField(
              readOnly: true,
              initialValue: "${selectedFile?.files.first.size ?? 0} bytes",
              decoration: InputDecoration(label: Text("Size")),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 25),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async{
                      final result = await uploadToCloudinary(selectedFile);
                      if(result){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Upload successfully!'))
                        );
                        context.pop();
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Upload failed!'))
                        );
                      }
                    }, 
                    child: Text('Upload')
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}