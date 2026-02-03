import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/user_avatar.dart';
import '../../../controllers/task_detail_controller.dart';

class EmployeeWorkItem extends StatelessWidget {
  final EmployeeWorkModel employee;
  final bool isFirst;
  final bool isLast;

  const EmployeeWorkItem({
    super.key,
    required this.employee,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/employee-detail'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                employee.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              employee.statusText,
              style: TextStyle(
                color: employee.statusColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (employee.avatarUrl.isNotEmpty) {
      return UserAvatar(
        name: employee.name,
        size: 48,
        backgroundColor: 0xFFE0E0E0,
        imageUrl: employee.avatarUrl,
      );
    }
    return UserAvatar(
      name: employee.name,
      size: 48,
    );
  }
}
