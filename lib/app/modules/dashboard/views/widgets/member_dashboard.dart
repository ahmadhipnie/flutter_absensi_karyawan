import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/dashboard_controller.dart';
import 'member_header_simple.dart';
import 'attendance_card.dart';
import 'member_department_section.dart';
import 'ongoing_task_section.dart';

class MemberDashboard extends GetView<DashboardController> {
  const MemberDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      color: AppTheme.primaryColor,
      edgeOffset: 0,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          children: [
            // Header biru dengan fixed height
            const MemberHeaderSimple(),
            // Content sections dengan negative margin untuk overlap
            Transform.translate(
              offset: const Offset(0, -30), // Overlap 30px ke atas
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  AttendanceCard(),
                  SizedBox(height: 20),
                  MemberDepartmentSection(),
                  SizedBox(height: 20),
                  OngoingTaskSection(),
                  SizedBox(height: 100), // Extra bottom padding for FAB
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
