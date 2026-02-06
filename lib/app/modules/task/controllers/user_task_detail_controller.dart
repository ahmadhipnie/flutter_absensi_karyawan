import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart' as data_model;
import '../../../data/models/task_item.dart';
import '../../../utils/date_helper.dart';

class UserTaskDetailController extends GetxController {
  // Task info - populated from API or arguments
  final taskId = Rxn<int>();
  final taskTitle = ''.obs;
  final postedDate = Rxn<DateTime>();
  final dueDate = Rxn<DateTime>();
  final status = ''.obs;
  final commentsCount = 0.obs;
  final description = ''.obs;
  final location = ''.obs;
  final customerName = ''.obs;

  // Status options
  final List<String> statusOptions = ['Approved', 'Pending', 'In Progress', 'Rejected'];

  // Uploaded files
  final RxList<Map<String, String>> uploadedFiles = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTaskData();
  }

  /// Load task data from arguments
  void _loadTaskData() {
    final arguments = Get.arguments;

    if (arguments == null) {
      _loadMockData();
      return;
    }

    // Handle TaskModel from API
    if (arguments is data_model.TaskModel) {
      final task = arguments as data_model.TaskModel;
      taskId.value = task.taskId;
      taskTitle.value = task.taskSubject;
      postedDate.value = task.createdAt;
      dueDate.value = task.dueDate;
      status.value = _capitalizeFirst(task.status);
      description.value = task.taskDescription;
      location.value = task.location;
      customerName.value = ''; // Not available from API
      return;
    }

    // Handle DashboardTaskItem (for backward compatibility)
    if (arguments is DashboardTaskItem) {
      final task = arguments as DashboardTaskItem;
      taskTitle.value = task.title;
      dueDate.value = task.dueDate;
      status.value = 'Pending';
      description.value = 'No description available';
      location.value = '';
      customerName.value = '';
      return;
    }

    // Fallback to mock data
    _loadMockData();
  }

  /// Load mock data as fallback
  void _loadMockData() {
    taskTitle.value = 'Update Daily Work Progress for Project 1';
    postedDate.value = DateTime(2025, 12, 25, 10, 30);
    dueDate.value = DateTime(2025, 12, 28, 11, 59);
    status.value = 'Pending';
    description.value =
        'Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.';
    location.value = 'Orchard 1, Batam';
    customerName.value = 'Alexandria Maria';
  }

  /// Capitalize first letter of string
  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Format date with time (WIB)
  String formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateHelper.formatDateTimeWib(date);
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
