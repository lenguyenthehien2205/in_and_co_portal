import 'package:get/get.dart';
import 'package:diacritic/diacritic.dart';

class BenefitController extends GetxController{
  var benefits = <Map<String, dynamic>>[].obs;
  var benefitHistory = <Map<String, dynamic>>[].obs; 
  var filteredBenefits = <Map<String, dynamic>>[].obs;
  var filteredBenefitHistory = <Map<String, dynamic>>[].obs;
  var searchBenefitsQuery = ''.obs;
  var searchBenefitHistoryQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBenefits();
    loadBenefitHistory();
    filteredBenefits.assignAll(benefits);
    filteredBenefitHistory.assignAll(benefitHistory);
  }

  void loadBenefits() {
    benefits.assignAll([
      {
        "id": 1,
        "employee_id": 1001,
        "name": "Bảo hiểm sức khỏe",
        "type": "Bảo hiểm",
        "icon": "assets/images/healthcare.png",
        "start_date": "10/03/2025",
        "end_date": "10/12/2025",
        "status": "Được hưởng",
        "description": "Gói bảo hiểm toàn diện cho nhân viên và gia đình."
      },
      {
        "id": 2,
        "employee_id": 1001,
        "name": "Trợ cấp đi lại",
        "type": "Trợ cấp",
        "icon": "assets/images/motorcycle.png",
        "start_date": "10/03/2025",
        "end_date": "10/09/2025",
        "status": "Được hưởng",
        "description": "Nhận trợ cấp 500.000 VNĐ/tháng khi đủ điều kiện."
      },
      {
        "id": 3,
        "employee_id": 1001,
        "name": "Bảo hiểm thất nghiệp",
        "type": "Bảo hiểm",
        "icon": "assets/images/unemployment.png",
        "start_date": "10/03/2025",
        "end_date": "10/03/2026",
        "status": "Được hưởng",
        "description": "Voucher 500.000 VNĐ mua sắm tại các cửa hàng đối tác."
      },
      {
        "id": 4,
        "employee_id": 1001,
        "name": "Thưởng Tết",
        "type": "Thưởng",
        "icon": "assets/images/bonus.png",
        "start_date": "01/01/2025",
        "end_date": "05/01/2025",
        "status": "Chưa áp dụng",
        "description": "Thưởng Tết 10.000.000 VNĐ"
      },
      {
        "id": 5,
        "employee_id": 1001,
        "name": "Hỗ trợ đào tạo",
        "type": "Đào tạo",
        "icon": "assets/images/presentation.png",
        "start_date": "15/06/2025",
        "end_date": "15/12/2025",
        "status": "Được hưởng",
        "description": "Được hỗ trợ 50% chi phí khóa học kỹ năng mềm."
      },
      {
        "id": 1,
        "employee_id": 1001,
        "name": "Bảo hiểm sức khỏe",
        "type": "Bảo hiểm",
        "icon": "assets/images/healthcare.png",
        "start_date": "10/03/2025",
        "end_date": "10/12/2025",
        "status": "Được hưởng",
        "description": "Gói bảo hiểm toàn diện cho nhân viên và gia đình."
      },
      {
        "id": 2,
        "employee_id": 1001,
        "name": "Trợ cấp đi lại",
        "type": "Trợ cấp",
        "icon": "assets/images/motorcycle.png",
        "start_date": "10/03/2025",
        "end_date": "10/09/2025",
        "status": "Được hưởng",
        "description": "Nhận trợ cấp 500.000 VNĐ/tháng khi đủ điều kiện."
      },
      {
        "id": 3,
        "employee_id": 1001,
        "name": "Bảo hiểm thất nghiệp",
        "type": "Bảo hiểm",
        "icon": "assets/images/unemployment.png",
        "start_date": "10/03/2025",
        "end_date": "10/03/2026",
        "status": "Được hưởng",
        "description": "Voucher 500.000 VNĐ mua sắm tại các cửa hàng đối tác."
      },
      {
        "id": 4,
        "employee_id": 1001,
        "name": "Thưởng Tết",
        "type": "Thưởng",
        "icon": "assets/images/bonus.png",
        "start_date": "01/01/2025",
        "end_date": "05/01/2025",
        "status": "Chưa áp dụng",
        "description": "Thưởng Tết 10.000.000 VNĐ"
      },
      {
        "id": 5,
        "employee_id": 1001,
        "name": "Hỗ trợ đào tạo",
        "type": "Đào tạo",
        "icon": "assets/images/presentation.png",
        "start_date": "15/06/2025",
        "end_date": "15/12/2025",
        "status": "Được hưởng",
        "description": "Được hỗ trợ 50% chi phí khóa học kỹ năng mềm."
      },
      {
        "id": 1,
        "employee_id": 1001,
        "name": "Bảo hiểm sức khỏe",
        "type": "Bảo hiểm",
        "icon": "assets/images/healthcare.png",
        "start_date": "10/03/2025",
        "end_date": "10/12/2025",
        "status": "Được hưởng",
        "description": "Gói bảo hiểm toàn diện cho nhân viên và gia đình."
      },
      {
        "id": 2,
        "employee_id": 1001,
        "name": "Trợ cấp đi lại",
        "type": "Trợ cấp",
        "icon": "assets/images/motorcycle.png",
        "start_date": "10/03/2025",
        "end_date": "10/09/2025",
        "status": "Được hưởng",
        "description": "Nhận trợ cấp 500.000 VNĐ/tháng khi đủ điều kiện."
      },
      {
        "id": 3,
        "employee_id": 1001,
        "name": "Bảo hiểm thất nghiệp",
        "type": "Bảo hiểm",
        "icon": "assets/images/unemployment.png",
        "start_date": "10/03/2025",
        "end_date": "10/03/2026",
        "status": "Được hưởng",
        "description": "Voucher 500.000 VNĐ mua sắm tại các cửa hàng đối tác."
      },
      {
        "id": 4,
        "employee_id": 1001,
        "name": "Thưởng Tết",
        "type": "Thưởng",
        "icon": "assets/images/bonus.png",
        "start_date": "01/01/2025",
        "end_date": "05/01/2025",
        "status": "Chưa áp dụng",
        "description": "Thưởng Tết 10.000.000 VNĐ"
      },
      {
        "id": 5,
        "employee_id": 1001,
        "name": "Hỗ trợ đào tạo",
        "type": "Đào tạo",
        "icon": "assets/images/presentation.png",
        "start_date": "15/06/2025",
        "end_date": "15/12/2025",
        "status": "Được hưởng",
        "description": "Được hỗ trợ 50% chi phí khóa học kỹ năng mềm."
      },
    ]);
  }
  void filterBenefits(String query) {
    searchBenefitsQuery.value = query;
    final normalizedQuery = removeDiacritics(query.toLowerCase());

    filteredBenefits.assignAll(
      benefits.where((benefit) {
        final name = benefit["name"].toString().toLowerCase();
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
        final name = benefit["name"].toString().toLowerCase();
        final nameWithoutDiacritics = removeDiacritics(name);

        final matchesQuery = nameWithoutDiacritics.contains(normalizedQuery);

        return matchesQuery;
      }).toList(),
    );
  }

  void loadBenefitHistory() {
    benefitHistory.assignAll([
      {
        "id": 1,
        "employee_id": 1001,
        "name": "Quà tặng sinh nhật",
        "type": "Quà tặng",
        "icon": "assets/images/bonus.png",
        "received_date": "10/03/2024",
        "description": "Voucher 500.000 VNĐ mua sắm tại các cửa hàng đối tác."
      },
      {
        "id": 2,
        "employee_id": 1001,
        "name": "Thưởng hiệu suất quý 1",
        "type": "Thưởng",
        "icon": "assets/images/bonus.png",
        "received_date": "01/04/2024",
        "description": "Thưởng 3.000.000 VNĐ do đạt KPI xuất sắc."
      },
      {
        "id": 3,
        "employee_id": 1001,
        "name": "Thưởng hiệu suất quý 2",
        "type": "Thưởng",
        "icon": "assets/images/bonus.png",
        "received_date": "01/07/2024",
        "description": "Thưởng 2.500.000 VNĐ do đạt chỉ tiêu công việc."
      },
      {
        "id": 4,
        "employee_id": 1001,
        "name": "Thưởng hiệu suất quý 3",
        "type": "Thưởng",
        "icon": "assets/images/bonus.png",
        "received_date": "01/10/2024",
        "description": "Thưởng 3.000.000 VNĐ do đạt KPI xuất sắc."
      },
      {
        "id": 5,
        "employee_id": 1001,
        "name": "Thưởng hiệu suất quý 4",
        "type": "Thưởng",
        "icon": "assets/images/bonus.png",
        "received_date": "01/01/2025",
        "description": "Thưởng 2.500.000 VNĐ do đạt chỉ tiêu công việc."
      },
    ]);
  }
}