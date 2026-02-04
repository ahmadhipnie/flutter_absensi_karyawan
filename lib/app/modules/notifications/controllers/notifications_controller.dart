import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final notifications = <NotificationItem>[
    NotificationItem(
      id: '1',
      title: "Alsaa has just set the company's vision and strategic direction",
      time: '2m',
      isUnread: true,
      hasAction: true,
      actionLabel: 'View Task',
    ),
    NotificationItem(
      id: '2',
      title: "Karina has just submitted the Task: Update Daily Work Progress for Project 1",
      time: '10m',
      isUnread: false,
      hasAction: true,
      actionLabel: 'View Task',
    ),
    NotificationItem(
      id: '3',
      title: "Bambang has just submitted the Task: Update Daily Work Progress for Project 1",
      time: '10m',
      isUnread: false,
      hasAction: true,
      actionLabel: 'View Task',
    ),
    NotificationItem(
      id: '4',
      title: "Jessylin has just submitted the Task: Update Daily Work Progress for Project 1",
      time: '10m',
      isUnread: false,
      hasAction: true,
      actionLabel: 'View Task',
    ),
  ].obs;

  void handleAction(NotificationItem item) {
    // Navigate to task detail or relevant page
    Get.snackbar('Action', 'Navigating to ${item.actionLabel} for ${item.id}');
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String time;
  final bool isUnread;
  final bool hasAction;
  final String? actionLabel;

  NotificationItem({
    required this.id,
    required this.title,
    required this.time,
    this.isUnread = false,
    this.hasAction = false,
    this.actionLabel,
  });
}
