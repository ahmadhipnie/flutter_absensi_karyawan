import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../controllers/task/task_controller.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final bool showDivider;

  const TaskItem({super.key, required this.task, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIconContainer(),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTaskInfo(controller),
              ),
            ],
          ),
        ),
        if (showDivider) _buildDivider(),
      ],
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.assignment_rounded,
        color: AppTheme.primaryColor,
        size: 24,
      ),
    );
  }

  Widget _buildTaskInfo(TaskController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          controller.formatDate(task.dueDate),
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Color(0xFFEEEEEE), thickness: 1, height: 1);
  }
}
