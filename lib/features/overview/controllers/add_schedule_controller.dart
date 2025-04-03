import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/business_itinerary.dart';
import 'package:in_and_co_portal/core/services/business_itinerary_service.dart';
import 'package:in_and_co_portal/main.dart';

class AddScheduleController extends GetxController {
  final BusinessItineraryService _service = BusinessItineraryService();
  var title = ''.obs;
  var purpose = 'Mục đích'.obs;
  var vehicle = 'Phương tiện'.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  void setStartDate(DateTime date) {
    startDate.value = date;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  void setPurpose(String value) {
    purpose.value = value;
  }

  void setVehicle(String value) {
    vehicle.value = value;
  }

  bool validateAndSubmit() {
    if (title.value == '') {
      globalScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text("Bạn chưa nhập tiêu đề", style: TextStyle(color: Colors.white)), backgroundColor: Colors.grey)
          );
      return false;
    }
    if (purpose.value == 'Mục đích') {
      globalScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text("Bạn chưa chọn mục đích công tác", style: TextStyle(color: Colors.white)), backgroundColor: Colors.grey)
          );
      return false;
    }
    if (vehicle.value == 'Phương tiện') {
      globalScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text("Bạn chưa chọn phương tiện công tác", style: TextStyle(color: Colors.white)), backgroundColor: Colors.grey)
          );
      return false;
    }
    if (startDate.value == null || endDate.value == null) {
      globalScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text("Bạn phải chọn ngày công tác", style: TextStyle(color: Colors.white)), backgroundColor: Colors.grey)
          );
      return false;
    }
    _service.addSchedule(BusinessItinerary(
      title: title.value, 
      purpose: purpose.value, 
      vehicle: vehicle.value, 
      startDate: Timestamp.fromDate(startDate.value!), 
      endDate: Timestamp.fromDate(endDate.value!), 
      status: "Chờ duyệt"
    ), FirebaseAuth.instance.currentUser!.uid);

    globalScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text("Lên lịch thành công", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green)
          );
    return true;
  }

  void resetForm() {
    title.value = '';
    purpose.value = 'Mục đích';
    vehicle.value = 'Phương tiện';
    startDate.value = null;
    endDate.value = null;
  }
}