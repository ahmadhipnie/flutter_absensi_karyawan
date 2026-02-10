import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../data/services/department_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );

    // Ensure DepartmentService is available for profile pages
    if (!Get.isRegistered<DepartmentService>()) {
      Get.lazyPut<DepartmentService>(() => DepartmentService());
    }
  }
}
