import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/supervisor_dashboard.dart';
import 'widgets/member_dashboard.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        final shouldExit = await controller.handleWillPop();
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Obx(() {
          return controller.isSupervisor
              ? const SupervisorDashboard()
              : const MemberDashboard();
        }),
      ),
    );
  }
}
