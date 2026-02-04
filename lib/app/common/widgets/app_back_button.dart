import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Back button with consistent styling across the app.
/// Used in AppBar leading widget.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
      onPressed: () => Get.back(),
    );
  }
}
