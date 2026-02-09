import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/task_model.dart' as data_model;
import '../../../data/models/task_item.dart';
import '../../../data/services/task_service.dart';
import '../../../core/config/app_config.dart';
import '../../../utils/date_helper.dart';

class UserTaskDetailController extends GetxController {
  final TaskService _taskService = Get.find<TaskService>();
  final ImagePicker _imagePicker = ImagePicker();

  // Task info - populated from API or arguments
  final taskId = Rxn<int>();
  final assignmentId = Rxn<int>(); // Assignment ID for submission
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

  // Uploaded files with File objects for actual upload
  final RxList<Map<String, dynamic>> uploadedFiles = <Map<String, dynamic>>[].obs;

  // Submission state
  final isSubmitting = false.obs;
  final isTaskSubmitted = false.obs;
  final submittedFileName = ''.obs;
  final submittedDate = ''.obs;
  final submittedFilePath = ''.obs;
  final isLoadingSubmissions = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTaskData();
  }

  /// Load task data from arguments
  void _loadTaskData() async {
    final arguments = Get.arguments;

    if (arguments == null) {
      _loadMockData();
      return;
    }

    // Handle TaskModel from API
    if (arguments is data_model.TaskModel) {
      final task = arguments;
      taskId.value = task.taskId ?? task.id; // Use taskId if available, otherwise use id
      assignmentId.value = task.id; // The id is the assignment ID
      taskTitle.value = task.taskSubject;
      postedDate.value = task.createdAt;
      dueDate.value = task.dueDate;
      status.value = _capitalizeFirst(task.status);
      description.value = task.taskDescription;
      location.value = task.location;
      customerName.value = ''; // Not available from API
      
      // Check if task is already submitted
      isTaskSubmitted.value = task.isSubmitted;
      
      // If submitted, fetch submission details
      if (task.isSubmitted && assignmentId.value != null) {
        await _loadSubmissionDetails();
      }
      
      return;
    }

    // Handle DashboardTaskItem (for backward compatibility)
    if (arguments is DashboardTaskItem) {
      final task = arguments;
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

  /// Format submission date
  String _formatSubmissionDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  /// Load submission details from API
  Future<void> _loadSubmissionDetails() async {
    if (assignmentId.value == null) return;

    try {
      isLoadingSubmissions.value = true;

      final submissions = await _taskService.getTaskSubmissions(
        assignmentId: assignmentId.value!,
      );

      if (submissions.isNotEmpty) {
        final latestSubmission = submissions.first;
        submittedFileName.value = latestSubmission.fileName ?? 'Untitled';
        submittedDate.value = _formatSubmissionDate(
          latestSubmission.submittedAt ?? DateTime.now()
        );
        submittedFilePath.value = latestSubmission.filePath ?? '';
      }
    } catch (e) {
      print('Error loading submissions: $e');
      // Don't show error to user, just use fallback values
      submittedFileName.value = 'Submitted File';
      submittedDate.value = _formatSubmissionDate(DateTime.now());
    } finally {
      isLoadingSubmissions.value = false;
    }
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
                      _pickFile();
                    },
                  ),
                  _buildUploadOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    onTap: () {
                      Get.back();
                      _pickImageFromCamera();
                    },
                  ),
                  _buildUploadOption(
                    icon: Icons.link,
                    label: 'Link',
                    onTap: () {
                      Get.back();
                      _showLinkDialog();
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

  /// Pick file from device storage
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          uploadedFiles.add({
            'name': file.name,
            'type': file.extension?.toUpperCase() ?? 'FILE',
            'source': 'Upload',
            'file': File(file.path!),
            'path': file.path!,
          });
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Pick image from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo != null) {
        final file = File(photo.path);
        uploadedFiles.add({
          'name': photo.name,
          'type': 'IMAGE',
          'source': 'Camera',
          'file': file,
          'path': photo.path,
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Show dialog to input link
  void _showLinkDialog() {
    final linkController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('Add Link'),
        content: TextField(
          controller: linkController,
          decoration: const InputDecoration(
            hintText: 'Enter link URL',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final link = linkController.text.trim();
              if (link.isNotEmpty) {
                uploadedFiles.add({
                  'name': link,
                  'type': 'LINK',
                  'source': 'Link',
                  'link': link,
                });
                Get.back();
              } else {
                Get.snackbar('Error', 'Please enter a valid link');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
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
  Future<void> submitWork() async {
    if (uploadedFiles.isEmpty) {
      Get.snackbar(
        'Error',
        'Please upload your work first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (assignmentId.value == null) {
      Get.snackbar(
        'Error',
        'Assignment ID not found',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      // Currently, we'll submit the first file
      // TODO: Handle multiple files if needed
      final firstFile = uploadedFiles.first;

      if (firstFile['type'] == 'LINK') {
        // TODO: Handle link submission if API supports it
        Get.snackbar(
          'Info',
          'Link submission is not yet implemented',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final filePath = firstFile['path'] as String;

      final response = await _taskService.submitTaskWork(
        assignmentId: assignmentId.value!,
        filePath: filePath,
        submissionType: 'file',
      );

      if (response != null && response.success) {
        // Update submission state
        isTaskSubmitted.value = true;
        
        // Clear uploaded files list
        uploadedFiles.clear();
        
        // Reload submission details from API to get accurate info
        await _loadSubmissionDetails();
        
        Get.snackbar(
          'Success',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit task',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Unsubmit task (reset to not submitted state)
  Future<void> unsubmitTask() async {
    // TODO: Implement API call to unsubmit if backend supports it
    // For now, just reset the UI state
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Unsubmit Task'),
        content: const Text('Are you sure you want to unsubmit this task?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Unsubmit', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == true) {
      isTaskSubmitted.value = false;
      submittedFileName.value = '';
      submittedDate.value = '';
      
      Get.snackbar(
        'Info',
        'Task unsubmitted. You can upload new work.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Open submitted file in browser
  Future<void> openSubmittedFile() async {
    if (submittedFilePath.value.isEmpty) {
      Get.snackbar(
        'Error',
        'File path not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final fileUrl = AppConfig.getTaskFileUrl(submittedFilePath.value);
      
      if (fileUrl == null) {
        Get.snackbar(
          'Error',
          'Invalid file URL',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final uri = Uri.parse(fileUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open file',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to open file: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
