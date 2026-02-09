import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/user_model.dart';
import '../../controllers/member_attendance_log_controller.dart';
import '../../../../routes/app_pages.dart';

class MemberAttendanceLogSection extends StatelessWidget {
  const MemberAttendanceLogSection({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    // Use a unique tag per user to avoid controller collisions
    final tag = 'member_attendance_${user.id}';
    final controller = Get.put(MemberAttendanceLogController(user), tag: tag);

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
                onPressed: () => Get.toNamed(Routes.ATTENDANCE_LOG),
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

          const SizedBox(height: 12),

          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.attendances.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('No attendance records', style: TextStyle(color: Colors.grey.shade500)),
                ),
              );
            }

            final list = controller.attendances.take(5).toList(); // show recent 5

            return Column(
              children: list.map((attendance) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () => controller.viewAttendanceDetail(attendance),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.formatLogDate(attendance.date),
                              style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: [
                                Text(attendance.clockInTime, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                                const SizedBox(width: 8),
                                const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E5E5)),
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
