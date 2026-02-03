import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/app_card_container.dart';
import '../../../controllers/task_detail_controller.dart';
import 'task_detail_info_row.dart';

class TaskDetailTabView extends GetView<TaskDetailController> {
  const TaskDetailTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _TaskDetailDateCard(),
          SizedBox(height: 16),
          _TaskDetailDescriptionCard(),
          SizedBox(height: 16),
          _TaskDetailInfoCard(),
        ],
      ),
    );
  }
}

class _TaskDetailDateCard extends GetView<TaskDetailController> {
  const _TaskDetailDateCard();

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              controller.taskTitle.value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: TaskDetailInfoRow(
                    label: 'Posted On',
                    value: controller.formatDate(controller.postedOn.value),
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TaskDetailInfoRow(
                    label: 'Due Date',
                    value: controller
                        .formatDate(controller.dueDate.value)
                        .substring(0, 6), // "17 Feb"
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskDetailDescriptionCard extends GetView<TaskDetailController> {
  const _TaskDetailDescriptionCard();

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.description.value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskDetailInfoCard extends GetView<TaskDetailController> {
  const _TaskDetailInfoCard();

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Obx(
        () => Column(
          children: [
            _buildInfoItem(
              label: 'Customer Name',
              value: controller.customerName.value,
            ),
            const SizedBox(height: 16),
            _buildInfoItem(label: 'Location', value: controller.location.value),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
