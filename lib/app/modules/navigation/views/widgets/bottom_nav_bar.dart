import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/navigation_controller.dart';
import 'nav_indicator.dart';
import 'nav_item.dart';

class BottomNavBar extends GetView<NavigationController> {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final itemWidth = screenWidth / 3;
        final indicatorWidth = 64.0;

        return Obx(() {
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
                    NavIndicator(offset: indicatorOffset),
                    _buildNavItems(),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildNavItems() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Expanded(child: NavItem(index: 0, icon: Icons.home_rounded, label: 'Home')),
        const Expanded(child: NavItem(index: 1, icon: Icons.assignment_rounded, label: 'Task')),
        const Expanded(child: NavItem(index: 2, icon: Icons.people_rounded, label: 'Community')),
      ],
    );
  }
}
