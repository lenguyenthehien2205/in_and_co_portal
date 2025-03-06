import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:in_and_co_portal/core/services/db_service.dart';

Future<bool> uploadToCloudinary(FilePickerResult? filePickerResult) async {
  if (filePickerResult == null) return false;

  File file = File(filePickerResult.files.single.path!);
  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';

  // tạo multipart request
  var uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
  var request = http.MultipartRequest("POST", uri);

  // đọc file thành bytes và thêm vào request
  var fileBytes = await file.readAsBytes();
  var multipartFile = http.MultipartFile.fromBytes(
    'file', fileBytes, 
    filename: file.path.split('/').last
  );
  // thêm file vào request
  request.files.add(multipartFile);
  request.fields['upload_preset'] = 'preset-for-file-upload';
  request.fields['resource_type'] = 'raw';

  // send request
  var response = await request.send();

  // Get the response as text
  var responseBody = await response.stream.bytesToString();

  // Print the response
  print(responseBody);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(responseBody);
    Map<String, String> requiredData = {
      "name": jsonResponse['display_name'],
      "id": jsonResponse['public_id'],
      "extension": jsonResponse['resource_type'],
      "size": jsonResponse['bytes'].toString(),
      "url": jsonResponse['secure_url'],
      "created_at": jsonResponse['created_at'],
    };
    print(requiredData);
    await DbService().saveUploadedFile(requiredData['url']??'');
    return true;
  } else {
    return false;
  }
}