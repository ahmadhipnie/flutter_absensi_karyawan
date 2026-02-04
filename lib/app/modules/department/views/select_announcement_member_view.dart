import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_announcement_controller.dart';
import '../../../core/theme/app_theme.dart';

class SelectAnnouncementMemberView extends GetView<CreateAnnouncementController> {
  const SelectAnnouncementMemberView({super.key});

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
          'Select Member',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            child: ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.edit_note, size: 16, color: AppTheme.primaryColor),
              label: const Text(
                'Done',
                style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEEF2FF),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.allMembers.length,
            itemBuilder: (context, index) {
              final member = controller.allMembers[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: (member['avatar'] is String && (member['avatar'] as String).isNotEmpty)
                          ? NetworkImage(member['avatar'] as String)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        (member['name'] ?? '').toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: (member['isSelected'] as bool?) ?? false,
                        onChanged: (val) => controller.toggleMemberSelection(index),
                        activeColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
