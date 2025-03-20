import 'package:cloud_firestore/cloud_firestore.dart';

class BenefitHistory {
  final String id;
  final String title;
  final Timestamp receivedDate;
  final String description;
  final String icon;
  final String employeeId;

  BenefitHistory({
    required this.id,
    required this.title,
    required this.receivedDate,
    required this.description,
    required this.icon,
    required this.employeeId,
  });

  // Convert từ Firestore document sang Task Model
  factory BenefitHistory.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return BenefitHistory(
      id: doc.id,
      title: data['title'] ?? '',
      receivedDate: data['received_date'] ?? Timestamp.now(),
      description: data['description'] ?? '', 
      icon: data['icon'] ?? '',
      employeeId: data['employee_id'] ?? '',
    );
  }

  // Convert từ Task Model sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'received_date': receivedDate,
      'description': description,
      'icon': icon,
      'employee_id': employeeId,
    };
  }
}