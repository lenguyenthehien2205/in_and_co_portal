import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/overview/controllers/task_controller.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class CareerPathScreen extends StatelessWidget {
  CareerPathScreen({super.key});
  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lộ trình công việc', style: AppText.headerTitle(context)),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: _StickyHeaderDelegate(),
              floating: true,
              pinned: true,
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 20),
              sliver: Obx(() {
                if (taskController.isLoading.value) {
                  return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (taskController.tasks.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text("Không có công việc nào", style: AppText.normal(context))),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = taskController.tasks[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: getStatusColor(task.status),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                formatTimeRange(task.startTime, task.endTime),
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              Text(
                                task.content,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          trailing: getStatusIcon(task.status),
                        ),
                      );
                    },
                    childCount: taskController.tasks.length,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  Color getStatusColor(String status) {
    switch (status) {
      case "done":
        return Colors.green;
      case "pending":
        return Colors.blue; 
      case "overdue":
        return Colors.red; 
      default:
        return Colors.grey;
    }
  }
  Widget getStatusIcon(String status) {
    switch (status) {
      case "done":
        return Icon(Icons.check_circle, color: Colors.white, size: 24);
      case "pending":
        return Icon(Icons.hourglass_empty, color: Colors.white, size: 24);
      case "overdue":
        return Icon(Icons.error, color: Colors.white, size: 24);
      default:
        return Icon(Icons.help, color: Colors.white, size: 24);
    }
  }
   /// Chuyển đổi Timestamp thành chuỗi giờ phút: `09:00 - 10:30`
  String formatTimeRange(TimeOfDay start, TimeOfDay end) {
    String formatTime(TimeOfDay time) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return "${formatTime(start)} - ${formatTime(end)}";
  }

}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TaskController taskController = Get.find<TaskController>();

  @override
  double get minExtent => 165;
  @override
  double get maxExtent => 165;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ngày ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    'Hôm nay',
                    style: AppText.title(context),
                  ),
                ],
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.push('/overview/career-path/add-task');
                },
                child: Text('Thêm công việc'),
              ),
            ],
          ),
          SizedBox(height: 10),
          DatePicker(
            DateTime.now(),
            height: 100,
            width: 80,
            initialSelectedDate: taskController.selectedDate.value,
            locale: "vi_VN",
            selectionColor: Theme.of(context).colorScheme.primary,
            selectedTextColor: Colors.white,
            onDateChange: (newDate) {
              taskController.updateSelectedDate(newDate);
            },
            monthTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold), 
            dayTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
            dateTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}