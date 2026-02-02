import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Validate email field
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!_authService.isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password field
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!_authService.isValidPassword(value)) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Handle login action
  Future<void> login() async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final success = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Login Failed',
          'Invalid email or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to forgot password screen
  void goToForgotPassword() {
    // TODO: Implement forgot password navigation
    Get.snackbar(
      'Info',
      'Forgot password feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
