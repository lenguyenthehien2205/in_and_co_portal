import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';

class DownloadImageController extends GetxController{
  Future<void> downloadImage(BuildContext context, String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      if(response.statusCode == 200){
        Uint8List bytes = response.bodyBytes; // convert sang bytes
        try {
          await FlutterImageGallerySaver.saveImage(bytes); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Lưu ảnh thành công!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Lưu ảnh thất bại: $e',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tải ảnh thất bại',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }
}