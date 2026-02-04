import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileSaveButton extends StatelessWidget {
  const ProfileSaveButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(Icons.edit_square, size: 16, color: AppTheme.primaryColor),
            label: Text(
              'Save',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }
}
