import 'package:get/get.dart';

class CommissionController extends GetxController {
  var selectedYear = 2024.obs;
  var selectedQuarter = 1.obs;

  var fromYear = 0.obs;
  var toYear = 0.obs;
  final RxList<MapEntry<int, int>> currentYearlyData = <MapEntry<int, int>>[].obs;


  final Map<int, Map<int, List<int>>> commissionsQuarterData = {
    2024: {
      1: [12, 15, 18], 
      2: [17, 16, 20], 
      3: [21, 19, 23], 
      4: [25, 22, 27], 
    },
    2025: {
      1: [13, 14, 19],
      2: [18, 17, 21],
      3: [22, 20, 24],
      4: [26, 23, 28],
    }
  };

  final Map<int, int> commissionsYearlyData = {
    2020: 125,
    2021: 134,
    2022: 110,
    2023: 145,
    2024: 125,
    2025: 160,
  };

  final List<int> availableYears = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
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