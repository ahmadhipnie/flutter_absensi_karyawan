import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/task_detail_controller.dart';
import 'employee_work_stats.dart';
import 'employee_work_section.dart';

class EmployeeWorkTabView extends GetView<TaskDetailController> {
  const EmployeeWorkTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmployeeWorkStats(
              approvedCount: controller.approvedCount.value,
              lateSubmissionsCount: controller.lateSubmissionsCount.value,
            ),
            const SizedBox(height: 24),
            EmployeeWorkSection(
              title: 'Approved',
              employees: controller.approvedEmployees,
            ),
            const SizedBox(height: 24),
            EmployeeWorkSection(
              title: 'Terlambat',
              employees: controller.lateEmployees,
            ),
            const SizedBox(height: 24),
            EmployeeWorkSection(
              title: 'Ditugaskan',
              employees: controller.assignedEmployees,
            ),
          ],
        ),
      ),
    );
  }
}
