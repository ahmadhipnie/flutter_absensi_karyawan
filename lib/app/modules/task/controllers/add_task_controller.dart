import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskFormController extends GetxController {
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
  final assignedMembers = ''.obs;

  /// Check if in edit mode
  bool get isEditMode => taskId != null;

  @override
  void onInit() {
    super.onInit();
    // Pre-fill form fields when editing
    if (isEditMode && existingTask != null) {
      subjectController.text = existingTask!['subject'] ?? '';
      descriptionController.text = existingTask!['description'] ?? '';
      customerNameController.text = existingTask!['customerName'] ?? '';
      locationController.text = existingTask!['location'] ?? '';
      assignedMembers.value = existingTask!['assignedMembers'] ?? '';
      
      // Parse and set due date
      if (existingTask!['dueDate'] != null) {
        selectedDate.value = DateTime.parse(existingTask!['dueDate']);
        dueDateController.text = _formatDate(selectedDate.value!);
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
          child: child!,
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
    if (result != null && result is String) {
      assignedMembers.value = result;
      update();
    }
  }

  /// Save task
  void saveTask() {
    if (formKey.currentState?.validate() ?? false) {
      if (isEditMode) {
        // TODO: Update task logic
        Get.back();
        Get.snackbar('Success', 'Task updated successfully');
      } else {
        // TODO: Create task logic
        Get.back();
        Get.snackbar('Success', 'Task created successfully');
      }
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
