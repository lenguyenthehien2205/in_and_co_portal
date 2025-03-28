import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:diacritic/diacritic.dart';
import 'package:in_and_co_portal/core/models/benefit-history.dart';
import 'package:in_and_co_portal/core/models/benefit.dart';
import 'package:in_and_co_portal/core/services/benefit_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';

class BenefitController extends GetxController{
  final BenefitService _benefitService = BenefitService();
  final ProfileController _profileController = Get.find();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  var isLoading = false.obs;
  var benefits = <Benefit>[].obs;
  var benefitHistory = <BenefitHistory>[].obs; 
  var filteredBenefits = <Benefit>[].obs;
  var filteredBenefitHistory = <BenefitHistory>[].obs;
  var searchBenefitsQuery = ''.obs;
  var searchBenefitHistoryQuery = ''.obs;


  @override
  void onInit() {
    super.onInit();
    loadBenefits();
    loadBenefitHistory();
  }
  void loadBenefits() {
    isLoading.value = true; // Bắt đầu tải
    _benefitService.fetchBenefits().listen((newBenefits) {
      benefits.value = newBenefits;
      filteredBenefits.assignAll(benefits);
      isLoading.value = false; // Chỉ tắt loading khi có dữ liệu
    }, onError: (error) {
      isLoading.value = false; // Tắt loading nếu có lỗi
    });
  }

  void loadBenefitHistory() {
    isLoading.value = true;
    _benefitService.fetchBenefitHistory(userId).listen((newBenefits) {
      benefitHistory.value = newBenefits;
      filteredBenefitHistory.assignAll(benefitHistory);
      print(benefitHistory);
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
    });
  }

  void filterBenefits(String query) {
    searchBenefitsQuery.value = query;
    final normalizedQuery = removeDiacritics(query.toLowerCase());

    filteredBenefits.assignAll(
      benefits.where((benefit) {
        final name = benefit.title.toString().toLowerCase();
        final nameWithoutDiacritics = removeDiacritics(name);

        final matchesQuery = nameWithoutDiacritics.contains(normalizedQuery);

        return matchesQuery;
      }).toList(),
    );
  }
  void filterBenefitHistory(String query) {
    searchBenefitHistoryQuery.value = query;
    final normalizedQuery = removeDiacritics(query.toLowerCase());

    filteredBenefitHistory.assignAll(
      benefitHistory.where((benefit) {
        final name = benefit.title.toString().toLowerCase();
        final nameWithoutDiacritics = removeDiacritics(name);

        final matchesQuery = nameWithoutDiacritics.contains(normalizedQuery);

        return matchesQuery;
      }).toList(),
    );
  }
  
}