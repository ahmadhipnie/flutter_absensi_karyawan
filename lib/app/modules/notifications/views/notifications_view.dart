import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';
import 'widgets/notification_list_item.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => Divider(
            height: 32,
            color: Colors.grey.shade100,
          ),
          itemBuilder: (context, index) {
            final item = controller.notifications[index];
            return NotificationListItem(item: item, controller: controller);
          },
        ),
      ),
    );
  }
}
