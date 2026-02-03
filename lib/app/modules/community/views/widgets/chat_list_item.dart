import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/user_avatar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../controllers/community_controller.dart';

class ChatListItem extends StatelessWidget {
  final Map<String, dynamic> chat;

  const ChatListItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommunityController>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => controller.openChat(chat['id']),
        borderRadius: BorderRadius.circular(8),
        splashColor: AppTheme.primaryColor.withOpacity(0.05),
        highlightColor: AppTheme.primaryColor.withOpacity(0.03),
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
            chat['name'],
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
          chat['timestamp'],
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
    return Row(
      children: [
        if (chat['isSentByMe'] ?? false) _buildReadStatus(),
        Expanded(
          child: Text(
            chat['message'],
            style: TextStyle(
              color: chat['unreadCount'] > 0
                  ? Colors.black
                  : AppTheme.gray600,
              fontSize: 13,
              fontWeight: chat['unreadCount'] > 0 ? FontWeight.w500 : FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (chat['unreadCount'] > 0) ...[
          const SizedBox(width: 8),
          _buildUnreadBadge(chat['unreadCount']),
        ],
      ],
    );
  }

  Widget _buildReadStatus() {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Icon(
        Icons.done_all,
        size: 16,
        color: (chat['isRead'] ?? false) ? AppTheme.primaryColor : AppTheme.gray500,
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarImage = chat['avatarImage'] as String?;
    final avatarColor = chat['avatarColor'] as int?;
    final avatarText = chat['avatarText'] as String?;

    return UserAvatar(
      name: chat['name'],
      size: 48,
      imageUrl: avatarImage?.isNotEmpty == true ? avatarImage : null,
      backgroundColor: avatarColor ?? AppTheme.primaryColor.value,
      textStyle: avatarText != null
          ? const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)
          : null,
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
        count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
