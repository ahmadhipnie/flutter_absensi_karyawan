import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/task_model.dart' as data_model;
import '../../../controllers/task_controller.dart';
import 'task_item.dart';

class TaskList extends GetView<TaskController> {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tasks = controller.groupedTasks;

      if (tasks.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tasks.length,
        itemBuilder: (context, monthIndex) {
          final month = tasks.keys.elementAt(monthIndex);
          final monthTasks = tasks[month]!;

          return _buildMonthSection(month, monthTasks);
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No tasks found',
        style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16),
      ),
    );
  }

  Widget _buildMonthSection(String month, List<data_model.TaskModel> monthTasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthHeader(month),
        ...monthTasks.asMap().entries.map((entry) {
          final isLast = entry.key == monthTasks.length - 1;
          return TaskItem(task: entry.value, showDivider: !isLast);
        }),
      ],
    );
  }

  Widget _buildMonthHeader(String month) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 10),
      child: Text(
        month,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
