import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/take_attendance_controller.dart';

class AttendanceClockInButton extends GetView<TakeAttendanceController> {
  const AttendanceClockInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSubmitting = controller.isSubmitting.value;
      final buttonText = controller.buttonText;
      final buttonColor = controller.attendanceType == 'check-in'
          ? AppTheme.primaryColor
          : Colors.red;

      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isSubmitting ? null : controller.clockIn,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            disabledBackgroundColor: buttonColor.withOpacity(0.6),
          ),
          child: isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      );
    });
  }
}
