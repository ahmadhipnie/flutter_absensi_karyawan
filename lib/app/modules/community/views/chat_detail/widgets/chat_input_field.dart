import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    required this.controller,
    required this.onSend,
    this.onCameraTap,
    this.selectedImage,
    this.onRemoveImage,
    this.isUploadingImage = false,
    this.hintText = 'Type a message here',
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onCameraTap;
  final File? selectedImage;
  final VoidCallback? onRemoveImage;
  final bool isUploadingImage;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final hasImage = selectedImage != null;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppTheme.paddingL),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Selected image preview
            if (hasImage)
              Container(
                margin: const EdgeInsets.only(bottom: AppTheme.paddingM),
                height: 150,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isUploadingImage)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onRemoveImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
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
                          icon: Icon(
                            hasImage ? Icons.check_circle : Icons.camera_alt,
                            color: hasImage
                                ? AppTheme.primaryColor
                                : AppTheme.gray500,
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
                  onTap: isUploadingImage ? null : onSend,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isUploadingImage
                          ? AppTheme.gray500
                          : AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: isUploadingImage
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 24,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
