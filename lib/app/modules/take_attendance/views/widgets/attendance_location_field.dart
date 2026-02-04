import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/take_attendance_controller.dart';

class AttendanceLocationField extends GetView<TakeAttendanceController> {
  const AttendanceLocationField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
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
            controller: controller.locationController,
            readOnly: true,
            decoration: const InputDecoration(
              hintText: 'Getting location...',
              hintStyle: TextStyle(color: AppTheme.gray500, fontSize: 15),
              prefixIcon: Icon(
                Icons.location_on_outlined,
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
