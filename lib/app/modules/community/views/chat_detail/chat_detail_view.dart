import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/chat_detail_controller.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/chat_message_bubble.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatAppBar(
        chatName: controller.chatName,
        isGroupChat: controller.isGroupChat,
        subtitle: controller.subtitle,
        avatarUrl: controller.avatarUrl,
        onLeaveConversation: controller.isGroupChat ? controller.leaveConversation : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final hasMessages = controller.messages.isNotEmpty;
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.paddingL,
                  vertical: AppTheme.paddingS,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.messages.length + (hasMessages ? 2 : 1), // +1 date, +1 pull indicator
                itemBuilder: (context, index) {
                  final totalItems = controller.messages.length + 1;
                  if (hasMessages && index == totalItems) {
                    // Pull to refresh indicator at bottom (only show if has messages)
                    return _PullUpRefreshFooter(onRefresh: controller.refresh);
                  }
                  if (index == 0) {
                    return _DateDivider(formattedDate: controller.formattedDate);
                  }
                  final message = controller.messages[index - 1];
                  return ChatMessageBubble(
                    message: message,
                    isGroupChat: controller.isGroupChat,
                    onDelete: message.isMe ? () => controller.deleteMessage(message) : null,
                  );
                },
              );
            }),
          ),
          Obx(() => ChatInputField(
            controller: controller.messageController,
            onSend: controller.sendMessage,
            selectedImage: controller.selectedImage.value,
            onRemoveImage: controller.clearSelectedImage,
            isUploadingImage: controller.isUploadingImage.value,
            onCameraTap: () => _showImageSourceBottomSheet(context),
          )),
        ],
      ),
    );
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                controller.pickImage(source: ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                controller.pickImage(source: ImageSource.camera);
              },
            ),
            if (controller.selectedImage.value != null)
              ListTile(
                leading: const Icon(Icons.close, color: Colors.red),
                title: const Text('Remove Image', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  controller.clearSelectedImage();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DateDivider extends StatelessWidget {
  const _DateDivider({required this.formattedDate});

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingL),
        child: Text(
          formattedDate,
          style: const TextStyle(
            color: AppTheme.gray500,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Refresh button at bottom - tap to refresh messages
class _RefreshButton extends StatefulWidget {
  final Future<void> Function() onRefresh;

  const _RefreshButton({required this.onRefresh});

  @override
  State<_RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<_RefreshButton> {
  bool _isLoading = false;

  Future<void> _handleRefresh() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await widget.onRefresh();
    if (mounted) {
      // Wait a bit to show success before resetting
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleRefresh,
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: AppTheme.paddingM),
        alignment: Alignment.center,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Refresh messages',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Pull up refresh footer - swipe up on this item to refresh
class _PullUpRefreshFooter extends StatefulWidget {
  final Future<void> Function() onRefresh;

  const _PullUpRefreshFooter({required this.onRefresh});

  @override
  State<_PullUpRefreshFooter> createState() => _PullUpRefreshFooterState();
}

class _PullUpRefreshFooterState extends State<_PullUpRefreshFooter> {
  bool _isRefreshing = false;
  double _dragOffset = 0;

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
      _dragOffset = 0;
    });
    await widget.onRefresh();
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Arrow always visible, text appears on drag
    final arrowOpacity = 0.4 + ((_dragOffset / 80).clamp(0.0, 0.6).toDouble());
    final textOpacity = (_dragOffset / 40).clamp(0.0, 1.0).toDouble();

    final extraHeight = (_dragOffset * 0.6).clamp(0.0, 60.0).toDouble();
    // Move content upward as we drag (negative Y = up)
    final upwardOffset = -(_dragOffset * 0.5).clamp(0.0, 30.0).toDouble();

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // Respond to upward drag (negative delta means moving up)
        if (details.delta.dy < 0) {
          setState(() {
            _dragOffset = (_dragOffset - details.delta.dy).clamp(0, 100);
          });
        }
        // Allow moving back down
        if (details.delta.dy > 0 && _dragOffset > 0) {
          setState(() {
            _dragOffset = (_dragOffset - details.delta.dy).clamp(0, 100);
          });
        }
      },
      onVerticalDragEnd: (_) {
        // Trigger refresh if pulled enough (>60px)
        if (_dragOffset > 60) {
          _handleRefresh();
        } else {
          setState(() => _dragOffset = 0);
        }
      },
      child: Container(
        height: 60 + extraHeight,
        alignment: Alignment.center,
        child: _isRefreshing
            ? const _PullUpLoadingIndicator()
            : Transform.translate(
                offset: Offset(0, upwardOffset),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: arrowOpacity,
                      child: const Icon(
                        Icons.keyboard_arrow_up,
                        size: 28,
                        color: AppTheme.gray500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Opacity(
                      opacity: textOpacity,
                      child: const Text(
                        'Pull up to refresh',
                        style: TextStyle(
                          color: AppTheme.gray500,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Pull up loading indicator - simple gray spinner
class _PullUpLoadingIndicator extends StatelessWidget {
  const _PullUpLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gray500),
      ),
    );
  }
}
