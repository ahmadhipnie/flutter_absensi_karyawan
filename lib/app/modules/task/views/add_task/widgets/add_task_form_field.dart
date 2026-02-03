import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class AddTaskFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final int maxLines;
  final bool readOnly;
  final bool isTransparent;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const AddTaskFormField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.isTransparent = false,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppTheme.gray500,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppTheme.gray700, size: 22)
            : null,
        filled: true,
        fillColor: isTransparent ? Colors.transparent : AppTheme.gray100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          borderSide: isTransparent ? BorderSide.none : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          borderSide: isTransparent ? BorderSide.none : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          borderSide: isTransparent
              ? BorderSide.none
              : BorderSide(color: AppTheme.primaryColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          borderSide: const BorderSide(color: AppTheme.errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          borderSide: const BorderSide(color: AppTheme.errorColor, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: prefixIcon != null ? 0 : AppTheme.paddingL,
          vertical: maxLines > 1 ? 14 : AppTheme.paddingL,
        ),
      ),
    );
  }
}
