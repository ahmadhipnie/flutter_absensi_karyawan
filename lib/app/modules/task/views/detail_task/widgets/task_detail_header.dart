import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/task_detail_controller.dart';

class TaskDetailHeader extends GetView<TaskDetailController> {
  const TaskDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
        controller.taskTitle.value,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
    );
  }
}
