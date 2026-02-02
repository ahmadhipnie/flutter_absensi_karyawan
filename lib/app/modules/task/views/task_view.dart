import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';

class TaskView extends GetView<TaskController> {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title - Left aligned like design
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Text(
                'Task',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Filter Chips
            _buildFilterChips(),

            // Task List
            Expanded(child: Obx(() => _buildTaskList())),
          ],
        ),
      ),
    );
  }

  /// Build Filter Chips
  Widget _buildFilterChips() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = controller.filters[index];
          return Obx(() {
            final isSelected = controller.selectedFilter.value == filter;
            return GestureDetector(
              onTap: () => controller.selectFilter(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF0046BE)
                        : const Color(0xFFE0E0E0),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF0046BE)
                        : const Color(0xFF424242),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  /// Build Task List
  Widget _buildTaskList() {
    final tasks = controller.filteredTasks;

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No tasks found',
          style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: tasks.length,
      itemBuilder: (context, monthIndex) {
        final month = tasks.keys.elementAt(monthIndex);
        final monthTasks = tasks[month]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Header
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 10),
              child: Text(
                month,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Tasks for this month
            ...monthTasks.asMap().entries.map((entry) {
              final isLast = entry.key == monthTasks.length - 1;
              return _TaskItem(task: entry.value, showDivider: !isLast);
            }),
          ],
        );
      },
    );
  }
}

/// Task Item Widget
class _TaskItem extends StatelessWidget {
  final task;
  final bool showDivider;

  const _TaskItem({required this.task, required this.showDivider});

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
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.assignment_rounded,
                  color: Color(0xFF0046BE),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Task Info
              Expanded(
                child: Column(
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
                ),
              ),
            ],
          ),
        ),

        // Divider
        if (showDivider)
          const Divider(color: Color(0xFFEEEEEE), thickness: 1, height: 1),
      ],
    );
  }
}
