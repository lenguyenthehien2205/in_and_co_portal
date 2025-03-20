import 'package:get/get.dart';
import 'package:in_and_co_portal/core/models/task.dart';
import 'package:in_and_co_portal/core/services/task_service.dart';
import 'package:in_and_co_portal/features/profile/controllers/profile_controller.dart';

class TaskController extends GetxController {
  final ProfileController _profileController = Get.find();
  var selectedDate = DateTime.now().obs;
  final TaskService _taskService = TaskService();
  var tasks = <Task>[].obs;
  var isLoading = false.obs; // Thêm trạng thái loading

  @override
  void onInit() {
    super.onInit();
    // Lắng nghe sự thay đổi của userData từ ProfileController
    ever(_profileController.userData, (data) {
      if (data.isEmpty || data["employee_id"] == null) {
        clearTasks(); // Xóa dữ liệu khi đăng xuất
      } else {
        fetchTasks();
      }
    });

    fetchTasks(); // Fetch task lần đầu
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
    fetchTasks(); // Fetch lại khi ngày thay đổi
  }

  void clearTasks() {
    tasks.value = []; // Xóa danh sách khi không có employee_id
  }

  void fetchTasks() {
    isLoading.value = true; // Bắt đầu tải dữ liệu
    _taskService.getTasksByEmployee(_profileController.userData["employee_id"], selectedDate.value).listen((newTasks) {
      tasks.value = newTasks;
      isLoading.value = false; // Dữ liệu đã tải xong
    }, onError: (error) {
      isLoading.value = false; // Dừng loading nếu có lỗi
    });
  }
}
