import 'package:get/get.dart';
import '../../../data/services/task_service.dart';
import '../controllers/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskService>(() => TaskService(), fenix: true);
    Get.lazyPut<TaskController>(() => TaskController());
  }
}
