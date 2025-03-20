import 'package:flutter/material.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class TimePickerCustom extends StatelessWidget {
  final String label;
  final String? timeText; // Hiển thị giờ đã chọn
  final VoidCallback onTap;

  const TimePickerCustom({
    super.key,
    required this.label,
    required this.onTap,
    this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.smallTitle(context)),
          SizedBox(height: 5),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeText ?? "Chọn giờ",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Icon(Icons.access_time, color: Colors.grey), // Icon đồng hồ
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
