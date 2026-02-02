import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../task/views/task_view.dart';
import '../../community/views/community_view.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize pages
    controller.pages.addAll([
      const DashboardView(),
      const TaskView(),
      const CommunityView(),
    ]);

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: controller.pages,
        ),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final itemWidth = screenWidth / 3;
          final indicatorWidth = 64.0;

          return Obx(() {
            // Calculate center position for indicator relative to each tab
            final tabCenter =
                (itemWidth * controller.currentIndex.value) + (itemWidth / 2);
            final indicatorOffset = tabCenter - (indicatorWidth / 2);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  height: 56,
                  child: Stack(
                    children: [
                      // Sliding Indicator - perfectly centered on each tab
                      Positioned(
                        top: 0,
                        left: indicatorOffset,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: indicatorWidth,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0046BE),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      // Navigation Items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: _buildNavItem(
                              index: 0,
                              icon: Icons.home_rounded,
                              label: 'Home',
                            ),
                          ),
                          Expanded(
                            child: _buildNavItem(
                              index: 1,
                              icon: Icons.assignment_rounded,
                              label: 'Task',
                            ),
                          ),
                          Expanded(
                            child: _buildNavItem(
                              index: 2,
                              icon: Icons.people_rounded,
                              label: 'Community',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF0046BE)
                  : const Color(0xFF616161),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? const Color(0xFF0046BE)
                    : const Color(0xFF616161),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
