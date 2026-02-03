import 'package:get/get.dart';
import '../controllers/user_task_detail_controller.dart';

class UserTaskDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserTaskDetailController>(() => UserTaskDetailController());
  }
}
