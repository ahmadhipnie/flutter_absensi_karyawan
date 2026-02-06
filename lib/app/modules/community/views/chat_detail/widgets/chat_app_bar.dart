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
    super.key,
  });

  final String chatName;
  final bool isGroupChat;
  final String? subtitle;
  final String? avatarUrl;

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
