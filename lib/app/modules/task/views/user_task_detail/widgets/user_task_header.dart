import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/app_card_container.dart';
import '../../../../../common/widgets/task_date_row.dart';
import '../../../controllers/user_task_detail_controller.dart';

class UserTaskHeader extends GetView<UserTaskDetailController> {
  const UserTaskHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                controller.taskTitle.value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              )),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => TaskDateRow(
                        label: 'Posted On',
                        value: controller.formatDateTime(controller.postedDate.value),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(
                  () => TaskDateRow(
                        label: 'Due Date',
                        value: controller.formatDateTime(controller.dueDate.value),
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatus()),
              const SizedBox(width: 16),
              Expanded(child: _buildComments()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF9E9E9E),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.getAssignmentStatusColor(
                      controller.assignmentStatus.value.isEmpty
                          ? 'pending'
                          : controller.assignmentStatus.value,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    controller.assignmentStatus.value.isEmpty
                        ? 'Pending'
                        : controller.getAssignmentStatusDisplay(
                            controller.assignmentStatus.value,
                          ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        InkWell(
          onTap: () async {
            print('Navigating to comments with assignmentId: ${controller.assignmentId.value}');
            await Get.toNamed(
              '/user-task-comment',
              arguments: {
                'assignmentId': controller.assignmentId.value,
              },
            );
            // Refresh comment count when returning
            controller.refreshCommentCount();
          },
          child: Row(
            children: [
              const Icon(Icons.chat_bubble_outline, size: 18, color: Color(0xFF757575)),
              const SizedBox(width: 8),
              Obx(() => Text(
                    '${controller.commentsCount.value} Comments',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
