import 'package:flutter/material.dart';
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

  /// Show upload options bottom sheet
  void showUploadOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUploadOption(
                    icon: Icons.upload_file_outlined,
                    label: 'Upload',
                    onTap: () {
                      Get.back();
                      _addDummyFile('Upload');
                    },
                  ),
                  _buildUploadOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () {
                      Get.back();
                      _addDummyFile('Camera');
                    },
                  ),
                  _buildUploadOption(
                    icon: Icons.link,
                    label: 'Link',
                    onTap: () {
                      Get.back();
                      _addDummyFile('Link');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            // Icon dalam circle border
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
              ),
              child: Icon(
                icon,
                size: 28,
                color: const Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF616161),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Add dummy file for UI demonstration
  void _addDummyFile(String source) {
    final fileNames = [
      'Hasil Laporan Observasi A',
      'Document Project.pdf',
      'Report Final.docx',
    ];
    final fileTypes = ['PDF', 'DOCX', 'XLSX'];
    
    final index = uploadedFiles.length % fileNames.length;
    
    uploadedFiles.add({
      'name': fileNames[index],
      'type': fileTypes[index],
      'source': source,
    });
  }

  /// Upload work (legacy, now shows options)
  void uploadWork() {
    showUploadOptions();
  }

  /// Remove uploaded file
  void removeFile(int index) {
    if (index >= 0 && index < uploadedFiles.length) {
      uploadedFiles.removeAt(index);
    }
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
