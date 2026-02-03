import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/add_task_controller.dart';
import 'add_task_form_field.dart';
import 'add_task_label.dart';
import 'add_task_assign_chip.dart';
import 'add_task_card_container.dart';

class AddTaskFirstCard extends GetView<AddTaskController> {
  const AddTaskFirstCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AddTaskCardContainer(
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
          AddTaskFormField(
            controller: controller.dueDateController,
            hint: '17 Feb',
            prefixIcon: Icons.calendar_today,
            readOnly: true,
            onTap: () => controller.selectDueDate(context),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Due date is required' : null,
          ),
          const SizedBox(height: 16),
          const AddTaskLabel(text: 'Assign To'),
          const SizedBox(height: 8),
          const AddTaskAssignChip(),
        ],
      ),
    );
  }
}

class AddTaskSecondCard extends GetView<AddTaskController> {
  const AddTaskSecondCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AddTaskCardContainer(
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

class AddTaskThirdCard extends GetView<AddTaskController> {
  const AddTaskThirdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AddTaskCardContainer(
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
