import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTaskController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final subjectController = TextEditingController();
  final dueDateController = TextEditingController();
  final descriptionController = TextEditingController();
  final customerNameController = TextEditingController();
  final locationController = TextEditingController();

  final selectedDate = Rx<DateTime?>(null);
  final assignedMembers = ''.obs;

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
      // TODO: Save task logic
      Get.back();
      Get.snackbar('Success', 'Task created successfully');
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
