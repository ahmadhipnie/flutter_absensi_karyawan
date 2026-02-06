import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/user_service.dart';
import '../../../data/services/auth_service.dart';

class ProfileChangePasswordController extends GetxController {
  final UserService _userService = UserService();
  AuthService? get _authService {
    try {
      return Get.find<AuthService>();
    } catch (e) {
      return null;
    }
  }

  // Form controllers
  final existingPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final showExistingPassword = false.obs;
  final showNewPassword = false.obs;
  final showConfirmPassword = false.obs;

  // Get current user ID
  int? get userId {
    final user = _authService?.currentUser;
    return user?.id;
  }

  @override
  void onClose() {
    existingPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Toggle existing password visibility
  void toggleExistingPassword() {
    showExistingPassword.value = !showExistingPassword.value;
  }

  /// Toggle new password visibility
  void toggleNewPassword() {
    showNewPassword.value = !showNewPassword.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPassword() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  /// Validate existing password
  String? validateExistingPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter existing password';
    }
    return null;
  }

  /// Validate new password
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter new password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value == existingPasswordController.text) {
      return 'New password must be different from existing password';
    }
    return null;
  }

  /// Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm new password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Change password
  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (userId == null) {
      Get.snackbar('Error', 'User not found');
      return;
    }

    try {
      isLoading.value = true;

      await _userService.changePassword(
        userId: userId!,
        oldPassword: existingPasswordController.text,
        newPassword: newPasswordController.text,
      );

      isLoading.value = false;

      // Clear form
      existingPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      // Go back
      Get.back();

      // Show success message
      await Future.delayed(const Duration(milliseconds: 300));
      Get.snackbar(
        'Success',
        'Password changed successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
