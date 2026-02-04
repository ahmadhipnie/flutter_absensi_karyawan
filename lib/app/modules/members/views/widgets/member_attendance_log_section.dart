import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MemberAttendanceLogSection extends StatelessWidget {
  const MemberAttendanceLogSection({super.key});

  static const List<Map<String, String>> attendanceData = [
    {'date': '17 Jan 2026', 'time': '08:00'},
    {'date': '18 Jan 2026', 'time': '08:00'},
    {'date': '19 Jan 2026', 'time': '08:00'},
    {'date': '20 Jan 2026', 'time': '08:00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Attendance Log',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View Log',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          ...List.generate(attendanceData.length, (index) {
            final item = attendanceData[index];
            final date = item['date'] ?? '';
            final time = item['time'] ?? '';
            return Column(
              children: [
                _buildAttendanceItem(date, time),
                if (index < attendanceData.length - 1)
                  const Divider(height: 1, color: Color(0xFFE5E5E5)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAttendanceItem(String date, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
