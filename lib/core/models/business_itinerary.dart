import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessItinerary {
  String title;
  String purpose;
  String vehicle;
  Timestamp startDate;
  Timestamp endDate;
  String status;

  BusinessItinerary({
    required this.title,
    required this.purpose,
    required this.vehicle,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory BusinessItinerary.fromFirestore(
      DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BusinessItinerary(
      title: data['title'] ?? '',
      purpose: data['purpose'] ?? '',
      vehicle: data['vehicle'] ?? '',
      startDate: data['startDate'] ?? Timestamp.now(),
      endDate: data['endDate'] ?? Timestamp.now(),
      status: data['status'] ?? 'Chờ xác nhận',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'purpose': purpose,
      'vehicle': vehicle,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
    };
  }
}