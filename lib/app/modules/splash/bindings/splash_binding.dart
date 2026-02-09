import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/attendance_service.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize ApiProvider as permanent singleton first (before AuthService)
    if (!Get.isRegistered<ApiProvider>()) {
      Get.put<ApiProvider>(ApiProvider.instance, permanent: true);
    }

    // Initialize AuthService as permanent singleton
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }

    // Initialize AttendanceService as permanent singleton
    if (!Get.isRegistered<AttendanceService>()) {
      Get.put<AttendanceService>(AttendanceService(), permanent: true);
    }

    Get.put<SplashController>(SplashController());
  }
}
