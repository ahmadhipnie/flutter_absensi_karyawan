import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/take_attendance_controller.dart';

class AttendancePhotoSection extends GetView<TakeAttendanceController> {
  const AttendancePhotoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        color: AppTheme.gray100,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Photo or placeholder
          Obx(
            () => controller.hasPhoto.value && controller.photoFile.value != null
                ? Image.file(
                    controller.photoFile.value!,
                    fit: BoxFit.cover,
                  )
                : _buildPlaceholder(),
          ),
          // Button at bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Obx(
              () => ElevatedButton.icon(
                onPressed: controller.takePhoto,
                icon: Icon(
                  controller.hasPhoto.value ? Icons.refresh : Icons.camera_alt,
                  size: 20,
                ),
                label: Text(
                  controller.hasPhoto.value ? 'Retake Photo' : 'Take Photo',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.gray100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 60,
            color: AppTheme.gray400,
          ),
          const SizedBox(height: 12),
          Text(
            'Tap button below to take photo',
            style: TextStyle(
              color: AppTheme.gray500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
