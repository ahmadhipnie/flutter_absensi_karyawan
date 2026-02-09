import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_controller.dart';
import '../../../core/config/app_config.dart';
import '../../../data/models/attendance_model.dart';

class EmployeeAttendanceLogView extends GetView<AttendanceController> {
  const EmployeeAttendanceLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Attendance Log',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Obx(() {
        if (controller.isLoadingAllAttendances.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final attendances = controller.allAttendances;

        if (attendances.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No attendance records',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        // Group attendances by date
        final groupedAttendances = _groupAttendancesByDate(attendances);

        return RefreshIndicator(
          onRefresh: controller.refreshAttendances,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: groupedAttendances.length,
            itemBuilder: (context, index) {
              final entry = groupedAttendances.entries.elementAt(index);
              return _buildDateSection(entry.key, entry.value);
            },
          ),
        );
      }),
    );
  }

  Map<String, List<AttendanceModel>> _groupAttendancesByDate(
    List<AttendanceModel> attendances,
  ) {
    final Map<String, List<AttendanceModel>> grouped = {};

    for (final attendance in attendances) {
      final dateKey = _formatDate(attendance.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(attendance);
    }

    return grouped;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildDateSection(String date, List<AttendanceModel> attendances) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...attendances.map((attendance) => _buildEmployeeItem(attendance)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildEmployeeItem(AttendanceModel attendance) {
    final username = attendance.username ?? 'Unknown User';
    final photoUrl = AppConfig.getProfilePhotoUrl('');

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl)
                  : NetworkImage(
                      'https://ui-avatars.com/api/?name=$username&background=random',
                    ),
              onBackgroundImageError: (_, __) {},
              child: photoUrl == null
                  ? null
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    attendance.hasCheckedOut
                        ? 'Check in: ${attendance.clockInTime} | Check out: ${attendance.clockOutTime}'
                        : 'Check in on ${attendance.clockInTime}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                  if (attendance.email != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      attendance.email!,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(color: Colors.grey.shade200, height: 1),
        const SizedBox(height: 16),
      ],
    );
  }
}
