import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/navigation_controller.dart';
import '../../../../core/theme/app_theme.dart';

class NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;

  const NavItem({
    super.key,
    required this.index,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    return Obx(() {
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
              _buildIcon(isActive),
              const SizedBox(height: 4),
              _buildLabel(isActive),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildIcon(bool isActive) {
    return Icon(
      icon,
      color: isActive ? AppTheme.primaryColor : const Color(0xFF616161),
      size: 24,
    );
  }

  Widget _buildLabel(bool isActive) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        color: isActive ? AppTheme.primaryColor : const Color(0xFF616161),
        height: 1.2,
      ),
    );
  }
}
