import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Task>> getTasksByEmployee(String employeeId, DateTime selectedDate) {
    DateTime startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
    DateTime endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    return _firestore
        .collection('users') // Truy cập user
        .doc(employeeId) // Chọn user cụ thể
        .collection('tasks') // Truy cập subcollection "tasks"
        .where('start_time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('start_time', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('start_time') 
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList());
  }

  Future<void> addTask(String userId, Task task, DateTime selectedDate) async {
    await _firestore
        .collection('users') // Chọn collection "users"
        .doc(userId) // Chọn document của user
        .collection('tasks') // Chọn subcollection "tasks"
        .add(task.toMap(selectedDate)); // Thêm task vào subcollection
  }

  ///
  Future<int> getTaskCountByUserId(String userId) async {
    DateTime now = DateTime.now();
    DateTime startOfWeek = DateTime(now.year, now.month, now.day - now.weekday + 1); // Thứ Hai
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6)); // Chủ Nhật

    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('start_time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
        .where('start_time', isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek))
        .get();

    return querySnapshot.size;
  }
}