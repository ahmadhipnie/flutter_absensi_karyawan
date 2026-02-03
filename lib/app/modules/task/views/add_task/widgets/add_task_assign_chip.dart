import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/add_task/add_task_controller.dart';

class AddTaskAssignChip extends GetView<AddTaskController> {
  const AddTaskAssignChip({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.assignMembers,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'All Member',
              style: TextStyle(
                color: Color(0xFF424242),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
