import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/quarterly_commission.dart';

class CommissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<QuarterlyCommission>> getAllCommissions(String userId) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('commissions')
        .doc('quarterly')
        .get();

    if (!docSnapshot.exists) return [];

    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    return data.entries
      .map((entry) {
        int? year = int.tryParse(entry.key);
        if (year != null && entry.value is Map<String, dynamic>) {
          return QuarterlyCommission.fromFirestore(year, entry.value as Map<String, dynamic>);
        }
        return null;
      })
      .whereType<QuarterlyCommission>()
      .toList();
  }

  


  /// 
  Future<int> getLastMonthComparison(String userId) async {
    DateTime now = DateTime.now();
    int currentMonthCommission = await getCurrentMonthCommission(userId);

    // Xác định tháng trước
    DateTime lastMonthDate = DateTime(now.year, now.month - 1);
    int lastMonthCommission = await getCurrentMonthCommission(userId, customDate: lastMonthDate);

    return currentMonthCommission - lastMonthCommission;
  }


  Future<int> getCurrentMonthCommission(String userId, {DateTime? customDate}) async {
    DateTime now = customDate ?? DateTime.now();
    String year = now.year.toString();
    int month = now.month;
    int quarter = ((month - 1) ~/ 3) + 1; // Xác định quý hiện tại
    int index = (month - 1) % 3; // Xác định vị trí trong mảng

    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('commissions')
        .doc('quarterly')
        .get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.containsKey(year) && data[year] is Map<String, dynamic>) {
        var quarterData = data[year][quarter.toString()];
        if (quarterData is List && index < quarterData.length) {
          return quarterData[index] as int;
        }
      }
    }
    return 0;
  }
  Future<int> getCurrentYearCommission(String userId) async {
    DateTime now = DateTime.now();
    String year = now.year.toString();

    DocumentSnapshot doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('commissions')
        .doc('quarterly')
        .get();
    if (!doc.exists) {
      return 0;
    }
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    if (data.containsKey(year) && data[year] is Map<String, dynamic>) {
      var quarters = data[year] as Map<String, dynamic>;
      int total = 0;

      for (var key in quarters.keys) {
        var quarterData = quarters[key];

        if (quarterData is List) {
          total += (quarterData.reduce((a, b) => a + b) as int);
        } 
      }
      return total;
    } 
    return 0;
  }

}