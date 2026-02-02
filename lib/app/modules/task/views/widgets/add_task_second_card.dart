import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/add_task_controller.dart';
import 'add_task_form_field.dart';
import 'add_task_label.dart';
import 'add_task_card_container.dart';

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
