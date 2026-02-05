import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize AuthService as permanent singleton
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }

    Get.put<SplashController>(SplashController());
  }
}
