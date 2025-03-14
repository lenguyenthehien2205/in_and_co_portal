import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TranslationController extends GetxController {
  var translatedText = ''.obs;
  var isTranslated = false.obs;

  Future<void> translateText(String text, String targetLang) async {
    if (text.isEmpty) return;

    final url = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$targetLang&dt=t&q=${Uri.encodeComponent(text)}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        translatedText.value = jsonResponse[0].map((item) => item[0]).join('');
        isTranslated.value = true;
      } else {
        translatedText.value = 'Lỗi dịch thuật!';
      }
    } catch (e) {
      translatedText.value = 'Lỗi kết nối!';
    } 
  }
  void resetTranslation() {
    translatedText.value = "";
    isTranslated.value = false;
  }
}
