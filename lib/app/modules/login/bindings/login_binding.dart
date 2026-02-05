import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize AuthService as permanent singleton (persists across navigation)
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(AuthService(), permanent: true);
    }

    // Initialize LoginController
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
