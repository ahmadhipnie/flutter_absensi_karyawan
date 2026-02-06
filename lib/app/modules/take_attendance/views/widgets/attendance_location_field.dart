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
        GestureDetector(
          onTap: controller.isLoadingLocation.value
              ? null
              : controller.refreshLocation,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.gray200),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: TextField(
              controller: controller.locationController,
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Getting location...',
                hintStyle: const TextStyle(
                  color: AppTheme.gray500,
                  fontSize: 15,
                ),
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppTheme.gray500,
                  size: 22,
                ),
                suffixIcon: Obx(
                  () => controller.isLoadingLocation.value
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: AppTheme.primaryColor,
                            size: 22,
                          ),
                          onPressed: controller.refreshLocation,
                        ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
