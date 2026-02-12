import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/fcm_service.dart';
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

      final response = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response != null && response.success) {
        _showSuccessSnackbar(response.message);

        // Register FCM token with backend after successful login
        _registerFcmToken();

        // Navigate to main layout with bottom nav
        Get.offAllNamed(Routes.MAIN);
      } else {
        // Login failed but got response (wrong credentials)
        _showErrorSnackbar(response?.message ?? 'Login failed');
      }
    } catch (e) {
      // Exception from AuthService (network error, etc.)
      _showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to forgot password screen
  void goToForgotPassword() {
    // TODO: Implement forgot password navigation
    _showInfoSnackbar('Forgot password feature coming soon');
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showInfoSnackbar(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Register FCM token with backend (fire and forget)
  void _registerFcmToken() {
    try {
      final fcmService = Get.find<FcmService>();
      fcmService.registerTokenWithBackend();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ FCM token registration skipped: $e');
      }
    }
  }
}
