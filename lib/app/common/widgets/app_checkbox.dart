import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppCheckbox extends StatelessWidget {
  final bool isSelected;
  final Color? activeColor;
  final Color? inactiveBorderColor;
  final double? size;

  const AppCheckbox({
    super.key,
    required this.isSelected,
    this.activeColor,
    this.inactiveBorderColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final checkboxSize = size ?? 24;
    final borderColor = inactiveBorderColor ?? const Color(0xFFBDBDBD);

    return Container(
      width: checkboxSize,
      height: checkboxSize,
      decoration: BoxDecoration(
        color: isSelected ? (activeColor ?? AppTheme.primaryColor) : Colors.transparent,
        border: Border.all(
          color: isSelected ? (activeColor ?? AppTheme.primaryColor) : borderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              color: Colors.white,
              size: (checkboxSize * 0.67).clamp(12, 24),
            )
          : null,
    );
  }
}
