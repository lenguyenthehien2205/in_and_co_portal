import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/business_itinerary.dart';

class BusinessItineraryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BusinessItinerary>> getSchedulesByUser(String userId) async {
    List<BusinessItinerary> schedules = [];
    try {
      QuerySnapshot itinerarySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('business_itineraries')
          .get();
      schedules = itinerarySnapshot.docs.map((doc) => BusinessItinerary.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error fetching schedules for user $userId: $e");
    }
    return schedules;
  }

  Future<void> addSchedule(BusinessItinerary itinerary, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('business_itineraries')
          .add(itinerary.toMap());
    } catch (e) {
      print("Lỗi khi lên lịch: $e");
      rethrow;
    }
  }
  Future<int> countThisMonthSchedules(String userId) async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0).add(const Duration(hours: 23, minutes: 59, seconds: 59));

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('business_itineraries')
        .where('start_date', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
        .where('start_date', isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
        .get();
    return snapshot.size;
  }
}