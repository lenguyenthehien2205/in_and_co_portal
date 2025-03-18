import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String content;
  final String employeeId;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String status;

  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.employeeId,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  // Convert từ Firestore document sang Task Model
  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return Task(
      id: doc.id,
      title: data['title'] ?? '', 
      content: data['content'] ?? '',
      employeeId: data['employee_id'] ?? '',
      startTime: _timestampToTimeOfDay(data['start_time']),
      endTime: _timestampToTimeOfDay(data['end_time']),
      status: data['status'] ?? '',
    );
  }

  // Convert từ Task Model sang Map để lưu vào Firestore
  Map<String, dynamic> toMap(DateTime selectedDate) {
    return {
      'title': title,
      'content': content,
      'employee_id': employeeId,
      'start_time': _timeOfDayToTimestamp(startTime, selectedDate),
      'end_time': _timeOfDayToTimestamp(endTime, selectedDate),
      'status': status,
    };
  }

  // ✅ Chuyển Timestamp Firestore -> TimeOfDay
  static TimeOfDay _timestampToTimeOfDay(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    }
    return TimeOfDay(hour: 0, minute: 0); // Default nếu lỗi
  }

  // ✅ Chuyển TimeOfDay -> Timestamp Firestore
  static Timestamp _timeOfDayToTimestamp(TimeOfDay time, DateTime selectedDate) {
    DateTime dateTime = DateTime(
      selectedDate.year, selectedDate.month, selectedDate.day, // ✅ Lấy ngày đã chọn
      time.hour, time.minute,
    );
    return Timestamp.fromDate(dateTime);
  }
}