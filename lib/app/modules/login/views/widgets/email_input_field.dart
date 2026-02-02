import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../../../core/theme/app_theme.dart';

class EmailInputField extends GetView<LoginController> {
  const EmailInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _EmailLabel(),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          validator: controller.validateEmail,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          decoration: _inputDecoration(
            hintText: 'Email',
            icon: Icons.alternate_email,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFF9E9E9E),
        fontSize: 16,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 16, right: 12),
        child: Icon(icon, color: const Color(0xFF9E9E9E), size: 24),
      ),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 52,
        minHeight: 52,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}

class _EmailLabel extends StatelessWidget {
  const _EmailLabel();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Email',
      style: TextStyle(
        fontSize: 15,
        color: Color(0xFF9E9E9E),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
