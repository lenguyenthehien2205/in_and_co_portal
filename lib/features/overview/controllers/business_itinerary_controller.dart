import 'package:diacritic/diacritic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/business_itinerary.dart';
import 'package:in_and_co_portal/core/services/business_itinerary_service.dart';

class BusinessItineraryController extends GetxController {
  final BusinessItineraryService _service = BusinessItineraryService();

  var selectedVehicle = 'bussiness_itinerary_vehicle'.tr.obs;
  var searchQuery = ''.obs;
  var itineraryData = <BusinessItinerary>[].obs;
  var filteredItineraryData = <BusinessItinerary>[].obs;
  var isLoading = false.obs; 
  var userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchItineraryData();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user?.uid != userId) {
        userId = user!.uid;
        fetchItineraryData();
      }
    });
  }

  Future<void> fetchItineraryData() async {
    isLoading.value = true;
    try {
      List<BusinessItinerary> data = await _service.getSchedulesByUser(FirebaseAuth.instance.currentUser!.uid);
      itineraryData.value = data.toList().obs;
      filteredItineraryData.value = data.toList().obs;
      isLoading.value = false;
    } catch (e) {
      print("Error fetching itineraries: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterByVehicle(String vehicle) {
    selectedVehicle.value = vehicle;
    _applyFilters();
  }

  void filterBySearch(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var filteredData = List<BusinessItinerary>.from(itineraryData);

    if (selectedVehicle.value != 'bussiness_itinerary_vehicle'.tr) {
      filteredData = filteredData
          .where((item) => item.vehicle == selectedVehicle.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      filteredData = filteredData
          .where((item) =>
              removeDiacritics(item.title)
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }
    filteredItineraryData.assignAll(filteredData);
  }
}
// final List<Map<String, dynamic>> _allItineraryData = [
//     {
//       'title': 'Chi nhánh Tây Ninh',
//       'purpose': 'Công tác nội bộ',
//       'vehicle': 'Xe cá nhân',
//       'date': '11/11/2025',
//       'status': 'Đã xác nhận',
//       'icon': Icons.directions_bike,
//       'color': Colors.green
//     },
//     {
//       'title': 'Gặp khách hàng NVIDIA',
//       'purpose': 'Gặp khách hàng',
//       'vehicle': 'Máy bay',
//       'date': '12/11/2025',
//       'status': 'Chờ kết quả công tác',
//       'icon': Icons.airplanemode_active,
//       'color': Colors.blue
//     },
//     {
//       'title': 'Tập đoàn VinGroup',
//       'purpose': 'Công ty khác',
//       'vehicle': 'Xe công ty',
//       'date': '13/11/2025',
//       'status': 'Đã xác nhận',
//       'icon': Icons.car_rental,
//       'color': Colors.orange
//     },
//   ];