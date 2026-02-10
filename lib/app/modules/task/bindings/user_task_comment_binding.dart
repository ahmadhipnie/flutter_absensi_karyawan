import 'package:get/get.dart';
import '../../../data/services/task_service.dart';
import '../controllers/user_task_comment_controller.dart';

class UserTaskCommentBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure TaskService is available
    if (!Get.isRegistered<TaskService>()) {
      Get.lazyPut<TaskService>(() => TaskService(), fenix: true);
    }
    
    Get.lazyPut<UserTaskCommentController>(() => UserTaskCommentController());
  }
}
