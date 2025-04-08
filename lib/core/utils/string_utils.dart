import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

List<String> generateKeywords(String name) {
  Set<String> keywords = {};
  
  // bỏ dấu tiếng Việt
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

String getTimeAgoByTimestamp(Timestamp timestamp) {
  DateTime createdAtDate = timestamp.toDate(); 
  DateTime now = DateTime.now();
  Duration diff = now.difference(createdAtDate);

  if (diff.inSeconds < 60) {
    return 'time_just_now'.tr;
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} ${'time_minute'.tr}';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} ${'time_hour'.tr}';
  } else if (diff.inDays < 7) {
    return '${diff.inDays} ${'time_day'.tr}';
  } else if (diff.inDays < 30) {
    return '${(diff.inDays / 7).floor()} ${'time_week'.tr}';
  } else if (diff.inDays < 365) {
    return '${(diff.inDays / 30).floor()} ${'time_month'.tr}';
  } else {
    return '${(diff.inDays / 365).floor()} ${'time_year'.tr}';
  }
}

String formatTimestampToTime(Timestamp timestamp) {
  final now = DateTime.now();
  final messageDate = DateTime(timestamp.toDate().year, timestamp.toDate().month, timestamp.toDate().day); // Cắt bỏ thời gian của timestamp để so sánh ngày

  if (now.year == messageDate.year && now.month == messageDate.month && now.day == messageDate.day) {
    return 'Hôm nay · ${DateFormat('HH:mm').format(timestamp.toDate())}';
  } else {
    return DateFormat('dd/MM/yyyy · HH:mm').format(timestamp.toDate());
  }
}

String formatTimestampToDate(Timestamp timestamp) {
  return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
}