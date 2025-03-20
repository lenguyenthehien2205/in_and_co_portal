import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/overview/controllers/add_task_controller.dart';
import 'package:in_and_co_portal/features/overview/widgets/date_picker_custom.dart';
import 'package:in_and_co_portal/features/profile/widgets/text_field_custom.dart';
import 'package:in_and_co_portal/features/overview/widgets/time_picker_custom.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});
  final AddTaskController addTaskController = Get.put(AddTaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm lịch', style: AppText.headerTitle(context)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            addTaskController.resetForm();
            context.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFieldCustom(
                label: 'Tiêu đề',
                hintText: 'Nhập tiêu đề',
                onChanged: (value) {
                  addTaskController.title.value = value;
                },
              ),
              TextFieldCustom(
                label: 'Nội dung',
                hintText: 'Nhập nội dung',
                onChanged: (value) {
                  addTaskController.content.value = value;
                },
              ),
              Obx(
                () => DatePickerCustom(
                  label: "Chọn ngày",
                  dateText:
                      "${addTaskController.selectedDate.value?.day ?? ''}/${addTaskController.selectedDate.value?.month ?? ''}/${addTaskController.selectedDate.value?.year ?? ''}",
                  onTap: () async {
                    DateTime today = DateTime.now();
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: addTaskController.selectedDate.value,
                      firstDate: today,
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      addTaskController.updateSelectedDate(pickedDate);
                    }
                  },
                ),
              ),
              Row(
                children: [
                  Obx(
                    () => TimePickerCustom(
                      label: "Bắt đầu",
                      timeText:
                          addTaskController.startTime.value != null
                              ? "${addTaskController.startTime.value!.hour.toString().padLeft(2, '0')}:${addTaskController.startTime.value!.minute.toString().padLeft(2, '0')}"
                              : "Chọn giờ",
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          addTaskController.updateStartTime(pickedTime);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Obx(
                    () => TimePickerCustom(
                      label: "Kết thúc",
                      timeText:
                          addTaskController.endTime.value != null
                              ? "${addTaskController.endTime.value!.hour.toString().padLeft(2, '0')}:${addTaskController.endTime.value!.minute.toString().padLeft(2, '0')}"
                              : "Chọn giờ",
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          addTaskController.updateEndTime(pickedTime);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Obx(
                () => Text(
                  addTaskController.startTimeError.value,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
              Obx(
                () => Text(
                  addTaskController.endTimeError.value,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
              ElevatedButton(onPressed: () {
                addTaskController.addTask(context);
              }, child: Text('Thêm lịch')),
            ],
          ),
        ),
      ),
    );
  }
}
