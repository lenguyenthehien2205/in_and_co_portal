import 'package:flutter/material.dart';
import 'package:in_and_co_portal/theme/app_text.dart';

class DatePickerCustom extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final String? dateText; // Hiển thị ngày đã chọn (truyền từ bên ngoài)

  const DatePickerCustom({
    super.key,
    required this.label,
    required this.onTap,
    this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  dateText ?? "Chọn ngày",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
