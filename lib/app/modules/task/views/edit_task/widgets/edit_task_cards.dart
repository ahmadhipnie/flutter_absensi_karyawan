import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/app_card_container.dart';
import '../../../controllers/edit_task_controller.dart';
import '../../add_task/widgets/add_task_form_field.dart';
import '../../add_task/widgets/add_task_label.dart';
import 'edit_task_assign_chip.dart';

class EditTaskFirstCard extends GetView<EditTaskController> {
  const EditTaskFirstCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AddTaskLabel(text: 'Subject'),
          const SizedBox(height: 8),
          AddTaskFormField(
            controller: controller.subjectController,
            hint: 'Update Daily Work Progress For Project 1',
            prefixIcon: Icons.work_outline,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Subject is required' : null,
          ),
          const SizedBox(height: 16),
          const AddTaskLabel(text: 'Due Date'),
          const SizedBox(height: 8),
          Obx(() => AddTaskFormField(
            controller: TextEditingController(
              text: controller.selectedDueDate.value != null
                  ? controller.formatDate(controller.selectedDueDate.value!)
                  : '',
            ),
            hint: '17 Feb',
            prefixIcon: Icons.calendar_today,
            readOnly: true,
            onTap: () => controller.selectDueDate(context),
          )),
          const SizedBox(height: 16),
          const AddTaskLabel(text: 'Assign To'),
          const SizedBox(height: 8),
          const EditTaskAssignChip(),
        ],
      ),
    );
  }
}

class EditTaskSecondCard extends GetView<EditTaskController> {
  const EditTaskSecondCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AddTaskLabel(text: 'Description'),
          const SizedBox(height: 8),
          AddTaskFormField(
            controller: controller.descriptionController,
            hint: 'Input Text disiniii',
            maxLines: 4,
            isTransparent: false,
          ),
        ],
      ),
    );
  }
}

class EditTaskThirdCard extends GetView<EditTaskController> {
  const EditTaskThirdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AddTaskLabel(text: 'Customer Name'),
          const SizedBox(height: 8),
          AddTaskFormField(
            controller: controller.customerNameController,
            hint: 'Alexandria Maria',
            prefixIcon: Icons.person_outline,
            isTransparent: false,
          ),
          const SizedBox(height: 16),
          const AddTaskLabel(text: 'Location'),
          const SizedBox(height: 8),
          AddTaskFormField(
            controller: controller.locationController,
            hint: 'Orchard 1, Batam',
            prefixIcon: Icons.location_on_outlined,
            isTransparent: false,
          ),
        ],
      ),
    );
  }
}
