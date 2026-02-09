import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_controller.dart';
import '../../../../core/config/app_config.dart';

class EmployeeList extends GetView<AttendanceController> {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading state
      if (controller.isLoadingAllAttendances.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final employees = controller.showClockedIn.value
          ? controller.employeesClockedIn
          : controller.employeesNotClockedIn;

      if (employees.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              controller.showClockedIn.value
                  ? 'No employees clocked in today'
                  : 'No employees to show',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: employees.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final employee = employees[index];
          final photoUrl = AppConfig.getProfilePhotoUrl(employee.avatarUrl);

          return ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => controller.viewEmployeeHistory(employee),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl)
                  : NetworkImage(
                      'https://ui-avatars.com/api/?name=${employee.name}&background=random',
                    ),
              onBackgroundImageError: (_, __) {},
            ),
            title: Text(
              employee.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              employee.status,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          );
        },
      );
    });
  }
}