import 'package:get/get.dart';
import '../../../data/services/notification_service.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    // Register NotificationService first
    Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);
    
    // Then register the controller
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
    );
  }
}
