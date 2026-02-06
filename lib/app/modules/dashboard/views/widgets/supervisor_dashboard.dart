import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/dashboard_controller.dart';
import 'dashboard_header.dart';
import 'quick_action_menu.dart';
import 'department_section.dart';

class SupervisorDashboard extends GetView<DashboardController> {
  const SupervisorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashboardHeader(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.onRefresh,
            color: AppTheme.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  QuickActionMenu(),
                  DepartmentSection(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
