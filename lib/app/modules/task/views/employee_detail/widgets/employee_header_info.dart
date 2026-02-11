import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/app_card_container.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../controllers/employee_detail_controller.dart';

class EmployeeHeaderInfo extends GetView<EmployeeDetailController> {
  const EmployeeHeaderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              controller.taskSubject.value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9E9E9E),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.employeeName.value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Obx(
                () => Text(
                  controller.formatDate(controller.submissionDate.value),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF757575),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Text(
                  controller.status.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: controller.statusColor.value,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.work_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Assignment Status Dropdown
              _buildStatusDropdown(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return InkWell(
      onTap: () => _showStatusDialog(context),
      borderRadius: BorderRadius.circular(20),
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status indicator dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: controller.getAssignmentStatusColor(
                    controller.assignmentStatus.value,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                controller.getAssignmentStatusDisplay(
                  controller.assignmentStatus.value,
                ),
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Obx(
                () => controller.isUpdatingStatus.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                      )
                    : const Icon(Icons.keyboard_arrow_down, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStatusDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: controller.assignmentStatusOptions.map((status) {
            return Obx(
              () => RadioListTile<String>(
                title: Text(
                  controller.getAssignmentStatusDisplay(status),
                ),
                subtitle: Text(
                  _getStatusDescription(status),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
                  ),
                ),
                value: status,
                groupValue: controller.assignmentStatus.value,
                activeColor: controller.getAssignmentStatusColor(status),
                onChanged: (value) {
                  Get.back(); // Close dialog
                  if (value != null) {
                    controller.updateAssignmentStatus(value);
                  }
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'pending':
        return 'Task is pending review';
      case 'in_progress':
        return 'Task is currently in progress';
      case 'completed':
        return 'Task has been completed';
      case 'cancelled':
        return 'Task has been cancelled';
      default:
        return '';
    }
  }
}
