import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        splashColor: const Color(0xFF0046BE).withOpacity(0.05),
        highlightColor: const Color(0xFF0046BE).withOpacity(0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            color: Color(0xFF9E9E9E),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Checkmark hanya untuk pesan yang dikirim user
                        if (chat['isSentByMe'] ?? false)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.done_all,
                              size: 16,
                              // Biru jika sudah dibaca, abu-abu jika belum
                              color: (chat['isRead'] ?? false)
                                  ? const Color(0xFF0046BE)
                                  : const Color(0xFF9E9E9E),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            chat['message'],
                            style: TextStyle(
                              color: chat['unreadCount'] > 0
                                  ? Colors.black
                                  : const Color(0xFF757575),
                              fontSize: 13,
                              fontWeight: chat['unreadCount'] > 0
                                  ? FontWeight.w500
                                  : FontWeight.w400,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (chat['avatarImage'] != null) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.network(
            chat['avatarImage'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildAvatarText(),
          ),
        ),
      );
    }

    return _buildAvatarText();
  }

  Widget _buildAvatarText() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Color(chat['avatarColor'] ?? 0xFF0046BE),
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.center,
      child: Text(
        chat['avatarText'] ?? chat['name'][0].toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildUnreadBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: const BoxDecoration(
        color: Color(0xFF0046BE),
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
