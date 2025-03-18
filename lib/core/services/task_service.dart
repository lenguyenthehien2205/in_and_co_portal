import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_and_co_portal/core/models/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Task>> getTasksByEmployee(String employeeId, DateTime selectedDate) {
    DateTime startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
    DateTime endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    return _firestore
        .collection('tasks')
        .where('employee_id', isEqualTo: employeeId)
        .where('start_time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('start_time', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('start_time')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList());
  }

  Future<void> addTask(Task task, DateTime selectedDate) async {
    await _firestore.collection('tasks').add(task.toMap(selectedDate));
  }
}