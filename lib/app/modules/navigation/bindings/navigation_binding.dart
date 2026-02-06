import 'package:get/get.dart';
import '../../../data/services/task_service.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../task/controllers/task_controller.dart';
import '../../community/controllers/community_controller.dart';
import '../controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // AuthService should already be registered from login (permanent: true)
    // Don't create a new instance here

    // Register services first (with fenix: true so they can be recreated if needed)
    Get.lazyPut<TaskService>(() => TaskService(), fenix: true);

    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<TaskController>(() => TaskController());
    Get.lazyPut<CommunityController>(() => CommunityController());
  }
}
