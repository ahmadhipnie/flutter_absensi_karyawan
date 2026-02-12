import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talenta_attendance/app/core/theme/app_theme.dart';
import 'package:talenta_attendance/app/data/models/announcement_model.dart';
import 'package:talenta_attendance/app/utils/date_helper.dart';
import '../../controllers/notifications_controller.dart';

class NotificationListItem extends StatelessWidget {
  final AnnouncementModel item;
  final NotificationsController controller;

  const NotificationListItem({super.key, required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isRead = controller.isRead(item.id);

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.navigateToDetail(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isRead ? Colors.transparent : const Color(0xFFF0F4FF),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.isBroadcast ? Icons.campaign : Icons.assignment,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    if (!isRead)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.subject,
                              style: TextStyle(
                                fontSize: 14,
                                color: isRead ? Colors.black54 : Colors.black87,
                                fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateHelper.formatRelativeDateWib(item.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: isRead ? Colors.grey.shade500 : Colors.grey.shade700,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.senderName ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
