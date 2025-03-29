import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class FirebaseApi {
  Future<String> getAccessToken() async {
    // Đọc file Service Account JSON
    final jsonString = await rootBundle.loadString('assets/service-account.json');
    final Map<String, dynamic> serviceAccount = json.decode(jsonString);

    final String clientEmail = serviceAccount["client_email"];
    final String privateKey = serviceAccount["private_key"];
    final String tokenUri = "https://oauth2.googleapis.com/token";

    // Tạo JWT
    final jwt = JWT(
      {
        "iss": clientEmail,
        "scope": "https://www.googleapis.com/auth/firebase.messaging",
        "aud": tokenUri,
        "exp": DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600, // Token 1 giờ
        "iat": DateTime.now().millisecondsSinceEpoch ~/ 1000,
      },
    );

    // Ký JWT bằng RSA SHA256
    final signedJWT = jwt.sign(RSAPrivateKey(privateKey), algorithm: JWTAlgorithm.RS256);

    // Gửi yêu cầu lấy Access Token
    final response = await http.post(
      Uri.parse(tokenUri),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
        "assertion": signedJWT,
      },
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData.containsKey("access_token")) {
      return responseData["access_token"];
    } else {
      throw Exception("Failed to get access token: ${response.body}");
    }
  }
  Future<void> sendNotificationToAuthor(String authorUid, String title, String body) async {
    String accessToken = await getAccessToken();
    String projectId = 'in-and-co-portal';

    await http.post(
      Uri.parse("https://fcm.googleapis.com/v1/projects/${projectId}/messages:send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "message": {
          "topic": authorUid, // Gửi đến tất cả subscriber của UID này
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
          }
        }
      }),
    );
  }
  Future<void> sendNotificationToAllUser(String title, String body) async {
    String accessToken = await getAccessToken();
    String projectId = 'in-and-co-portal';

    await http.post(
      Uri.parse("https://fcm.googleapis.com/v1/projects/${projectId}/messages:send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "message": {
          "topic": 'all_users', // Gửi đến tất cả subscriber của topic này
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
          }
        }
      }),
    );
  }
}
