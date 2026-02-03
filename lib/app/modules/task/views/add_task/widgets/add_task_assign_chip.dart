import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../controllers/add_task_controller.dart';

class AddTaskAssignChip extends GetView<AddTaskController> {
  const AddTaskAssignChip({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.assignMembers,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'All Member',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
