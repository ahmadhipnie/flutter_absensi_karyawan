import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../task/views/task_view.dart';
import '../../community/views/community_view.dart';
import 'widgets/bottom_nav_bar.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    _initializePages();

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.pages,
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  void _initializePages() {
    if (controller.pages.isEmpty) {
      controller.pages.addAll([
        const DashboardView(),
        const TaskView(),
        const CommunityView(),
      ]);
    }
  }
}
