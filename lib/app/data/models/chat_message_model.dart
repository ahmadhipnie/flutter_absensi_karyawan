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

  /// Create from API JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json, {String? myUserId}) {
    // Determine if this message is from me
    final senderId = json['sender_id']?.toString() ?? json['user_id']?.toString() ?? '';
    final isMe = myUserId != null && senderId == myUserId;

    return ChatMessage(
      id: json['id']?.toString() ?? '',
      text: json['message_text'] ?? json['message'] ?? json['text'] ?? '',
      senderId: senderId,
      senderName: json['sender_name'] ?? json['username'] ?? 'Unknown',
      senderAvatar: json['sender_avatar'] ?? json['avatar_url'] ?? json['photo_profile'],
      timestamp: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      isMe: isMe,
    );
  }

  /// Create a message from current user (for sending)
  factory ChatMessage.fromMe({
    required String text,
    required String myUserId,
    required String myName,
    String? myAvatar,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: myUserId,
      senderName: myName,
      senderAvatar: myAvatar,
      timestamp: DateTime.now(),
      isMe: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'timestamp': timestamp.toIso8601String(),
      'is_me': isMe,
    };
  }
}
