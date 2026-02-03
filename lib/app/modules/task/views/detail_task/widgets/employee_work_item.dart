import 'package:flutter/material.dart';
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
    return Padding(
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
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: employee.avatarUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(employee.avatarUrl),
                fit: BoxFit.cover,
              )
            : null,
        color: employee.avatarUrl.isEmpty ? const Color(0xFFE0E0E0) : null,
      ),
      child: employee.avatarUrl.isEmpty
          ? Center(
              child: Text(
                employee.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}
