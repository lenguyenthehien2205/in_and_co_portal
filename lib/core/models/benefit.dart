import 'package:cloud_firestore/cloud_firestore.dart';

class Benefit {
  final String id;
  final List<String> employeeIds;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String icon;

  Benefit({
    required this.id,
    required this.employeeIds,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.icon,
  });

  // Convert từ Firestore document sang Task Model
  factory Benefit.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Benefit(
      id: doc.id,
      employeeIds: List<String>.from(data['employee_ids'] ?? []),
      title: data['title'] ?? '',
      startDate: (data['start_date'] as Timestamp).toDate(),
      endDate: (data['end_date'] as Timestamp).toDate(),
      description: data['description'] ?? '', 
      icon: data['icon'] ?? '',
    );
  }

  // Convert từ Task Model sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'employee_ids': employeeIds,
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'icon': icon,
    };
  }
}