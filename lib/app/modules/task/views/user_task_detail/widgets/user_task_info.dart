import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/app_card_container.dart';
import '../../../controllers/user_task_detail_controller.dart';

class UserTaskInfo extends GetView<UserTaskDetailController> {
  const UserTaskInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      child: Column(
        children: [
          _buildInfoRow('Customer Name', controller.customerName.value),
          const SizedBox(height: 16),
          _buildInfoRow('Location', controller.location.value),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF9E9E9E),
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
