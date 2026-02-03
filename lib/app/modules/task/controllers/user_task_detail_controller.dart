import 'package:get/get.dart';

class UserTaskDetailController extends GetxController {
  // Task info
  final taskTitle = 'Update Daily Work Progress for Project 1'.obs;
  final postedDate = DateTime(2025, 12, 25, 10, 30).obs;
  final dueDate = DateTime(2025, 12, 28, 11, 59).obs;
  final status = 'Approved'.obs;
  final commentsCount = 2.obs;
  final description =
      'Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet'
          .obs;
  final customerName = 'Alexandria Maria'.obs;
  final location = 'Orchard 1, Batam'.obs;

  // Status options
  final List<String> statusOptions = ['Approved', 'Pending', 'Rejected'];

  // Uploaded files
  final RxList<Map<String, String>> uploadedFiles = <Map<String, String>>[].obs;

  /// Format date with time
  String formatDateTime(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$minute';
  }

  /// Change status
  void changeStatus(String? newStatus) {
    if (newStatus != null) {
      status.value = newStatus;
    }
  }

  /// Upload work
  void uploadWork() {
    // TODO: Implement file picker
    Get.snackbar('Upload', 'File picker coming soon');
  }

  /// Submit work
  void submitWork() {
    if (uploadedFiles.isEmpty) {
      Get.snackbar('Error', 'Please upload your work first');
      return;
    }
    // TODO: Submit to backend
    Get.back();
    Get.snackbar('Success', 'Work submitted successfully');
  }
}
