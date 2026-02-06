import 'package:get/get.dart';

import '../controllers/department_controller.dart';
import '../../members/controllers/members_controller.dart';

class DepartmentBinding extends Bindings {
  @override
  void dependencies() {
    // Register MembersController if not already registered
    // This is needed for department detail to show member counts
    if (!Get.isRegistered<MembersController>()) {
      Get.lazyPut<MembersController>(
        () => MembersController(),
      );
    }
    
    Get.lazyPut<DepartmentController>(
      () => DepartmentController(),
    );
  }
}
