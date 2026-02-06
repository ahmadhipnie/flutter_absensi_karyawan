import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/task_model.dart';
import '../../../data/services/task_service.dart';

class EditTaskController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final customerNameController = TextEditingController();
  final locationController = TextEditingController();

  // Observable fields
  final selectedDueDate = Rxn<DateTime>();
  final selectedMembers = RxString('');
  final assignedMemberIds = RxList<int>([]);
  final isSubmitting = false.obs;

  // Services
  late final TaskService _taskService;

  // Task data
  int? taskId;
  TaskModel? originalTask;

  @override
  void onInit() {
    super.onInit();
    _taskService = Get.find<TaskService>();

    // Get task data from arguments
    taskId = Get.arguments?['taskId'] as int?;
    originalTask = Get.arguments?['task'] as TaskModel?;

    // Populate form with existing data
    if (originalTask != null) {
      subjectController.text = originalTask!.taskSubject;
      descriptionController.text = originalTask!.taskDescription;
      customerNameController.text = originalTask!.customerName ?? '';
      locationController.text = originalTask!.location;
      selectedDueDate.value = originalTask!.dueDate;

      // Note: We don't have assigned member info from task detail endpoint
      // User needs to reselect members
      selectedMembers.value = 'Please select members again';
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    descriptionController.dispose();
    customerNameController.dispose();
    locationController.dispose();
    super.onClose();
  }

  /// Open member selection modal
  Future<void> selectMembers() async {
    final result = await Get.toNamed('/select-member');

    if (result != null && result is Map<String, dynamic>) {
      selectedMembers.value = result['displayText'] ?? '';
      final memberIds = result['memberIds'] as List<dynamic>?;
      if (memberIds != null) {
        assignedMemberIds.value = memberIds.cast<int>();
      }
    }
  }

  /// Open date picker
  Future<void> selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      selectedDueDate.value = picked;
    }
  }

  /// Format date for display
  String formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Format date for API (yyyy-MM-dd)
  String formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Validate and save task
  Future<void> saveTask() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return;
    }

    if (selectedDueDate.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select due date',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return;
    }

    if (assignedMemberIds.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select at least one member',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return;
    }

    if (taskId == null) {
      Get.snackbar(
        'Error',
        'Task ID not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      return;
    }

    try {
      isSubmitting.value = true;

      final response = await _taskService.updateTask(
        taskId: taskId!,
        subject: subjectController.text.trim(),
        description: descriptionController.text.trim(),
        dueDate: formatDateForApi(selectedDueDate.value!),
        location: locationController.text.trim(),
        assignedTo: assignedMemberIds,
        customerName: customerNameController.text.trim(),
      );

      if (response != null) {
        Get.back(result: true); // Return success to previous screen
        Get.snackbar(
          'Success',
          'Task updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
        );
      } else {
        throw 'Failed to update task';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Cancel editing
  void cancel() {
    Get.back();
  }
}
