import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/task.dart';
import 'package:in_and_co_portal/core/services/task_service.dart';

class TaskController extends GetxController {
  var selectedDate = DateTime.now().obs;
  final TaskService _taskService = TaskService();
  var tasks = <Task>[].obs;
  var isLoading = false.obs; // Thêm trạng thái loading

  @override
  void onInit() {
    super.onInit();
    fetchTasks(); // Fetch task lần đầu
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
    fetchTasks(); // Fetch lại khi ngày thay đổi
  }

  void fetchTasks() {
    isLoading.value = true; // Bắt đầu tải dữ liệu

    _taskService.getTasksByEmployee("1", selectedDate.value).listen((newTasks) {
      tasks.value = newTasks;
      isLoading.value = false; // Dữ liệu đã tải xong
    }, onError: (error) {
      isLoading.value = false; // Dừng loading nếu có lỗi
    });
  }
}
