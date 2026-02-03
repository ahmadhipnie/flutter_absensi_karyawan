import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppFAB extends StatelessWidget {
  final String heroTag;
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;

  const AppFAB({
    super.key,
    required this.heroTag,
    required this.onPressed,
    this.icon = Icons.add,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppTheme.primaryColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
