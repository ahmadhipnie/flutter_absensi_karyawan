import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_log_controller.dart';

class AttendanceLogView extends GetView<AttendanceLogController> {
  const AttendanceLogView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get title once (doesn't change after init)
    final title = controller.viewingUser?.displayName ?? 'Attendance Report';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month selector
              Row(
                children: [
                  IconButton(
                    onPressed: controller.previousMonth,
                    icon: Icon(Icons.chevron_left, color: Colors.grey[700]),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => Text(
                          controller.formattedMonth,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: controller.nextMonth,
                    icon: Icon(Icons.chevron_right, color: Colors.grey[700]),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stats
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Row(
                  children: [
                    Expanded(child: _buildStatCard('Absent', controller.absentDays.value.toString(), Colors.black)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Present', controller.presentDays.value.toString(), Colors.black)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Late', controller.lateDays.value.toString(), Colors.black)),
                  ],
                );
              }),

              const SizedBox(height: 24),

              // Logs
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                }

                if (controller.attendances.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text('No attendance records', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                          const SizedBox(height: 8),
                          Text('for the selected month', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: controller.attendances.map((attendance) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () => controller.viewAttendanceDetail(attendance),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    controller.formatLogDate(attendance.date),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      
                                      const SizedBox(width: 4),
                                      Text(attendance.clockInTime, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      
                                      const SizedBox(width: 4),
                                      Text(attendance.clockOutTime, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
                                    ],
                                  ),
                                ),
                                if (attendance.lateDuration > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(4)),
                                    child: Text('Late', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange.shade700)),
                                  ),
                                const SizedBox(width: 8),
                                Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
                              ],
                            ),
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.shade100),
                      ],
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade100)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ]),
    );
  }
}
