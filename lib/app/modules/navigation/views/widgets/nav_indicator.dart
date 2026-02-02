import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NavIndicator extends StatelessWidget {
  final double offset;

  const NavIndicator({super.key, required this.offset});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: offset,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 64,
        height: 4,
        decoration: const BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
      ),
    );
  }
}
