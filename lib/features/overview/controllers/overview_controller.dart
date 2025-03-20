import 'package:get/get.dart';

class OverviewController extends GetxController {
  var card1Visible = false.obs;
  var card2Visible = false.obs;
  var card3Visible = false.obs;

  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  void startAnimation() async {
    await Future.delayed(Duration(milliseconds: 200)); 
    card1Visible.value = true;
    await Future.delayed(Duration(milliseconds: 300)); 
    card2Visible.value = true;
    await Future.delayed(Duration(milliseconds: 400)); 
    card3Visible.value = true;
  }
}