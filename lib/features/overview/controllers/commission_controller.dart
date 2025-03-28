import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/quarterly_commission.dart';
import 'package:in_and_co_portal/core/services/commission_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';

class CommissionController extends GetxController {
  final ProfileController profileController = Get.find();
  var selectedYear = 2023.obs;
  var selectedQuarter = 1.obs;

  var fromYear = 0.obs;
  var toYear = 0.obs;
  final RxList<MapEntry<int, int>> currentYearlyData = <MapEntry<int, int>>[].obs;
  var currentMonthCommission = 0.obs;
  var currentYearCommission = 0.obs;
  var lastMonthComparison = 0.obs;
  var cardLoading = true.obs;
  final CommissionService commissionService = CommissionService();
  final RxMap<int, Map<int, List<int>>> commissionsQuarterData = <int, Map<int, List<int>>>{}.obs;
  final RxMap<int, int> commissionsYearlyData = <int, int>{}.obs;

  final List<int> availableYears = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(profileController.userData, (data) {
      if (data.isEmpty || data["employee_id"] == null) {
        clearCommissions();
      } else {
        fetchCommissionsData();
      }
    });
    fetchCommissionsData();
  }

  Future<void> fetchCurrentCommissions() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    cardLoading.value = true;
    currentMonthCommission.value = await commissionService.getCurrentMonthCommission(userId);
    currentYearCommission.value = await commissionService.getCurrentYearCommission(userId);
    lastMonthComparison.value = await commissionService.getLastMonthComparison(userId);
    cardLoading.value = false;
  }

  void clearCommissions() {
    commissionsQuarterData.clear();
    commissionsYearlyData.clear();
    availableYears.clear();
    fromYear.value = 0;
    toYear.value = 0;
    currentYearlyData.clear();
  }

  /// Lấy dữ liệu từ Firebase
  Future<void> fetchCommissionsData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<QuarterlyCommission> commissions = await commissionService.getAllCommissions(userId);
    
    // Chuyển đổi dữ liệu Firebase vào commissionsQuarterData
    commissionsQuarterData.clear();
    for (var commission in commissions) {
      commissionsQuarterData[commission.year] = commission.quarters;
      
      // Cập nhật tổng hoa hồng từng năm
      int totalYearly = commission.quarters.values.expand((e) => e).reduce((a, b) => a + b);
      commissionsYearlyData[commission.year] = totalYearly;
    }

    fetchCurrentCommissions();
    updateAvailableYears();
    updateCurrentYearlyData();
  }
  

  void updateAvailableYears() {
    availableYears.assignAll(commissionsYearlyData.keys.toList()..sort());
    
    if (availableYears.isNotEmpty) {
      fromYear.value = availableYears.first; 
      toYear.value = availableYears.last;  
    }

    updateCurrentYearlyData();
  }

  void updateFromYear(int year) { 
    fromYear.value = year;
    updateCurrentYearlyData();
  }

  void updateToYear(int year) {
    toYear.value = year;
    updateCurrentYearlyData();
  }
  void updateCurrentYearlyData() {
    currentYearlyData.assignAll(
      commissionsYearlyData.entries
          .where((entry) => entry.key >= fromYear.value && entry.key <= toYear.value)
          .toList(),
    );
  }

  List<int> get currentQuarterlyData {
    return commissionsQuarterData[selectedYear.value]?[selectedQuarter.value] ?? [];
  }

  List<String> get currentMonths {
    switch (selectedQuarter.value) {
      case 1:
        return ['commission_january'.tr, 'commission_february'.tr, 'commission_march'.tr];
      case 2:
        return ['commission_april'.tr, 'commission_may'.tr, 'commission_june'.tr];
      case 3:
        return ['commission_july'.tr, 'commission_august'.tr, 'commission_september'.tr];
      case 4:
        return ['commission_october'.tr, 'commission_november'.tr, 'commission_december'.tr];
      default:
        return [];
    }
  }
}
