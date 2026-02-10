import 'package:get/get.dart';
import '../../../data/services/task_service.dart';
import '../controllers/employee_detail_controller.dart';

class EmployeeDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure TaskService is available
    if (!Get.isRegistered<TaskService>()) {
      Get.lazyPut<TaskService>(() => TaskService(), fenix: true);
    }
    
    Get.lazyPut<EmployeeDetailController>(() => EmployeeDetailController());
  }
}
