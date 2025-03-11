import 'package:get/get.dart';
class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'login_empty_email'.tr;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'login_invalid_email'.tr;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'login_empty_password'.tr;
    }
    if (value.length < 6) {
      return 'login_invalid_password'.tr;
    }
    return null;
  }
}
