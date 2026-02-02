import 'package:get/get.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../task/controllers/task_controller.dart';
import '../../community/controllers/community_controller.dart';
import '../controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<TaskController>(() => TaskController());
    Get.lazyPut<CommunityController>(() => CommunityController());
  }
}
