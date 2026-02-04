import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/attendance_history_detail_controller.dart';

class AttendanceHistoryDetailItem extends GetView<AttendanceHistoryDetailController> {
  const AttendanceHistoryDetailItem({
    required this.label,
    required this.icon,
    required this.value,
    super.key,
  });

  final String label;
  final IconData icon;
  final RxString value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.gray500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.gray200),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: AppTheme.gray500,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => Text(
                    value.value.isEmpty ? '-' : value.value,
                    style: const TextStyle(
                      color: AppTheme.gray900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
