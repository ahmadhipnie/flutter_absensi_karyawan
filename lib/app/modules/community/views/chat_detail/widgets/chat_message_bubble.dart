import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/chat_message_model.dart';
import '../../../../../common/widgets/user_avatar.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    required this.message,
    required this.isGroupChat,
    this.onDelete,
    super.key,
  });

  final ChatMessage message;
  final bool isGroupChat;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (message.isMe) {
      return _MyMessageBubble(
        message: message,
        onDelete: onDelete,
      );
    }
    return _OtherMessageBubble(
      message: message,
      showSenderName: isGroupChat,
    );
  }
}

class _MyMessageBubble extends StatelessWidget {
  const _MyMessageBubble({
    required this.message,
    this.onDelete,
  });

  final ChatMessage message;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final hasImage = message.hasImage;

    final bubbleContent = Container(
      margin: const EdgeInsets.only(left: 64, bottom: AppTheme.paddingM),
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (hasImage) ...[
            _buildImageBubble(),
            if (message.text.isNotEmpty) const SizedBox(height: 8),
          ],
          if (message.text.isNotEmpty)
            _buildTextBubble(),
        ],
      ),
    );

    // Add long press for delete if onDelete is provided
    if (onDelete != null) {
      return GestureDetector(
        onLongPress: () => _showDeleteOptions(context),
        child: bubbleContent,
      );
    }

    return bubbleContent;
  }

  void _showDeleteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Message', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  onDelete?.call();
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingL,
        vertical: AppTheme.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Text(
        message.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImageBubble() {
    return GestureDetector(
      onTap: () => _viewImage(),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: _buildImage(),
        ),
      ),
    );
  }

  void _viewImage() {
    Get.to(
      () => _FullImageView(imageUrl: message.imageUrl, localPath: message.image),
      transition: Transition.fadeIn,
    );
  }

  Widget _buildImage() {
    // If image is a local file path (during upload)
    if (message.image != null && message.image!.startsWith('/')) {
      return Image.file(
        File(message.image!),
        width: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }

    // If image is from server (URL)
    if (message.imageUrl != null) {
      return Image.network(
        message.imageUrl!,
        width: 200,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: const Icon(
        Icons.broken_image,
        color: Colors.white54,
        size: 40,
      ),
    );
  }
}

class _OtherMessageBubble extends StatelessWidget {
  const _OtherMessageBubble({
    required this.message,
    required this.showSenderName,
  });

  final ChatMessage message;
  final bool showSenderName;

  @override
  Widget build(BuildContext context) {
    final hasImage = message.hasImage;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(
            name: message.senderName,
            imageUrl: message.senderAvatar,
            size: 36,
          ),
          const SizedBox(width: AppTheme.paddingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showSenderName) ...[
                  Text(
                    message.senderName,
                    style: const TextStyle(
                      color: AppTheme.gray500,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.gray100,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasImage) _buildImage(),
                      if (message.text.isNotEmpty)
                        _buildText(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 64),
        ],
      ),
    );
  }

  Widget _buildText() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingL,
        vertical: AppTheme.paddingM,
      ),
      child: Text(
        message.text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImage() {
    return GestureDetector(
      onTap: () => _viewImage(),
      child: _buildImageContent(),
    );
  }

  void _viewImage() {
    Get.to(
      () => _FullImageView(imageUrl: message.imageUrl, localPath: message.image),
      transition: Transition.fadeIn,
    );
  }

  Widget _buildImageContent() {
    // If image is a local file path
    if (message.image != null && message.image!.startsWith('/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Image.file(
          File(message.image!),
          width: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        ),
      );
    }

    // If image is from server (URL)
    if (message.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Image.network(
          message.imageUrl!,
          width: 200,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 200,
              height: 150,
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
        ),
      );
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: const Icon(
        Icons.broken_image,
        color: AppTheme.gray500,
        size: 40,
      ),
    );
  }
}

/// Fullscreen image viewer
class _FullImageView extends StatelessWidget {
  const _FullImageView({
    required this.imageUrl,
    this.localPath,
  });

  final String? imageUrl;
  final String? localPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Image',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          scaleEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: _buildImage(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Try local file first
    if (localPath != null && localPath!.startsWith('/')) {
      return Image.file(
        File(localPath!),
        errorBuilder: (context, error, stackTrace) {
          // Fall back to network URL if local file fails
          if (imageUrl != null) {
            return Image.network(
              imageUrl!,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white54,
                    size: 48,
                  ),
                );
              },
            );
          }
          return const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.white54,
              size: 48,
            ),
          );
        },
      );
    }

    // Network image
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.white54,
              size: 48,
            ),
          );
        },
      );
    }

    return const Center(
      child: Icon(
        Icons.broken_image,
        color: Colors.white54,
        size: 48,
      ),
    );
  }
}
