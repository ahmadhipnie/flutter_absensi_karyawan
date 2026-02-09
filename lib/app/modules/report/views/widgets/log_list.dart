import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_report_controller.dart';

class LogList extends GetView<AttendanceReportController> {
  const LogList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   'Attendance History',
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.grey.shade800,
        //   ),
        // ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoadingAttendances.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (controller.attendances.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No attendance records',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'for the selected month',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: controller.attendances.map((attendance) {
              return Column(
                children: [
                  InkWell(
                    onTap: () => controller.viewAttendanceDetail(attendance),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          // Date
                          Expanded(
                            flex: 2,
                            child: Text(
                              controller.formatLogDate(attendance.date),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          // Check-in time
                          Expanded(
                            child: Row(
                              children: [
                                
                                const SizedBox(width: 4),
                                Text(
                                  attendance.clockInTime,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Check-out time
                          Expanded(
                            child: Row(
                              children: [
                                
                                const SizedBox(width: 4),
                                Text(
                                  attendance.clockOutTime,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Late indicator
                          if (attendance.lateDuration > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Late',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                ],
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
