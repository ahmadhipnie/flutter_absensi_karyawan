import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../task/controllers/task_controller.dart';
import '../../community/controllers/community_controller.dart';
import '../controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthService is available
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<TaskController>(() => TaskController());
    Get.lazyPut<CommunityController>(() => CommunityController());
  }
}
