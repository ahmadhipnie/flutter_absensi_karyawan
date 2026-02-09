import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_report_controller.dart';

class MonthSelector extends GetView<AttendanceReportController> {
  const MonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: controller.previousMonth,
            icon: Icon(Icons.chevron_left, color: Colors.grey[700]),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => Text(
                  controller.formattedMonth,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                )),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: controller.nextMonth,
            icon: Icon(Icons.chevron_right, color: Colors.grey[700]),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
