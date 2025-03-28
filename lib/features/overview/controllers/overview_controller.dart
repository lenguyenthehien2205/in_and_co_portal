import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/services/benefit_service.dart';
import 'package:in_and_co_portal/core/services/commission_service.dart';
import 'package:in_and_co_portal/core/services/task_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';

class OverviewController extends GetxController {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final ProfileController profileController = Get.find();
  TaskService taskService = TaskService();
  CommissionService commissionService = CommissionService();
  BenefitService benefitService = BenefitService();
  var card1Visible = false.obs;
  var card2Visible = false.obs;
  var card3Visible = false.obs;
  RxInt taskCount = 0.obs;
  RxInt commission = 0.obs;
  RxInt benefits = 0.obs;

  @override
  void onInit() async{
    super.onInit();
    startAnimation();

    ever(profileController.userData, (data) {
      if (data.isEmpty || data["employee_id"] == null) {
        taskCount.value = 0;
        commission.value = 0;
        benefits.value = 0;
      } else {
        loadData();
      }
    });
    loadData();
  }

  void startAnimation() async {
    await Future.delayed(Duration(milliseconds: 200)); 
    card1Visible.value = true;
    await Future.delayed(Duration(milliseconds: 300)); 
    card2Visible.value = true;
    await Future.delayed(Duration(milliseconds: 400)); 
    card3Visible.value = true;
  }

  void loadData() async {
    print('loadData');
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String employeeId = profileController.userData["employee_id"];
    taskCount.value = await getTaskCountByUserId(userId);
    commission.value = await getCurrentMonthCommission(userId);
    benefits.value = await getUserBenefitCount(employeeId);
  }

  Future<int> getTaskCountByUserId(String userId) {
    return taskService.getTaskCountByUserId(userId);
  }
  
  Future<int> getCurrentMonthCommission(String userId) async {
    return commissionService.getCurrentMonthCommission(userId);
  }

  Future<int> getUserBenefitCount(String userId) async {
    return benefitService.getUserBenefitCount(userId); 
  }
}