import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final selectedTabIndex = 0.obs;

  // Sample task data
  final taskTitle = 'Update Daily Work Progress for Project 1'.obs;
  final postedOn = DateTime(2026, 2, 17).obs;
  final dueDate = DateTime(2026, 2, 17).obs;
  final description =
      '''Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet'''
          .obs;
  final customerName = 'Alexandria Maria'.obs;
  final location = 'Orchard 1, Batam'.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// Format date to display
  String formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Edit task
  void editTask() {
    Get.snackbar('Edit Task', 'Edit functionality coming soon');
  }
}
