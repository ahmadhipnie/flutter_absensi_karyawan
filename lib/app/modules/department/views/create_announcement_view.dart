import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_announcement_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../core/theme/app_theme.dart';

class CreateAnnouncementView extends GetView<CreateAnnouncementController> {
  const CreateAnnouncementView({super.key});

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
          'Create Announcement',
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
            child: Obx(() => ElevatedButton.icon(
              onPressed: controller.isLoading.value ? null : controller.postAnnouncement,
              icon: controller.isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppTheme.primaryColor))
                  : const Icon(Icons.edit_note,
                      size: 16, color: AppTheme.primaryColor),
              label: Text(
                controller.isLoading.value ? 'Posting...' : 'Post',
                style: const TextStyle(
                    color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEEF2FF),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Notify To'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.SELECT_ANNOUNCEMENT_MEMBER),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Obx(() => Text(
                      controller.notifyToText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    )),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Subject'),
            const SizedBox(height: 8),
            TextField(
              onChanged: (val) => controller.subjectController.value = val,
              decoration: InputDecoration(
                hintText: 'Input Subject',
                prefixIcon: const Icon(Icons.bookmark_border, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel('Message Content'),
            const SizedBox(height: 8),
            TextField(
              onChanged: (val) => controller.messageController.value = val,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Input Text disniiii',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey[600],
      ),
    );
  }
}
