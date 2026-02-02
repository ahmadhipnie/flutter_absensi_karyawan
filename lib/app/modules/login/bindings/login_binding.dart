import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize AuthService as singleton if not already initialized
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);

    // Initialize LoginController
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
