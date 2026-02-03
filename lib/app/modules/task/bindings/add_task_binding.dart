import 'package:get/get.dart';
import '../controllers/add_task_controller.dart';

class AddTaskBinding extends Bindings {
  @override
  void dependencies() {
    // Extract arguments if provided (for edit mode)
    final args = Get.arguments as Map<String, dynamic>?;
    final taskId = args?['taskId'] as String?;
    final existingTask = args?['taskData'] as Map<String, dynamic>?;

    Get.lazyPut<TaskFormController>(
      () => TaskFormController(
        taskId: taskId,
        existingTask: existingTask,
      ),
    );
  }
}
