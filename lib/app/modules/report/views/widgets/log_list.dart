import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_report_controller.dart';

class LogList extends GetView<AttendanceReportController> {
  const LogList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: controller.logs.map((log) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          log['date'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      Text(
                        log['time'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade100),
              ],
            );
          }).toList(),
        ));
  }
}
