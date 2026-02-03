import 'package:flutter/material.dart';
import '../../../../../common/widgets/app_card_container.dart';

class EmployeeWorkStats extends StatelessWidget {
  final int approvedCount;
  final int lateSubmissionsCount;

  const EmployeeWorkStats({
    super.key,
    required this.approvedCount,
    required this.lateSubmissionsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(label: 'Approved', count: approvedCount),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            label: 'Late Submissions',
            count: lateSubmissionsCount,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required String label, required int count}) {
    return AppCardContainer(
      backgroundColor: const Color(0xFFF8F9FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
