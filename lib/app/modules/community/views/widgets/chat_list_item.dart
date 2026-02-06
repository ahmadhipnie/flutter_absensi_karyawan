import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/user_avatar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/conversation_model.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../utils/date_helper.dart';
import '../../controllers/community_controller.dart';

class ChatListItem extends StatelessWidget {
  final ConversationModel chat;

  const ChatListItem({super.key, required this.chat});

  // Get current user ID
  String? get myUserId {
    try {
      final authService = Get.find<AuthService>();
      return authService.currentUser?.id.toString();
    } catch (e) {
      return null;
    }
  }

  // Get display name with current user context
  String get chatDisplayName {
    if (myUserId != null) {
      return chat.displayNameWithId(myUserId!);
    }
    return chat.displayName;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommunityController>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.openChat(chat),
        borderRadius: BorderRadius.circular(8),
        splashColor: AppTheme.primaryColor.withValues(alpha: 0.05),
        highlightColor: AppTheme.primaryColor.withValues(alpha: 0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(child: _buildChatContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameAndTimestamp(),
        const SizedBox(height: 4),
        _buildMessageRow(),
      ],
    );
  }

  Widget _buildNameAndTimestamp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            chatDisplayName, // Use computed property
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatTimestamp(chat.updatedAt),
          style: const TextStyle(
            color: AppTheme.gray500,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageRow() {
    final hasUnread = chat.unreadCount > 0;

    return Row(
      children: [
        Expanded(
          child: Text(
            _getLastMessagePreview(),
            style: TextStyle(
              color: hasUnread ? Colors.black : AppTheme.gray600,
              fontSize: 13,
              fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (hasUnread) ...[
          const SizedBox(width: 8),
          _buildUnreadBadge(chat.unreadCount),
        ],
      ],
    );
  }

  Widget _buildAvatar() {
    return UserAvatar(
      name: chatDisplayName, // Use computed property
      size: 48,
      backgroundColor: AppTheme.primaryColor.value,
    );
  }

  Widget _buildUnreadBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        shape: BoxShape.circle,
      ),
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateHelper.nowWib();
    final difference = now.difference(dateTime);

    // Today: show time only
    if (DateHelper.isTodayWib(dateTime)) {
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    // Yesterday: show "Yesterday"
    if (DateHelper.isYesterdayWib(dateTime)) {
      return 'Yesterday';
    }

    // This week: show day name
    if (difference.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dateTime.weekday - 1];
    }

    // Older: show date
    return DateHelper.formatDateWib(dateTime);
  }

  String _getLastMessagePreview() {
    // Use actual last message if available
    if (chat.lastMessage != null) {
      final lm = chat.lastMessage!;

      // Build message content based on type
      String messageContent;
      if (lm.messageType == 'image') {
        // Image message: show photo indicator + caption if exists
        if (lm.text.isNotEmpty) {
          messageContent = '📷 ${lm.text}';
        } else {
          messageContent = '📷 Photo';
        }
      } else {
        // Text only
        messageContent = lm.text;
      }

      if (lm.isFromMe) {
        return 'You: $messageContent';
      } else {
        return messageContent;
      }
    }

    // Fallback to placeholder based on unread count
    if (chat.unreadCount > 0) {
      return '${chat.unreadCount} new message${chat.unreadCount > 1 ? 's' : ''}';
    }
    return 'No messages yet';
  }
}
