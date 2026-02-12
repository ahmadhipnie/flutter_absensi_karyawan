import 'package:get/get.dart';
import '../../../data/services/notification_service.dart';
import '../../../data/services/notification_read_storage.dart';
import '../../../data/models/announcement_model.dart';
import '../../../routes/app_pages.dart';

class NotificationsController extends GetxController {
  NotificationService get notificationService => Get.find<NotificationService>();
  NotificationReadStorage get readStorage => Get.find<NotificationReadStorage>();

  final notifications = <AnnouncementModel>[].obs;
  final isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  /// Expose update trigger from storage for reactive UI updates
  RxInt get readUpdateTrigger => readStorage.updateTrigger;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
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
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh notifications for pull-to-refresh
  Future<void> refresh() async {
    await fetchAnnouncements();
  }

  void navigateToDetail(AnnouncementModel announcement) {
    // Mark as read when user taps on notification
    readStorage.markAsRead(announcement.id);
    Get.toNamed(Routes.ANNOUNCEMENT_DETAIL, arguments: announcement);
  }

  /// Check if a notification has been read
  bool isRead(int notificationId) {
    return readStorage.isRead(notificationId);
  }
}
