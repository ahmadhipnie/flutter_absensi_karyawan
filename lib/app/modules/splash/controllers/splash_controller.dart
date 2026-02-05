import 'package:get/get.dart';
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

    // Small delay for splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Navigate based on auth status
    if (_authService.isLoggedIn) {
      Get.offAllNamed(Routes.MAIN);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
