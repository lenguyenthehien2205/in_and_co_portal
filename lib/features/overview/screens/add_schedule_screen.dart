import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/core/controllers/language_controller.dart';
import 'package:in_and_co_portal/features/overview/controllers/add_schedule_controller.dart';
import 'package:in_and_co_portal/features/overview/controllers/business_itinerary_controller.dart';
import 'package:in_and_co_portal/features/overview/widgets/date_picker_custom.dart';
import 'package:in_and_co_portal/features/overview/widgets/dropdown_custom.dart';
import 'package:in_and_co_portal/features/profile/widgets/text_field_custom.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class AddScheduleScreen extends StatelessWidget {
  const AddScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AddScheduleController addScheduleController = Get.put(AddScheduleController());
    final BusinessItineraryController businessItineraryController = Get.find<BusinessItineraryController>();
    final LanguageController languageController = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('bussiness_itinerary_add'.tr, style: AppText.headerTitle(context)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            addScheduleController.resetForm();
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
                label: 'bussiness_itinerary_title'.tr,
                hintText: 'bussiness_itinerary_title_placeholder'.tr,
                onChanged: (value) => addScheduleController.title.value = value,
              ),
              Obx(() => DropdownCustom(
                label: 'bussiness_itinerary_purpose'.tr,
                items: ['bussiness_itinerary_purpose_placeholder'.tr, "Công tác nội bộ", "Gặp khách hàng", "Công ty khác"],
                value: addScheduleController.purpose.value,
                onChanged: (value) {
                  addScheduleController.setPurpose(value!);
                },
              )),
              Obx(() => DropdownCustom(
                label: 'bussiness_itinerary_vehicle'.tr,
                items: ["bussiness_itinerary_vehicle_placeholder".tr, "Xe công ty", "Xe cá nhân", "Máy bay"],
                value: addScheduleController.vehicle.value,
                onChanged: (value) {
                  addScheduleController.setVehicle(value!);
                },
              )),
              Obx(() => DatePickerCustom(
                label: 'bussiness_itinerary_start_date'.tr,
                dateText: addScheduleController.startDate.value == null
                    ? 'bussiness_itinerary_date_placeholder'.tr
                    : "${addScheduleController.startDate.value!.day}/${addScheduleController.startDate.value!.month}/${addScheduleController.startDate.value!.year}",
                onTap: () async {
                  DateTime today = DateTime.now();
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: addScheduleController.startDate.value ?? today,
                    firstDate: today,
                    lastDate: addScheduleController.endDate.value ?? DateTime(2100), 
                  );
                  if (pickedDate != null) {
                    addScheduleController.setStartDate(pickedDate);
                  }
                },
              )),

          Obx(() => DatePickerCustom(
                label: 'bussiness_itinerary_end_date'.tr,
                dateText: addScheduleController.endDate.value == null
                    ? 'bussiness_itinerary_date_placeholder'.tr
                    : "${addScheduleController.endDate.value!.day}/${addScheduleController.endDate.value!.month}/${addScheduleController.endDate.value!.year}",
                onTap: () async {
                  DateTime today = DateTime.now();
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: addScheduleController.endDate.value ?? addScheduleController.startDate.value ?? today,
                    firstDate: addScheduleController.startDate.value ?? today, // Giới hạn min là ngày bắt đầu nếu đã chọn
                    lastDate: DateTime(2100),
                    locale: Get.locale,
                  );
                  if (pickedDate != null) {
                    addScheduleController.setEndDate(pickedDate);
                  }
                },
              )),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  if (addScheduleController.validateAndSubmit()) {
                    businessItineraryController.fetchItineraryData();
                    addScheduleController.resetForm();
                    context.pop(); 
                  }
                },
                child: Text('bussiness_itinerary_add'.tr, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}