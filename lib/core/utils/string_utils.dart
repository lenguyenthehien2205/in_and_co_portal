import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:intl/intl.dart';

List<String> generateKeywords(String name) {
  Set<String> keywords = {};
  
  // Loại bỏ dấu tiếng Việt trước khi xử lý
  String normalized = removeDiacritics(name.toLowerCase());

  List<String> words = normalized.split(" ");

  for (var word in words) {
    String prefix = "";
    for (int i = 0; i < word.length; i++) {
      prefix += word[i];
      keywords.add(prefix);
    }
  }

  return keywords.toList();
}

String formatTimestamp(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  return DateFormat('dd/MM/yyyy').format(date); 
}