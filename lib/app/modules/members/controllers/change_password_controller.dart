import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';

class ChangePasswordController extends GetxController {
  final UserService _userService = UserService();

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

  late UserModel user;

  @override
  void onInit() {
    super.onInit();
    // Get user from arguments
    user = Get.arguments as UserModel;
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

    try {
      isLoading.value = true;

      await _userService.changePassword(
        userId: user.id,
        oldPassword: existingPasswordController.text,
        newPassword: newPasswordController.text,
      );

      // Set loading false before navigation
      isLoading.value = false;

      // Go back first
      Get.back();

      // Then show success message after navigation
      await Future.delayed(const Duration(milliseconds: 300));

      Get.showSnackbar(
        GetSnackBar(
          title: 'Success',
          message: 'Password changed successfully',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
    } catch (e) {
      // Set loading false
      isLoading.value = false;

      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to change password: ${e.toString()}',
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        ),
      );
      print('Error changing password: $e');
    }
  }
}
