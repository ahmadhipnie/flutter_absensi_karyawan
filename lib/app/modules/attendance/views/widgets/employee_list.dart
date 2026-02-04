import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attendance_controller.dart';

class EmployeeList extends GetView<AttendanceController> {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final employees = controller.showClockedIn.value
          ? controller.employeesClockedIn
          : controller.employeesNotClockedIn;

      if (employees.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              'No employees found',
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
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: employee.avatarUrl.isNotEmpty
                  ? NetworkImage(employee.avatarUrl)
                  : null,
              child: employee.avatarUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.blue)
                  : null,
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
