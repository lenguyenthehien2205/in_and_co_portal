import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/benefit-history.dart';
import 'package:in_and_co_portal/core/models/benefit.dart';

class BenefitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var benefitData = <Benefit>[].obs;

  Stream<List<Benefit>> fetchBenefits() {
    return _firestore
        .collection("benefits")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Benefit.fromFirestore(doc)).toList());
  }

  // Stream<List<BenefitHistory>> fetchBenefitHistory(String employeeId) {
  //   print(employeeId);  
  //   return _firestore
  //       .collection("benefit-history")
  //       .where('employee_id', isEqualTo: employeeId)
  //       // .orderBy('received_date', descending: true)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => BenefitHistory.fromFirestore(doc)).toList());
  // }
  ////

  Stream<List<BenefitHistory>> fetchBenefitHistory(String userId) {
    return FirebaseFirestore.instance
        .collection('users') // Truy cập users
        .doc(userId) // Chọn user cụ thể
        .collection('benefit-history') // Truy cập subcollection benefits
        .orderBy('received_date', descending: true) // Sắp xếp theo ngày nhận
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => BenefitHistory.fromFirestore(doc)).toList());
  }

  Future<List<Map<String, dynamic>>> getBenefitHistoryWithStatus(String userId) async {
    // Lấy danh sách tất cả benefits
    QuerySnapshot benefitsSnapshot =
        await FirebaseFirestore.instance.collection('benefits').get();

    // Lấy danh sách benefits của user
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    List<String> userBenefits = [];
    if (userSnapshot.exists) {
      userBenefits = List<String>.from(userSnapshot['benefits'] ?? []);
    }

    // Gán trạng thái cho từng benefit
    return benefitsSnapshot.docs.map((doc) {
      Map<String, dynamic> benefitData = doc.data() as Map<String, dynamic>;
      String benefitId = doc.id;

      return {
        "id": benefitId,
        "name": benefitData['name'],
        "description": benefitData['description'],
        "status": userBenefits.contains(benefitId) ? "Được hưởng" : "Chưa áp dụng",
      };
    }).toList();
  }

  Future<int> getUserBenefitCount(String userId) async {
    QuerySnapshot benefitSnapshot = await FirebaseFirestore.instance
        .collection('benefits')
        .where('employee_ids', arrayContains: userId) 
        .get();

    return benefitSnapshot.size; 
  }
}