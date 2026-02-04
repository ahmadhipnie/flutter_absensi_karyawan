import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class EditTaskButton extends StatelessWidget {
  const EditTaskButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.edit_outlined,
              color: AppTheme.primaryColor,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              'Edit Task',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
