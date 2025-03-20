import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/models/task.dart';
import 'package:in_and_co_portal/core/services/task_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';

class AddTaskController extends GetxController {
  final ProfileController _profileController = Get.find();
  var title = "".obs;
  var content = "".obs;
  var selectedDate = Rxn<DateTime>(DateTime.now());// mặc định là hôm nay 
  var startTime = Rxn<TimeOfDay>();
  var endTime = Rxn<TimeOfDay>();
  var startTimeError = "".obs;
  var endTimeError = "".obs;
  var isLoading = false.obs;

  final TaskService _taskService = TaskService();

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
    print(selectedDate.value);
  }

  void updateStartTime(TimeOfDay newTime) {
    DateTime now = DateTime.now();
    TimeOfDay nowTime = TimeOfDay(hour: now.hour, minute: now.minute);

    // Kiểm tra nếu ngày được chọn là hôm nay và giờ mới nhỏ hơn giờ hiện tại
    if (selectedDate.value != null && 
        selectedDate.value!.year == now.year &&
        selectedDate.value!.month == now.month &&
        selectedDate.value!.day == now.day &&
        (newTime.hour < nowTime.hour || 
        (newTime.hour == nowTime.hour && newTime.minute < nowTime.minute))) {
      startTimeError.value = "Không thể đặt giờ trước thời gian hiện tại";
      return;
    }
    if (endTime.value != null &&
        (newTime.hour > endTime.value!.hour ||
            (newTime.hour == endTime.value!.hour &&
                newTime.minute >= endTime.value!.minute))) {
      startTimeError.value =
          "Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc";
      return;
    }
    startTime.value = newTime;
    startTimeError.value = "";
  }

  void updateEndTime(TimeOfDay newTime) {
    DateTime now = DateTime.now();
    TimeOfDay nowTime = TimeOfDay(hour: now.hour, minute: now.minute);

    // Kiểm tra nếu ngày được chọn là hôm nay và giờ mới nhỏ hơn giờ hiện tại
    if (selectedDate.value != null && 
        selectedDate.value!.year == now.year &&
        selectedDate.value!.month == now.month &&
        selectedDate.value!.day == now.day &&
        (newTime.hour < nowTime.hour || 
        (newTime.hour == nowTime.hour && newTime.minute < nowTime.minute))) {
      startTimeError.value = "Không thể đặt giờ trước thời gian hiện tại";
      return;
    }
    if (startTime.value != null &&
        (newTime.hour < startTime.value!.hour ||
            (newTime.hour == startTime.value!.hour &&
                newTime.minute <= startTime.value!.minute))) {
      endTimeError.value = "Thời gian kết thúc phải lớn hơn thời gian bắt đầu";
      return;
    }
    endTime.value = newTime;
    endTimeError.value = "";
  }

  void resetForm() {
    title.value = "";
    content.value = "";
    selectedDate.value = DateTime.now();
    startTime.value = null;
    endTime.value = null;
  }

  Future<void> addTask(BuildContext context) async {
    if (title.value.isEmpty ||
        content.value.isEmpty ||
        startTime.value == null ||
        endTime.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vui lòng nhập đủ thông tin',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    isLoading.value = true;


    Task newTask = Task(
      id: "",
      title: title.value,
      content: content.value,
      employeeId: _profileController.userData["employee_id"],
      startTime: startTime.value!,
      endTime: endTime.value!,
      status: "pending",
    );

    await _taskService.addTask(newTask, selectedDate.value!);

    isLoading.value = false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thêm lịch thành công'.tr,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
    resetForm();
    context.pop();
  }
}
