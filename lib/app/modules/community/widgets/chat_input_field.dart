import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    required this.controller,
    required this.onSend,
    this.onCameraTap,
    this.hintText = 'Type a message here',
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onCameraTap;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppTheme.paddingL),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingL),
                decoration: BoxDecoration(
                  color: AppTheme.gray100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: const TextStyle(
                            color: AppTheme.gray500,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onSubmitted: (_) => onSend(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: AppTheme.gray500,
                        size: 24,
                      ),
                      onPressed: onCameraTap,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppTheme.paddingM),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
