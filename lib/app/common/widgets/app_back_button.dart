import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Back button with consistent styling across the app.
/// Used in AppBar leading.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
      onPressed: _handleBack,
    );
  }

  void _handleBack() {
    // Close any open snackbars, dialogs, or bottom sheets first
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    if (Get.isDialogOpen == true) {
      Get.back(closeOverlays: true);
    } else if (Get.isBottomSheetOpen == true) {
      Get.back(closeOverlays: true);
    } else {
      Get.back();
    }
  }
}
