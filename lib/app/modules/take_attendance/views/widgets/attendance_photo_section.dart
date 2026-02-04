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
          Obx(
            () => controller.hasPhoto.value
                ? Image.asset(
                    'assets/images/placeholder_photo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                  )
                : _buildPlaceholder(),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton.icon(
              onPressed: controller.retakePhoto,
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text(
                'Retake Photo',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.gray100,
      child: Center(
        child: Icon(
          Icons.camera_alt,
          size: 60,
          color: AppTheme.gray400,
        ),
      ),
    );
  }
}
