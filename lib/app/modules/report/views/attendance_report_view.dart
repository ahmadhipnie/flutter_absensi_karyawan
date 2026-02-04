import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_report_controller.dart';
import 'widgets/employee_selector.dart';
import 'widgets/month_selector.dart';
import 'widgets/stats_row.dart';
import 'widgets/log_list.dart';

class AttendanceReportView extends GetView<AttendanceReportController> {
  const AttendanceReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Attendance Report',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EmployeeSelector(),
            const SizedBox(height: 16),
            const MonthSelector(),
            const SizedBox(height: 24),
            const StatsRow(),
            const SizedBox(height: 24),
            const LogList(),
          ],
        ),
      ),
    );
  }
}
