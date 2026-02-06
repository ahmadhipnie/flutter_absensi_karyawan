import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/user_avatar.dart';
import '../../../../../core/theme/app_theme.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    required this.chatName,
    required this.isGroupChat,
    this.subtitle,
    this.avatarUrl,
    this.onLeaveConversation,
    super.key,
  });

  final String chatName;
  final bool isGroupChat;
  final String? subtitle;
  final String? avatarUrl;
  final VoidCallback? onLeaveConversation;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => Get.back(),
      ),
      title: isGroupChat
          ? _buildGroupTitle()
          : _buildPersonalTitle(),
      actions: isGroupChat ? [_buildPopupMenu()] : null,
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black),
      onSelected: (value) {
        if (value == 'leave') {
          onLeaveConversation?.call();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'leave',
          child: Row(
            children: [
              Icon(Icons.exit_to_app, color: Colors.red, size: 20),
              SizedBox(width: AppTheme.paddingM),
              Text(
                'Leave conversation',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chatName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: const TextStyle(
              color: AppTheme.gray500,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalTitle() {
    return Row(
      children: [
        UserAvatar(
          name: chatName,
          imageUrl: avatarUrl,
          size: 36,
        ),
        const SizedBox(width: AppTheme.paddingM),
        Text(
          chatName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
