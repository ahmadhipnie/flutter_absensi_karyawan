import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../controllers/edit_task_controller.dart';

class EditTaskAssignChip extends GetView<EditTaskController> {
  const EditTaskAssignChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: controller.selectMembers,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.selectedMembers.value.isEmpty
                    ? 'All Member'
                    : controller.selectedMembers.value,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_drop_down,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
