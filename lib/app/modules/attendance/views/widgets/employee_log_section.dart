import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../controllers/attendance_controller.dart';
import 'employee_log_tabs.dart';
import 'employee_list.dart';

class EmployeeLogSection extends GetView<AttendanceController> {
  const EmployeeLogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          const EmployeeLogTabs(),
          const SizedBox(height: 16),
          const EmployeeList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Employee Attendance Log',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.EMPLOYEE_ATTENDANCE_LOG),
          child: Text(
            'See More',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w500,
            ),
        ),
        ),
      ],
    );
  }
}
