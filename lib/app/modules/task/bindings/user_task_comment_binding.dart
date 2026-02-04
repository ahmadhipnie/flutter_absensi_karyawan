import 'package:get/get.dart';
import '../controllers/user_task_comment_controller.dart';

class UserTaskCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserTaskCommentController>(() => UserTaskCommentController());
  }
}
