import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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
          color: Color(0xFF9E9E9E),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color(0xFF616161), size: 22)
            : null,
        filled: true,
        fillColor: isTransparent ? Colors.transparent : const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isTransparent ? BorderSide.none : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isTransparent ? BorderSide.none : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isTransparent
              ? BorderSide.none
              : BorderSide(color: AppTheme.primaryColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: prefixIcon != null ? 0 : 16,
          vertical: maxLines > 1 ? 14 : 16,
        ),
      ),
    );
  }
}
