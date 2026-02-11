import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/take_attendance_controller.dart';

class AttendanceNotesField extends GetView<TakeAttendanceController> {
  const AttendanceNotesField({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if controller is still registered before accessing
    if (!Get.isRegistered<TakeAttendanceController>(tag: tag)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.gray500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.gray200),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: TextField(
            controller: controller.notesController,
            decoration: const InputDecoration(
              hintText: 'Add notes...',
              hintStyle: TextStyle(color: AppTheme.gray500, fontSize: 15),
              prefixIcon: Icon(
                Icons.work_outline,
                color: AppTheme.gray500,
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
