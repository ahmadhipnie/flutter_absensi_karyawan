import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../common/widgets/user_avatar.dart';
import '../../../data/models/chat_message_model.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    required this.message,
    required this.isGroupChat,
    super.key,
  });

  final ChatMessage message;
  final bool isGroupChat;

  @override
  Widget build(BuildContext context) {
    if (message.isMe) {
      return _MyMessageBubble(message: message);
    }
    return _OtherMessageBubble(
      message: message,
      showSenderName: isGroupChat,
    );
  }
}

class _MyMessageBubble extends StatelessWidget {
  const _MyMessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 64, bottom: AppTheme.paddingM),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingL,
                    vertical: AppTheme.paddingM,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.gray100,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
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
                ),
              ],
            ),
          ),
          const SizedBox(width: 64),
        ],
      ),
    );
  }
}
