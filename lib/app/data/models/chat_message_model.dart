class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.timestamp,
    required this.isMe,
  });
}
