class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final DateTime timestamp;
  final bool isMe;
  final String? image; // Image filename
  final String messageType; // 'text' or 'image'

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.timestamp,
    required this.isMe,
    this.image,
    this.messageType = 'text',
  });

  /// Get full image URL
  String? get imageUrl {
    if (image == null || image!.isEmpty) return null;
    return 'https://api-absensi.hftech.web.id/api/assets/message_images/$image';
  }

  /// Check if message has image
  bool get hasImage => image != null && image!.isNotEmpty;

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
      image: json['image'] as String?,
      messageType: json['message_type'] as String? ?? 'text',
    );
  }

  /// Create a message from current user (for sending)
  factory ChatMessage.fromMe({
    required String text,
    required String myUserId,
    required String myName,
    String? myAvatar,
    String? image,
    String messageType = 'text',
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: myUserId,
      senderName: myName,
      senderAvatar: myAvatar,
      timestamp: DateTime.now(),
      isMe: true,
      image: image,
      messageType: messageType,
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
      'image': image,
      'message_type': messageType,
    };
  }

  /// Create an image message placeholder (while uploading)
  factory ChatMessage.placeholderImage({
    required String text,
    required String myUserId,
    required String myName,
    required String localImagePath,
  }) {
    return ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      senderId: myUserId,
      senderName: myName,
      timestamp: DateTime.now(),
      isMe: true,
      image: localImagePath, // Temporary local path
      messageType: 'image',
    );
  }
}
