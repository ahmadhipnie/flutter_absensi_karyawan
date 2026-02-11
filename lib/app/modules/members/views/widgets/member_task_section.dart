import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/user_model.dart';
import '../../../members/controllers/member_task_controller.dart';

class MemberTaskSection extends StatelessWidget {
  final UserModel user;
  
  const MemberTaskSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Use a unique tag per user to avoid controller collisions
    final tag = 'member_task_${user.id}';
    final controller = Get.put(MemberTaskController(user), tag: tag);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Task',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Row(
                children: [
                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'Ditugaskan',
                      count: '${controller.assignedCount.value}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'Tepat Waktu',
                      count: '${controller.onTimeCount.value}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'Approved',
                      count: '${controller.approvedCount.value}',
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 24),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
              );
            }

            if (controller.memberTasks.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'No tasks assigned yet',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.memberTasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final task = controller.memberTasks[index];
                return _TaskItem(
                  task: task,
                  controller: controller,
                );
              },
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _TaskSummaryCard extends StatelessWidget {
  const _TaskSummaryCard({
    required this.title,
    required this.count,
  });

  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF757575),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  final dynamic task;
  final MemberTaskController controller;

  const _TaskItem({
    required this.task,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.openTaskDetail(task),
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEBF0FF),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Center(
              child: Icon(Icons.assignment, color: AppTheme.primaryColor, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.taskSubject,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  controller.formatDueDate(task.dueDate),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                if (task.isSubmitted) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(int.parse(controller.getStatusColor(task.status))).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(int.parse(controller.getStatusColor(task.status))),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 20, color: Color(0xFF757575)),
        ],
      ),
    );
  }
}
