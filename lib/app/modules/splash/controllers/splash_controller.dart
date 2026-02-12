import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/config/fcm_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Initialize auth service (load saved session)
    await _authService.init();

    // Initialize FCM Service
    try {
      final fcmService = Get.find<FcmService>();
      await fcmService.init();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ FCM initialization skipped: $e');
      }
    }

    // Small delay for splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Navigate based on auth status
    if (_authService.isLoggedIn) {
      // Register FCM token with backend after successful auth
      _registerFcmToken();
      Get.offAllNamed(Routes.MAIN);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
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
