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

  Stream<List<BenefitHistory>> fetchBenefitHistory(String employeeId) {
    print(employeeId);  
    return _firestore
        .collection("benefit-history")
        .where('employee_id', isEqualTo: employeeId)
        // .orderBy('received_date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => BenefitHistory.fromFirestore(doc)).toList());
  }
}