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
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        color: Colors.blue,
        child: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.errorMessage.value != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              controller.errorMessage.value ?? 'Failed to load notifications',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: controller.notifications.isEmpty
                          ? 1
                          : controller.notifications.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 32,
                        color: Colors.grey.shade100,
                      ),
                      itemBuilder: (context, index) {
                        if (controller.notifications.isEmpty) {
                          return const SizedBox(
                            height: 400,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.notifications_outlined,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No notifications',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        final item = controller.notifications[index];
                        return NotificationListItem(item: item, controller: controller);
                      },
                    ),
        ),
      ),
    );
  }
}
