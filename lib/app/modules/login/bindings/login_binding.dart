import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/services/auth_service.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize ApiProvider as permanent singleton first (before AuthService)
    if (!Get.isRegistered<ApiProvider>()) {
      Get.put<ApiProvider>(ApiProvider.instance, permanent: true);
    }

    // Initialize AuthService as permanent singleton (persists across navigation)
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }

    // Initialize LoginController
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
