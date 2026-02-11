import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../core/theme/app_theme.dart';

class AttendanceCard extends GetView<DashboardController> {
  const AttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateAndStatus(),
          const SizedBox(height: 20),
          _buildWorkHours(),
          const SizedBox(height: 24),
          _buildLocation(),
          const SizedBox(height: 24),
          _buildClockInButton(),
        ],
      ),
    );
  }

  Widget _buildDateAndStatus() {
    return Obx(() {
      final attendance = controller.todayAttendance.value;
      final statusInfo = _getStatusInfo(attendance);
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            controller.formattedDate,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusInfo['bgColor'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusInfo['text'],
              style: TextStyle(
                color: statusInfo['textColor'],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    });
  }

  Map<String, dynamic> _getStatusInfo(dynamic attendance) {
    if (attendance == null) {
      return {
        'text': 'Not Checked In',
        'bgColor': Colors.grey.shade100,
        'textColor': Colors.grey.shade700,
      };
    }

    // Check if checked out
    if (attendance.hasCheckedOut) {
      return {
        'text': 'Checked Out',
        'bgColor': Colors.blue.shade50,
        'textColor': Colors.blue.shade700,
      };
    }

    // Check if checked in
    if (attendance.hasCheckedIn) {
      // Check if late
      if (attendance.lateDuration > 0) {
        return {
          'text': 'Late',
          'bgColor': Colors.orange.shade50,
          'textColor': Colors.orange.shade700,
        };
      }
      return {
        'text': 'Working',
        'bgColor': Colors.green.shade50,
        'textColor': Colors.green.shade700,
      };
    }

    return {
      'text': 'Not Checked In',
      'bgColor': Colors.grey.shade100,
      'textColor': Colors.grey.shade700,
    };
  }

  Widget _buildWorkHours() {
    return Center(
      child: Obx(
        () => Text(
          '${controller.workStartTime.value} - ${controller.workEndTime.value}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildLocation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Obx(
                () => GestureDetector(
                  onTap: controller.isLoadingLocation.value
                      ? null
                      : controller.refreshLocation,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.displayLocation,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (controller.isLoadingLocation.value)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryColor,
                          ),
                        )
                      else
                        const Icon(
                          Icons.refresh,
                          color: AppTheme.primaryColor,
                          size: 16,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClockInButton() {
    return Obx(() {
      final attendance = controller.todayAttendance.value;
      final canCheckIn = controller.canCheckIn;
      final canCheckOut = controller.canCheckOut;

      // Show loading state
      if (controller.isLoadingAttendance.value) {
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
        );
      }

      // Show check-in/check-out status and buttons
      if (attendance != null && attendance.hasCheckedIn) {
        return Column(
          children: [
            // Show check-in and check-out times
            Row(
              children: [
                Expanded(
                  child: _buildTimeCard(
                    'Check In',
                    attendance.clockInTime,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeCard(
                    'Check Out',
                    attendance.clockOutTime,
                    attendance.hasCheckedOut ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Logic for showing button based on status
            if (attendance.hasCheckedOut)
              // Already checked out - Show completed message
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Attendance Completed',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (canCheckOut)
              // Checked in and can check out now
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: controller.clockOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Clock Out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              )
            else
              // Checked in but not time to check out yet
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Already Checked In',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        'Check-out available after ${controller.workEndTime.value}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      }

      // Haven't checked in yet - Show check-in button
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: canCheckIn ? controller.clockIn : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Clock In',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    });
  }

  Widget _buildTimeCard(String label, String time, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
