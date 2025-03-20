import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String employeeId;
  final String fullname;
  final String role;
  final String avatar;

  User({
    required this.id,
    required this.employeeId,
    required this.fullname,
    required this.role,
    required this.avatar,
  });

  // Convert từ Firestore document sang Task Model
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return User(
      id: doc.id,
      employeeId: data['employee_id'] ?? '',
      fullname: data['fullname'] ?? '',
      role: data['role'] ?? '',
      avatar: data['avatar'] ?? '',
    );
  }

  // Convert từ Task Model sang Map để lưu vào Firestore
  Map<String, dynamic> toMap(DateTime selectedDate) {
    return {
      'employee_id': employeeId,
      'fullname': fullname,
      'role': role,
      'avatar': avatar,
    };
  }
}