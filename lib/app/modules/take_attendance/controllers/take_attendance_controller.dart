import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TakeAttendanceController extends GetxController {
  // Selected date
  final selectedDate = DateTime(2025, 12, 27).obs;

  // Photo path (using placeholder for UI)
  final photoPath = ''.obs;
  final hasPhoto = true.obs;

  // Form fields
  final notesController = TextEditingController(text: 'Work');
  final locationController = TextEditingController(
    text: 'Jl. Our memories together 04',
  );

  /// Format date for app bar title
  String get formattedDate {
    final date = selectedDate.value;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Retake photo
  void retakePhoto() {
    // TODO: Implement camera functionality
    Get.snackbar('Camera', 'Opening camera...');
  }

  /// Clock in action
  void clockIn() {
    if (notesController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please add notes');
      return;
    }
    if (locationController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please add location');
      return;
    }
    // TODO: Submit attendance to backend
    Get.snackbar('Success', 'Clock in successful!');
  }

  @override
  void onClose() {
    notesController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
