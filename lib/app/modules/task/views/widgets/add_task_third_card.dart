import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/add_task_controller.dart';
import 'add_task_form_field.dart';
import 'add_task_label.dart';
import 'add_task_card_container.dart';

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
