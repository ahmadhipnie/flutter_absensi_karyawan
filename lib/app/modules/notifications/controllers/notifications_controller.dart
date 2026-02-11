import 'package:get/get.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/models/announcement_model.dart';
import '../../../routes/app_pages.dart';

class NotificationsController extends GetxController {
  NotificationService get notificationService => Get.find<NotificationService>();

  final notifications = <AnnouncementModel>[].obs;
  final isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    try {
      final response = await notificationService.getMyAnnouncements();
      
      if (response != null && response.success) {
        notifications.value = response.data;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void navigateToDetail(AnnouncementModel announcement) {
    Get.toNamed(Routes.ANNOUNCEMENT_DETAIL, arguments: announcement);
  }
}
