import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/task_service.dart';
import '../../../data/services/auth_service.dart';

class TaskFormController extends GetxController {
  final TaskService _taskService = Get.find<TaskService>();
  
  // Get AuthService
  AuthService? get _authService {
    try {
      return Get.find<AuthService>();
    } catch (e) {
      return null;
    }
  }
  
  // Get current user ID
  int? get currentUserId => _authService?.currentUser?.id;

  // Mode parameters
  final String? taskId;
  final Map<String, dynamic>? existingTask;

  TaskFormController({this.taskId, this.existingTask});

  final formKey = GlobalKey<FormState>();

  final subjectController = TextEditingController();
  final dueDateController = TextEditingController();
  final descriptionController = TextEditingController();
  final customerNameController = TextEditingController();
  final locationController = TextEditingController();

  final selectedDate = Rx<DateTime?>(null);
  final assignedMembers = ''.obs; // Display text
  final assignedMemberIds = <int>[].obs; // Actual user IDs
  final isSubmitting = false.obs;

  /// Check if in edit mode
  bool get isEditMode => taskId != null;

  @override
  void onInit() {
    super.onInit();
    // Pre-fill form fields when editing
    if (isEditMode && existingTask != null) {
      final task = existingTask!;
      subjectController.text = task['subject'] ?? '';
      descriptionController.text = task['description'] ?? '';
      customerNameController.text = task['customerName'] ?? '';
      locationController.text = task['location'] ?? '';
      assignedMembers.value = task['assignedMembers'] ?? '';

      // Parse and set due date
      final dueDateStr = task['dueDate'];
      if (dueDateStr != null && dueDateStr is String) {
        final parsedDate = DateTime.tryParse(dueDateStr);
        if (parsedDate != null) {
          selectedDate.value = parsedDate;
          dueDateController.text = _formatDate(parsedDate);
        }
      }
    }
  }

  /// Select due date
  Future<void> selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0046BE)),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      dueDateController.text = _formatDate(picked);
    }
  }

  /// Format date to display
  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]}';
  }

  /// Assign members
  Future<void> assignMembers() async {
    final result = await Get.toNamed('/select-member');
    if (result != null && result is Map<String, dynamic>) {
      assignedMembers.value = result['displayText'] ?? '';
      assignedMemberIds.value = List<int>.from(result['memberIds'] ?? []);
      update();
    }
  }

  /// Save task
  Future<void> saveTask() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    
    // Validate assigned members
    if (assignedMemberIds.isEmpty) {
      Get.snackbar('Error', 'Please assign at least one member');
      return;
    }
    
    // Validate current user
    if (currentUserId == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    try {
      isSubmitting.value = true;

      if (isEditMode) {
        // TODO: Update task logic
        Get.back();
        Get.snackbar('Success', 'Task updated successfully');
      } else {
        // Create new task
        // Format date to yyyy-MM-dd
        final formattedDate = selectedDate.value != null
            ? '${selectedDate.value!.year}-${selectedDate.value!.month.toString().padLeft(2, '0')}-${selectedDate.value!.day.toString().padLeft(2, '0')}'
            : '';

        await _taskService.createTask(
          subject: subjectController.text.trim(),
          description: descriptionController.text.trim(),
          dueDate: formattedDate,
          location: locationController.text.trim(),
          assignedTo: assignedMemberIds.toList(),
          customerName: customerNameController.text.trim(),
          creatorId: currentUserId!,
        );

        Get.back(result: true); // Return true to indicate success
        Get.snackbar(
          'Success',
          'Task created successfully',
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

  @override
  void onClose() {
    subjectController.dispose();
    dueDateController.dispose();
    descriptionController.dispose();
    customerNameController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
